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
       01  wc-page-title           PIC  X(20) VALUE 'Databasfel'.
       01  wn-rtn-code             PIC  S99   VALUE ZERO.
       
       *> table data
       01  wr-jlocalrecord.
           05  wn-lokal_id         PIC  9(04) VALUE ZERO.
           05  FILLER              PIC  X.           
           05  wc-lokalnamn        PIC  X(40) VALUE SPACE.
           05  FILLER              PIC  X.
           05  wc-vaningsplan      PIC  X(40) VALUE SPACE.
           05  FILLER              PIC  X.
           05  wn-maxdeltagare     PIC  9(04) VALUE ZERO.           
           
       *> database connect info and T_JLOKAL 
       EXEC SQL BEGIN DECLARE SECTION END-EXEC.
       01  wc-database              PIC  X(30).
       01  wc-passwd                PIC  X(10).       
       01  wc-username              PIC  X(30).
       01  Lokal_id                 PIC  9(04).
       01  Lokalnamn                PIC  X(40).
       01  Vaningsplan              PIC  X(40).
       01  Maxdeltagare             PIC  9(04).
       EXEC SQL END DECLARE SECTION END-EXEC.

       EXEC SQL INCLUDE SQLCA END-EXEC.
       
       *>**************************************************
       PROCEDURE DIVISION.
       *>**************************************************       
       B0100-cgi-list-local.
           
       *>  CONNECT
           MOVE  "openjensen"    TO   wc-database.
           MOVE  "jensen"        TO   wc-username.
           MOVE  SPACE           TO   wc-passwd.
           
           EXEC SQL
               CONNECT :wc-username IDENTIFIED BY :wc-passwd
                                            USING :wc-database 
           END-EXEC
           
           
           IF  SQLSTATE NOT = ZERO
                PERFORM B900-error-routine GOBACK
           END-IF  

       *>  DECLARE CURSOR
           EXEC SQL 
               DECLARE cur-1 CURSOR FOR
               SELECT Lokal_id, Lokalnamn, Vaningsplan, Maxdeltagare
                      FROM T_JLOKAL
           END-EXEC
           
           EXEC SQL
               OPEN cur-1
           END-EXEC
           
           IF  SQLSTATE NOT = ZERO
               PERFORM B900-error-routine GOBACK
           END-IF
             
       
       *>  fetch first row       
           EXEC SQL 
               FETCH cur-1 INTO :Lokal_id,    :Lokalnamn,
                                :Vaningsplan, :Maxdeltagare
           END-EXEC
           
           
           PERFORM UNTIL SQLSTATE NOT = ZERO
           
              MOVE  Lokal_id      TO    wn-lokal_id
              MOVE  Lokalnamn     TO    wc-lokalnamn
              MOVE  Vaningsplan   TO    wc-vaningsplan
              MOVE  Maxdeltagare  TO    wn-maxdeltagare
              
              DISPLAY wr-jlocalrecord
              INITIALIZE wr-jlocalrecord
           
              *> fetch next row  
              EXEC SQL 
                 FETCH cur-1 INTO :Lokalnamn,:Vaningsplan,:Maxdeltagare
              END-EXEC
              
           END-PERFORM
           
           IF  SQLSTATE NOT = ZERO
                PERFORM B900-error-routine GOBACK
           END-IF              
             
       *>  close cursor
           EXEC SQL 
               CLOSE cur-1 
           END-EXEC 
           
       *>  commit
           EXEC SQL 
               COMMIT WORK
           END-EXEC                          
                                 
       *>  disconnect
           EXEC SQL
               DISCONNECT ALL
           END-EXEC
           
           
           GOBACK
           .

       *>**************************************************
       B900-error-routine.
       
           *> Always send out the Content-Type before any other I/O
           CALL 'wui-print-header' USING wc-page-title   
           *>  start html doc
           CALL 'wui-start-html' USING wn-rtn-code    
           
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
           
           CALL 'wui-end-html' USING wn-rtn-code 
           .
           
       *> END PROGRAM  
