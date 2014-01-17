       *>
       *> cgi-remove-local: Removes a named local 
       *> from table T_JLOKAL 
       *> 
       *> Coder: BK 
       *>
       IDENTIFICATION DIVISION.
       program-id. cgi-remove-local.
       *>**************************************************
       DATA DIVISION.
       working-storage section.
       *> switches
       01   switches.
            03  is-valid-post-switch        PIC X   VALUE 'N'.
                88  is-valid-post                   VALUE 'Y'.
            03  is-valid-transaction-switch PIC X   VALUE 'N'.
                88  is-valid-transaction            VALUE 'Y'.
            03  is-db-connected-switch      PIC X   VALUE 'N'.
                88  is-db-connected                 VALUE 'Y'. 
       
       *> used in calls to dynamic libraries
       01  wn-rtn-code             PIC  S99   VALUE ZERO.
       
       01  wc-post1-name            PIC X(40)  VALUE SPACE.
       01  wc-post1-value           PIC X(40)  VALUE SPACE.
       
       01  wc-post2-name            PIC X(40)  VALUE SPACE.
       01  wc-post2-value           PIC X(40)  VALUE SPACE.  
       
       01  wc-pagetitle            PIC X(20) VALUE 'Tag bort lokal'.
       
       *> table data
       01  wr-rec-vars.
           05  wn-lokal-id         PIC  9(04) VALUE ZERO.   
           05  wc-lokalnamn        PIC  X(40) VALUE SPACE.
           
       *> wc-database connect info and table T_JLOKAL 
       EXEC SQL BEGIN DECLARE SECTION END-EXEC.
       01  wc-database              PIC  X(30) VALUE SPACE.
       01  wc-passwd                PIC  X(10) VALUE SPACE.       
       01  wc-username              PIC  X(30) VALUE SPACE.
       01  jlocal-rec-vars.       
           05  jlokal-lokal-id      PIC  9(04).
           05  jlokal-lokalnamn     PIC  X(40).
       EXEC SQL END DECLARE SECTION END-EXEC.

       EXEC SQL INCLUDE SQLCA END-EXEC.
       
       *>**************************************************
       PROCEDURE DIVISION.
       *>**************************************************       
       0000-main.
       
           PERFORM A0100-init
           
           IF is-valid-post
           
                PERFORM B0100-connect
                IF is-db-connected
                    PERFORM B0200-cgi-delete-row
                END-IF
                
           END-IF
           
           PERFORM C0100-goback
           .
       *>**************************************************          
       A0100-init.       
           
           *> always send out the Content-Type before any other I/O
           CALL 'wui-print-header' USING wn-rtn-code  
           *>  start html doc
           CALL 'wui-start-html' USING wc-pagetitle
           
           
           *> CGI post: remove row by local-name
           MOVE 'local-name' TO wc-post1-name
           MOVE SPACE TO wc-post1-value

           CALL 'get-post-value' USING wc-post1-name
                                       wc-post1-value                           
           MOVE wc-post1-value TO wc-lokalnamn


           *>  CGI post: remove row by local-id?
           MOVE 'local-id' TO wc-post2-name
           MOVE SPACE TO wc-post2-value
           
           CALL 'get-post-value' USING wc-post2-name
                                       wc-post2-value  
           
           *> debug           
           DISPLAY
                "<br> " wc-post2-name " " wc-post2-value
           END-DISPLAY                            
                                       
           *> convert to number (SPACE --> 0)
           COMPUTE wn-lokal-id = FUNCTION NUMVAL(wc-post2-value)                                               

           *> debug
           DISPLAY
                "<br> " wc-post2-name " (" wn-lokal-id ")"
           END-DISPLAY
           
           IF wc-lokalnamn = SPACE AND wn-lokal-id = 0
                DISPLAY "<br> *** MISSING LOKAL ID ELLER NAMN ***"
           ELSE
                SET is-valid-post TO TRUE
           END-IF           
                                     
           .
           
       *>**************************************************
       B0100-connect.
        
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
           ELSE
                SET is-db-connected TO TRUE
           END-IF  

           .
                               
       *>**************************************************          
       B0200-cgi-delete-row.      
           
           *> deletion based on Lokal_id (primary key)
           IF wn-lokal-id NOT = 0  
           
                *> the selected row to be removed
                MOVE wn-lokal-id TO jlokal-lokal-id
                
                *> delete row from table
                EXEC SQL 
                    DELETE FROM T_JLOKAL
                             WHERE Lokal_id = :jlokal-lokal-id
                END-EXEC
           
           END-IF
           
           *> deletion based on local given name           
           IF wc-lokalnamn NOT = SPACE 
           
                *> the selected row to be removed
                MOVE wc-lokalnamn TO jlokal-lokalnamn
                
                *> delete row from table
                EXEC SQL 
                    DELETE FROM T_JLOKAL
                             WHERE Lokalnamn = :jlokal-lokalnamn
                END-EXEC
           
           END-IF
           
           IF  SQLSTATE NOT = ZERO
                PERFORM Z0100-error-routine
           ELSE
                PERFORM B0210-commit-work
           END-IF
           
           PERFORM B0220-disconnect
           
           .
           
       *>**************************************************
       B0210-commit-work.

           *>  commit work permanently
           EXEC SQL 
               COMMIT WORK
           END-EXEC
           DISPLAY "<br> *** Lokal bortagen ***"

           .           
           
       *>**************************************************
       B0220-disconnect.

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
           END-EVALUATE
           
           .
           
       *>**************************************************    
       *> END PROGRAM  
