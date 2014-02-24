       *>
       *> toolchaindisplaytest: 
       *> Initial call tests - not part of application
       *> 
       *> Coder: BK 
       *>
       IDENTIFICATION DIVISION.
       program-id. toolchaindisplaytest.
        
       ENVIRONMENT DIVISION.
        
       DATA DIVISION.
       working-storage section.
       01  accept-char PIC X VALUE SPACE.
        
       linkage section.
       01  username    PIC X(15).        
        
       PROCEDURE DIVISION USING username.
       000-consolesubmain.
        
           DISPLAY '[sub justdisplay] You passed: ' username
           DISPLAY '[sub justdisplay] Press Enter key to return...'
           ACCEPT accept-char
            
           EXIT PROGRAM
           .
            
       *>******************************************************  

