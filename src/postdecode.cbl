        IDENTIFICATION DIVISION.
        program-id. postdecode.
        *>*************************************************
        *>
        *> Modulfunction: Split the browser post string
        *>                in separate form parameters
        *>
        *> Module: postdecode
        *>
        *> Vers: 0.01
        *>
        *> Coder: BK
        *>
        *>*************************************************
        
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
        01  module-rec.
            05  mod-rec-version  PIC X(5)   VALUE '0.01-'. 
            05  mod-rec-name     PIC X(35)  VALUE 'postdecode'.       
        
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
        
        PROCEDURE DIVISION.
        000-decode-post-from-browser.
        
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
                DISPLAY
                    "<p>CGI POST: Content-Length is to large</p>"
                END-DISPLAY
                CALL 'end-html' USING rtnflag    
                GOBACK
            END-IF            
            
            *> get long post tring  and convert back to utf-8
            PERFORM 010-get-stdin-poststring
            *>  Count number value-pair-separators '&'        
            PERFORM 020-set-number-of-value-pairs
            
            DISPLAY '<p>Debug: Postlength: ' num-cnt-len
                ' - Converted post-string: ' post-string
                ' - Pairs: ' number-of-value-pairs
                '</p>'
            END-DISPLAY
            
            PERFORM VARYING pair-counter FROM 1 BY 1
                UNTIL pair-counter > number-of-value-pairs
            
                DISPLAY
                    '<br>PairCnt: ' pair-counter
                END-DISPLAY
            
                *> extract one name-pair
                PERFORM 030-extract-next-value-pair
                
                *> Debug 
                *> CALL
                *>    'dump-string' USING BY CONTENT tmp-name tmp-value
                *> END-CALL
                
                DISPLAY
                    '<p>'
                    '<br>tmp-name:' tmp-name
                    ' - tmp-value:' tmp-value
                    '</p>'
                END-DISPLAY
                
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
            
            *> get STDIN post input and assign to our variable
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

            *> decode utf-8 encoded characters            
            MOVE chunk-of-post(1:num-cnt-len) TO post-string
            
            CALL 'url-charconv' USING rtnflag post-string num-cnt-len
            
            *> Restore all space characters (encoded as + signs)
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
        030-extract-next-value-pair.
        
            MOVE SPACE TO tmp-name-value
            MOVE SPACE TO tmp-name
            MOVE SPACE TO tmp-value
  
            *> Get value-pair upto next '&' (if it exists)            
            UNSTRING post-string DELIMITED BY '&'
                INTO tmp-name-value
                WITH POINTER unstring-next-position
            END-UNSTRING
            
            *> Separate out the name and value part                            
            UNSTRING tmp-name-value DELIMITED BY '='
                INTO tmp-name tmp-value
            END-UNSTRING
            .
            
        *>******************************************************
        
