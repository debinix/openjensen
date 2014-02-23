       *>*************************************************
       *>
       *> write-post-string: write received environment CGI
       *>   post, and write to a sequental file on ../data.
       *>
       *> Coder: BK
       *>
       *>*************************************************       
       IDENTIFICATION DIVISION.
       program-id. write-post-string IS INITIAL.
       *>-------------------------------------------------
       ENVIRONMENT DIVISION.
       input-output section.
            
       file-control.
           SELECT webinput ASSIGN TO KEYBOARD
              FILE STATUS IS wn-instatus.
       
           SELECT postfileout 
              ASSIGN TO '../data/postfile.dat'
              ORGANIZATION IS LINE SEQUENTIAL.         
                   
       *>------------------------------------------------- 
       DATA DIVISION.
       file section.
        
       FD  webinput.
       01  fd-chunk-of-posts              PIC X(512).
           
       FD  postfileout.
       01  fd-postfile-post. 
           03  fc-post-name               PIC X(64).
           03  fc-post-separator          PIC X.      
           03  fc-post-value              PIC X(64). 
       *>-------------------------------------------------- 
       working-storage section.
       
       01  wn-instatus                    PIC 9(4)      VALUE ZERO.  
       01  wc-env-length                  PIC X(3)      VALUE SPACE.
       01  wn-content-length              PIC 9(4)      VALUE ZERO.

       01  wc-raw-post-string             PIC X(512)    VALUE SPACE.
       01  wn-number-of-value-pairs       PIC 99        VALUE ZERO.        
       01  wn-pair-counter                PIC 99        VALUE ZERO.        
        
       01  wc-tmp-name-value              PIC X(128)    VALUE SPACE.
       01  wc-tmp-name                    PIC X(64)     VALUE SPACE.
       01  wc-tmp-value                   PIC X(64)     VALUE SPACE.
       01  wn-unstring-next-position      PIC 9(3)      VALUE 1.

       *>-------------------------------------------------        
       linkage section.
       01  ln-rtn-code                    PIC  S99.

       *>*************************************************
       PROCEDURE DIVISION USING ln-rtn-code.
       0000-main.
       
           PERFORM A0100-init
           
           PERFORM B0100-write-post-to-file
           PERFORM C0100-closedown

           EXIT PROGRAM
           .
         
           
       *>**************************************************
       A0100-init.

           ACCEPT wc-env-length FROM ENVIRONMENT 'CONTENT_LENGTH'
           COMPUTE wn-content-length = FUNCTION NUMVAL(wc-env-length)          
           
           MOVE SPACE TO wc-raw-post-string
           *> get STDIN post input and assign to our variable
           OPEN INPUT webinput
              IF wn-instatus < 10 THEN
                   READ
                       webinput
                   END-READ
                   IF wn-instatus > 9 THEN
                       MOVE SPACES TO fd-chunk-of-posts
                   END-IF
           END-IF
           CLOSE webinput
        
           MOVE fd-chunk-of-posts(1:wn-content-length)
                                      TO wc-raw-post-string

           *> open outfile
           OPEN OUTPUT postfileout
       
           MOVE ZERO TO ln-rtn-code

           .

       *>*************************************************        
       B0100-write-post-to-file.
  
            *> Count number of value pairs in raw post string
            
            MOVE ZERO TO wn-number-of-value-pairs
            INSPECT wc-raw-post-string
                TALLYING wn-number-of-value-pairs FOR ALL '&'
                
            *> Since '&' separates each value-pairs, add 1 for the
            *> last, and this is true also for one name-value pair
            ADD 1 TO wn-number-of-value-pairs

            MOVE 1 TO wn-unstring-next-position
            
            PERFORM VARYING wn-pair-counter FROM 1 BY 1
                UNTIL wn-pair-counter > wn-number-of-value-pairs

                *> writes one name-value-pair to file
                PERFORM B0200-process-value-pair
                          
            END-PERFORM

            .

       *>******************************************************            
       B0200-process-value-pair.
        
            MOVE SPACE TO wc-tmp-name-value
            MOVE SPACE TO wc-tmp-name
            MOVE SPACE TO wc-tmp-value
  
            *> Get value-pair upto next '&' (if it exists)            
            UNSTRING wc-raw-post-string DELIMITED BY '&'
                INTO wc-tmp-name-value
                WITH POINTER wn-unstring-next-position
            END-UNSTRING
            
            *> Separate out the name and value part                            
            UNSTRING wc-tmp-name-value DELIMITED BY '='
                INTO wc-tmp-name wc-tmp-value
            END-UNSTRING 
            
            MOVE wc-tmp-name TO fc-post-name
            MOVE '=' TO fc-post-separator
            MOVE wc-tmp-value TO fc-post-value
            WRITE fd-postfile-post
            
            .
            
       *>**************************************************
       C0100-closedown.

           CLOSE postfileout
           .

       *>**************************************************
