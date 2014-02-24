       *>******************************************************
       *> Test setup of setup of OCESQL (pre-processor)
       *> Database: openjensen, test table: tbl_user
       *>
       *> Coder: BK
       *>
       *>******************************************************        
       IDENTIFICATION DIVISION.
       program-id. anslutdb.
       ENVIRONMENT DIVISION.
       DATA DIVISION.         
       working-storage section.
        
       EXEC SQL BEGIN DECLARE SECTION END-EXEC.
       01 username                PIC  X(30) VALUE SPACE.        
       01 dbname                  PIC  X(30) VALUE SPACE.
       01 dbpasswd                PIC  X(10) VALUE SPACE.
       01 record-cnt              PIC  9(04) VALUE ZERO.
       EXEC SQL END DECLARE SECTION END-EXEC.
 
       EXEC SQL INCLUDE SQLCA END-EXEC.        
        
       *>******************************************************
       PROCEDURE DIVISION.
       000-main.
           
           *> development environment settings for test
           COPY setupenv_openjensen. 
           
           DISPLAY "*** ANSLUTNINGSTEST STARTAS ***"
           DISPLAY "*** DB: openjensen TBL: tbl_user ***"           
     
           PERFORM A100-connect-to-database
              
           GOBACK
           .
            
       *>******************************************************    
       A100-connect-to-database.
        
           *>  CONNECT
           MOVE  "openjensen"    TO   dbname
           MOVE  "jensen"        TO   username
           MOVE  SPACE           TO   dbpasswd
            
           EXEC SQL
               CONNECT :username IDENTIFIED BY :dbpasswd USING :dbname 
           END-EXEC
            
           IF  SQLSTATE NOT = ZERO
               PERFORM A900-error-routine
               STOP RUN
           END-IF
                       
           EXEC SQL 
               SELECT COUNT(*) INTO :record-cnt FROM tbl_user  
           END-EXEC
            
           IF  SQLSTATE NOT = ZERO
               PERFORM A900-error-routine
           END-IF
            
           IF SQLSTATE = ZERO
               DISPLAY "ANTALET POSTER: " record-cnt
           END-IF
                                  
           *>  DISCONNECT
           EXEC SQL
               DISCONNECT ALL
           END-EXEC
            
           *>  END
           IF SQLSTATE = ZERO
               DISPLAY "*** ANSLUTNINGSTEST OK ***"
           END-IF
                
           .
            
       *>******************************************************               
       A900-error-routine.
           
           DISPLAY "***SQL DATABAS FEL ***"
           DISPLAY "SQLSTATE: " SQLSTATE
            
           EVALUATE SQLSTATE
               WHEN  "02000"
                   DISPLAY "Inga poster funna!"

               WHEN  "08003"
               WHEN  "08001"
                   DISPLAY "Anslutningsförsöket misslyckadades!"            
                 
               WHEN  SPACE
                   DISPLAY "Okänt databasfel!"
  
               WHEN  OTHER
                   DISPLAY "SQLCODE: "   SQLCODE
                   DISPLAY "SQLERRMC: "  SQLERRMC
           END-EVALUATE
           .            
            
       *>******************************************************    
            