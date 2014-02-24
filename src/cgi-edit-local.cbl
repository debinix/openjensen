       *>
       *> INITIAL TEMPLATE FOR SQL UPDATE (here lokal)
       *>          
       *>
       *> cgi-edit-local: changes existing data.
       *> Finally saves into table T_JLOKAL
       *> 
       *> Coder: BK (not part of application)
       *>
       IDENTIFICATION DIVISION.
       program-id. cgi-edit-local.
       *>**************************************************
       DATA DIVISION.
       working-storage section.
       01   switches-edit.
            03  is-db-connected-switch              PIC X   VALUE 'N'.
                88  is-db-connected                         VALUE 'Y'.
            03  is-valid-init-switch                PIC X   VALUE 'N'.
                88  is-valid-init                           VALUE 'Y'.             
            03  local-id-is-in-table-switch         PIC X   VALUE 'N'.
                88  local-id-is-in-table                    VALUE 'Y'.                             
                
       *> used in calls to dynamic libraries
       01  wn-rtn-code             PIC  S99   VALUE ZERO.
       01  wc-post-name            PIC X(40)  VALUE SPACE.
       01  wc-post-value           PIC X(40)  VALUE SPACE.
       
       *> always - used in error routine
       01  wc-printscr-string      PIC X(40)  VALUE SPACE.        
       
       01  wc-pagetitle            PIC X(20) VALUE 'Uppdatera lokaler'.
       
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
       
       *> temporary table holding existing data
       01  wr-cur-rec-vars.
           05  wn-cur-lokal-id         PIC  9(4) VALUE ZERO.     
           05  wc-cur-lokalnamn        PIC  X(40) VALUE SPACE. 
           05  wc-cur-vaningsplan      PIC  X(40) VALUE SPACE.
           05  wc-cur-maxdeltagare     PIC  X(40) VALUE SPACE.           

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
                
                    PERFORM B0200-edit-local
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
                PERFORM A0110-init-edit-action
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
               MOVE 'Saknar ett angivet lokal id'
                    TO wc-printscr-string
               CALL 'stop-printscr' USING wc-printscr-string      
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
                                             
               MOVE wc-post-value TO wc-maxdeltagare              
                
               IF wc-lokalnamn NOT = SPACE OR
                  wc-vaningsplan NOT = SPACE OR
                  wc-maxdeltagare NOT = SPACE
                        SET is-valid-init TO TRUE                  
               ELSE
                   MOVE 'Ingen kolumn att uppdatera'
                        TO wc-printscr-string
                   CALL 'stop-printscr' USING wc-printscr-string
               END-IF   
                  
           
           END-IF
       
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
       B0200-edit-local.
           
           PERFORM B0210-does-local-id-exist
               
           IF local-id-is-in-table
               PERFORM B0220-change-local-item
           ELSE
               MOVE 'Denna lokal finns ej'
                    TO wc-printscr-string
               CALL 'stop-printscr' USING wc-printscr-string
           END-IF
           
           .

       *>**************************************************
       B0210-does-local-id-exist.

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

               *> retrieve current row columns (which we may update)
               
               MOVE jlokal-lokal-id TO wn-cur-lokal-id
               MOVE jlokal-lokalnamn TO wc-cur-lokalnamn
               MOVE jlokal-vaningsplan TO wc-cur-vaningsplan
               MOVE jlokal-maxdeltagare TO wc-cur-maxdeltagare
                    
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
       B0220-change-local-item.

           *> change any value that is different from existing
           
           *> any changes to Lokalnamn?
           IF wc-lokalnamn NOT = wc-cur-lokalnamn
               MOVE wc-lokalnamn TO jlokal-lokalnamn
           ELSE    
               MOVE wc-cur-lokalnamn TO jlokal-lokalnamn
           END-IF
           
           *> any changes to Vaningsplan?           
           IF wc-vaningsplan NOT = wc-cur-vaningsplan
               MOVE wc-vaningsplan TO jlokal-vaningsplan
           ELSE
               MOVE wc-cur-vaningsplan TO jlokal-vaningsplan
           END-IF
           
            *> any changes to Maxdeltagare?
           IF wc-cur-maxdeltagare NOT = wc-cur-maxdeltagare
               MOVE wc-lokalnamn TO jlokal-maxdeltagare
           ELSE    
               MOVE wc-cur-maxdeltagare TO jlokal-maxdeltagare
           END-IF
                      
           *> finally update table
           MOVE wn-lokal-id TO jlokal-lokal-id
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
                PERFORM B0230-commit-work
                MOVE 'Lokal ändrad' TO wc-printscr-string
                CALL 'ok-printscr' USING wc-printscr-string      
           END-IF
           
           .           

       *>**************************************************       
       B0230-commit-work.

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
