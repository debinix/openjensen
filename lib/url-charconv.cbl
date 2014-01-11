        IDENTIFICATION DIVISION.
        program-id. url-charconv.
        
        ENVIRONMENT DIVISION.
        
        DATA DIVISION.
        working-storage section.
        01  tmp                  PIC X.
        
        linkage section.
        01  rtnflag              PIC X.        
        01  str-value            PIC X(25).     

        *>  Note the call order of parameters below!
        *> (NOT the order the linkage section above)
        PROCEDURE DIVISION USING rtnflag str-value.
        000-main-conversion.
        
            *> TODO Decode HTML escapes to normal characters



            GOBACK
            .
        *>******************************************************            