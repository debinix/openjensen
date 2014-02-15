       *>
       *> cgi-list-betygalla: fetch a list of all student, 
       *> students courses in associated program and grade 
       *> status and write the results back to file.
       *> 
       *> Coder: BK 
       *>
       IDENTIFICATION DIVISION.
       program-id. cgi-list-betygalla.
       *>**************************************************
       ENVIRONMENT DIVISION.
       input-output section.
            
       file-control.
           SELECT fileout 
              ASSIGN TO '../betyg-all.txt'
              ORGANIZATION IS LINE SEQUENTIAL.         
       *>**************************************************
       DATA DIVISION.
       file section.
        
       FD  fileout.
       01  fd-fileout-post. 
           03  fc-course-name             PIC X(40).
           03  fc-sep-1                   PIC X.      
           03  fc-user-firstname          PIC X(40).
           03  fc-sep-2                   PIC X.           
           03  fc-user-lastname           PIC X(40).
           03  fc-sep-3                   PIC X.     
           03  fc-grade                   PIC X(40).           
           
       *>--------------------------------------------------
       working-storage section.
       01   switches.
           03  is-db-connected-switch      PIC X   VALUE 'N'.
               88  is-db-connected                 VALUE 'Y'.
           03  is-valid-init-switch        PIC X   VALUE 'N'.
               88  is-valid-init                   VALUE 'Y'.
       
       *> used in calls to dynamic libraries
       01  wn-rtn-code             PIC  S99   VALUE ZERO.
       01  wc-post-name            PIC X(40)  VALUE SPACE.
       01  wc-post-value           PIC X(40)  VALUE SPACE.
              
       *> always - used in error routine
       01  wc-printscr-string      PIC X(40)  VALUE SPACE.   
       
       01  wc-pagetitle            PIC X(20) VALUE 'Lista alla kurser'.
       
           EXEC SQL BEGIN DECLARE SECTION END-EXEC.
       01  wc-database              PIC  X(30).
       01  wc-passwd                PIC  X(10).       
       01  wc-username              PIC  X(30).
           EXEC SQL END DECLARE SECTION END-EXEC.       
       
       *>#######################################################
           EXEC SQL BEGIN DECLARE SECTION END-EXEC.
       *>
       01  tbl_user-rec-vars.       
           05  tbl_user-user_id          PIC  9(4).
           05  tbl_user-user_firstname   PIC  X(40).
           05  tbl_user-user_lastname    PIC  X(40).
           05  tbl_user-usertype_id      PIC  9(4).            
           05  tbl_user-user_program     PIC  9(4).           

       *> table data
       01  wr-rec-vars.
           05  wn-user_id               PIC  9(4)  VALUE ZERO.          
           05  wc-user_firstname        PIC  X(40) VALUE SPACE.
           05  wc-user_lastname         PIC  X(40) VALUE SPACE.
           05  wn-user-typeid           PIC  9(4)  VALUE ZERO.                
           05  wn-user-program          PIC  9(4)  VALUE ZERO.         
       
       *>*******************************************************
       01  tbl_course-rec-vars.       
           05  tbl_course-course_id        PIC  9(4).
           05  tbl_course-course_name      PIC  X(40).
           05  tbl_course-program_id       PIC  9(4).           

       *> table data
       01  wr-rec-vars.
           05  wn-course_id          PIC  9(4)  VALUE ZERO.          
           05  wc-course_name        PIC  X(40) VALUE SPACE.
           05  wn-course-program_id  PIC  9(4)  VALUE ZERO.  
       
       *>*******************************************************
       01  tbl_grade-rec-vars.       
           05  tbl_grade-grade_grade      PIC  X(40).
           05  tbl_grade-user_id          PIC  9(4).
           05  tbl_grade-course_id        PIC  9(4).           
       *>    

       *> table data
       01  wr-rec-vars.    
           05  wc-grade_grade        PIC  X(40) VALUE SPACE.
           05  wn-grade-user_id      PIC  9(4)  VALUE ZERO.
           05  wn-grade-course_id    PIC  9(4)  VALUE ZERO. 
           
           EXEC SQL END DECLARE SECTION END-EXEC.    
       *>#######################################################

           EXEC SQL INCLUDE SQLCA END-EXEC.
           
       *> receiving variables for data passed from php
       01 wn-program_id              PIC  9(4) VALUE ZERO.
       
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
                    PERFORM B0200-list-all-betyg
                    PERFORM B0300-disconnect
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
               
               *>  get program_id          
               MOVE ZERO TO wn-rtn-code
               MOVE SPACE TO wc-post-value
               MOVE 'program_id' TO wc-post-name
               CALL 'get-post-value' USING wn-rtn-code
                                           wc-post-name wc-post-value
               MOVE FUNCTION NUMVAL(wc-post-value) TO wn-program_id  
               
               *> open outfile
               OPEN OUTPUT fileout
  
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
       B0200-list-all-betyg.

           *> PERFORM B0210-process-given-grades
           PERFORM B0250-fetch-all-courses-in-pgrm
       
           .

       *>**************************************************          
       B0210-process-given-grades.
           

           *> MOVE ZERO TO wn-tbl-cnt
           
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
                                     :tbl_grade-grade_grade,
           END-EXEC
           
           PERFORM UNTIL SQLCODE NOT = ZERO
           
              MOVE  tbl_grade-course_id TO wn-grade-course_id
              MOVE  tbl_course-course_name TO wc-course_name


              MOVE  tbl_grade-grade_grade TO wc-grade_grade
              
              PERFORM B0220-write-grade-row

              INITIALIZE tbl_grade-rec-vars
           
              *> fetch next row  
               EXEC SQL 
                FETCH cursgrade INTO :tbl_course-course_name,
                                     :tbl_grade-grade_grade,
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
           
           *> STDOUT
           
           
           
           
           *> MOVE wc-course_name TO fc-course-name
           *> MOVE ',' TO fc-sep-1
           *> MOVE ',' TO fc-sep-2           
           *> MOVE ',' TO fc-sep-3           
           *> MOVE wc-grade_grade TO fc-grade       
           
           *> Rememeber which user-id have completed their grades
           *> ADD 1 TO wn-tbl-cnt
           *> MOVE wn-grade-course_id TO wn-tbl-user-id(wn-tbl-cnt)
           
           *> WRITE fd-fileout-post
           
           .    

       *>**************************************************          
       B0250-fetch-all-courses-in-pgrm.
               
           *> 1 is 'students'
           MOVE 1 TO wn-user-typeid
           MOVE wn-program_id TO wn-course-program_id           
           
       *>  get all courses for all users regardless if a grade is given
       
       *>  declare cursor          
           EXEC SQL            
              DECLARE cursall CURSOR FOR           
              SELECT c.course_name, u.user_firstname, u.user_lastname,
                     u.user_id, c.course_id, u.user_program
              FROM tbl_user u
              JOIN tbl_course c
              ON c.program_id = u.user_program
              AND   u.usertype_id = :wn-user-typeid
              AND   u.user_program = :wn-course-program_id
              ORDER BY c.course_name, u.user_lastname, u.user_firstname
           END-EXEC           
             
           *> never, never use a dash in cursor names!
           EXEC SQL
               OPEN cursall
           END-EXEC
       
       *>  fetch first row       
           EXEC SQL 
               FETCH cursall INTO :tbl_course-course_name,
                                  :tbl_user-user_firstname,
                                  :tbl_user-user_lastname,                       
                                  :tbl_user-user_id,
                                  :tbl_course-course_id,
                                  :tbl_user-user_program
           END-EXEC
                            
           PERFORM UNTIL SQLCODE NOT = ZERO
           
              MOVE tbl_course-course_name TO wc-course_name
              MOVE tbl_user-user_firstname TO wc-user_firstname
              MOVE tbl_user-user_lastname TO wc-user_lastname              
              MOVE tbl_user-user_id TO wn-user_id
              MOVE tbl_course-course_id TO wn-course_id
              MOVE tbl_user-user_program TO wn-user-program
              
              PERFORM B0260-write-course-row

              INITIALIZE tbl_user-rec-vars
              INITIALIZE tbl_course-rec-vars
              
           
              *> fetch next row  
               EXEC SQL 
               FETCH cursall INTO :tbl_course-course_name,
                                  :tbl_user-user_firstname,
                                  :tbl_user-user_lastname,                       
                                  :tbl_user-user_id,
                                  :tbl_course-course_id,
                                  :tbl_user-user_program
               END-EXEC
              
           END-PERFORM
           
           *> end of data
           IF  SQLSTATE NOT = '02000'
                PERFORM Z0100-error-routine
           END-IF              
             
       *>  close cursor
           EXEC SQL 
               CLOSE cursall 
           END-EXEC 
           
           .
           
       *>**************************************************
       B0260-write-course-row.            
           

           *> STDOUT
           *>    DISPLAY '<br> ' wc-course_name
           *>    DISPLAY '<br> ' wc-user_firstname
           *>    DISPLAY '<br> ' wc-user_lastname
           
           *>   DISPLAY '<br> ' wn-user_id
           *>   DISPLAY '<br> ' wn-course_id
           *>   DISPLAY '<br> ' wn-user-program           
           
           MOVE WC-NO-SQLVALUE-TO-PHP TO wc-grade_grade
           
           
           MOVE wc-course_name TO fc-course-name
           MOVE ',' TO fc-sep-1
           MOVE wc-user_firstname TO fc-user-firstname
           MOVE ',' TO fc-sep-2
           MOVE wc-user_lastname TO fc-user-lastname
           MOVE ',' TO fc-sep-3
           MOVE wc-grade_grade TO fc-grade

           WRITE fd-fileout-post
           
           .                

       *>**************************************************
       B0300-disconnect. 
                                 
       *>  disconnect
           EXEC SQL
               DISCONNECT ALL
           END-EXEC
           
           *> close outfile
           CLOSE fileout
           
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
