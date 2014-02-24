       *>
       *> wui-print-header:
       *>
       *> dispaly header for browser output
       *> 
       *> Coder: BK 
       *>        
       IDENTIFICATION DIVISION.
       program-id. wui-print-header.
        
       ENVIRONMENT DIVISION.
        
       DATA DIVISION.
       working-storage section.
       01  wc-newline     PIC X VALUE x'0a'.        
        
       *> Always require one link parameter in linkage-
       *> section to compile as dynamic (*.so) library.
       linkage section.
       01  ln-rtn-code    PIC S99.    
        
       PROCEDURE DIVISION USING ln-rtn-code.
       000-print-html-header.
        
           *> Always send out the Content-Type before any other I/O
           DISPLAY
               "Content-Type: text/html; charset=utf-8"
               wc-newline
               wc-newline
           END-DISPLAY        
        
           EXIT PROGRAM
           .
            
       *>******************************************************


