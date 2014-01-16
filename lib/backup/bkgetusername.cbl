        IDENTIFICATION DIVISION.
        program-id. bkgetusername.
        
        ENVIRONMENT DIVISION.
        
        DATA DIVISION.
        working-storage section.
        01  accept-char PIC X value space.
        
        linkage section.
        01  username    PIC X(15).
        
        PROCEDURE DIVISION USING username.
        000-consolesubmain.
        
            DISPLAY '[sub getusername] Enter your name: '
                WITH NO ADVANCING
            ACCEPT username
            DISPLAY '[sub getusername] Thank you: ' username
            DISPLAY '[sub getusername] Press Enter key to return...'
            ACCEPT accept-char
            GOBACK
            .
            


