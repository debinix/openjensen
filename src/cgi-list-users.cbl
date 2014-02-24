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
       DATA DIVISION.
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
             05  wn-user-usertype-id   PIC  9(9) VALUE ZERO.
             05  wn-user-program-id    PIC  9(9) VALUE ZERO.
             
       EXEC SQL BEGIN DECLARE SECTION END-EXEC.
       01  program-rec-vars.
             05 t-program-id           PIC 9(4) VALUE ZERO.
             05 t-program-name         PIC X(40) VALUE SPACE.
             05 t-program-startdate    PIC X(40) VALUE SPACE.
             05 t-program-enddate      PIC X(40) VALUE SPACE.
       EXEC SQL END DECLARE SECTION END-EXEC.

       01  wr-program-rec-vars.
             05 wc-program-id          PIC 9(4) VALUE ZERO.
             05 wc-program-name        PIC X(40) VALUE SPACE.
             05 wc-program-startdate   PIC X(40) VALUE SPACE.
             05 wc-program-enddate     PIC X(40) VALUE SPACE.

       EXEC SQL BEGIN DECLARE SECTION END-EXEC.
       01  usertype-rec-vars.
             05 t-usertype-id         PIC 9(4) VALUE ZERO.
             05 t-usertype-name       PIC X(40) VALUE SPACE.
             05 t-usertype-rights     PIC 9(4) VALUE ZERO.
       EXEC SQL END DECLARE SECTION END-EXEC.

       01  wr-usertype-rec-vars.
             05 wc-usertype-id         PIC 9(4) VALUE ZERO.
             05 wc-usertype-name       PIC X(40) VALUE SPACE.
             05 wc-usertype-rights     PIC 9(4) VALUE ZERO.


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
       01 wn-user-id-edit               PIC ZZZ9  VALUE ZERO.
       
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
            
            *>MOVE ZERO TO wn-rtn-code
            
            IF wn-rtn-code = ZERO
                SET is-valid-init TO true
                MOVE ZERO TO wn-rtn-code
                MOVE SPACE TO wc-post-value
                MOVE 'usertype_id' TO wc-post-name
                CALL 'get-post-value'
                    USING wn-rtn-code wc-post-name wc-post-value
            ELSE
               MOVE 'Fel i wui-print-header'
                    TO wc-printscr-string
               CALL 'stop-printscr' USING wc-printscr-string
            END-IF
            
            *>MOVE "4" TO wc-post-value
            IF wc-post-value = SPACE
               MOVE 'Saknar ett anv�ndattyp id'
                    TO wc-printscr-string
               CALL 'stop-printscr' USING wc-printscr-string
            ELSE
                *> *** Get the post values ***            
                MOVE FUNCTION numval(wc-post-value)
                     TO wn-user-type-number
            END-IF
           .       
       *>**************************************************
       B0100-Main.            
            IF is-valid-init
    
                PERFORM B0200-connect
                
                IF is-db-connected
                    PERFORM B0300-Get-Lookup-Data
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
       B0300-Get-Lookup-Data.
           perform B0310-Get-Program-Names
           perform B0320-Get-User-Type-Names
           .
       *>**************************************************
       B0310-Get-Program-Names.
           EXEC SQL
               DECLARE cur4 CURSOR FOR
                  SELECT  program_id, program_name
                  FROM tbl_program
                  ORDER BY program_id
           END-EXEC
            
           EXEC SQL
                OPEN cur4
           END-EXEC

           EXEC SQL
               FETCH cur4 INTO
                   :t-program-id,
                   :t-program-name
           END-EXEC

           SET idx-program TO 1

           PERFORM UNTIL SQLSTATE NOT = ZERO
                MOVE t-program-name TO tbl-program-name(idx-program)
                SET idx-program UP BY 1
 
                EXEC SQL
                    FETCH cur4 INTO
                        :t-program-id,
                        :t-program-name
                END-EXEC
           END-PERFORM

           EXEC SQL
                CLOSE cur4
           END-EXEC
           .
       *>**************************************************
       B0320-Get-User-Type-Names.
            EXEC SQL
                DECLARE cur5 CURSOR FOR
                   SELECT usertype_id, usertype_name
                   FROM tbl_usertype
                   ORDER BY usertype_id
            END-EXEC
            
            EXEC SQL
                OPEN cur5
            END-EXEC
 
            EXEC SQL
                FETCH cur5 INTO
                    :t-usertype-id,
                    :t-usertype-name
            END-EXEC
 
            SET idx-user-type TO 1
 
            PERFORM UNTIL SQLSTATE NOT = ZERO
                MOVE t-usertype-name
                    TO tbl-user-type-name(idx-user-type)
                
                SET idx-user-type UP BY 1
 
                EXEC SQL
                    FETCH cur5 INTO
                        :t-usertype-id,
                        :t-usertype-name
                END-EXEC
 
            END-PERFORM
 
            EXEC SQL
                CLOSE cur5
            END-EXEC
           .
       *>**************************************************
       B0400-List-Users.
            
            EXEC SQL
                DECLARE curpupil CURSOR FOR
                   SELECT  user_id,
                           user_firstname,
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
                    SELECT  user_id,
                            user_firstname,
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
                DISPLAY
                    html-table-row-start
                    html-table-cell-start
                      tbl-user-type-name(t-user-usertype-id)
                    html-table-cell-end
                    html-table-cell-start
                      t-user-firstname
                    html-table-cell-end
                    html-table-cell-start
                      t-user-lastname
                    html-table-cell-end
                    html-table-cell-start
                      tbl-program-name(t-user-program-id)
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

            END-PERFORM

            *> Close cursors
            EVALUATE wn-user-type-number
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
       B0410-Get-Pupil-Data.
            EXEC SQL
               FETCH curpupil INTO
                    :t-user-id,
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
                    :t-user-id,
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
            IF wn-user-type-number >= 3 THEN
            MOVE t-user-id TO wn-user-id-edit
                DISPLAY
                   '<td><a href="users.edit.php?user_id='
                   FUNCTION trim (wn-user-id-edit)
                   '"><span class="label label-info">'
                   'Redigera'
                   '</span></a></td>'
                   html-table-row-end
                END-DISPLAY
            ELSE
                DISPLAY html-table-row-end
            END-IF
            .
       *>**************************************************
       *> Exit and cleanup procedures
       *>**************************************************
       C0100-Exit.
            
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
