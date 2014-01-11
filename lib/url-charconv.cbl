        IDENTIFICATION DIVISION.
        program-id. url-charconv.
        
        ENVIRONMENT DIVISION.
        
        DATA DIVISION.
        working-storage section.
        01  cnv-post-string      PIC X(256) VALUE SPACE.
        01  ws-post-string       PIC X(256) VALUE SPACE.
        
        01  urlchars             PIC X(5)   VALUE SPACE.
        01  cindex               PIC 9(3)   VALUE 1.
        
        *> ISO8859-1 hex codes for åäö, ÅÄÖ
        01  gem-au               PIC X      VALUE x'E5'.        
        01  gem-ae               PIC X      VALUE x'E4'.
        01  gem-ou               PIC X      VALUE x'F6'.        
        01  ver-au               PIC X      VALUE x'C5'.
        01  ver-ae               PIC X      VALUE x'C4'.        
        01  ver-ou               PIC X      VALUE x'D6'.        
        
        linkage section.
        01  rtnflag              PIC X.        
        01  raw-post-string      PIC X(256).
        01  num-len-cnt          PIC 9(5).        
        

        *>  Note the call order of parameters below!
        *> (NOT the order the linkage section above)
        PROCEDURE DIVISION USING rtnflag raw-post-string num-len-cnt.
        000-main-conversion.
        
            MOVE raw-post-string TO ws-post-string
        
            PERFORM VARYING cindex FROM 1 BY 1
                UNTIL cindex > num-len-cnt

                IF ws-post-string(cindex:1) = '%'
                    
                *> DISPLAY 'Debug: Found it: ' ws-post-string(cindex:6)
                    
                    *> ISO8859-1 hex codes for åäö, ÅÄÖ
                    EVALUATE ws-post-string(cindex:6)
                        
                        WHEN '%C3%A5'
                            MOVE gem-au TO cnv-post-string(cindex:1)
                            
                        WHEN '%C3%A4'
                            MOVE gem-ae TO cnv-post-string(cindex:1)
                            
                        WHEN '%C3%B6'
                            MOVE gem-ou TO cnv-post-string(cindex:1)
                            
                        WHEN '%C3%85'
                            MOVE ver-au TO cnv-post-string(cindex:1)
                            
                        WHEN '%C3%84'
                            MOVE ver-ae TO cnv-post-string(cindex:1)
                            
                        WHEN '%C3%96'
                            MOVE ver-ou TO cnv-post-string(cindex:1)            
                    
                    END-EVALUATE

                    ADD 5 TO cindex
                    
                ELSE
                
                    MOVE ws-post-string(cindex:1) TO
                                cnv-post-string(cindex:1)
                    *> DISPLAY 'Debug: ' cindex
                
                END-IF


            END-PERFORM
            
            DISPLAY 'Without encodings but missing: ' cnv-post-string
            
            MOVE cnv-post-string TO raw-post-string

            GOBACK
            .
        *>******************************************************
        
        *> Pseudo code
        *>
        *> int i
        *>
        *> for (i=0, i++, i < length(poststring) {
        *>    
        *>     if poststring[i] = '%' {
        *>    
        *>         tmp-string = poststring[i:i+5]
        *>        cnv-post-string[i] = lookuptbl(tmp-string)
        *>        i = i+5
        *>        
        *>    } else {
        *>    
        *>        cnv-post-string[i] = poststring[i]
        *>        
        *>    }
        *>
        *> }
        