       *>
       *> bktort (not part of application)
       *>
       *> Open Cobol ESQL (Ocesql) Sample Program
       *> bktort -- demonstrates SQL connect and
       *> select data from table 't_ort'.
       *>
       *> Coder: BK
       *>
       IDENTIFICATION DIVISION.
       
       IDENTIFICATION DIVISION.
       program-id. bktort.       

       DATA DIVISION.
       working-storage section.
       01  ws-tort-rec.
           05  ws-tort-ort         PIC  X(40).
           05  FILLER              PIC  X.
           05  ws-tort-postnummer  PIC  X(5).      
 
       EXEC SQL BEGIN DECLARE SECTION END-EXEC.
       01  dbname                  PIC  X(30) VALUE SPACE.
       01  username                PIC  X(30) VALUE SPACE.
       01  dbpasswd                PIC  X(10) VALUE SPACE.
       01  tort-cnt                PIC  9(04).
       01  tort-rec-vars.
           05  tort-ort            PIC  X(40).
           05  tort-postnr         PIC  X(05).
       EXEC SQL END DECLARE SECTION END-EXEC.

       EXEC SQL INCLUDE SQLCA END-EXEC.

       PROCEDURE DIVISION.

       MAIN-RTN.
           DISPLAY "*** CONNECT STARTED ***".
           DISPLAY "*** DB: openjensen TBL: t_ort ***".
           
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
               SELECT COUNT(*) INTO :tort-cnt FROM t_ort
           END-EXEC.
           IF  SQLSTATE NOT = ZERO PERFORM 900-error-routine.
           DISPLAY "TOTAL RECORD: " tort-cnt.                  
                  
       *>  DECLARE CURSOR
           EXEC SQL 
               DECLARE C1 CURSOR FOR
               SELECT postort, postnummer
                      FROM t_ort
                      ORDER BY postort
           END-EXEC.                  
           EXEC SQL
               OPEN C1
           END-EXEC.
           IF  SQLSTATE NOT = ZERO PERFORM 900-error-routine STOP RUN.                  
             

           DISPLAY "------------------------------------------------".
           DISPLAY "Postort                                Postnumer".
           DISPLAY "------------------------------------------------".
       
       *>  FETCH       
           EXEC SQL 
               FETCH C1 INTO :tort-ort, :tort-postnr
           END-EXEC.
           PERFORM UNTIL SQLSTATE NOT = ZERO
              MOVE  tort-ort      TO    ws-tort-ort
              MOVE  tort-postnr   TO    ws-tort-postnummer
              
              DISPLAY ws-tort-rec
              EXEC SQL 
                  FETCH C1 INTO :tort-ort, :tort-postnr
              END-EXEC
           END-PERFORM.
           
           IF  SQLSTATE NOT = "02000" PERFORM 900-error-routine STOP RUN.             
             
             
       *>  CLOSE CURSOR
           EXEC SQL 
               CLOSE C1 
           END-EXEC. 
           
       *>  COMMIT
           EXEC SQL 
               COMMIT WORK
           END-EXEC.             
                  
                  
                                 
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
              *> TO RESTART TRANSACTION, DO ROLLBACK.
              *> EXEC SQL
              *>       ROLLBACK
              *>  END-EXEC
           END-EVALUATE.
           
       *> END PROGRAM  
