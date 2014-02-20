       *>**************************************************
       *> Author:  Peter Brink
       *> Purpose: Get info a group of pupils from the database.
       *> Created: 2014-02-11
       *> Revisions:
       *>       0.1: Initial revision.
       *>**************************************************
       IDENTIFICATION DIVISION.
       program-id. cgi-list-users.
       *>**************************************************
       ENVIRONMENT DIVISION.
      *>**************************************************
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           select optional html-file assign to 'html-output.txt'
               organization is line sequential.
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

       *> Working storage for record to file
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

       exec sql begin declare section end-exec.
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
       exec sql end declare section end-exec.

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

       exec sql begin declare section end-exec.
       01  program-rec-vars.
             05 t-program-id           PIC 9(4) VALUE ZERO.
             05 t-program-name         PIC X(40) VALUE SPACE.
             05 t-program-startdate    PIC X(40) VALUE SPACE.
             05 t-program-enddate      PIC X(40) VALUE SPACE.
       exec sql end declare section end-exec.

       01  wr-program-rec-vars.
             05 wc-program-id          PIC 9(4) VALUE ZERO.
             05 wc-program-name        PIC X(40) VALUE SPACE.
             05 wc-program-startdate   PIC X(40) VALUE SPACE.
             05 wc-program-enddate     PIC X(40) VALUE SPACE.

       exec sql begin declare section end-exec.
       01  usertype-rec-vars.
             05 t-usertype-id         PIC 9(4) VALUE ZERO.
             05 t-usertype-name       PIC X(40) VALUE SPACE.
             05 t-usertype-rights     PIC 9(4) VALUE ZERO.
       exec sql end declare section end-exec.

       01  wr-usertype-rec-vars.
             05 wc-usertype-id         PIC 9(4) VALUE ZERO.
             05 wc-usertype-name       PIC X(40) VALUE SPACE.
             05 wc-usertype-rights     PIC 9(4) VALUE ZERO.

       *>**************************************************
       *> used in calls to dynamic libraries
       01  wn-rtn-code                 PIC  s99   VALUE ZERO.
       01  wc-post-name                PIC X(40)  VALUE SPACE.
       01  wc-post-VALUE               PIC X(40)  VALUE SPACE.

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
           05 tbl-user-type-name PIC X(40) occurs 4 times indexed by
                                                       idx-user-type.
        01 Program-Name-Table.
           05 tbl-program-name   PIC X(40) occurs 2 times indexed by
                                                       idx-program.

       *>**************************************************
       *> Various temporal and utility fields.
       01 wn-user-type-number           PIC 9(4)  VALUE ZERO.
       01 wc-filename                   PIC X(32) VALUE ZERO.
       01 wc-src-file-path              PIC X(64) VALUE SPACE.
       01 wc-dest-dir-path              PIC X(32) VALUE SPACE.
       01 wc-dest-file-path             PIC X(64) VALUE SPACE.
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
           copy setupenv_openjensen.

           perform A0100-Init
           perform B0100-Main
           perform C0100-Exit
           .
       *>**************************************************
       A0100-Init.
           CALL 'wui-print-header' USING wn-rtn-code
           
           move "/srv/www/cgi-bin/html-output.txt"
                to wc-src-file-path
           move "srv/www/htdocs/" to wc-dest-dir-path

           call 'write-post-string' using wn-rtn-code

           if wn-rtn-code = ZERO
               set is-valid-init to true
               move zero to wn-rtn-code
               move space to wc-post-VALUE
               move 'usertype_id' to wc-post-name
               call 'get-post-value' using wn-rtn-code
                                           wc-post-name wc-post-value
           end-if

           IF wc-post-value = SPACE
               MOVE 'Saknar ett användattyp id'
                    TO wc-printscr-string
               CALL 'stop-printscr' USING wc-printscr-string
           ELSE
               *> *** Get the post values ***
               move function numval(wc-post-value)
                    to wn-user-type-number

               move zero to wn-rtn-code
               move space to wc-post-value
               move 'filename' to wc-post-name
               call 'get-post-value'
                    using wn-rtn-code wc-post-name wc-post-value

               if wn-rtn-code = zero
                   move wc-post-value TO wc-filename
                   set is-valid-init to true
               end-if
            END-IF

           perform A0110-Init-Cursors

           .
       *>**************************************************
       A0110-Init-Cursors.
            *> pupils only
            EXEC SQL
              DECLARE cur1 CURSOR FOR
                   SELECT  user_firstname,
                           user_lastname,
                           user_email,
                           user_phonenumber,
                           user_program,
                           user_lastlogin
                   FROM tbl_users
                   WHERE usertype_id = 1
                   ORDER BY user_lastname, user_firstname
            END-EXEC

            *> teachers
            EXEC SQL
              DECLARE cur2 CURSOR FOR
                  SELECT  user_firstname,
                          user_lastname,
                          user_email,
                          user_phonenumber,
                          user_program,
                          user_lastlogin
                  FROM tbl_users
                  WHERE usertype_id = 2
                  ORDER BY user_lastname, user_firstname
            END-EXEC

            *> all users
            EXEC SQL
              DECLARE cur3 cursor for
                  SELECT  user_firstname,
                          user_lastname,
                          user_email,
                          user_phonenumber,
                          user_program,
                          user_lastlogin
                  FROM tbl_users
                  ORDER BY user_lastname, user_firstname
            END-EXEC

            *> program names
            EXEC SQL
               DECLARE cur4 CURSOR FOR
                   SELECT  program_id, user_name
                   FROM tbl_program
                   ORDER BY program_id
            END-EXEC

            *> user type names
            EXEC SQL
               DECLARE cur5 CURSOR FOR
                   SELECT usertype_id, usertype_name
                   FROM tbl_usertype
                   ORDER BY usertype_id
            END-EXEC
       .
       *>**************************************************
       B0100-Main.
           if is-valid-init

                perform B0200-connect
                if is-db-connected
                    perform B0300-Get-Lookup-Data
                    perform B0400-List-Users
                    perform Z0200-Disconnect
                end-if
           end-if
           .
       *>**************************************************
       B0200-Connect.
           move  "openjensen"    to   wc-database
           move  "jensen"        to   wc-username
           move  SPACE           to   wc-passwd

           exec sql
               connect :wc-username identified by :wc-passwd
                                    using :wc-database
           end-exec

           if  sqlstate not = zero
                perform Z0100-Error-Routine
           else
                set is-db-connected to true
           end-if
           .
       *>**************************************************
       B0300-Get-Lookup-Data.
           perform B0310-Get-Program-Names
           perform B0320-Get-User-Type-Names
           .
       *>**************************************************
       B0310-Get-Program-Names.
           exec sql
                open cur4
           end-exec

           exec sql
               fetch cur4 into
                   :t-program-id,
                   :t-program-name
           end-exec

           set idx-program to 1

           perform until sqlstate not = zero

               move t-program-name to tbl-program-name(idx-program)
               set idx-program up by 1

               exec sql
                   fetch cur4 into
                       :t-program-id,
                       :t-program-name
               end-exec

           end-perform

           exec sql
                close cur4
           end-exec
           .
       *>**************************************************
       B0320-Get-User-Type-Names.

           exec sql
                open cur5
           end-exec

           exec sql
               fetch cur5 into
                   :t-usertype-id,
                   :t-usertype-name
           end-exec

           set idx-user-type to 1

           perform until sqlstate not = zero

               move t-usertype-name to tbl-user-type-name(idx-user-type)
               set idx-user-type up by 1

               exec sql
                   fetch cur5 into
                       :t-usertype-id,
                       :t-usertype-name
               end-exec

           end-perform

           exec sql
                close cur5
           end-exec
           .
       *>**************************************************
       B0400-List-Users.

           open output html-file

           *> Fetch the first record
           evaluate wc-post-value
               when 1
                  exec sql
                        open cur1
                  end-exec
                  perform B0410-Get-Pupil-Data
               when 2
                   exec sql
                        open cur2
                   end-exec
                   perform B0420-Get-Teacher-Data
               when other
                   exec sql
                        open cur3
                   end-exec
                   perform B0430-Get-All-User-Data
           end-evaluate

           *> Fetch the remaining records
           perform until sqlstate not = zero

                string html-table-row-start
                    html-table-cell-start
                      tbl-user-type-name(wn-user-type-number)
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
                    into wc-html-code
                perform B0500-Check-if-Admin

               evaluate wc-post-value
                   when 1
                       perform B0410-Get-Pupil-Data
                   when 2
                       perform B0420-Get-Teacher-Data
                   when other
                       perform B0430-Get-All-User-Data
               end-evaluate

               move wr-html-output-rec to html-output-rec
               write html-output-rec
           end-perform

           *> All users have been written to file. Close it.
           close html-file

           *> Close cursors
           evaluate wc-post-value
               when 1
                  exec sql
                        close cur1
                  end-exec
               when 2
                   exec sql
                        close cur2
                   end-exec
               when other
                   exec sql
                        close cur3
                   end-exec
           end-evaluate
           .
       *>**************************************************
       B0410-Get-Pupil-Data.
           exec sql
               fetch cur1 into
                   :t-user-firstname,
                   :t-user-lastname,
                   :t-user-email,
                   :t-user-phonenumber,
                   :t-user-program-id,
                   :t-user-lastlogin
           end-exec
           .
       *>**************************************************
       B0420-Get-Teacher-Data.
           exec sql
               fetch cur2 into
                   :t-user-firstname,
                   :t-user-lastname,
                   :t-user-email,
                   :t-user-phonenumber,
                   :t-user-program-id,
                   :t-user-lastlogin
           end-exec
           .
       *>**************************************************
       B0430-Get-All-User-Data.
           exec sql
               fetch cur3 into
                   :t-user-firstname,
                   :t-user-lastname,
                   :t-user-email,
                   :t-user-phonenumber,
                   :t-user-program-id,
                   :t-user-lastlogin
           end-exec
           .
       *>**************************************************
       *> Checks if admin and builds output line
       B0500-Check-if-Admin.
           if wn-user-type-number = 4 then
               string
                   '<td><a href="users.edit.php?user_id='
                   '<?php echo $ row['
                   function trim(t-user-id)
                   ']; ?>"><span class="label label-info">'
                   'Ändra'
                   '</span></a></td>'
               into wc-php-code
               string wc-html-code delimited by " "
                      wc-php-code delimited by " "
                      html-table-row-end
                      into wc-html-output
           else
                string wc-html-code delimited by " "
                       html-table-row-end
                       into wc-html-output
           end-if
           .
       *>**************************************************
       *> Exit and cleanup procedures
       *>**************************************************
       C0100-Exit.
            *> rename output file to the name given by php-script
            *> using a build in subroutine. Then remove output file.
            string wc-dest-dir-path delimited by " "
                   wc-filename delimited by " "
                   into wc-dest-file-path
            CALL "C$COPY" USING wc-src-file-path, wc-dest-file-path, 0
            *> CALL “C$DELETE” USING wc-src-file-path, 0
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
           exec sql
               disconnect all
           end-exec
           .
