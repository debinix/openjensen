       IDENTIFICATION DIVISION.
       program-id. error-printscr IS INITIAL.
        
       ENVIRONMENT DIVISION.
        
       DATA DIVISION.
       working-storage section.
       01  wc-debug             PIC X(40) VALUE SPACE.
                
       linkage section.
       01  lc-err-state         PIC X(5).
       01  lc-err-msg           PIC X(70).
        
       PROCEDURE DIVISION USING lc-err-state lc-err-msg.
       000-error-printscr.
        
           *> only display if debug environment is set
           ACCEPT wc-debug FROM ENVIRONMENT 'OJ_DBG'
           
           IF wc-debug = '1'
               DISPLAY '<br>ERROR: |' lc-err-state '|' lc-err-msg
           END-IF
           
           *> TODO
           *> Only write to log file if OJ_LOG is set 1
            
           EXIT PROGRAM
           .
            
       *>******************************************************             


<