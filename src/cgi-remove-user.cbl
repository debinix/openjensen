       *>**************************************************
       *> Author:  Peter Brink
       *> Purpose: Remove a user to the database.
       *> Created: 2014-02-13
       *> Revisions:
       *>       0.1: Initial revision.
       *>**************************************************
       IDENTIFICATION DIVISION.
       program-id. cgi-remove-user.
       *>**************************************************
       DATA DIVISION.
       *>**************************************************
       WORKING-STORAGE SECTION.
       *>**************************************************
       01   switches.
            03  is-valid-post-switch        PIC X   VALUE 'N'.
                88  is-valid-post                   VALUE 'Y'.
            03  is-valid-transaction-switch PIC X   VALUE 'N'.
                88  is-valid-transaction            VALUE 'Y'.
            03  is-db-connected-switch      PIC X   VALUE 'N'.
                88  is-db-connected                 VALUE 'Y'.
            03  is-valid-init-switch        PIC X   VALUE 'N'.
                88  is-valid-init                   VALUE 'Y'.
            03  is-id-found-switch          PIC X   VALUE 'N'.
                88  is-id-found                     VALUE 'Y'.

       *> used in calls to dynamic libraries
       01  wn-rtn-code             PIC  S99   VALUE ZERO.
       01  wc-post-name            PIC X(40)  VALUE SPACE.
       01  wc-post-value           PIC X(40)  VALUE SPACE.

       *> always - used in error routine
       01  wc-printscr-string      PIC X(40)  VALUE SPACE.

       01  wc-pagetitle       PIC X(20)  VALUE 'Tag bort användare'.

       EXEC SQL BEGIN DECLARE SECTION END-EXEC.
       01  wc-database              PIC  X(30).
       01  wc-passwd                PIC  X(10).
       01  wc-username              PIC  X(30).
       EXEC SQL END DECLARE SECTION END-EXEC.

       *>**************************************************
       EXEC SQL BEGIN DECLARE SECTION END-EXEC.
         01  users-rec-vars.
             05  t-user-id            PIC  9(4).
             05  t-user-firstname     PIC  X(40).
             05  t-user-lastname      PIC  X(40).
             05  t-user-email         PIC  X(40).
             05  t-user-phonenumber   PIC  X(40).
             05  t-user-username      PIC  X(40).
             05  t-user-password      PIC  X(40).
             05  t-user-lastlogin     PIC  X(40).
             05  t-user-usertype-id   PIC  9(4).
             05  t-user-program-id    PIC  9(4).
       EXEC SQL END DECLARE SECTION END-EXEC.

       01  wr-rec-vars.
             05  wn-user-id           PIC  9(4) VALUE ZERO.
             05  wc-firstname         PIC  X(40) VALUE SPACE.
             05  wc-lastname          PIC  X(40) VALUE SPACE.
             05  wc-user-email        PIC  X(40) VALUE SPACE.
             05  wc-user-phonenumber  PIC  X(40) VALUE SPACE.
             05  wc-user-username     PIC  X(40) VALUE SPACE.
             05  wc-user-password     PIC  X(40) VALUE SPACE.
             05  wn-user-usertype-id  PIC  9(4) VALUE ZERO.
             05  wn-user-program-id   PIC  9(4) VALUE ZERO.

       *>**************************************************
       EXEC SQL INCLUDE SQLCA END-EXEC.

       *>**************************************************
       PROCEDURE DIVISION.
       *>**************************************************
       0000-main.

           *> contains development environment settings for test
           copy setupenv_openjensen.

           perform a0100-init

           if is-valid-post and is-valid-init

                perform B0100-connect
                if is-db-connected
                    perform B0200-cgi-delete-row
                end-if

           end-if

           perform c0100-closedown

           goback
        .

       *>**************************************************
       A0100-init.

           *> always send out the Content-Type before any other I/O
           CALL 'wui-print-header' USING wn-rtn-code
           *>  start html doc
           CALL 'wui-start-html' USING wc-pagetitle

           *> decompose and save current post string
           call 'write-post-string' using wn-rtn-code

           if wn-rtn-code = zero

               set is-valid-init to true

               *> cgi post: remove row by local-id
               move zero to wn-rtn-code
               move space to wc-post-VALUE
               move 'user-id' to wc-post-name
               call 'get-post-value' using wn-rtn-code
                                           wc-post-name wc-post-value
               *> convert to number (space --> 0)
               move function numval(wc-post-value) to wn-user-id

           end-if

           if wn-user-id = 0
                move 'Saknar användarens identifikation'
                    to wc-printscr-string
                call 'stop-printscr' using wc-printscr-string
           else
                set is-valid-post to true
           end-if

        .

       *>**************************************************
       B0100-connect.

           *>  connect
           move  "openjensen"    to   wc-database
           move  "jensen"        to   wc-username
           move  "jensen"        to   wc-passwd

           exec sql
               connect :wc-username identified by :wc-passwd
                                            using :wc-database
           end-exec

           if  sqlstate not = zero
                perform Z0100-error-routine
           else
                set is-db-connected to true
           end-if

        .

       *>**************************************************
       B0200-cgi-delete-row.

           *> delete based on user_id
           if wn-user-id not = 0

                *> the selected row to be removed
                move wn-user-id to t-user-id

                perform B0210-is-id-found

                *> delete row from table
                *> the pre-compiler does not like lowercase
                *> characters when an sql statement is embedded
                *> into an if-then-else clause...
                IF is-id-found
                     EXEC SQL
                         DELETE FROM tbl_user
                                  WHERE user_id = :t-user-id
                     END-EXEC
                END-IF

                if  sqlstate = zero
                    move 'Användaren bortagen'
                    to wc-printscr-string
                    call 'ok-printscr' using wc-printscr-string
                else
                    perform Z0100-error-routine
                end-if

           end-if

           perform B0300-commit-work

           perform B0310-disconnect

        .

       *>**************************************************
       B0210-is-id-found.

           *> cursor for tbl_user
           exec sql
             declare curs1 cursor for
                 select user_id
                 from tbl_user
                     where user_id = :t-user-id
           end-exec.

           *> open the cursor
           exec sql
                open curs1
           end-exec

           *> try a fetch
           exec sql
               fetch curs1
                   into :wn-user-id
           end-exec

           if sqlstate = zero
               set is-id-found to true
           end-if

        .

       *>**************************************************
       B0300-commit-work.

           *>  commit work permanently
           exec sql
               commit work
           end-exec
        .

       *>**************************************************
       B0310-disconnect.

           *>  disconnect
           exec sql
               disconnect all
           end-exec

        .

       *>**************************************************
       C0100-closedown.

          CALL 'wui-end-html' USING wn-rtn-code

        .

       *>**************************************************
       Z0100-error-routine.

           *> requires the ending dot (and no extension)!
           copy z0100-error-routine.
        .
