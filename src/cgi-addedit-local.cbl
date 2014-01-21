       *>
       *> cgi-addeit-local: reads new user data related to
       *> a local, or changes existing data.
       *> Finally saves into table T_JLOKAL
       *> 
       *> Coder: BK 
       *>
       IDENTIFICATION DIVISION.
       program-id. cgi-addedit-local.
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
                
       01   switches-edit.                
            03  local-id-is-in-table-switch         PIC X   VALUE 'N'.
                88  local-id-is-in-table                    VALUE 'Y'.                

       01   flags.
            03  cgi-action                          PIC X.
                88  is-add-local                            VALUE '1'.
                88  is-edit-local                           VALUE '2'.                
                
       *> used in calls to dynamic libraries
       01  wn-rtn-code             PIC  S99   VALUE ZERO.
       01  wc-post-name            PIC X(40)  VALUE SPACE.
       01  wc-post-value           PIC X(40)  VALUE SPACE.  
       
       01  wc-pagetitle            PIC X(20) VALUE 'Lista lokaler'.
       
       *> browser table data
       01  wr-rec-vars.
           05  wn-lokal-id         PIC  9(4) VALUE ZERO.     
           05  wc-lokalnamn        PIC  X(40) VALUE SPACE. 
           05  wc-vaningsplan      PIC  X(40) VALUE SPACE.
           05  wn-maxdeltagare     PIC  9(4) VALUE ZERO.
           
       *> existing table data
       01  wr-cur-rec-vars.
           05  wn-cur-lokal-id         PIC  9(4) VALUE ZERO.     
           05  wc-cur-lokalnamn        PIC  X(40) VALUE SPACE. 
           05  wc-cur-vaningsplan      PIC  X(40) VALUE SPACE.
           05  wn-cur-maxdeltagare     PIC  9(4) VALUE ZERO.           
           
           
       *> host variables used within EXEC SQL - END-EXEC 
       EXEC SQL BEGIN DECLARE SECTION END-EXEC.
       *>
       01  wc-database              PIC  X(30).
       01  wc-passwd                PIC  X(10).       
       01  wc-username              PIC  X(30).
       01  jlocal-rec-vars.       
           05  jlokal-lokal-id      PIC  9(4).
           05  jlokal-lokalnamn     PIC  X(40).
           05  jlokal-vaningsplan   PIC  X(40).
           05  jlokal-maxdeltagare  PIC  9(4).
       *>    
       EXEC SQL END DECLARE SECTION END-EXEC.

       EXEC SQL INCLUDE SQLCA END-EXEC.
       
       *>**************************************************
       PROCEDURE DIVISION.
       *>**************************************************       
       0000-main.
       
           PERFORM A0100-init
           
           IF is-valid-init
           
                PERFORM B0100-connect
                IF is-db-connected
                
                    *> action add new local
                    IF is-add-local
                        PERFORM B0200-add-local
                        PERFORM Z0200-disconnect
                    END-IF
                
                    *> action edit existing local
                    IF is-edit-local
                        PERFORM B0300-edit-local
                        PERFORM Z0200-disconnect
                    END-IF

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
           
               *> is action 'add' or is action 'change' local
               MOVE ZERO TO wn-rtn-code
               MOVE SPACE TO wc-post-value
               MOVE 'cgiaction' TO wc-post-name
               CALL 'get-post-value' USING wn-rtn-code
                                           wc-post-name wc-post-value
                                           
               EVALUATE wc-post-value
               
                    WHEN 'edit-local'
                        SET is-edit-local TO TRUE
                        PERFORM A0110-init-edit-action
                    WHEN 'add-local'
                        SET is-add-local TO TRUE
                        PERFORM A0120-init-add-action
                        
               END-EVALUATE
               
           END-IF
           
           .
           
       *>**************************************************       
       A0110-init-edit-action.
       
           *> what row are we updating (local-id - required)
           MOVE ZERO TO wn-rtn-code
           MOVE SPACE TO wc-post-value
           MOVE 'local-id' TO wc-post-name
           CALL 'get-post-value' USING wn-rtn-code
                               wc-post-name wc-post-value
            
           MOVE FUNCTION NUMVAL(wc-post-value) TO wn-lokal-id
            
           IF wc-post-value = SPACE              
               DISPLAY "<br>[Varning] Saknar ett angivet lokal id."                             
           ELSE                 
                             
               *> *** one of these columns must change ***
                       
               *> update alternative name?           
               MOVE ZERO TO wn-rtn-code
               MOVE SPACE TO wc-post-value
               MOVE 'local-sign-name' TO wc-post-name
               CALL 'get-post-value' USING wn-rtn-code
                                    wc-post-name wc-post-value
                     
               MOVE wc-post-value TO wc-lokalnamn   
                
               *>  update floor plan?
               MOVE ZERO TO wn-rtn-code
               MOVE SPACE TO wc-post-value
               MOVE 'plan' TO wc-post-name
                 
               CALL 'get-post-value' USING wn-rtn-code wc-post-name
                                            wc-post-value                                     
                 
               MOVE wc-post-value TO wc-vaningsplan
                 
               *>  update max peoples in the local?
               MOVE ZERO TO wn-rtn-code
               MOVE SPACE TO wc-post-value
               MOVE 'local-max' TO wc-post-name
               CALL 'get-post-value' USING wn-rtn-code
                                            wc-post-name wc-post-value               
                                             
               MOVE FUNCTION NUMVAL(wc-post-value)
                                         TO wn-maxdeltagare              
                
               IF wc-lokalnamn NOT = SPACE OR
                  wc-vaningsplan NOT = SPACE OR
                  wn-maxdeltagare NOT = ZERO
                        SET is-valid-init TO TRUE                  
               ELSE   
                   DISPLAY "<br>[Varning] Ingen kolumn att uppdatera."
               END-IF   
                  
           
           END-IF
       
           . 
       *>**************************************************         
       A0120-init-add-action.
       
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
               DISPLAY "<br>[Varning] Saknar namn på lokal."
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
                                        
           MOVE FUNCTION NUMVAL(wc-post-value)
                                      TO wn-maxdeltagare       
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
               DISPLAY "<br>[Varning] Denna lokal finns redan upplagd."
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
       
           EXEC SQL 
               SELECT COUNT(*) INTO :jlokal-lokal-id FROM T_JLOKAL
           END-EXEC
           
           IF  SQLCODE NOT = ZERO
                PERFORM Z0100-error-routine
           ELSE
               SET is-valid-table-position TO TRUE
           END-IF
           
           *> next row in table
           COMPUTE wn-lokal-id = jlokal-lokal-id + 1
           
           .
           
       *>**************************************************          
       B0230-add-local-to-table.
       
            
           MOVE wn-lokal-id TO jlokal-lokal-id
           MOVE wc-lokalnamn TO jlokal-lokalnamn
           MOVE wc-vaningsplan TO jlokal-vaningsplan
           MOVE wn-maxdeltagare TO jlokal-maxdeltagare
            
           EXEC SQL
               INSERT INTO T_JLOKAL
               VALUES (:jlokal-lokal-id, :jlokal-lokalnamn,
                       :jlokal-vaningsplan, :jlokal-maxdeltagare)
           END-EXEC 
            
           IF  SQLCODE NOT = ZERO
                PERFORM Z0100-error-routine
           ELSE
                PERFORM B0240-commit-work
                DISPLAY "<br>[Info] Lokal adderad."
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
       B0300-edit-local.
           
           PERFORM B0310-does-local-id-exist
               
           IF local-id-is-in-table
               PERFORM B0320-change-local-item
           ELSE    
               DISPLAY "<br>[Info] Denna lokal finns ej."
           END-IF
           
           .

       *>**************************************************
           B0310-does-local-id-exist.

           *> Cursor for T_JLOKAL
           EXEC SQL
             DECLARE curseditlocal CURSOR FOR
                 SELECT Lokal_id, Lokalnamn, Vaningsplan, Maxdeltagare
                 FROM T_JLOKAL
           END-EXEC      

           *> Open the cursor
           EXEC SQL
                OPEN curseditlocal
           END-EXEC
           
           MOVE wn-lokal-id TO jlokal-lokal-id
                      
           *> fetch first row
           EXEC SQL
               FETCH curseditlocal
                   INTO :jlokal-lokal-id, :jlokal-lokalnamn,
                        :jlokal-vaningsplan, :jlokal-maxdeltagare 
           END-EXEC
           
           PERFORM UNTIL SQLCODE NOT = ZERO
           
               *> set flag if in table
               IF wn-lokal-id = jlokal-lokal-id
                    SET local-id-is-in-table TO TRUE
                    
                    *> this it the local row items we may update
                    MOVE jlocal-rec-vars TO wr-cur-rec-vars
                    
               END-IF
           
              *> fetch next row  
               EXEC SQL
                   FETCH curseditlocal
                       INTO :jlokal-lokal-id, :jlokal-lokalnamn,
                            :jlokal-vaningsplan, :jlokal-maxdeltagare
               END-EXEC
              
           END-PERFORM
           
           
           *> end of data
           IF  SQLSTATE NOT = '02000'
                PERFORM Z0100-error-routine
           END-IF                 
             
           *> close cursor
           EXEC SQL 
               CLOSE curseditlocal 
           END-EXEC            
           
           .
           
       *>**************************************************
           B0320-change-local-item.

           *> change any value that is different from existing
           
           IF wc-lokalnamn NOT = wc-cur-lokalnamn
               MOVE wc-lokalnamn TO jlokal-lokalnamn
           ELSE    
               MOVE wc-cur-lokalnamn TO jlokal-lokalnamn
           END-IF
           
           
           IF wc-vaningsplan NOT = wc-cur-vaningsplan
               MOVE wc-vaningsplan TO jlokal-vaningsplan
           ELSE
               MOVE wc-cur-vaningsplan TO jlokal-vaningsplan
           END-IF
           
           
           IF wn-cur-maxdeltagare NOT = wn-cur-maxdeltagare
               MOVE wc-lokalnamn TO jlokal-maxdeltagare
           ELSE    
               MOVE wn-cur-maxdeltagare TO jlokal-maxdeltagare
           END-IF
           
           
           MOVE wn-lokal-id TO jlokal-lokal-id
           
           *> update table
           EXEC SQL
               UPDATE T_JLOKAL
                   SET Lokalnamn = :jlokal-lokalnamn,
                       Vaningsplan = :jlokal-vaningsplan,
                       Maxdeltagare = :jlokal-maxdeltagare
               WHERE Lokal_id = :jlokal-lokal-id
           END-EXEC
            
           IF  SQLCODE NOT = ZERO
                PERFORM Z0100-error-routine
           ELSE
                PERFORM B0240-commit-work
                DISPLAY "<br>[Info] Lokal ändrad."
           END-IF
           
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
