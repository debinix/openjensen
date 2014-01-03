        identification division.
        program-id. cgienv.
 
        environment division.
        input-output section.
        file-control.
            select webinput assign to KEYBOARD
            file status is in-status.
 
        data division.
        file section.
        fd webinput.
           01 chunk-of-post     pic x(1024).
 
        working-storage section.
        01 in-status            pic 9999.
        01 newline              pic x     value x'0a'.
        01 name-count           pic 99    value 25.
        01 name-index           pic 99    usage comp-5.
        01 value-string         pic x(256).
           88 IS-POST                     value 'POST'.
        01 environment-names.
           02 name-strings.
              03 filler         pic x(20) value 'DOCUMENT_ROOT'.
              03 filler         pic x(20) value 'GATEWAY_INTERFACE'.
              03 filler         pic x(20) value 'HTTP_ACCEPT'.      
              03 filler         pic x(20) value 'HTTP_ACCEPT_CHARSET'.
              03 filler         pic x(20) value 'HTTP_ACCEPT_ENCODING'.
              03 filler         pic x(20) value 'HTTP_ACCEPT_LANGUAGE'.
              03 filler         pic x(20) value 'HTTP_CONNECTION'.  
              03 filler         pic x(20) value 'HTTP_HOST'.        
              03 filler         pic x(20) value 'HTTP_USER_AGENT'.   
              03 filler         pic x(20) value 'LIB_PATH'.   
              03 filler         pic x(20) value 'PATH'.             
              03 filler         pic x(20) value 'QUERY_STRING'.     
              03 filler         pic x(20) value 'REMOTE_ADDR'.      
              03 filler         pic x(20) value 'REMOTE_PORT'.      
              03 filler         pic x(20) value 'REQUEST_METHOD'.   
              03 filler         pic x(20) value 'REQUEST_URI'.      
              03 filler         pic x(20) value 'SCRIPT_FILENAME'.   
              03 filler         pic x(20) value 'SCRIPT_NAME'.      
              03 filler         pic x(20) value 'SERVER_ADDR'.      
              03 filler         pic x(20) value 'SERVER_ADMIN'.         
              03 filler         pic x(20) value 'SERVER_NAME'.      
              03 filler         pic x(20) value 'SERVER_PORT'.       
              03 filler         pic x(20) value 'SERVER_PROTOCOL'.  
              03 filler         pic x(20) value 'SERVER_SIGNATURE'.  
              03 filler         pic x(20) value 'SERVER_SOFTWARE'.  
           02 filler redefines name-strings.
              03 name-string    pic x(20) occurs 25 times.
              88 IS-REQUEST-METHOD        value 'REQUEST_METHOD'.
 
       *> ***************************************************************
        procedure division.
 
       *> Always send out the Content-type before any other IO
        display
            "Content-type: text/html; charset=ISO-8859-4"
            newline
            newline
        end-display
 
        display
            "<html><head>"
            "<style>"
            "  table"
            "  { background-color:#e0ffff; border-collapse:collapse; }"
            "  table, th, td"
            "  { border: 1px solid black; }"
            "</style>"
            "</head><body>"
            newline
            "<h3>CGI environment with GNU Cobol</h3>"
            newline "<p>"
            '<a href="../index.html"> Back to main menu - try again!'
            newline "</p><p>"
            "<i>All values of &lt;, &gt;, and &amp;"
            " replaced by space</i>"
            "</p><p><table>"
        end-display
 
       *> Display some of the known CGI environment values
        perform varying name-index from 1 by 1
            until name-index > name-count
 
                accept value-string from environment
                    name-string(name-index)
                end-accept
 
               *> cleanse any potential danger, thoughtlessly
                inspect value-string converting "<>&" to "   " 
 
                display
                    "<tr><td>"
                    name-string(name-index)
                    ": </td><td>"
                    function trim (value-string trailing)
                    "</td></tr>"
                end-display
 
                *> Demonstration of POST handling
                if IS-REQUEST-METHOD(name-index) and IS-POST
 
                       *> open a channel to the POST data, KEYBOARD
                       *> read what's there, in a loop normally
                       *> and close. For real world, this would
                       *> have more intelligent defensive programming
                       *>   and likely fatter buffers
 
                       open input webinput
                       if in-status < 10 then
                           read webinput end-read
                           if in-status > 9 then
                               move spaces to chunk-of-post
                           end-if
                       end-if
                       close webinput
 
                       *> cleanse any potential danger, thoughtlessly
                       inspect chunk-of-post converting "<>&" to "   "
 
                       display
                           '<tr><td align="right">'
                           "First chunk of POST:&nbsp;"
                           "</td><td>" chunk-of-post(1:72) "</td></tr>"
                       end-display
                end-if
        end-perform
 
       *> end the table, and being free software, link to the source
 
        goback
        .
        
