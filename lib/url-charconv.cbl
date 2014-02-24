       *>
       *> url-charconv: 
       *> Initial url conversion tests - not part of application
       *> 
       *> Coder: BK 
       *>
       IDENTIFICATION DIVISION.
       program-id. url-charconv.
        
       ENVIRONMENT DIVISION.
        
       DATA DIVISION.
       working-storage section.
       01  cnv-post-string      PIC X(256) VALUE SPACE.
       01  ws-post-string       PIC X(256) VALUE SPACE.
        
       01  urlchars             PIC X(5)   VALUE SPACE.
       01  cindex               PIC 9(3)   VALUE 1.
     
       linkage section.
       01  rtnflag              PIC X.        
       01  raw-post-string      PIC X(256).
       01  num-len-cnt          PIC 9(5).        
        

       *>  Note the call order of parameters below!
       *> (NOT the order the linkage section above)
       PROCEDURE DIVISION USING rtnflag raw-post-string num-len-cnt.
       000-convert-to-utf8.
        
           MOVE raw-post-string TO ws-post-string
       
           PERFORM VARYING cindex FROM 1 BY 1
               UNTIL cindex > num-len-cnt

                IF ws-post-string(cindex:1) = '%'
                    
                *> DISPLAY 'Debug: Found it: ' ws-post-string(cindex:6)
                    
                    *> http://en.wikipedia.org/wiki/UTF-8
                    *> http://www.utf8-chartable.de/
                   
                    *> utf-8 hex codes for åäö and ÅÄÖ (U+0000-000F)
                    
                    EVALUATE ws-post-string(cindex:6)
                        
                        *> å
                        WHEN '%C3%A5'
                            MOVE x'c3a5' TO cnv-post-string(cindex:2)
                        *> ä    
                        WHEN '%C3%A4'
                            MOVE x'c3a4' TO cnv-post-string(cindex:2)
                        *> ö    
                        WHEN '%C3%B6'
                            MOVE x'c3b6' TO cnv-post-string(cindex:2)
                        *> Å    
                        WHEN '%C3%85'
                            MOVE x'c385' TO cnv-post-string(cindex:2)
                        *> Ä    
                        WHEN '%C3%84'
                             MOVE x'c384' TO cnv-post-string(cindex:2)
                        *> Ö    
                        WHEN '%C3%96'
                            MOVE x'c396' TO cnv-post-string(cindex:2)            
                    
                    END-EVALUATE

                    ADD 5 TO cindex
                    
                ELSE
                
                    MOVE ws-post-string(cindex:1) TO
                                cnv-post-string(cindex:1)
                    *> DISPLAY 'Debug: ' cindex
                
                END-IF


           END-PERFORM
            
           MOVE cnv-post-string TO raw-post-string

           EXIT PROGRAM
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
        