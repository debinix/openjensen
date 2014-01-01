        IDENTIFICATION DIVISION.
        program-id. bkhello.
        
        ENVIRONMENT DIVISION.
        
        DATA DIVISION.
        working-storage section.
        01 newline              PIC X     value x'0a'.
        
        PROCEDURE DIVISION.
        000-main.
            
            DISPLAY    
            "Content-type: text/html; charset=ISO-8859-4"
            newline
            newline
            END-DISPLAY
        
            DISPLAY
                "<html><head>"
                "<title>Hello in Cobol</title>"
                "</head><body>"
                newline
                "<h3>Hello COBOL world!</h3>"
                newline "<p>"
                '<a href="../index.html"> Back to index - try again!'
                newline
                "</body>"                
            END-DISPLAY        
        
            GOBACK
            .
