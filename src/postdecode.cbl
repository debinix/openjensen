        IDENTIFICATION DIVISION.
        program-id. postdecode.
        
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
        01  in-status            PIC 9999.  
        01  pagetitle            PIC X(20)  VALUE 'CGI decode'.
        01  rtnflag              PIC X      VALUE '0'.
        01  content-length       PIC X(5)   VALUE SPACE.
        01  num-cnt-len          PIC 9(5)   VALUE ZERO.

        01  post-string          PIC X(256) VALUE SPACE.
        
        01  tmp-name-value       PIC X(50) VALUE SPACE.
        01  tmp-name             PIC X(25) VALUE SPACE.
        01  tmp-value            PIC X(25) VALUE SPACE.
        
        01  env-value                   PIC X(25) VALUE SPACE.
            
        01  unstring-next-position      PIC 99 VALUE 1.
        01  number-of-value-pairs       PIC 99 VALUE ZERO.
        01  pair-counter                PIC 99 VALUE ZERO.
        01  space-counter               PIC 99 VALUE ZERO.        
        
        *>******************************************************
        PROCEDURE DIVISION.
        000-main.
        
            *> (just to be sure)       
            COPY src_setupenv_openjensen.        
        
            CALL 'print-header' USING rtnflag
            CALL 'start-html' USING BY CONTENT pagetitle            

            ACCEPT content-length FROM ENVIRONMENT 'CONTENT_LENGTH'
            COMPUTE num-cnt-len = FUNCTION NUMVAL(content-length)

            IF num-cnt-len = 0
                DISPLAY "<p>CGI POST: Content-Length is 0!</p>"
                CALL 'end-html' USING rtnflag    
                GOBACK
            END-IF
  
            IF num-cnt-len > 256
                DISPLAY "<p>CGI POST: Content-Length is to large</p>"
                CALL 'end-html' USING rtnflag    
                GOBACK
            END-IF            
            
            
            PERFORM 010-get-stdin-poststring
            *>  Count number value-pair-separators '&'        
            PERFORM 020-set-number-of-value-pairs
            
            DISPLAY '<p>Debug: Postlength: ' num-cnt-len
                '<br>'
                'Debug: Our long post string: </p>' post-string
            END-DISPLAY
            
            PERFORM VARYING pair-counter FROM 1 BY 1
                UNTIL pair-counter > number-of-value-pairs
            
                PERFORM 030-set-next-value-pair
                
                *>  Sets environment only if a pair has a value
                PERFORM 040-set-environment
                
                *> only for debug
                PERFORM 050-show-new-environment
                
            END-PERFORM
            
            *>
            *>    main dispatch of call queries here
            *> 
            
            
            *>  end html doc
            CALL 'end-html' USING BY CONTENT rtnflag    
        
            GOBACK
            .
        *>******************************************************    
        010-get-stdin-poststring.
            
            *> get STDIN post input to our variable
            OPEN INPUT webinput
            IF in-status < 10 THEN
                READ
                    webinput
                END-READ
                IF in-status > 9 THEN
                    MOVE SPACES TO chunk-of-post
                END-IF
            END-IF
            CLOSE webinput

            *> decode high ascii HTML encoded characters            
            MOVE chunk-of-post(1:num-cnt-len) TO post-string
            
            CALL 'url-charconv' USING rtnflag post-string num-cnt-len
            
            *> Restore all space charcters, encoded + as signs
            INSPECT post-string CONVERTING '+' to SPACE
        
            .

        *>******************************************************
        020-set-number-of-value-pairs.
        
            MOVE ZERO TO number-of-value-pairs
            INSPECT post-string TALLYING number-of-value-pairs
                FOR ALL '&'
                
            *> Since '&' separates each value-pairs, add 1 for
            *> last, and this is true also for one name-value pair
            ADD 1 TO number-of-value-pairs
            .
        *>******************************************************            
        030-set-next-value-pair.
        
            MOVE SPACE TO tmp-name-value
            MOVE SPACE TO tmp-name
            MOVE SPACE TO tmp-value
  
            *> Get value-pair upto next '&' (if it exists)            
            UNSTRING post-string DELIMITED BY '&'
                INTO tmp-name-value
                WITH POINTER unstring-next-position
            
            *> Separate out the name and value part                            
            UNSTRING tmp-name-value DELIMITED BY '='
                INTO tmp-name
                     tmp-value
            .
        *>******************************************************     
        040-set-environment.
        
            MOVE ZERO TO space-counter
            INSPECT tmp-value TALLYING space-counter
                FOR ALL ' '
                
            *> DISPLAY 'Debug: Number of spaces: ' space-counter    
        
            IF space-counter NOT = FUNCTION LENGTH(tmp-value)
                SET ENVIRONMENT tmp-name TO tmp-value
            *> DISPLAY 'Debug: Environment: ' tmp-name ' ' tmp-value
            END-IF
    
            .
        *>******************************************************             
        050-show-new-environment.
        
            ACCEPT env-value FROM ENVIRONMENT tmp-name
            DISPLAY '<p>Retrieved Environment: </p>'
                                tmp-name' : ' env-value
            
            .

        *>******************************************************
        
