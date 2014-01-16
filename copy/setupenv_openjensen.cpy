       *>
       *>  Setup run-time environment - in the development environment
       *>  This is where the executing '*.cgi' script finds any 
       *>  dynamically loaded '*.so' files. Thus at run-time the executable
       *>  will set this environment. This is the last chance to locate
       *>  the *.so-file, if not in $PATH or the current executed directory.
       *>
           DISPLAY "COB_LIBRARY_PATH" UPON ENVIRONMENT-NAME.
           DISPLAY "../lib"           UPON ENVIRONMENT-VALUE.