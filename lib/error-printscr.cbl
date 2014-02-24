       *>
       *> error-printscr: optional display error messages
       *> and save to error log file if environment is set
       *> 
       *> Coder: BK 
       *>
       IDENTIFICATION DIVISION.
       program-id. error-printscr IS INITIAL.
        
       ENVIRONMENT DIVISION.
       input-output section.
       file-control.
           SELECT OPTIONAL ojlogfile
              ASSIGN TO '../data/openjensen.log'
              ORGANIZATION IS LINE SEQUENTIAL.
        
       DATA DIVISION.
       file section.
       FD  ojlogfile.
       01  fd-ojlogfile-post.
           03  fc-yyyy                    PIC X(4).
           03  fc-sep-1                   PIC X.
           03  fc-monthmonth              PIC X(2).
           03  fc-sep-2                   PIC X.
           03  fc-dd                      PIC X(2).
           03  fc-sep-3                   PIC X.
           03  fc-hh                      PIC X(2).
           03  fc-sep-4                   PIC X.
           03  fc-mm                      PIC X(2).
           03  fc-sep-5                   PIC X.           
           03  fc-ss                      PIC X(2).
           03  fc-sep-6                   PIC X.
           03  fc-tt                      PIC X(2).
           03  fc-sep-7                   PIC X.           
           03  fc-err-state               PIC X(5).
           03  fc-sep-8                   PIC X.      
           03  fc-err-msg                 PIC X(40).
           03  fc-sep-9                   PIC X.       
       
       working-storage section.       
       01  wr-log-date-time.
           03  wr-yyyymmdd.
               05 wn-year     PIC 9(4) VALUE ZERO.
               05 wn-month    PIC 9(2) VALUE ZERO.
               05 wn-day      PIC 9(2) VALUE ZERO.
           03  wr-hhmmss.
               05 wn-hour     PIC 9(2) VALUE ZERO.
               05 wn-minute   PIC 9(2) VALUE ZERO.
               05 wn-second   PIC 9(2) VALUE ZERO.
               05 wn-hundred  PIC 9(2) VALUE ZERO.               
           03  wc-other       PIC X(5) VALUE SPACE.    
       
       01  wc-is-debug             PIC X(40) VALUE SPACE.
       01  wc-is-errlog            PIC X(40) VALUE SPACE.       
                
       linkage section.
       01  lc-err-state         PIC X(5).
       01  lc-err-msg           PIC X(70).
       
       *>******************************************************         
       PROCEDURE DIVISION USING lc-err-state lc-err-msg.
       A000-error-printscr.
        
           *> only display if debug environment is set
           ACCEPT wc-is-debug FROM ENVIRONMENT 'OJ_DBG'
           
           IF wc-is-debug = '1'
               DISPLAY '<br>ERROR: |' lc-err-state '|' lc-err-msg
           END-IF
           
           *> Only write to log file if OJ_LOG is set 1
           ACCEPT wc-is-errlog FROM ENVIRONMENT 'OJ_LOG'
           
           IF wc-is-errlog = '1'
               PERFORM A0100-append-msg-to-error-file
           END-IF
            
           EXIT PROGRAM
           .
            
       *>******************************************************             
       A0100-append-msg-to-error-file.
       
           MOVE FUNCTION CURRENT-DATE TO wr-log-date-time
           
           *> append data
           OPEN EXTEND ojlogfile
                            
           MOVE wn-year TO fc-yyyy  
           MOVE '-' TO fc-sep-1   
           MOVE wn-month TO fc-monthmonth   
           MOVE '-' TO fc-sep-2    
           MOVE wn-day TO fc-dd     
           MOVE 'T' TO fc-sep-3     
           MOVE wn-hour TO fc-hh      
           MOVE ':' TO fc-sep-4                 
           MOVE wn-minute TO fc-mm    
           MOVE ':' TO fc-sep-5                  
           MOVE wn-second TO fc-ss
           MOVE ',' TO fc-sep-6
           MOVE wn-hundred TO fc-tt               
           MOVE '|' TO fc-sep-7               
           MOVE lc-err-state TO fc-err-state      
           MOVE '|' TO fc-sep-8          
           MOVE lc-err-msg TO fc-err-msg
           MOVE '|' TO fc-sep-9        
                             
           WRITE fd-ojlogfile-post
           
           CLOSE ojlogfile
       
           .
           
       *>******************************************************               

<