       *>
       *> cgi-list-betygelev: fetch a list of student
       *> courses within his program and his grades
       *> from table tbl_course and tbl_grade and writes
       *> the results back to file.
       *> 
       *> Coder: BK  
       *>
       IDENTIFICATION DIVISION.
       program-id. cgi-list-betygelev.
       *>**************************************************
       ENVIRONMENT DIVISION.
       input-output section.
                 
       file-control.
           SELECT fileout ASSIGN TO
              '../data/betyg-elev.txt'
              ORGANIZATION IS LINE SEQUENTIAL.
           
           SELECT OPTIONAL statusfile
              ASSIGN TO
              '../data/status'             
              ORGANIZATION IS LINE SEQUENTIAL.  
              
       *>**************************************************
       DATA DIVISION.
       file section.
        
       FD  fileout.
       01  fd-fileout-post. 
           03  fc-course-name             PIC X(40).
           03  fc-sep-1                   PIC X.      
           03  fc-course-start            PIC X(10).
           03  fc-sep-2                   PIC X.           
           03  fc-course-end              PIC X(10).
           03  fc-sep-3                   PIC X.     
           03  fc-grade                   PIC X(40).    
           03  fc-sep-4                   PIC X.      
           03  fc-grade-comment           PIC X(40).
           03  fc-sep-5                   PIC X.      
           03  fc-magic-number            PIC X(40).
           
       FD  statusfile.
       01  fd-fileout-status         PIC  X(1) VALUE SPACE.           
           
       *>--------------------------------------------------
       working-storage section.
       01   switches.
            03  is-db-connected-switch      PIC X   VALUE 'N'.
                88  is-db-connected                 VALUE 'Y'.
            03  is-valid-init-switch        PIC X   VALUE 'N'.
                88  is-valid-init                   VALUE 'Y'.
            03  is-grade-done-switch        PIC X   VALUE 'N'.
                88  is-grade-done                   VALUE 'Y'.
            03  is-sql-error-switch         PIC X   VALUE 'N'.
                88  is-sql-error                    VALUE 'Y'.
       
       *> each switch monitors one received POST name-value pair
       01  sub-init-swithes.        
            03  is-valid-init-user-switch   PIC X   VALUE 'N'.
                88  is-valid-init-user              VALUE 'Y'.
            03  is-valid-init-program-witch PIC X   VALUE 'N'.
                88  is-valid-init-program           VALUE 'Y'.
            03  is-valid-init-magic-switch  PIC X   VALUE 'N'.
                88  is-valid-init-magic             VALUE 'Y'.                
                
       *> temporary table for completed grades for this student         
       01   tbl-grade                         VALUE ZERO.
            03 grade OCCURS 25 TIMES.
                05  wn-tbl-user-id          PIC  9(4).
       01   wn-tbl-cnt                      PIC  9(2) VALUE ZERO.                   
                
       *> used in calls to dynamic libraries
       01  wn-rtn-code             PIC  S99   VALUE ZERO.
       01  wc-post-name            PIC X(40)  VALUE SPACE.
       01  wc-post-value           PIC X(40)  VALUE SPACE.
       
       *> always - used in error routine
       01  wc-printscr-string      PIC X(40)  VALUE SPACE.   
       
       01  wc-pagetitle            PIC X(20) VALUE 'Lista kurser'.
       
           EXEC SQL BEGIN DECLARE SECTION END-EXEC.
       01  wc-database              PIC  X(30).
       01  wc-passwd                PIC  X(10).       
       01  wc-username              PIC  X(30).
           EXEC SQL END DECLARE SECTION END-EXEC.       
       
       *>#######################################################
           EXEC SQL BEGIN DECLARE SECTION END-EXEC.
       *>
       01  tbl-cource-record.       
           05  tbl_course-course_id        PIC  9(4).
           05  tbl_course-course_name      PIC  X(40).
           05  tbl_course-course_startdate PIC  X(10).
           05  tbl_course-course_enddate   PIC  X(10).
           05  tbl_course-program_id       PIC  9(4).           

       *> table data
       01  wr-course-record.
           05  wn-course_id          PIC  9(4)  VALUE ZERO.          
           05  wc-course_name        PIC  X(40) VALUE SPACE.
           05  wc-course_startdate   PIC  X(10) VALUE SPACE.
           05  wc-course_enddate     PIC  X(10) VALUE SPACE.
           05  wn-course-program_id  PIC  9(4)  VALUE ZERO.  
       
       *>*******************************************************
       01  tbl-grade-record.       
           05  tbl_grade-grade_id         PIC  9(4).
           05  tbl_grade-grade_grade      PIC  X(40).
           05  tbl_grade-grade_comment    PIC  X(40).
           05  tbl_grade-user_id          PIC  9(4).
           05  tbl_grade-course_id        PIC  9(4).             

       *> table data
       01  wr-grade-record.
           05  wn-grade_id           PIC  9(4)  VALUE ZERO.          
           05  wc-grade_grade        PIC  X(40) VALUE SPACE.
           05  wc-grade_comment      PIC  X(40) VALUE SPACE.
           05  wn-grade-user_id      PIC  9(4)  VALUE ZERO.
           05  wn-grade-course_id    PIC  9(4)  VALUE ZERO. 
           
           EXEC SQL END DECLARE SECTION END-EXEC.    
       *>#######################################################

           EXEC SQL INCLUDE SQLCA END-EXEC.
           
       *> receiving variables for data passed from php
       01 wn-user_id                 PIC  9(4) VALUE ZERO.
       01 wn-program_id              PIC  9(4) VALUE ZERO.
       01 wc-magic-number              PIC  X(40) VALUE SPACE.
       
       *> holds the status file real name
       01 wc-file-name               PIC  X(60) VALUE SPACE.
       01 wc-dest-path               PIC  X(80) VALUE SPACE.
       
       *> constant to signal to php - no value
       01 WC-NO-SQLVALUE-TO-PHP      PIC X(1)  VALUE '-'.   
              
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
                    PERFORM B0200-list-elev-betyg
                    PERFORM B0300-disconnect
                END-IF
           ELSE
                MOVE 'Kunde ej läsa POST data' TO wc-printscr-string
                CALL 'stop-printscr' USING wc-printscr-string
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
           
               *>  get program_id          
               MOVE ZERO TO wn-rtn-code
               MOVE SPACE TO wc-post-value
               MOVE 'user_program' TO wc-post-name
               CALL 'get-post-value' USING wn-rtn-code
                                           wc-post-name wc-post-value
               IF wc-post-value NOT = SPACE
                   SET is-valid-init-program TO TRUE
                   MOVE FUNCTION NUMVAL(wc-post-value) TO wn-program_id
               END-IF                            

               
               *>  get user_id          
               MOVE ZERO TO wn-rtn-code
               MOVE SPACE TO wc-post-value
               MOVE 'user_id' TO wc-post-name
               CALL 'get-post-value' USING wn-rtn-code
                                           wc-post-name wc-post-value
               IF wc-post-value NOT = SPACE
                   SET is-valid-init-user TO TRUE
                   MOVE FUNCTION NUMVAL(wc-post-value) TO wn-user_id
               END-IF
               
               
               *> get magic number to return with data sent back to php
               MOVE ZERO TO wn-rtn-code
               MOVE SPACE TO wc-post-value
               MOVE 'magic_number' TO wc-post-name
               CALL 'get-post-value' USING wn-rtn-code
                                           wc-post-name wc-post-value
               IF wc-post-value NOT = SPACE
                   SET is-valid-init-magic TO TRUE                                                      
                   MOVE wc-post-value TO wc-magic-number               
               END-IF
               
               *> all must be valid
               IF is-valid-init-program AND is-valid-init-user AND
                  is-valid-init-magic
                  
                  SET is-valid-init TO TRUE
                  *> open outfile
                  OPEN OUTPUT fileout
                  
               END-IF   
  
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
       B0200-list-elev-betyg.

           PERFORM B0210-process-given-grades
           PERFORM B0250-process-all-programs
       
           .

       *>**************************************************          
       B0210-process-given-grades.
           
           MOVE wn-user_id TO wn-grade-user_id
           MOVE ZERO TO wn-tbl-cnt
           
       *>  declare cursor
           EXEC SQL 
               DECLARE cursgrade CURSOR FOR
               SELECT g.course_id, c.course_name, 
                      c.course_startdate, c.course_enddate,
                      g.grade_grade, g.grade_comment
                      FROM tbl_course c
                      INNER JOIN tbl_grade g
                      ON c.course_id = g.course_id
                      AND g.user_id = :wn-grade-user_id
           END-EXEC
           
           *> never never use a dash in cursor names!
           EXEC SQL
               OPEN cursgrade
           END-EXEC
       
       *>  fetch first row       
           EXEC SQL 
                FETCH cursgrade INTO :tbl_grade-course_id,
                                     :tbl_course-course_name,
                                     :tbl_course-course_startdate,
                                     :tbl_course-course_enddate,
                                     :tbl_grade-grade_grade,
                                     :tbl_grade-grade_comment
           END-EXEC
           
           PERFORM UNTIL SQLCODE NOT = ZERO
           
              MOVE  tbl_grade-course_id TO wn-grade-course_id
              MOVE  tbl_course-course_name TO wc-course_name
              MOVE  tbl_course-course_startdate TO wc-course_startdate
              MOVE  tbl_course-course_enddate TO wc-course_enddate
              MOVE  tbl_grade-grade_grade TO wc-grade_grade
              MOVE  tbl_grade-grade_comment TO wc-grade_comment
              
              PERFORM B0220-write-grade-row

              INITIALIZE wr-grade-record
           
              *> fetch next row  
               EXEC SQL 
                FETCH cursgrade INTO :tbl_course-course_name,
                                     :tbl_course-course_startdate,
                                     :tbl_course-course_enddate,
                                     :tbl_grade-grade_grade,
                                     :tbl_grade-grade_comment
               END-EXEC
              
           END-PERFORM
           
           *> end of data
           IF  SQLSTATE NOT = '02000'
                PERFORM Z0100-error-routine
           END-IF              
             
       *>  close cursor
           EXEC SQL 
               CLOSE cursgrade 
           END-EXEC
           
           .
                  
       *>**************************************************
       B0220-write-grade-row.            
           
           
           MOVE wc-course_name TO fc-course-name
           MOVE ',' TO fc-sep-1
           MOVE wc-course_startdate TO fc-course-start
           MOVE ',' TO fc-sep-2           
           MOVE wc-course_enddate TO fc-course-end
           MOVE ',' TO fc-sep-3           
           MOVE wc-grade_grade TO fc-grade
           MOVE ',' TO fc-sep-4           
           MOVE wc-grade_comment TO fc-grade-comment
           MOVE ',' TO fc-sep-5           
           MOVE wc-magic-number TO fc-magic-number             
           
           *> Rememeber which user-id have completed their grades
           ADD 1 TO wn-tbl-cnt
           MOVE wn-grade-course_id TO wn-tbl-user-id(wn-tbl-cnt)
           
           WRITE fd-fileout-post
           
           .    

       *>**************************************************          
       B0250-process-all-programs.
           
           MOVE wn-program_id TO wn-course-program_id
           
       *>  declare cursor
           EXEC SQL 
               DECLARE cursprog CURSOR FOR
               SELECT course_id, course_name, course_startdate,
                      course_enddate
               FROM tbl_course
               WHERE program_id = :wn-course-program_id
           END-EXEC
           
           *> never, never use a dash in cursor names!
           EXEC SQL
               OPEN cursprog
           END-EXEC
       
       *>  fetch first row       
           EXEC SQL 
               FETCH cursprog INTO :tbl_course-course_id,
                                   :tbl_course-course_name,
                                   :tbl_course-course_startdate,
                                   :tbl_course-course_enddate
           END-EXEC
                      
           PERFORM UNTIL SQLCODE NOT = ZERO
           
              MOVE  tbl_course-course_id TO wn-course_id              
              MOVE  tbl_course-course_name TO wc-course_name
              MOVE  tbl_course-course_startdate TO wc-course_startdate
              MOVE  tbl_course-course_enddate TO wc-course_enddate
              
              PERFORM B0260-write-program-row

              INITIALIZE wr-course-record
           
              *> fetch next row  
               EXEC SQL 
                    FETCH cursprog INTO :tbl_course-course_id,
                                        :tbl_course-course_name,
                                        :tbl_course-course_startdate,
                                        :tbl_course-course_enddate
               END-EXEC
              
           END-PERFORM
           
           *> end of data
           IF  SQLSTATE NOT = '02000'
                PERFORM Z0100-error-routine
           END-IF              
             
       *>  close cursor
           EXEC SQL 
               CLOSE cursprog 
           END-EXEC 
           
           .
           
       *>**************************************************
       B0260-write-program-row.            
           
           *> write non-completed courses
           
           *> check user-id for completed courses
           MOVE 1 TO wn-tbl-cnt
           PERFORM WITH TEST AFTER
               VARYING wn-tbl-cnt FROM 1 BY 1
               UNTIL wn-tbl-cnt >= 25 OR is-grade-done
        
               IF wn-tbl-user-id(wn-tbl-cnt) = wn-course_id
                   SET is-grade-done TO TRUE
               END-IF
           END-PERFORM
           
           *> move constant into the grade fields
           IF NOT is-grade-done
           
               MOVE wc-course_name TO fc-course-name
               MOVE ',' TO fc-sep-1
               MOVE wc-course_startdate TO fc-course-start
               MOVE ',' TO fc-sep-2           
               MOVE wc-course_enddate TO fc-course-end
               MOVE ',' TO fc-sep-3           
               MOVE WC-NO-SQLVALUE-TO-PHP TO fc-grade
               MOVE ',' TO fc-sep-4           
               MOVE WC-NO-SQLVALUE-TO-PHP TO fc-grade-comment
               MOVE ',' TO fc-sep-5           
               MOVE wc-magic-number TO fc-magic-number               
               
               WRITE fd-fileout-post
           
           END-IF
           
           *> reset found switch for next line
           MOVE 'N' TO is-grade-done-switch
           
           .                

       *>**************************************************
       B0300-disconnect. 
                                 
       *>  disconnect
           EXEC SQL
               DISCONNECT ALL
           END-EXEC
           
           IF NOT is-sql-error
               PERFORM Z0200-write-status-ok-file
           END-IF
           
           *> close outfile
           CLOSE fileout
           
           .

       *>**************************************************
       C0100-closedown.

           CALL 'wui-end-html' USING wn-rtn-code 
           
           .
           
       *>**************************************************
       Z0100-error-routine.
                  
           SET is-sql-error TO TRUE
           
           *> requires the ending dot (and no extension)!
           COPY z0100-error-routine.
           
           .
           
       *>**************************************************
       Z0200-write-status-ok-file.
       
           *> use the magic number as base in the new filename
           MOVE wc-magic-number TO wc-file-name
       
           *> create a zero file
           OPEN EXTEND statusfile           
           CLOSE statusfile
           
           *> create a new name like '78637866427818048743723.OK'
           MOVE SPACE TO wc-dest-path    
           STRING '../data/'   DELIMITED BY SPACE
              wc-file-name DELIMITED BY SPACE 
                      '.'  DELIMITED BY SPACE
                      'OK' DELIMITED BY SPACE
                      INTO wc-dest-path
                      ON OVERFLOW
                      MOVE 'Filnamn för långt' TO wc-printscr-string
                      CALL 'stop-printscr' USING wc-printscr-string
                      NOT ON OVERFLOW
                         CONTINUE
           END-STRING                   
           *> copy existing dummy named 'status' file to OK-file
           CALL 'C$COPY' USING '../data/status', wc-dest-path, 0
           *> remove not needed dummy file
           CALL 'C$DELETE' USING '../data/status', 0           
       
           .           
           
       *>**************************************************    
       *> END PROGRAM  
