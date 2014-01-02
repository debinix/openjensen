        IDENTIFICATION DIVISION.
        program-id. start-html.
        
        ENVIRONMENT DIVISION.
        
        DATA DIVISION.
        working-storage section.      
        
        linkage section.
        01  pagetitle    PIC X(20).   
        
        PROCEDURE DIVISION USING pagetitle.
        000-start-html.
        
            *> Always send out the Content-type before any other IO
            DISPLAY
            "<!DOCTYPE HTML PUBLIC "
            "-//W3C//DTD HTML 4.01 Transitional//EN "
            "http://www.w3.org/TR/html4/loose.dtd"
            ">"
            '<html lang="sv">'
            "<head>"
            '<meta http-equiv="Content-Type"'
            'content="text/html; charset=utf-8">'	
            "<title>"
            pagetitle
            "</title>"
            "<style>"
            *>COPY <copybook css in style>
            "</style>"
            "</head>"
            "<body>"            
            END-DISPLAY        
        
            GOBACK
            .
            


