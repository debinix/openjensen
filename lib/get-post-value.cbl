       IDENTIFICATION DIVISION.
       program-id. get-post-value IS INITIAL.
       *>*************************************************
       *>
       *> get-post-value: Reads received environment CGI
       *>   post, returns the asked value of a named post item.
       *>
       *> Coder: BK
       *>
       *>*************************************************
        
       ENVIRONMENT DIVISION.
       input-output section.
        
       file-control.
           select webinput assign to KEYBOARD
           file status is wn-instatus.                
        
       DATA DIVISION.
       file section.
        
       fd  webinput.
       01  fd-chunk-of-posts              PIC X(1024).            
        
       working-storage section.
       *> switches
       01   switches.
            03  value-is-found-switch     PIC X         VALUE 'N'.
                88  value-is-found                      VALUE 'Y'.
       
       01  wn-instatus                    PIC 9(4)      VALUE ZERO.  
       01  wc-content                     PIC X(5)      VALUE SPACE.
       01  wn-content-length              PIC 9(5)      VALUE ZERO.

       01  wc-raw-post-string             PIC X(256)    VALUE SPACE.
       01  wn-number-of-value-pairs       PIC 99        VALUE ZERO.        
       01  wn-pair-counter                PIC 99        VALUE ZERO.        
        
       01  wc-tmp-name-value              PIC X(80)     VALUE SPACE.
       01  wc-tmp-name                    PIC X(40)     VALUE SPACE.
       01  wc-tmp-value                   PIC X(40)     VALUE SPACE.
       01  wn-unstring-next-position      PIC 99        VALUE 1.

               
       linkage section.
       01  lc-post-name                   PIC X(40).         
       01  lc-post-value                  PIC X(40).

       *>*************************************************
       PROCEDURE DIVISION USING lc-post-name lc-post-value.
       0000-main.
       
           PERFORM A0100-init
           
           PERFORM B0100-get-post-value
           
           EXIT PROGRAM
           .
           
       *>**************************************************
       A0100-init.

           ACCEPT wc-content FROM ENVIRONMENT 'CONTENT_LENGTH'
           COMPUTE wn-content-length = FUNCTION NUMVAL(wc-content)           
           
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

           .

       *>*************************************************        
       B0100-get-post-value.
  
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
                OR value-is-found
                     
                *> find one name-pair
                PERFORM B0200-extract-value-pair
                
                IF wc-tmp-name = lc-post-name
                    MOVE wc-tmp-value TO lc-post-value
                    SET value-is-found TO TRUE
                END-IF
                       
            END-PERFORM

            .

       *>******************************************************            
       B0200-extract-value-pair.
        
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
            .
            
       *>**************************************************
    
        
