        IDENTIFICATION DIVISION.
        program-id. print-header.
        
        ENVIRONMENT DIVISION.
        
        DATA DIVISION.
        working-storage section.
        01  newline     PIC X VALUE x'0a'.        
        
        *> Need a dummy parameter for this routine
        *> to to link as a shared library.
        linkage section.
        01  rtnflag    PIC X.     
        
        PROCEDURE DIVISION USING rtnflag.
        000-print-html-header.
        
            *> Always send out the Content-Type before any other I/O
            DISPLAY
                "Content-Type: text/html; charset=utf-8"
                newline
                newline
            END-DISPLAY        
        
            GOBACK
            .
            


