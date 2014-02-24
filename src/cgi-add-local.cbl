       *>
       *> INITIAL TEMPLATE FOR SQL INSERT (here lokal)
       *>
       *> cgi-add-local: adds user data related to
       *> a local, saves into table T_JLOKAL
       *> 
       *> Coder: BK (not part of application)
       *>
       IDENTIFICATION DIVISION.
       program-id. cgi-add-local.
       *>**************************************************
       DATA DIVISION.
       working-storage section.
       01   switches-add.
            03  is-db-connected-switch              PIC X   VALUE 'N'.
                88  is-db-connected                         VALUE 'Y'.
            03  is-valid-init-switch                PIC X   VALUE 'N'.
                88  is-valid-init                           VALUE 'Y'.
            03  name-is-in-table-switch             PIC X   VALUE 'N'.
                88  name-is-in-table                        VALUE 'Y'.
            03  is-valid-table-position-switch      PIC X   VALUE 'N'.
                88  is-valid-table-position                 VALUE 'Y'.
                            
       *> used in calls to dynamic libraries
       01  wn-rtn-code             PIC  S99   VALUE ZERO.
       01  wc-post-name            PIC X(40)  VALUE SPACE.
       01  wc-post-value           PIC X(40)  VALUE SPACE.
       
       *> always - used in error routine
       01  wc-printscr-string      PIC X(40)  VALUE SPACE. 
       
       01  wc-pagetitle            PIC X(20) VALUE 'Addera lokal'.
       
       EXEC SQL BEGIN DECLARE SECTION END-EXEC.
       01  wc-database              PIC  X(30).
       01  wc-passwd                PIC  X(10).       
       01  wc-username              PIC  X(30).
       EXEC SQL END DECLARE SECTION END-EXEC.             
       
       *>#######################################################
       EXEC SQL BEGIN DECLARE SECTION END-EXEC.
       *>
       01  jlocal-rec-vars.       
           05  jlokal-lokal-id      PIC  9(4).
           05  jlokal-lokalnamn     PIC  X(40).
           05  jlokal-vaningsplan   PIC  X(40).
           05  jlokal-maxdeltagare  PIC  X(40).
       *>    
       EXEC SQL END DECLARE SECTION END-EXEC.
       *> table data
       01  wr-rec-vars.
           05  wn-lokal-id         PIC  9(4) VALUE ZERO.
           05  wc-lokalnamn        PIC  X(40) VALUE SPACE.
           05  wc-vaningsplan      PIC  X(40) VALUE SPACE.
           05  wc-maxdeltagare     PIC  X(40) VALUE SPACE.     
       *>#######################################################

       EXEC SQL INCLUDE SQLCA END-EXEC.
       
       *>**************************************************
       PROCEDURE DIVISION.
       *>**************************************************       
       0000-main.
       
           *> contains development environment settings for test
           COPY setupenv_openjensen. 
           
           PERFORM A0100-init
           
           IF is-valid-init
           
                PERFORM B0100-connect
                IF is-db-connected
                
                    PERFORM B0200-add-local
                    PERFORM Z0200-disconnect
                
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
               PERFORM A0110-init-add-action
           END-IF
           
           . 
       *>**************************************************         
       A0110-init-add-action.
       
           *>  read local-sign-name (name is required)        
           MOVE ZERO TO wn-rtn-code
           MOVE SPACE TO wc-post-value
           MOVE 'local-sign-name' TO wc-post-name
           CALL 'get-post-value' USING wn-rtn-code
                                       wc-post-name wc-post-value                           

           MOVE wc-post-value TO wc-lokalnamn
           
           *> in case using alternative name (not real local) 
           IF wc-post-value = SPACE
            
              *>  read local-alt-name 
              MOVE ZERO TO wn-rtn-code
              MOVE SPACE TO wc-post-value
              MOVE 'local-alt-name' TO wc-post-name
              CALL 'get-post-value' USING wn-rtn-code
                                  wc-post-name wc-post-value
                
              MOVE wc-post-value TO wc-lokalnamn
            
           END-IF

           IF wc-lokalnamn = SPACE
               MOVE 'Saknar namn på lokal' TO wc-printscr-string
               CALL 'stop-printscr' USING wc-printscr-string
           ELSE
               *> all required column input data is done
               SET is-valid-init TO TRUE
           END-IF


           *>  read floor plan (optional column)
           MOVE ZERO TO wn-rtn-code
           MOVE SPACE TO wc-post-value
           MOVE 'plan' TO wc-post-name
            
           CALL 'get-post-value' USING wn-rtn-code wc-post-name
                                       wc-post-value                                     
            
           MOVE wc-post-value TO wc-vaningsplan
            
           *>  read max peoples in the local (optional column)
           MOVE ZERO TO wn-rtn-code
           MOVE SPACE TO wc-post-value
           MOVE 'local-max' TO wc-post-name
           CALL 'get-post-value' USING wn-rtn-code
                                       wc-post-name wc-post-value               
                                        
           MOVE wc-post-value TO wc-maxdeltagare       
           . 
       
       *>**************************************************
       B0100-connect.
        
           *>  connect
           MOVE  "openjensen"    TO   wc-database
           MOVE  "jensen"        TO   wc-username
           MOVE  SPACE           TO   wc-passwd
                
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
       B0200-add-local.
           
           
           PERFORM B0210-does-local-name-exist
               
           IF NOT name-is-in-table
               PERFORM B0220-get-new-row-number
               
               IF is-valid-table-position
                   PERFORM B0230-add-local-to-table
               END-IF
           ELSE
               MOVE 'Denna lokal finns redan upplagd'
                    TO wc-printscr-string
               CALL 'stop-printscr' USING wc-printscr-string
           END-IF
           
           .
           
       *>**************************************************          
       B0210-does-local-name-exist.
           
           *> Cursor for T_JLOKAL
           EXEC SQL
             DECLARE cursaddlocal CURSOR FOR
                 SELECT Lokal_id, Lokalnamn
                 FROM T_JLOKAL
           END-EXEC      

           *> Open the cursor
           EXEC SQL
                OPEN cursaddlocal
           END-EXEC
           
           MOVE wc-lokalnamn TO jlokal-lokalnamn
                      
           *> fetch first row
           EXEC SQL
               FETCH cursaddlocal
                   INTO :jlokal-lokal-id, :jlokal-lokalnamn
           END-EXEC
           
           PERFORM UNTIL SQLCODE NOT = ZERO
           
               *> set flag if already in the table
               IF FUNCTION UPPER-CASE (wc-lokalnamn) =
                  FUNCTION UPPER-CASE (jlokal-lokalnamn)
                        SET name-is-in-table TO TRUE
               END-IF
           
              *> fetch next row  
               EXEC SQL
                   FETCH cursaddlocal
                       INTO :jlokal-lokal-id, :jlokal-lokalnamn
               END-EXEC
              
           END-PERFORM
           
           
           *> end of data
           IF  SQLSTATE NOT = '02000'
                PERFORM Z0100-error-routine
           END-IF                 
             
           *> close cursor
           EXEC SQL 
               CLOSE cursaddlocal 
           END-EXEC 
           
           .       
       
       *>**************************************************          
       B0220-get-new-row-number.
       
           *> Cursor for T_JLOKAL
           EXEC SQL
             DECLARE cursaddid CURSOR FOR
                 SELECT Lokal_id
                 FROM T_JLOKAL
                 ORDER BY Lokal_id DESC
           END-EXEC   
       
           *> Open the cursor
           EXEC SQL
                OPEN cursaddid
           END-EXEC
       
           *> fetch first row (which now have the highest id)
           EXEC SQL
               FETCH cursaddid
                   INTO :jlokal-lokal-id
           END-EXEC       
        
           IF  SQLCODE NOT = ZERO
                PERFORM Z0100-error-routine
           ELSE
               SET is-valid-table-position TO TRUE
               *> next number for new row in table
               COMPUTE wn-lokal-id = jlokal-lokal-id + 1             
           END-IF

           *> close cursor
           EXEC SQL 
               CLOSE cursaddid 
           END-EXEC            
           
           .
           
       *>**************************************************          
       B0230-add-local-to-table.
       
            
           MOVE wn-lokal-id TO jlokal-lokal-id
           MOVE wc-lokalnamn TO jlokal-lokalnamn
           MOVE wc-vaningsplan TO jlokal-vaningsplan
           MOVE wc-maxdeltagare TO jlokal-maxdeltagare
            
           EXEC SQL
               INSERT INTO T_JLOKAL
               VALUES (:jlokal-lokal-id, :jlokal-lokalnamn,
                       :jlokal-vaningsplan, :jlokal-maxdeltagare)
           END-EXEC 
            
           IF  SQLCODE NOT = ZERO
                PERFORM Z0100-error-routine
           ELSE
                PERFORM B0240-commit-work
                MOVE 'Lokal adderad' TO wc-printscr-string
                CALL 'ok-printscr' USING wc-printscr-string
           END-IF     
    
           .

       *>**************************************************       
       B0240-commit-work.

           *>  commit work permanently
           EXEC SQL 
               COMMIT WORK
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
       Z0200-disconnect. 
                                 
       *>  disconnect
           EXEC SQL
               DISCONNECT ALL
           END-EXEC
           
           .

       *>**************************************************    
       *> END PROGRAM  
