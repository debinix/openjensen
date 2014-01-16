        IDENTIFICATION DIVISION.
        program-id. bkcaller.
        
        ENVIRONMENT DIVISION.
        
        DATA DIVISION.
        working-storage section.
        
        01  is-quit-appl PIC 9     VALUE 0.        
        01  username     PIC X(15) VALUE 'Första raden'.
        
        01  mysum        PIC 99    VALUE 0.       
        01  addvalue     PIC 9     VALUE 0.     
        
        *>******************************************************
        PROCEDURE DIVISION.
        000-main.
        
        *>  call without parameters
        
            CALL 'bkjustdisplay' USING BY CONTENT username
            
        *>  called by content (protected called parameters)  
        
            DISPLAY '[main] username is ' username
            CALL 'bkgetusername' USING BY CONTENT username
            
            DISPLAY '[main] After call name (protected): ' username
          
        *>  called by reference (default), get new value back
        
            PERFORM 100-loop-until-nine
                UNTIL is-quit-appl = 9.
        
            GOBACK
            .
        *>******************************************************    
        100-loop-until-nine.
        
            MOVE 0 TO addvalue
            DISPLAY '[main] ----------------------------------'            
            DISPLAY '[main] Select number [0-8] to add to sum.'
            DISPLAY '[main]   Select 9 to quit application!   '            
            DISPLAY '[main] ----------------------------------'                
            ACCEPT addvalue
            
            EVALUATE addvalue
            
                WHEN NOT 9
                    DISPLAY '[main] Value to be added ' addvalue                
                    DISPLAY '[main] Sum before call : ' mysum
                    
                    *> here always check parameters call order!
                    CALL 'bkincrementer' USING
                                BY REFERENCE addvalue mysum       

                    DISPLAY '[main] New sum after call: ' mysum
                    
                WHEN OTHER  
                    DISPLAY '[main] Terminating demo application!'
                    MOVE 9 TO is-quit-appl
             
            END-EVALUATE
            .
            
        *>******************************************************    
            
        
