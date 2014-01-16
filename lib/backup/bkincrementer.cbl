        IDENTIFICATION DIVISION.
        program-id. bkincrementer.
        
        ENVIRONMENT DIVISION.
        
        DATA DIVISION.
        working-storage section.
        01  accept-char PIC X value space.
        
        linkage section.
        01  addvalue    PIC 9.        
        01  mysum       PIC 99.       

        *>  Note the call order of parameters below!
        *> (NOT the order the linkage section above)
        PROCEDURE DIVISION USING addvalue 
                                 mysum.
        000-consolesubmain.
        
            DISPLAY '[sub incrementer] Sum before addition: ' mysum
            DISPLAY '[sub incrementer] Calculating...'         
            COMPUTE mysum = mysum + addvalue
            DISPLAY '[sub incrementer] The new sum is: ' mysum
            DISPLAY '[sub incrementer] Press Enter key to return...'
            ACCEPT accept-char
            GOBACK
            .
            