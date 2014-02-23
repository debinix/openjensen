       *>**************************************************
       *> Author:  Peter Brink
       *> Purpose: Get info a group of pupils from the database.
       *> Created: 2014-02-11
       *> Revisions:
       *>       0.1: Initial revision.
       *>**************************************************
       IDENTIFICATION DIVISION.
       PROGRAM-ID. cgi-list-users.
       *>**************************************************
       ENVIRONMENT DIVISION.
       *>**************************************************
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
            SELECT OPTIONAL html-file ASSIGN TO 'html-output.txt'
               ORGANIZATION IS LINE SEQUENTIAL.

       *>**************************************************
       DATA DIVISION.
       *>**************************************************
       FILE SECTION.
       FD html-file.
       01  html-output-rec.
           05  html-output                     PIC X(1024).
        
       *>**************************************************
       WORKING-STORAGE SECTION.
       *>**************************************************
       01 Switches.
           05  is-valid-post-switch            PIC X   VALUE 'N'.
               88  is-valid-post                       VALUE 'Y'.
           05  is-db-connected-switch          PIC X   VALUE 'N'.
               88  is-db-connected                     VALUE 'Y'.
           05  is-valid-init-switch            PIC X   VALUE 'N'.
               88 is-valid-init                        VALUE 'Y'.

       *> Working sTOrage for record TO file
       01 wr-html-output-rec.
            05 wc-html-output          PIC X(1024) VALUE SPACE.

       *>**************************************************
       *> SQL Copybooks

       EXEC SQL INCLUDE SQLCA END-EXEC.

       EXEC SQL BEGIN DECLARE SECTION END-EXEC.
       01  wc-database                 PIC  X(30) VALUE SPACE.
       01  wc-passwd                   PIC  X(10) VALUE SPACE.
       01  wc-username                 PIC  X(30) VALUE SPACE.
       EXEC SQL END DECLARE SECTION END-EXEC.

       EXEC SQL BEGIN DECLARE SECTION END-EXEC.
       01  users-rec-vars.
             05  t-user-id             PIC  9(4) VALUE ZERO.
             05  t-user-firstname      PIC  X(40) VALUE SPACE.
             05  t-user-lastname       PIC  X(40) VALUE SPACE.
             05  t-user-email          PIC  X(40) VALUE SPACE.
             05  t-user-phonenumber    PIC  X(40) VALUE SPACE.
             05  t-user-username       PIC  X(40) VALUE SPACE.
             05  t-user-password       PIC  X(40) VALUE SPACE.
             05  t-user-lastlogin      PIC  X(40) VALUE SPACE.
             05  t-user-usertype-id    PIC  9(9) VALUE ZERO.
             05  t-user-program-id     PIC  9(9) VALUE ZERO.
       EXEC SQL END DECLARE SECTION END-EXEC.

       01  wr-users-rec-vars.
             05  wc-user-id            PIC  9(4) VALUE ZERO.
             05  wc-user-firstname     PIC  X(40) VALUE SPACE.
             05  wc-user-lastname      PIC  X(40) VALUE SPACE.
             05  wc-user-email         PIC  X(40) VALUE SPACE.
             05  wc-user-phonenumber   PIC  X(40) VALUE SPACE.
             05  wc-user-username      PIC  X(40) VALUE SPACE.
             05  wc-user-password      PIC  X(40) VALUE SPACE.
             05  wc-user-lastlogin     PIC  X(40) VALUE SPACE.
             05  wc-user-usertype-id   PIC  9(9) VALUE ZERO.
             05  wc-user-program-id    PIC  9(9) VALUE ZERO.

       *>**************************************************
       *> used in CALLs TO dynamic libraries
       01  wn-rtn-code                 PIC  s99   VALUE ZERO.
       01  wc-post-name                PIC X(40)  VALUE SPACE.
       01  wc-post-value               PIC X(40)  VALUE SPACE.

       *>**************************************************
       *> html-tags
       01 html-tags.
           05 html-table-row-start     PIC X(4)   VALUE '<tr>'.
           05 html-table-row-end       PIC X(5)   VALUE '</tr>'.
           05 html-table-cell-start    PIC X(4)   VALUE '<td>'.
           05 html-table-cell-end      PIC X(5)   VALUE '</td>'.

       *>**************************************************
       *> Lookup tables
        01 User-Type-Table.
           05 tbl-user-type-name PIC X(40) OCCURS 4 TIMES INDEXED BY
                                                       idx-user-type.
        01 Program-Name-Table.
           05 tbl-program-name   PIC X(40) OCCURS 2 TIMES INDEXED BY
                                                       idx-program.

       *>**************************************************
       *> Various temporal and utility fields.
       01 wn-user-type-number           PIC 9(4)  VALUE ZERO.
       01 wc-filename                   PIC X(40) VALUE ZERO.
       01 wc-src-file-path              PIC X(15)  VALUE SPACE.
       01 wc-dest-dir-path              PIC X(8)  VALUE "../data/".
       01 wc-dest-file-path             PIC X(64) VALUE SPACE.
       01 wc-usertype-name              PIC X(20) VALUE SPACE.
       01 wc-program-name               PIC X(20) VALUE SPACE.
       
       *> These two plus html-table-row-end makes up one
       *> line in the output file
       01 wc-html-code                  PIC X(891) VALUE SPACE.
       01 wc-php-code                   PIC X(128) VALUE SPACE.

       *> always - used in error routine
       01  wc-printscr-string      PIC X(40)  VALUE SPACE.

       *>**************************************************
       PROCEDURE DIVISION.
       *>**************************************************
       0000-Start.
            COPY setupenv_openjensen.
 
            PERFORM A0100-Init
            PERFORM B0100-Main
            PERFORM C0100-Exit
            .
       *>**************************************************
       A0100-Init.
            CALL 'wui-print-header' USING wn-rtn-code
           
            MOVE "html-output.txt"
                TO wc-src-file-path

            CALL 'write-post-string' USING wn-rtn-code

            IF wn-rtn-code = ZERO
                SET is-valid-init TO true
                MOVE ZERO TO wn-rtn-code
                MOVE SPACE TO wc-post-value
                MOVE 'usertype_id' TO wc-post-name
                CALL 'get-post-value'
                    USING wn-rtn-code wc-post-name wc-post-value
            END-IF

            IF wc-post-value = SPACE
                MOVE 'Saknar ett användattyp id'
                     TO wc-printscr-string
                CALL 'stop-printscr' USING wc-printscr-string
            ELSE
                *> *** Get the post values ***
                MOVE function numval(wc-post-value)
                     TO wn-user-type-number
 
                MOVE ZERO TO wn-rtn-code
                MOVE SPACE TO wc-post-value
                MOVE 'filename' TO wc-post-name
                CALL 'get-post-value'
                    USING wn-rtn-code wc-post-name wc-post-value
 
                IF wn-rtn-code = ZERO
                    MOVE wc-post-value TO wc-filename
                    SET is-valid-init TO true
                END-IF
            END-IF
           .       
       *>**************************************************
       B0100-Main.            
            IF is-valid-init
    
                PERFORM B0200-connect
                
                IF is-db-connected
                     PERFORM B0400-List-Users
                     PERFORM Z0200-Disconnect
                END-IF
            END-IF
           .
       *>**************************************************
       B0200-Connect.
            MOVE  "openjensen"    TO   wc-database
            MOVE  "jensen"        TO   wc-username
            MOVE  SPACE           TO   wc-passwd

            
            EXEC SQL
               CONNECT :wc-username IDENTIFIED BY :wc-passwd
                                    USING :wc-database
            END-EXEC

            IF SQLSTATE NOT = ZERO
                PERFORM Z0100-Error-Routine
            ELSE
                SET is-db-connected TO TRUE
            END-IF
            .
       *>**************************************************
       B0400-List-Users.
            *>OPEN OUTPUT html-file
            
            EXEC SQL
                DECLARE curpupil CURSOR FOR
                   SELECT  user_firstname,
                           user_lastname,
                           user_email,
                           user_phonenumber,
                           usertype_id,
                           user_program,
                           user_lastlogin
                   FROM tbl_user
                   WHERE usertype_id = 1
                   ORDER BY user_lastname, user_firstname
            END-EXEC

            EXEC SQL
                DECLARE curall CURSOR FOR
                    SELECT  user_firstname,
                            user_lastname,
                            user_email,
                            user_phonenumber,
                            usertype_id,
                            user_program,
                            user_lastlogin
                    FROM tbl_user
                    ORDER BY user_lastname, user_firstname
            END-EXEC
 
            *> Fetch the first record
            EVALUATE wn-user-type-number
                WHEN 1
                    EXEC SQL
                        OPEN curpupil
                    END-EXEC
                    PERFORM B0410-Get-Pupil-Data
                WHEN OTHER
                    EXEC SQL
                        OPEN curall
                    END-EXEC
                    PERFORM B0430-Get-All-User-Data
            END-EVALUATE

            *> Fetch the remaining records
            PERFORM UNTIL sqlstate NOT = ZERO
                
                PERFORM B0405-Get-Usertype-Name
                PERFORM B0406-Get-Program-Name
                
                DISPLAY
                    html-table-row-start
                    html-table-cell-start
                      wc-usertype-name
                    html-table-cell-end
                    html-table-cell-start
                      t-user-firstname
                    html-table-cell-end
                    html-table-cell-start
                      t-user-lastname
                    html-table-cell-end
                    html-table-cell-start
                      wc-program-name
                    html-table-cell-end
                    html-table-cell-start
                      t-user-email
                    html-table-cell-end
                    html-table-cell-start
                      t-user-phonenumber
                    html-table-cell-end
                    html-table-cell-start
                      t-user-lastlogin
                    html-table-cell-end
                END-DISPLAY
                PERFORM B0500-Check-if-Admin
                
                *> fetch next
                EVALUATE wn-user-type-number
                    WHEN 1
                        PERFORM B0410-Get-Pupil-Data
                    WHEN other
                        PERFORM B0430-Get-All-User-Data
                END-EVALUATE

                *>MOVE wr-html-output-rec TO html-output-rec
                *>WRITE html-output-rec
            END-PERFORM

            *> All users have been written TO file. Close it.
            *>CLOSE html-file
            
            *> Close cursors
            EVALUATE wc-post-value
               WHEN 1
                  EXEC SQL
                        CLOSE curpupil
                  END-EXEC
               WHEN OTHER
                   EXEC SQL
                        CLOSE curall
                   END-EXEC
            END-EVALUATE
            .
       *>**************************************************
       *> TO-DO: move these two procedures into a subroutine
       *> and fetch the names from the db and put them in in-
       *> ternal tables. /PB 
       B0405-Get-Usertype-Name.
            EVALUATE t-user-usertype-id
                WHEN 1
                    MOVE 'Elev' TO wc-usertype-name
                WHEN 2
                    MOVE 'Lärare' TO wc-usertype-name
                WHEN 4
                    MOVE 'Utbildningsledare' TO wc-usertype-name
                WHEN 16
                    MOVE 'Administratör' TO wc-usertype-name
            END-EVALUATE
            .
       *>**************************************************
       B0406-Get-Program-Name.
            EVALUATE t-user-program-id
                WHEN 1
                    MOVE 'Testprogram1' TO wc-program-name
                WHEN 2
                    MOVE 'Testprogram2' TO wc-program-name
            END-EVALUATE
            .
       *>**************************************************
       B0410-Get-Pupil-Data.
            EXEC SQL
               FETCH curpupil INTO
                   :t-user-firstname,
                   :t-user-lastname,
                   :t-user-email,
                   :t-user-phonenumber,
                   :t-user-usertype-id,
                   :t-user-program-id,
                   :t-user-lastlogin
            END-EXEC
            .
       *>**************************************************
       B0430-Get-All-User-Data.
            EXEC SQL
               FETCH curall INTO
                   :t-user-firstname,
                   :t-user-lastname,
                   :t-user-email,
                   :t-user-phonenumber,
                   :t-user-usertype-id,
                   :t-user-program-id,
                   :t-user-lastlogin
            END-EXEC
            .
       *>**************************************************
       *> Checks IF admin and builds output line
       B0500-Check-if-Admin.
            IF wn-user-type-number = 16 THEN
                DISPLAY
                   '<td><a href="users.edit.php?user_id='
                   '<?php echo $ row['
                   function trim(t-user-id)
                   ']; ?>"><span class="label label-info">'
                   'Ändra'
                   '</span></a></td>'
                END-DISPLAY
            ELSE
                DISPLAY html-table-row-end
            END-IF
            .
       *>**************************************************
       *> Exit and cleanup procedures
       *>**************************************************
       C0100-Exit.

            *>CALL 'wui-end-html' USING wn-rtn-code
            *> rename output file to the name given by php-script
            *> using a build in subroutine. Then remove output file.
            *>STRING wc-dest-dir-path DELIMITED BY " "
            *>       wc-filename DELIMITED BY " "
            *>       INTO wc-dest-file-path
            *>CALL "C$COPY"
            *>    USING wc-src-file-path, wc-dest-file-path, 0
            *>CALL "C$DELETE" USING wc-src-file-path, 0
            
            goback
            .
            
       *>**************************************************
       *> Utility procedures (Z0000- etc.)
       *>**************************************************
       Z0100-Error-Routine.
            COPY z0100-error-routine.
            .
       *>**************************************************
       Z0200-Disconnect.
            EXEC SQL
               DISCONNECT ALL
            END-EXEC
            .
