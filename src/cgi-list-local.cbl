       *>
       *> cgi-list-local: fetch a list of locals 
       *> from table T_JLOKAL and writes to STDOUT 
       *> 
       *> Coder: BK 
       *>
       IDENTIFICATION DIVISION.
       program-id. cgi-list-local.
       *>**************************************************
       DATA DIVISION.
       working-storage section.
       *> used in calls to dynamic libraries
       01  wn-rtn-code             PIC  S99   VALUE ZERO.
       01  wc-pagetitle            PIC X(20) VALUE 'Lista lokaler'.  
       
       *> table data
       01  wr-rec-vars.
           05  wn-lokal-id         PIC  9(04) VALUE ZERO.
           05  FILLER              PIC  X.           
           05  wc-lokalnamn        PIC  X(40) VALUE SPACE.
           05  FILLER              PIC  X.
           05  wc-vaningsplan      PIC  X(40) VALUE SPACE.
           05  FILLER              PIC  X.
           05  wn-maxdeltagare     PIC  9(04) VALUE ZERO.          
           
       *> wc-database connect info and T_JLOKAL 
       EXEC SQL BEGIN DECLARE SECTION END-EXEC.
       01  wc-database              PIC  X(30) VALUE SPACE.
       01  wc-passwd                PIC  X(10) VALUE SPACE.       
       01  wc-username              PIC  X(30) VALUE SPACE.
       01  jlocal-rec-vars.       
           05  jlokal-lokal-id      PIC  9(04).
           05  jlokal-lokalnamn     PIC  X(40).
           05  jlokal-vaningsplan   PIC  X(40).
           05  jlokal-maxdeltagare  PIC  9(04).
       EXEC SQL END DECLARE SECTION END-EXEC.

       EXEC SQL INCLUDE SQLCA END-EXEC.
       
       *>**************************************************
       PROCEDURE DIVISION.
       *>**************************************************       
       0000-main.
       
           PERFORM A0100-init
           PERFORM B0100-cgi-list-local
           PERFORM C0100-goback
           .
       *>**************************************************          
       A0100-init.       
           
           *> always send out the Content-Type before any other I/O
           CALL 'wui-print-header' USING wn-rtn-code  
           *>  start html doc
           CALL 'wui-start-html' USING wc-pagetitle            
                      
       *>  connect
           MOVE  "openjensen"    TO   wc-database.
           MOVE  "jensen"        TO   wc-username.
           MOVE  SPACE           TO   wc-passwd.
           
           EXEC SQL
               CONNECT :wc-username IDENTIFIED BY :wc-passwd
                                            USING :wc-database 
           END-EXEC
           
           IF  SQLSTATE NOT = ZERO
                PERFORM Z0100-error-routine
                PERFORM C0100-goback
           END-IF 
       
           .
       
       *>**************************************************          
       B0100-cgi-list-local.
           
       *>  declare cursor (only place were tablenames are used)
           EXEC SQL 
               DECLARE jlokalcurs CURSOR FOR
               SELECT Lokal_id, Lokalnamn, Vaningsplan, Maxdeltagare
                      FROM T_JLOKAL
           END-EXEC
           
           *> never never use a dash in cursor names!
           EXEC SQL
               OPEN jlokalcurs
           END-EXEC
           
           IF  SQLSTATE NOT = ZERO
               PERFORM Z0100-error-routine
               PERFORM C0100-goback
           END-IF
       
       *>  fetch first row       
           EXEC SQL 
               FETCH jlokalcurs INTO :jlokal-lokal-id,:jlokal-lokalnamn,
                          :jlokal-vaningsplan,:jlokal-maxdeltagare
           END-EXEC
           
           PERFORM UNTIL SQLSTATE NOT = ZERO
           
              MOVE  jlokal-lokal-id      TO    wn-lokal-id
              MOVE  jlokal-lokalnamn     TO    wc-lokalnamn
              MOVE  jlokal-vaningsplan   TO    wc-vaningsplan
              MOVE  jlokal-maxdeltagare  TO    wn-maxdeltagare
              
              DISPLAY
                "<br>" wr-rec-vars
              END-DISPLAY  
              
              INITIALIZE jlocal-rec-vars
           
              *> fetch next row  
               EXEC SQL 
                    FETCH jlokalcurs INTO :jlokal-lokal-id,
                                :jlokal-lokalnamn,:jlokal-vaningsplan,
                                :jlokal-maxdeltagare
               END-EXEC
              
           END-PERFORM
           
           *> end of data
           IF  SQLSTATE NOT = "02000"
                PERFORM Z0100-error-routine
                PERFORM C0100-goback
           END-IF              
             
       *>  close cursor
           EXEC SQL 
               CLOSE jlokalcurs 
           END-EXEC 
           
       *>  commit
           EXEC SQL 
               COMMIT WORK
           END-EXEC
           
           IF  SQLSTATE NOT = ZERO
                PERFORM Z0100-error-routine
                PERFORM C0100-goback
           END-IF      
                                 
       *>  disconnect
           EXEC SQL
               DISCONNECT ALL
           END-EXEC
           
           .

       *>**************************************************
       C0100-goback.

           CALL 'wui-end-html' USING wn-rtn-code 
           
           GOBACK
           .

       *>**************************************************
       Z0100-error-routine.
                  
           DISPLAY "*** SQL ERROR ***".
           DISPLAY "SQLSTATE: " SQLSTATE.
           EVALUATE SQLSTATE
              WHEN  "02000"
                 DISPLAY "Record not found"
              WHEN  "08003"
              WHEN  "08001"
                 DISPLAY "Connection falied"
              WHEN  SPACE
                 DISPLAY "Undefined error"
              WHEN  OTHER
                 DISPLAY "SQLCODE: "   SQLCODE
                 DISPLAY "SQLERRMC: "  SQLERRMC
              *> TO RESTART TRANSACTION, DO ROLLBACK.
              *> EXEC SQL
              *>       ROLLBACK
              *>  END-EXEC
           END-EVALUATE
           
           .
           
       *>**************************************************    
       *> END PROGRAM  
