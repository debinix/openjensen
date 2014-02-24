       *>*************************************************
       *> Test that we have the environment setup
       *> properly to build application with OpenCobol
       *>
       *> Coder: BK
       *>
       *>*************************************************   
       IDENTIFICATION DIVISION.
       program-id. toolchaintest.
      
       ENVIRONMENT DIVISION.
        
       *>*************************************************
       DATA DIVISION.
       working-storage section.
       01  ws-meny-number      PIC 9     VALUE ZERO.
       01  ws-user-name        PIC X(15) VALUE SPACE.
       01  ws-num-of-spaces    PIC 99 VALUE 0.
        
       01  env-name            PIC X(40) VALUE SPACE.
       01  env-value           PIC X(40) VALUE SPACE.
        
       *>*************************************************        
       PROCEDURE DIVISION.
       000-toolchaintest.
            
           PERFORM A100-display-menu UNTIL ws-meny-number = 9

           GOBACK
           .
       *>*************************************************
       A100-display-menu.
        
           DISPLAY '**************************************'
           DISPLAY '1 - Initial simple test (no libs used)'
           DISPLAY '2 - Call your created (shared) function'            
           DISPLAY '3 - Use a built-in OpenCobol function'
           DISPLAY SPACE
           DISPLAY '9 - Quit'
                    DISPLAY SPACE
           DISPLAY 'Enter your choice: ' WITH NO ADVANCING
           ACCEPT ws-meny-number
            
           EVALUATE ws-meny-number
                WHEN 1 PERFORM B100-initial
                WHEN 2 PERFORM B200-call-my-subroutine
                WHEN 3 PERFORM B300-call-built-in-function
        
           END-EVALUATE
           .
       *>*************************************************        
       B100-initial.
        
           DISPLAY 'Enter your name: ' WITH NO ADVANCING
           ACCEPT ws-user-name
           DISPLAY 'Thank you ' ws-user-name
            
           .
       *>*************************************************
       B200-call-my-subroutine.        
        
           *> Show the required environment variable
           MOVE 'COB_LIBRARY_PATH' TO env-name
            
           DISPLAY '*** Environment required for CALLs ***'
           ACCEPT env-value FROM ENVIRONMENT env-name
           DISPLAY '|' env-name '|' env-value '|'
           DISPLAY SPACE
            
           *> Do we have a name?
           INSPECT ws-user-name TALLYING ws-num-of-spaces
               FOR ALL SPACE
            
           *> LENGTH give us the declared size of the string
           IF FUNCTION LENGTH(ws-user-name) NOT = ws-num-of-spaces   
               CALL 'toolchaindisplaytest' USING BY
                                               CONTENT ws-user-name
           ELSE
               DISPLAY 'Ooops..Enter your name with (1)'
               DISPLAY 'Please enter a name first!'
           END-IF
            
           .
       *>*************************************************
       B300-call-built-in-function. 
                
            
           MOVE 'COB_LIBRARY_PATH' TO env-name
           DISPLAY env-name
           DISPLAY 'Use built-in function reverse above text'
           DISPLAY 'Reversed: ' function reverse (env-name)
           DISPLAY SPACE
                
           .
        
       *>*************************************************    
        
