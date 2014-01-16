        IDENTIFICATION DIVISION.
        program-id. dump-string IS INITIAL.
        
        ENVIRONMENT DIVISION.
        
        DATA DIVISION.
        working-storage section.
        
        linkage section.
        01  string-info     PIC X(25).        
        01  dump-string     PIC X(25).
        
        PROCEDURE DIVISION USING string-info, dump-string.
        000-dump-string.
        
            DISPLAY
                string-info '[' dump-string ']'          
            END-DISPLAY 

            GOBACK
            .
        *>******************************************************             


