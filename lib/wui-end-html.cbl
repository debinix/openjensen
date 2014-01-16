        IDENTIFICATION DIVISION.
        program-id. end-html.
        
        ENVIRONMENT DIVISION.
        
        DATA DIVISION.
        working-storage section.      
        
        linkage section.
        01  rtn-code    PIC S99.      
        
        PROCEDURE DIVISION USING rtn-code.
        000-end-html.
        
            DISPLAY
                "</body>"
                "</html>"          
            END-DISPLAY        
        
            GOBACK
            .
            


