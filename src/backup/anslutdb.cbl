        IDENTIFICATION DIVISION.
        program-id. anslutdb.
        
        ENVIRONMENT DIVISION.
        input-output section.
        
        file-control.
            select webinput assign to KEYBOARD
            file status is in-status.                
        
        DATA DIVISION.
        file section.
        
        fd  webinput.
        01  chunk-of-post     PIC X(1024).            
        
        working-storage section.

        01  content-length       PIC X(5)  VALUE SPACE.

        01  pagetitle    PIC X(20)  VALUE 'Anslutningstest'.
        01  dummy        PIC X      VALUE SPACE.
        01  newline      PIC X      VALUE x'0a'.
        
        01  in-status            PIC 9999.        
        01 value-string  PIC X(256) VALUE SPACE.        
        
        EXEC SQL BEGIN DECLARE SECTION END-EXEC.
        01  username                PIC  X(30) VALUE SPACE.        
        01  dbname                  PIC  X(30) VALUE SPACE.
        01  dbpasswd                PIC  X(10) VALUE SPACE.
        01  record-cnt              PIC  9(04).
        EXEC SQL END DECLARE SECTION END-EXEC.
 
        EXEC SQL INCLUDE SQLCA END-EXEC.        
        
        
        *>******************************************************
        PROCEDURE DIVISION.
        000-main.
        
            *> (just to be sure)       
            *> COPY setupenv_openjensen.        
        
            *> Always send out the Content-Type before any other I/O
            CALL 'wui-print-header' USING BY REFERENCE dummy.
            *>  start html doc
            CALL 'wui-start-html' USING BY CONTENT pagetitle
            
            ACCEPT content-length FROM ENVIRONMENT 'CONTENT_LENGTH'
            
            DISPLAY
                "<h3>*** ANSLUTNINGSTEST STARTAS ***</h3>"
                "<p>Content length (bytes): "
                content-length
                "</p>"
            END-DISPLAY
            
            *> Get POST variables from environment and set up for db
            PERFORM 050-set-post-variables            

            PERFORM 100-connect-test-to-database
             
            *>  end html doc
            CALL 'wui-end-html' USING BY REFERENCE dummy.                
        
            GOBACK
            .
            
        *>******************************************************             
        050-set-post-variables.
        
            ACCEPT value-string FROM ENVIRONMENT
                'REQUEST_METHOD'
            END-ACCEPT
        
            *> Check that it was a POST (not get)        
            DISPLAY
                "<p>"
                "REQUEST_METHOD"
                ": "
                function trim (value-string trailing)
                "</p>"
            END-DISPLAY
            
            IF function trim (value-string trailing) NOT = 'POST'
                DISPLAY
                    "<p> *** ERROR NOT A POST ***</p>"
                END-DISPLAY
                STOP RUN
            END-IF
            
            OPEN INPUT webinput
            IF in-status < 10 THEN
                READ
                    webinput
                END-READ
                IF in-status > 9 THEN
                    MOVE SPACES TO chunk-of-post
                END-IF
            END-IF
            CLOSE webinput
            
            DISPLAY
                "<p>"
                "POST is: " chunk-of-post(1:72)
                "</p>"
            END-DISPLAY
            
            .    
            
        *>******************************************************    
        100-connect-test-to-database.
        
            *>  CONNECT
            MOVE  "openjensen"    TO   dbname.
            MOVE  "jensen"        TO   username.
            MOVE  SPACE           TO   dbpasswd.
            
            EXEC SQL
                CONNECT :username IDENTIFIED BY :dbpasswd USING :dbname 
            END-EXEC.
            
            IF  SQLSTATE NOT = ZERO
                PERFORM 900-error-routine
                STOP RUN
            END-IF
            
            *>  SELECT COUNT(*) INTO HOST-VARIABLE
            *>  Note: table name (t_ort) has to be hard coded.
            EXEC SQL 
                SELECT COUNT(*) INTO :record-cnt FROM t_ort
            END-EXEC.
            
            IF  SQLSTATE NOT = ZERO
                PERFORM 900-error-routine
            END-IF
            
            IF SQLSTATE = ZERO
                DISPLAY
                    "<p>"
                    "ANTALET POSTER: " record-cnt
                    "</p>"
                END-DISPLAY
            END-IF
                                  
            *>  DISCONNECT
            EXEC SQL
                DISCONNECT ALL
            END-EXEC.
            
            *>  END
            IF SQLSTATE = ZERO
                DISPLAY
                    "<p>"            
                    "<h3>*** ANSLUTNINGSTEST OK ***</h3>"
                    "</p>"
                END-DISPLAY
            END-IF
                
            .
            
        *>******************************************************               
        900-error-routine.
            *>
            DISPLAY
                "<p>"
                "<h3>***SQL DATABAS FEL ***</h3>"
                "<br>"
                "SQLSTATE: " SQLSTATE
                "</p>"
            END-DISPLAY
            
            EVALUATE SQLSTATE
                WHEN  "02000"
                
                DISPLAY
                    "<p>"     
                     "Inga poster funna!"
                    "</p>"
                END-DISPLAY
                 
                WHEN  "08003"
                WHEN  "08001"
                DISPLAY
                    "<p>"                  
                    "Anslutningsförsöket misslyckadades!"
                    "</p>"
                END-DISPLAY                 
                 
                WHEN  SPACE
                DISPLAY
                    "<p>"    
                    "Okänt databasfel!"
                    "</p>"
                END-DISPLAY  
                 
                WHEN  OTHER
                DISPLAY
                    "<p>"                  
                    "SQLCODE: "   SQLCODE
                    "<br>"
                    "SQLERRMC: "  SQLERRMC
                    "</p>"
                END-DISPLAY                   
                 

            END-EVALUATE
            .            
            
        *>******************************************************    
            
        
