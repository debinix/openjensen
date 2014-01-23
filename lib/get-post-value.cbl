       IDENTIFICATION DIVISION.
       program-id. get-post-value IS INITIAL.
       *>*************************************************
       *>
       *> get-post-value: Reads CGI post data file,
       *>     returns the asked value of named post item.
       *>
       *> Coder: BK
       *>
       *>*************************************************
        
       ENVIRONMENT DIVISION.
       input-output section.
        
       file-control. 
       *>  Infile
           SELECT OPTIONAL postfilein
               ASSIGN TO '/tmp/postfile.dat'
               ORGANIZATION IS LINE SEQUENTIAL.             
        
       DATA DIVISION.
       file section.
       
       FD  postfilein.
       01  fd-postfile-post. 
           03  fc-post-name               PIC X(64).
           03  fc-post-separator          PIC X.      
           03  fc-post-value              PIC X(64).            
        
       working-storage section.
       *> switches
       01   switches.
            03  value-is-found-switch     PIC X         VALUE 'N'.
                88  value-is-found                      VALUE 'Y'.
            03  is-eof-input-switch      PIC X          VALUE 'N'.
                88  is-eof-input                        VALUE 'Y'.   
       
       linkage section.
       01  ln-rtn-code                    PIC  S99.
       01  lc-post-name                   PIC X(40).         
       01  lc-post-value                  PIC X(40).

       *>*************************************************
       PROCEDURE DIVISION USING ln-rtn-code lc-post-name lc-post-value.
       0000-main.
       
           PERFORM A0100-init
           
           PERFORM B0100-get-post-value
           
           PERFORM C0100-closedown  
                  
           EXIT PROGRAM
           .
           
       *>**************************************************
       A0100-init.

           MOVE -1 TO ln-rtn-code
           
           OPEN INPUT postfilein
           
           .

       *>*************************************************        
       B0100-get-post-value.
  
           *>  Read first record
           READ postfilein
              AT END
                   SET is-eof-input TO TRUE
           END-READ
           
           IF NOT is-eof-input
           
              MOVE ZERO TO ln-rtn-code

              PERFORM UNTIL is-eof-input OR value-is-found
              
                 IF fc-post-name = lc-post-name
                 
                     *> TODO
                     *> restore HTML utf-8 encoded characters
                 
                     *> restore HTML encoded space characters
                     INSPECT fc-post-value CONVERTING "+" to " " 
                     
                     MOVE fc-post-value TO lc-post-value
                     
                     SET value-is-found TO TRUE
                 END-IF
                 
                 *>  Read next record                 
                 READ postfilein
                      AT END
                          SET is-eof-input TO TRUE
                 END-READ              
                  
              END-PERFORM
              
           END-IF

           .
          
       *>**************************************************
       C0100-closedown.

           CLOSE postfilein
           .

       *>**************************************************
    
        
