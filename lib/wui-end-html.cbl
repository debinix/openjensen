        IDENTIFICATION DIVISION.
        program-id. end-html.
        
        ENVIRONMENT DIVISION.
        
        DATA DIVISION.
        working-storage section.      
        
        linkage section.
        01  rtnflag    PIC X.      
        
        PROCEDURE DIVISION USING rtnflag.
        000-end-html.
        
            DISPLAY
                "</body>"
                "</html>"          
            END-DISPLAY        
        
            GOBACK
            .
            


