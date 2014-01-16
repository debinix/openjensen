       *>
       *>  Open Cobol ESQL (Ocesql) Sample Program
       *>  bkconnect -- demonstrates SQL connect
       *>  to PostgreSQL database (if it exist).
       *>
       IDENTIFICATION DIVISION.
       program-id. bkconnect.       

       DATA DIVISION.
       working-storage section.
 
       EXEC SQL BEGIN DECLARE SECTION END-EXEC.
       01  dbname                  PIC  X(30) VALUE SPACE.
       01  username                PIC  X(30) VALUE SPACE.
       01  dbpasswd                PIC  X(10) VALUE SPACE.
       01  record-cnt              PIC  9(04).
       EXEC SQL END DECLARE SECTION END-EXEC.

       EXEC SQL INCLUDE SQLCA END-EXEC.

       PROCEDURE DIVISION.

       000-main.
       *> (just to be sure)       
           COPY setupenv_openjensen.
       *>           
           DISPLAY "*** CONNECT STARTED ***".
           
       *>  CONNECT
           MOVE  "openjensen"    TO   dbname.
           MOVE  "jensen"        TO   username.
           MOVE  SPACE           TO   dbpasswd.
           
           EXEC SQL
               CONNECT :username IDENTIFIED BY :dbpasswd USING :dbname 
           END-EXEC.
           IF  SQLSTATE NOT = ZERO PERFORM 900-error-routine STOP RUN.
                  
       *>  SELECT COUNT(*) INTO HOST-VARIABLE
       *>  Note: table name (t_ort) has to be hard coded.
           EXEC SQL 
               SELECT COUNT(*) INTO :record-cnt FROM t_ort
           END-EXEC.
           IF  SQLSTATE NOT = ZERO PERFORM 900-error-routine.
           DISPLAY "TOTAL RECORD: " record-cnt.
                  
                                 
       *>  DISCONNECT
           EXEC SQL
               DISCONNECT ALL
           END-EXEC.
           
       *>  END
           DISPLAY "*** CONNECT FINISHED SUCCESFUL ***".
           STOP RUN.

       *>
       900-error-routine.
       *>
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
                 
              *> Skip the rollback of transaction.
              *> EXEC SQL
              *>       ROLLBACK
              *>  END-EXEC
           END-EVALUATE.
           
       *> END PROGRAM  
