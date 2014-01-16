        IDENTIFICATION DIVISION.
        program-id. print-header.
        
        ENVIRONMENT DIVISION.
        
        DATA DIVISION.
        working-storage section.
        01  newline     PIC X VALUE x'0a'.        
        
        *> Always require one link parameter in linkage-
        *> section to complile as dynamic (*.so) library.
        linkage section.
        01  rtn-code    PIC S99.    
        
        PROCEDURE DIVISION USING rtn-code.
        000-print-html-header.
        
            *> Always send out the Content-Type before any other I/O
            DISPLAY
                "Content-Type: text/html; charset=utf-8"
                newline
                newline
            END-DISPLAY        
        
            GOBACK
            .
            


