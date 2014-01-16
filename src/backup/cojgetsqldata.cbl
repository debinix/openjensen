        IDENTIFICATION DIVISION.
        program-id. cojgetsqldata.
        
        ENVIRONMENT DIVISION.
        
        input-output section.
        file-control.
            select webinput assign to KEYBOARD
            file status is in-status.        
        
        DATA DIVISION.
        file section.
        fd  webinput.
        01  chunk-of-post     PIC X(1024).        
        
        working-storage section.        
        01  pagetitle    PIC X(20) VALUE 'Post data display'.
        01  dummy        PIC X     VALUE SPACE.
        
        
        01  in-status            PIC 9999.
        01  newline      PIC X     VALUE x'0a'.
        
        01 name-index           PIC 99    usage comp-5.
        01 value-string         PIC X(256).
           88 IS-POST                     value 'POST'.
        01 environment-names.
           02 name-strings.
              03 filler         PIC X(20) value 'DOCUMENT_ROOT'.
              03 filler         PIC X(20) value 'GATEWAY_INTERFACE'.
              03 filler         PIC X(20) value 'HTTP_ACCEPT'.      
              03 filler         PIC X(20) value 'HTTP_ACCEPT_CHARSET'.
              03 filler         PIC X(20) value 'HTTP_ACCEPT_ENCODING'.
              03 filler         PIC X(20) value 'HTTP_ACCEPT_LANGUAGE'.
              03 filler         PIC X(20) value 'HTTP_CONNECTION'.  
              03 filler         PIC X(20) value 'HTTP_HOST'.        
              03 filler         PIC X(20) value 'HTTP_USER_AGENT'.   
              03 filler         PIC X(20) value 'LIB_PATH'.   
              03 filler         PIC X(20) value 'PATH'.             
              03 filler         PIC X(20) value 'QUERY_STRING'.     
              03 filler         PIC X(20) value 'REMOTE_ADDR'.      
              03 filler         PIC X(20) value 'REMOTE_PORT'.      
              03 filler         PIC X(20) value 'REQUEST_METHOD'.   
              03 filler         PIC X(20) value 'REQUEST_URI'.      
              03 filler         PIC X(20) value 'SCRIPT_FILENAME'.   
              03 filler         PIC X(20) value 'SCRIPT_NAME'.      
              03 filler         PIC X(20) value 'SERVER_ADDR'.      
              03 filler         PIC X(20) value 'SERVER_ADMIN'.         
              03 filler         PIC X(20) value 'SERVER_NAME'.      
              03 filler         PIC X(20) value 'SERVER_PORT'.       
              03 filler         PIC X(20) value 'SERVER_PROTOCOL'.  
              03 filler         PIC X(20) value 'SERVER_SIGNATURE'.  
              03 filler         PIC X(20) value 'SERVER_SOFTWARE'.  
           02 filler redefines name-strings.
              03 name-string    PIC X(20) occurs 25 times.
              88 IS-REQUEST-METHOD        value 'REQUEST_METHOD'.
        
        *>******************************************************
        PROCEDURE DIVISION.
        000-main.

            CALL 'wui-print-header' USING BY REFERENCE dummy.
            CALL 'wui-start-html'   USING BY CONTENT pagetitle
            
            ACCEPT value-string FROM ENVIRONMENT
                'REQUEST_METHOD'
            END-ACCEPT


            display
                "<p>"
                "REQUEST_METHOD"
                ": "
                function trim (value-string trailing)
                "</p>"
            end-display
            

        
            CALL 'wui-end-html' USING BY REFERENCE dummy.                
        
            GOBACK
            .
        *>******************************************************  