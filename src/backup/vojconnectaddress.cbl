        IDENTIFICATION DIVISION.
        program-id. vojconnectaddress.
        
        ENVIRONMENT DIVISION.
        
        DATA DIVISION.
        working-storage section.
             
        01  pagetitle    PIC X(20) VALUE 'Open Jensen'.
        01  dummy        PIC X     VALUE SPACE.
        01  newline      PIC X     VALUE x'0a'. 
        
        *>******************************************************
        PROCEDURE DIVISION.
        000-main.
        
            *> Always send out the Content-Type before any other I/O
        
            CALL 'print-header' USING BY REFERENCE dummy.
            
        *>  start html doc
        
            CALL 'start-html' USING BY CONTENT pagetitle
            

        *>  get information from client
        
            PERFORM 100-get-database-entry
             
             
        *>  end html doc
        
            CALL 'end-html' USING BY REFERENCE dummy.                
        
            GOBACK
            .
        *>******************************************************    
        100-get-database-entry.
        
            DISPLAY
            
                "<h3>Hämta adresser</h3>"
                '<form action="http://www.mc-butter.se/'
                "cgi-bin/cojgetsqldata.cgi"
                ' target="main" '
                'method="post">'
                    "<p>"
                    'Användare: <input type="text" '
                    'name="username"><br>'
                    'Databas namn: <input type="text" '
                    'name="databasename"><br>'        
                    'Lösenord (optional): <input type="password" '
                    'name="password"><br>'
                    '<input type="submit" '
                    'value="Utför"> <input type="reset" '
                    'value="Rensa">'
                    "</p>"    
                "</form>"
                   
            
            END-DISPLAY

            .
            
        *>******************************************************    
            
        
