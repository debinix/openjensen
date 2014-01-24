       IDENTIFICATION DIVISION.
       program-id. stop-printscr IS INITIAL.
        
       ENVIRONMENT DIVISION.
        
       DATA DIVISION.
       working-storage section.
       01  wc-debug         PIC X(40) VALUE SPACE.
                
       linkage section.
       01  lc-string        PIC X(40).
        
       PROCEDURE DIVISION USING lc-string.
       000-stop-printscr.
        
           *> only display if debug environment is set
           ACCEPT wc-debug FROM ENVIRONMENT 'OJ_DBG'
           
           IF wc-debug = '1'
               DISPLAY '<br>STOP: ' lc-string
           END-IF
               
           *> TODO
           *> Only write to log file if OJ_LOG is set 1
            
           EXIT PROGRAM
           .
            
       *>******************************************************             


