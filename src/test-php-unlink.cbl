       *>
       *> creates a file (0-byte) for delete tests
       *> from php with the php unlink() function
       *>
       IDENTIFICATION DIVISION.
       program-id. test-php-unlink.
       *>**************************************************
       ENVIRONMENT DIVISION.
       input-output section.
            
       file-control.           
           SELECT OPTIONAL statusfile 
              ASSIGN TO '../status'
              ORGANIZATION IS LINE SEQUENTIAL.              
              
       *>**************************************************
       DATA DIVISION.
       file section.     
       FD  statusfile.
       01  fd-fileout-status         PIC  X(1) VALUE SPACE. 
       *>--------------------------------------------------
       working-storage section.
       01 wc-file-name               PIC  X(60) VALUE SPACE.
       01 wc-dest-file-path          PIC  X(80) VALUE SPACE.
       *>**************************************************
       PROCEDURE DIVISION.
       *>**************************************************       
       0000-main.

           PERFORM Z0100-write-status-ok-file
           
           GOBACK
           .
       *>**************************************************
       Z0100-write-status-ok-file.
       
           *> simulates file name with a 'magic (unique) number'
           MOVE '../1111111111111111' TO wc-file-name
       
           *> create a zero file
           OPEN EXTEND statusfile           
           CLOSE statusfile
           
           MOVE SPACE TO wc-dest-file-path    
           STRING wc-file-name DELIMITED BY SPACE 
                          '.'  DELIMITED BY SPACE
              'OK-ta-bort-mig' DELIMITED BY SPACE
                               INTO wc-dest-file-path
           *> copy file to new name
           CALL 'CBL_COPY_FILE' USING '../status', wc-dest-file-path
           CALL 'CBL_DELETE_FILE' USING '../status'           
       
           .
           

       *>**************************************************       
       
       