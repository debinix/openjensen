       *>
       *> cgi-add-betyg: sets the student grade for
       *> existing student, saves into table tbl_grade
       *> 
       *> Coder: BK 
       *>
       IDENTIFICATION DIVISION.
       program-id. cgi-add-betyg.
       *>**************************************************
       DATA DIVISION.
       working-storage section.
       01   switches-add.
            03  is-db-connected-switch              PIC X   VALUE 'N'.
                88  is-db-connected                         VALUE 'Y'.
            03  is-valid-init-switch                PIC X   VALUE 'N'.
                88  is-valid-init                           VALUE 'Y'.
            03  grade-is-in-table-switch            PIC X   VALUE 'N'.
                88  grade-is-in-table                       VALUE 'Y'.
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
       01  tbl-grade-rec-vars.       
           05  tbl-grade-grade-id        PIC  9(4).
           05  tbl-grade-grade-grade     PIC  X(40).
           05  tbl-grade-grade-comment   PIC  X(40).
           05  tbl-grade-user-id         PIC  9(4).
           05  tbl-grade-course-id       PIC  9(4).           
       *>    
       EXEC SQL END DECLARE SECTION END-EXEC.
       *> table data
       01  wr-rec-vars.
           05  wn-grade-grade-id         PIC  9(4) VALUE ZERO.
           05  wc-grade-grade-grade      PIC  X(40) VALUE SPACE.
           05  wc-grade-grade-comment    PIC  X(40) VALUE SPACE.
           05  wn-grade-user-id          PIC  9(4) VALUE ZERO.
           05  wn-grade-course-id        PIC  9(4) VALUE ZERO.
           
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
                
                    PERFORM B0200-add-grade
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
       
           SET is-valid-init TO TRUE
           
           *>  read grade_grade (required)        
           MOVE ZERO TO wn-rtn-code
           MOVE SPACE TO wc-post-value
           MOVE 'grade_grade' TO wc-post-name
           CALL 'get-post-value' USING wn-rtn-code
                                       wc-post-name wc-post-value                           
           MOVE wc-post-value TO wc-grade-grade-grade
           IF wc-grade-grade-grade = SPACE
               MOVE 'Saknar betyget för student' TO wc-printscr-string
               CALL 'stop-printscr' USING wc-printscr-string
               MOVE 'N' TO is-valid-init-switch
           END-IF           
           
           *>  read grade_comment (required)    
           MOVE ZERO TO wn-rtn-code
           MOVE SPACE TO wc-post-value
           MOVE 'grade_comment' TO wc-post-name
           CALL 'get-post-value' USING wn-rtn-code
                                wc-post-name wc-post-value
              
           MOVE wc-post-value TO wc-grade-grade-comment
           IF wc-grade-grade-comment = SPACE
               MOVE 'Saknar kommentar på betyget' TO wc-printscr-string
               CALL 'stop-printscr' USING wc-printscr-string
               MOVE 'N' TO is-valid-init-switch
           END-IF                   


           *>  read user_id (required) 
           MOVE ZERO TO wn-rtn-code
           MOVE SPACE TO wc-post-value
           MOVE 'user_id' TO wc-post-name
            
           CALL 'get-post-value' USING wn-rtn-code wc-post-name
                                       wc-post-value
           
           IF wc-post-value = SPACE
               MOVE 'Saknar student id (user_id)' TO wc-printscr-string
               CALL 'stop-printscr' USING wc-printscr-string
               MOVE 'N' TO is-valid-init-switch
           ELSE
               MOVE FUNCTION NUMVAL(wc-post-value) TO wn-grade-user-id           
           END-IF                                
                                       
            
           *>  read course_id (required) 
           MOVE ZERO TO wn-rtn-code
           MOVE SPACE TO wc-post-value
           MOVE 'course_id' TO wc-post-name
            
           CALL 'get-post-value' USING wn-rtn-code wc-post-name
                                       wc-post-value
           
           IF wc-post-value = SPACE
              MOVE 'Saknar kurs id' TO wc-printscr-string
              CALL 'stop-printscr' USING wc-printscr-string
              MOVE 'N' TO is-valid-init-switch
           ELSE
              MOVE FUNCTION NUMVAL(wc-post-value) TO wn-grade-course-id           
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
       B0200-add-grade.
           
           
           PERFORM B0210-does-user-course-exist
               
           IF NOT grade-is-in-table
               PERFORM B0220-get-new-row-number
               
               IF is-valid-table-position
                   PERFORM B0230-add-new-grade-to-table
               END-IF
           ELSE
               MOVE 'Denna student har redan ett kursbetyg.'
                    TO wc-printscr-string
               CALL 'stop-printscr' USING wc-printscr-string
           END-IF
           
           .
           
       *>**************************************************          
       B0210-does-user-course-exist.
           
           *> Cursor for tbl_grade
                     
           EXEC SQL
              DECLARE ADDCHK CURSOR FOR
                 SELECT user_id, course_id
                 FROM tbl_grade
           END-EXEC      

           *> Open the cursor
           EXEC SQL
                OPEN ADDCHK
           END-EXEC
                      
           *> fetch first row
           EXEC SQL
               FETCH ADDCHK
                   INTO :tbl-grade-user-id, :tbl-grade-course-id
           END-EXEC
           
           
           PERFORM UNTIL SQLCODE NOT = ZERO
           
               *> set flag if already in the table
               IF ( tbl-grade-user-id = wn-grade-user-id
                    AND tbl-grade-course-id = wn-grade-course-id )
                  
                    SET grade-is-in-table TO TRUE
                        
               END-IF
           
              *> fetch next row  
              EXEC SQL
                  FETCH ADDCHK
                      INTO :tbl-grade-user-id, :tbl-grade-course-id
              END-EXEC
              
           END-PERFORM           
           
                      
           *> check for errors if query returned no rows
           IF  SQLSTATE NOT = '02000'
               PERFORM Z0100-error-routine
           END-IF
                 
             
           *> close cursor
           EXEC SQL 
               CLOSE ADDCHK 
           END-EXEC 
           
           .       
       
       *>**************************************************          
       B0220-get-new-row-number.
       
           *> Cursor for tbl_grade
           EXEC SQL
             DECLARE NEWROW CURSOR FOR
                 SELECT grade_id
                 FROM tbl_grade
                 ORDER BY grade_id DESC
           END-EXEC   
       
           *> Open the cursor
           EXEC SQL
                OPEN NEWROW
           END-EXEC
       
           *> fetch first row (which now have the highest id)
           EXEC SQL
               FETCH NEWROW
                   INTO :tbl-grade-grade-id
           END-EXEC       
        
           IF  SQLCODE NOT = ZERO
                PERFORM Z0100-error-routine
           ELSE
               SET is-valid-table-position TO TRUE
               
               *> next number for new row in table
               COMPUTE tbl-grade-grade-id = tbl-grade-grade-id + 1
               
           END-IF

           *> close cursor
           EXEC SQL 
               CLOSE NEWROW 
           END-EXEC            
           
           .
           
       *>**************************************************          
       B0230-add-new-grade-to-table.
                  
           MOVE wc-grade-grade-grade TO tbl-grade-grade-grade
           MOVE wc-grade-grade-comment TO tbl-grade-grade-comment
           MOVE wn-grade-user-id TO tbl-grade-user-id
           MOVE wn-grade-course-id TO tbl-grade-course-id
                     
           EXEC SQL
               INSERT INTO tbl_grade
               VALUES ( :tbl-grade-grade-id,
                        :tbl-grade-grade-grade,
                        :tbl-grade-grade-comment,
                        :tbl-grade-user-id,
                        :tbl-grade-course-id )
           END-EXEC 
            
           IF  SQLCODE NOT = ZERO
                PERFORM Z0100-error-routine
           ELSE
                PERFORM B0240-commit-work
                MOVE 'Nytt betyg adderat' TO wc-printscr-string
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
