       *>**************************************************
       *> Author:  Peter Brink
       *> Purpose: Add a user to the database.
       *> Created: 2014-02-12
       *> Revisions:
       *>       0.1: Initial revision.
       *>**************************************************
       IDENTIFICATION DIVISION.
       program-id. cgi-add-user.
       *>**************************************************
       DATA DIVISION.
       *>**************************************************
       WORKING-STORAGE SECTION.
       *>**************************************************
       01   switches-add.
            03  is-db-connected-switch         PIC X   VALUE 'N'.
                88  is-db-connected                    VALUE 'Y'.
            03  is-valid-init-switch           PIC X   VALUE 'N'.
                88  is-valid-init                      VALUE 'Y'.
            03  name-is-in-table-switch        PIC X   VALUE 'N'.
                88  name-is-in-table                   VALUE 'Y'.
            03  is-valid-table-position-switch PIC X   VALUE 'N'.
                88  is-valid-table-position            VALUE 'Y'.

       *> used in calls to dynamic libraries
       01  wn-rtn-code             PIC  S99   VALUE ZERO.
       01  wc-post-name            PIC X(40)  VALUE SPACE.
       01  wc-post-value           PIC X(40)  VALUE SPACE.

       *> always - used in error routine
       01  wc-printscr-string      PIC X(40)  VALUE SPACE.

       01  wc-pagetitle   PIC X(20) VALUE 'Lägg till användare'.

       EXEC SQL BEGIN DECLARE SECTION END-EXEC.
       01  wc-database              PIC  X(30).
       01  wc-passwd                PIC  X(10).
       01  wc-username              PIC  X(30).
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

       01  wr-rec-vars.
             05  wn-user-id           PIC  9(4) VALUE zero.
             05  wc-firstname         PIC  x(40) VALUE space.
             05  wc-lastname          PIC  x(40) VALUE space.
             05  wc-user-email        PIC  x(40) VALUE space.
             05  wc-user-phonenumber  PIC  x(40) VALUE space.
             05  wc-user-username     PIC  x(40) VALUE space.
             05  wc-user-password     PIC  x(40) VALUE space.
             05  wn-user-usertype-id  PIC  9(4) VALUE zero.
             05  wn-user-program-id   PIC  9(4) VALUE zero.

       EXEC SQL INCLUDE SQLCA END-EXEC.

       *>**************************************************
       PROCEDURE DIVISION.
       *>**************************************************
       0000-main.

           *> contains development environment settings for test
           copy setupenv_openjensen.

           perform A0100-init

           if is-valid-init

                perform B0100-connect
                if is-db-connected

                    perform B0200-add-dataitem
                    perform Z0200-disconnect

                end-if

           end-if

           perform C0100-closedown

           goback
        .
       *>**************************************************
       A0100-init.

           *> always send out the content-type before any other i/o
           call 'wui-print-header' using wn-rtn-code
           *>  start html doc
           *>call 'wui-start-html' using wc-pagetitle

           *> decompose and save current post string
           call 'write-post-string' using wn-rtn-code

           if wn-rtn-code = zero
               perform A0110-init-add-action
           end-if

        .
       *>**************************************************
       A0110-init-add-action.

           move zero to wn-rtn-code
           move space to wc-post-value
           move 'firstname' to wc-post-name
           call 'get-post-value' using wn-rtn-code
                                       wc-post-name wc-post-value

           if wn-rtn-code = zero
               move wc-post-value TO wc-firstname
               set is-valid-init to true
           end-if

           move zero to wn-rtn-code
           move space to wc-post-value
           move 'lastname' to wc-post-name
           call 'get-post-value' using wn-rtn-code
                                       wc-post-name wc-post-value

           if wn-rtn-code = zero
               move wc-post-value TO wc-lastname
               set is-valid-init to true
           end-if

           move zero to wn-rtn-code
           move space to wc-post-value
           move 'email' to wc-post-name
           call 'get-post-value' using wn-rtn-code
                                       wc-post-name wc-post-value

           if wn-rtn-code = zero
               move wc-post-value TO wc-user-email
               set is-valid-init to true
           end-if

           move zero to wn-rtn-code
           move space to wc-post-value
           move 'phone' to wc-post-name
           call 'get-post-value' using wn-rtn-code
                                       wc-post-name wc-post-value

           if wn-rtn-code = zero
               move wc-post-value TO wc-user-phonenumber
               set is-valid-init to true
           end-if

           move zero to wn-rtn-code
           move space to wc-post-value
           move 'username' to wc-post-name
           call 'get-post-value' using wn-rtn-code
                                       wc-post-name wc-post-value

           if wn-rtn-code = zero
               move wc-post-value TO wc-user-username
               set is-valid-init to true
           end-if

           move zero to wn-rtn-code
           move space to wc-post-value
           move 'password' to wc-post-name
           call 'get-post-value' using wn-rtn-code
                                       wc-post-name wc-post-value

           if wn-rtn-code = zero
               move wc-post-value TO wc-user-password
               set is-valid-init to true
           end-if

           move zero to wn-rtn-code
           move space to wc-post-value
           move 'program' to wc-post-name
           call 'get-post-value' using wn-rtn-code
                                       wc-post-name wc-post-value

           if wn-rtn-code = zero
               move wc-post-value TO wn-user-program-id
               set is-valid-init to true
           end-if

           move zero to wn-rtn-code
           move space to wc-post-value
           move 'usertype' to wc-post-name
           call 'get-post-value' using wn-rtn-code
                                       wc-post-name wc-post-value

           if wn-rtn-code = zero
               move wc-post-value TO wn-user-usertype-id
               set is-valid-init to true
           end-if
       .
       *>**************************************************
       B0100-connect.

           *>  connect
           move  "openjensen"    to   wc-database
           move  "jensen"        to   wc-username
           move  "jensen"        to   wc-passwd

           EXEC SQL
               CONNECT :wc-username identified BY :wc-passwd
                                            USING :wc-database
           END-EXEC

           if  sqlstate not = zero
                perform Z0100-error-routine
           else
                set is-db-connected to true
           end-if
        .

       *>**************************************************
       B0200-add-dataitem.

           perform B0210-does-username-exist

           IF not name-is-in-table
               perform B0220-get-new-row-number

               IF is-valid-table-position
                   perform B0230-add-dataitem-to-table
               END-IF
           ELSE
        move 'det finns redan användare med detta användarnamn'
                    to wc-printscr-string
               call 'stop-printscr' using wc-printscr-string
           END-IF

           .

       *>**************************************************
       B0210-does-username-exist.

           *> cursor for tbl_user
           EXEC SQL
             DECLARE cursadduser CURSOR FOR
                 SELECT user_id, user_username
                 FROM tbl_user
           END-EXEC

           *> open the cursor
           EXEC SQL
                OPEN cursadduser
           END-EXEC

           *> fetch first row
           EXEC SQL
               FETCH cursadduser
                   INTO :t-user-id,
                        :t-user-username
           END-EXEC

           PERFORM UNTIL sqlcode not = zero

               *> set flag if already in the table
               IF FUNCTION UPPER-CASE (wc-user-username) =
                  FUNCTION UPPER-CASE (t-user-username)
                        set name-is-in-table to true
               END-IF

              *> fetch next row
               EXEC SQL
                   FETCH cursadduser
                       INTO :t-user-id, :t-user-username
               END-EXEC

           END-PERFORM


           *> end of data
           IF  sqlstate not = '02000'
                perform Z0100-error-routine
           END-IF

           *> close cursor
           EXEC SQL
               CLOSE cursadduser
           END-EXEC

        .

       *>**************************************************
       B0220-get-new-row-number.

           *> Cursor for tbl_user
           EXEC SQL
             DECLARE cursaddid cursor FOR
                 SELECT user_id
                 FROM tbl_user
                 ORDER BY user_id DESC
           END-EXEC

           *> Open the cursor
           EXEC SQL
                OPEN cursaddid
           END-EXEC

           *> fetch first row (which now have the highest id)
           EXEC SQL
               FETCH cursaddid
                   INTO :t-user-id
           END-EXEC

           IF  sqlcode not = zero
                perform Z0100-error-routine
           ELSE
               set is-valid-table-position to true
               *> next number for new row in table
               compute wn-user-id  = t-user-id  + 1
           END-IF

           *> close cursor
           EXEC SQL
               CLOSE cursaddid
           END-EXEC

           .

       *>**************************************************
       B0230-add-dataitem-to-table.

           *> get current timestamp
           EXEC SQL
                SELECT current_timestamp
                INTO :t-user-lastlogin
           END-EXEC

           move wn-user-id to t-user-id
           move wc-firstname to t-user-firstname
           move wc-lastname to t-user-lastname
           move wc-user-email to t-user-email
           move wc-user-phonenumber to t-user-phonenumber
           move wc-user-username to t-user-username
           move wc-user-password to t-user-password
           move wn-user-usertype-id to t-user-usertype-id
           move wn-user-program-id to t-user-program-id

           EXEC SQL
               INSERT INTO tbl_users
               VALUES (:t-user-id, :t-user-firstname,
                       :t-user-lastname, :t-user-email,
                       :t-user-phonenumber, :t-user-username,
                       :t-user-password, :t-user-lastlogin,
                       :t-user-usertype-id, :t-user-program-id)
           END-EXEC

           IF  sqlcode not = zero
                perform Z0100-error-routine
           ELSE
                perform B0240-commit-work
                move 'användare adderad' to wc-printscr-string
                call 'ok-printscr' using wc-printscr-string
           END-IF

        .

       *>**************************************************
       B0240-commit-work.

           *>  commit work permanently
           EXEC SQL
               COMMIT WORK
           END-EXEC
        .

       *>**************************************************
       C0100-closedown.

          *> call 'wui-end-html' using wn-rtn-code

        .

       *>**************************************************
       Z0100-error-routine.

           *> requires the ending dot (and no extension)!
           copy z0100-error-routine.

       .

       *>**************************************************
       Z0200-disconnect.

           EXEC SQL
               DISCONNECT ALL
           END-EXEC

        .
