        IDENTIFICATION DIVISION.
        program-id. call-display-header.
        
        ENVIRONMENT DIVISION.
        
        DATA DIVISION.
        working-storage section.
        01  accept-char PIC X VALUE SPACE.
        
        linkage section.
        01  username    PIC X(15).        
        
        PROCEDURE DIVISION.
        000-consolesubmain.
        
            DISPLAY '[sub justdisplay] Without parameter'
            DISPLAY '[sub justdisplay] Press Enter key to return...'
            ACCEPT accept-char
            GOBACK
            .
            


