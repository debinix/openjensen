        IDENTIFICATION DIVISION.
        program-id. print-header.
        
        ENVIRONMENT DIVISION.
        
        DATA DIVISION.
        working-storage section.
        01  newline     PIC X VALUE x'0a'.        
        
        linkage section.
        01  dummy    PIC X.     
        
        PROCEDURE DIVISION.
        000-print-html-header.
        
            *> Always send out the Content-type before any other IO
            DISPLAY
                "Content-Type: text/html; charset=utf-8"
                newline
                newline
            END-DISPLAY        
        
            GOBACK
            .
            


