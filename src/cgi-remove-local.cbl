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
            03  is-valid-init-switch        PIC X   VALUE 'N'.
                88  is-valid-init                   VALUE 'Y'.
            03  is-lokal-id-found-switch    PIC X   VALUE 'N'.
                88  is-lokal-id-found               VALUE 'Y'.                
            03  is-lokalname-found-switch    PIC X   VALUE 'N'.
                88  is-lokalname-found               VALUE 'Y'.                  
       
       *> used in calls to dynamic libraries
       01  wn-rtn-code             PIC  S99   VALUE ZERO.
       
       01  wc-post-name            PIC X(40)  VALUE SPACE.
       01  wc-post-value           PIC X(40)  VALUE SPACE.
       
       01  wc-pagetitle            PIC X(20)  VALUE 'Tag bort lokal'.
       
       *> table data
       01  wr-rec-vars.
           05  wn-lokal-id         PIC  9(04) VALUE ZERO.   
           05  wc-lokalnamn        PIC  X(40) VALUE SPACE.
       
       *> variables wrapped within EXEC SQL - END-EXEC 
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
           
           IF is-valid-post AND is-valid-init
           
                PERFORM B0100-connect
                IF is-db-connected
                    PERFORM B0200-cgi-delete-row
                END-IF
                
           END-IF
           
           PERFORM C0100-closedown
           
           GOBACK
           .
           
       *>**************************************************          
       A0100-init.       
           
           *> always send out the Content-Type before any other I/O
           CALL 'wui-print-header' USING wn-rtn-code  
           *>  start html doc
           CALL 'wui-start-html' USING wc-pagetitle
           
           *> decompose and save current post string
           CALL 'write-post-string' USING wn-rtn-code
           
           IF wn-rtn-code = ZERO
           
               SET is-valid-init TO TRUE
               
               *> CGI post: remove row by local-name?             
               MOVE ZERO TO wn-rtn-code
               MOVE SPACE TO wc-post-value
               MOVE 'local-name' TO wc-post-name
               CALL 'get-post-value' USING wn-rtn-code
                                           wc-post-name wc-post-value

               MOVE wc-post-value TO wc-lokalnamn

               *> CGI post: remove row by local-id?
               MOVE ZERO TO wn-rtn-code
               MOVE SPACE TO wc-post-value
               MOVE 'local-id' TO wc-post-name               
               CALL 'get-post-value' USING wn-rtn-code
                                           wc-post-name wc-post-value
               *> convert to number (SPACE --> 0)
               MOVE FUNCTION NUMVAL(wc-post-value) TO wn-lokal-id                                                               
               
           END-IF                                            
      
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
                
           IF  SQLCODE NOT = ZERO
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
                
                PERFORM B0210-is-lokal-id-data-found
                
                *> delete row from table
                IF is-lokal-id-found
                     EXEC SQL 
                         DELETE FROM T_JLOKAL
                                  WHERE Lokal_id = :jlokal-lokal-id
                     END-EXEC
                END-IF
                
                IF  SQLCODE = ZERO
                    DISPLAY "<br> *** Lokal bortagen ***"           
                ELSE
                    PERFORM Z0100-error-routine
                END-IF
                
           *> deletion based on Lokalnamn           
           ELSE IF wc-lokalnamn NOT = SPACE 

                *> the selected row to be removed
                MOVE wc-lokalnamn TO jlokal-lokalnamn
                
                PERFORM B0220-is-lokalname-data-found
                
                *> delete row from table
                IF is-lokalname-found                
                     EXEC SQL 
                         DELETE FROM T_JLOKAL
                                  WHERE Lokalnamn = :jlokal-lokalnamn
                     END-EXEC
                END-IF
                
                IF  SQLCODE = ZERO
                    DISPLAY "<br> *** Lokal bortagen ***"           
                ELSE
                    PERFORM Z0100-error-routine
                END-IF
                
           END-IF
           
           PERFORM B0300-commit-work
           
           PERFORM B0310-disconnect
           
           .
           
       *>**************************************************
       B0210-is-lokal-id-data-found.

           *> Cursor for T_JLOKAL
           EXEC SQL
             DECLARE curs1 CURSOR FOR
                 SELECT Lokal_id
                 FROM T_JLOKAL
                     WHERE Lokal_id = :jlokal-lokal-id
           END-EXEC.      

           *> Open the cursor
           EXEC SQL
                OPEN curs1
           END-EXEC
                      
           *> try a fetch
           EXEC SQL
               FETCH curs1
                   INTO :wn-lokal-id
           END-EXEC
           
           IF SQLCODE = ZERO
               SET is-lokal-id-found TO TRUE
           END-IF
              
           .
           
       *>**************************************************
       B0220-is-lokalname-data-found.

           *> Cursor for T_JLOKAL
           EXEC SQL
             DECLARE curs2 CURSOR FOR
                 SELECT Lokalnamn
                 FROM T_JLOKAL
                     WHERE Lokalnamn = :jlokal-lokalnamn
           END-EXEC.      

           *> Open the cursor
           EXEC SQL
                OPEN curs2
           END-EXEC
                      
           *> try a fetch
           EXEC SQL
               FETCH curs2
                   INTO :wc-lokalnamn
           END-EXEC
           
           IF SQLCODE = ZERO
               SET is-lokalname-found TO TRUE
           END-IF
              
           .       
       
       *>**************************************************       
       B0300-commit-work.

           *>  commit work permanently
           EXEC SQL 
               COMMIT WORK
           END-EXEC
           .           
           
       *>**************************************************
       B0310-disconnect.

           *>  disconnect
           EXEC SQL
               DISCONNECT ALL
           END-EXEC

           .

       *>**************************************************
       C0100-closedown.

           CALL 'wui-end-html' USING wn-rtn-code
           
           .

       *>**************************************************
       Z0100-error-routine.
           
           *> requires the ending dot (and no extension)!
           COPY z0100-error-routine.
       
           .
                  
       *>**************************************************    
       *> END PROGRAM  
