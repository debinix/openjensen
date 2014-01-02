        IDENTIFICATION DIVISION.
        program-id. end-html.
        
        ENVIRONMENT DIVISION.
        
        DATA DIVISION.
        working-storage section.      
        
        linkage section.
        01  dummy    PIC X.      
        
        PROCEDURE DIVISION.
        000-end-html.
        
            DISPLAY
                "</body>"
                "</html>"          
            END-DISPLAY        
        
            GOBACK
            .
            


