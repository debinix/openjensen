       *>**************************************************
       *> Author:  Peter Brink
       *> Purpose: Add a user to the database.
       *> Created: 2014-02-12
       *> Revisions:
       *>       0.1: Initial revision.
       *>**************************************************
       IDENTIFICATION DIVISION.
       program-id. cgi-edit-user.
       *>**************************************************
       DATA DIVISION.
       *>**************************************************
       working-storage section.
       *>**************************************************
       01   switches-edit.
            03  is-db-connected-switch              PIC X  VALUE 'N'.
                88  is-db-connected                        VALUE 'Y'.
            03  is-valid-init-switch                PIC X  VALUE 'N'.
                88  is-valid-init                          VALUE 'Y'.
            03  is-id-in-table-switch               PIC X  VALUE 'N'.
                88  is-id-in-table                         VALUE 'Y'.

       *> used in calls to dynamic libraries
       01  wn-rtn-code             PIC  S99   VALUE ZERO.
       01  wc-post-name            PIC X(40)  VALUE SPACE.
       01  wc-post-value           PIC X(40)  VALUE SPACE.

       *> always - used in error routine
       01  wc-printscr-string      PIC X(40)  VALUE SPACE.

       01  wc-pagetitle        PIC X(20) VALUE 'Uppdatera användare'.

       EXEC SQL BEGIN DECLARE SECTION END-EXEC.
       01  wc-database              PIC  X(30).
       01  wc-passwd                PIC  X(10).
       01  wc-username              PIC  X(30).
       EXEC SQL END DECLARE SECTION END-EXEC.

       *>#######################################################
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
             05  t-user-program-id     PIC  9(9) VALUE ZERO.
       EXEC SQL END DECLARE SECTION END-EXEC.

       01  wr-users-rec-vars.
             05  wn-user-id            PIC  9(4) VALUE ZERO.
             05  wc-user-firstname     PIC  X(40) VALUE SPACE.
             05  wc-user-lastname      PIC  X(40) VALUE SPACE.
             05  wc-user-email         PIC  X(40) VALUE SPACE.
             05  wc-user-phonenumber   PIC  X(40) VALUE SPACE.
             05  wc-user-username      PIC  X(40) VALUE SPACE.
             05  wc-user-password      PIC  X(40) VALUE SPACE.
             05  wc-user-lastlogin     PIC  X(40) VALUE SPACE.
             05  wn-user-program-id    PIC  9(9) VALUE ZERO.
       *>#######################################################

       *> temporary table holding existing data
       01  wr-cur-rec-vars.
             05  wn-cur-user-id           PIC  9(4) VALUE ZERO.
             05  wc-cur-user-firstname    PIC  X(40) VALUE SPACE.
             05  wc-cur-user-lastname     PIC  X(40) VALUE SPACE.
             05  wc-cur-user-email        PIC  X(40) VALUE SPACE.
             05  wc-cur-user-phonenumber  PIC  X(40) VALUE SPACE.
             05  wc-cur-user-username     PIC  X(40) VALUE SPACE.
             05  wc-cur-user-password     PIC  X(40) VALUE SPACE.
             05  wc-cur-user-lastlogin    PIC  X(40) VALUE SPACE.
             05  wn-cur-user-program-id   PIC  9(9) VALUE ZERO.

       EXEC SQL INCLUDE SQLCA END-EXEC.

       *>**************************************************
       PROCEDURE DIVISION.
       *>**************************************************
       0000-main.

           *> contains development environment settings for test
           COPY setupenv_openjensen.

           PERFORM A0100-init

           IF is-valid-init

                PERFORM B0100-connect
                IF is-db-connected

                    PERFORM B0200-edit-dataitem
                    PERFORM Z0200-disconnect

                END-IF
           END-IF

           PERFORM C0100-closedown

           GOBACK
           .

       *>**************************************************
       A0100-init.

           *> always send out the Content-Type before any other I/O
           CALL 'wui-print-header' USING wn-rtn-code
           *>  start html doc
           CALL 'wui-start-html' USING wc-pagetitle

           *> decompose and save current post string
           CALL 'write-post-string' USING wn-rtn-code

           IF wn-rtn-code = ZERO
                PERFORM A0110-init-edit-action
           END-IF

           .

       *>**************************************************
       A0110-init-edit-action.

           *> what row are we updating (local-id - required)
           MOVE ZERO TO wn-rtn-code
           MOVE SPACE TO wc-post-value
           MOVE 'user_id' TO wc-post-name
           CALL 'get-post-value' USING wn-rtn-code
                               wc-post-name wc-post-value

           MOVE FUNCTION NUMVAL(wc-post-value) TO wn-user-id

           IF wc-post-value = SPACE
               MOVE 'Saknar ett angivet användar id'
                    TO wc-printscr-string
               CALL 'stop-printscr' USING wc-printscr-string
           ELSE
               *> *** Get the post values ***
               MOVE ZERO TO wn-rtn-code
               MOVE SPACE TO wc-post-value
               MOVE 'firstname' TO wc-post-name
               CALL 'get-post-value'
                    USING wn-rtn-code wc-post-name wc-post-value

               IF wn-rtn-code = ZERO
                   MOVE wc-post-value TO wc-user-firstname
                   SET is-valid-init TO true
               END-IF

               MOVE ZERO TO wn-rtn-code
               MOVE SPACE TO wc-post-value
               MOVE 'lastname' TO wc-post-name
               CALL 'get-post-value'
                    USING wn-rtn-code wc-post-name wc-post-value

               IF wn-rtn-code = ZERO
                   MOVE wc-post-value TO wc-user-lastname
                   SET is-valid-init TO true
               END-IF

               MOVE ZERO TO wn-rtn-code
               MOVE SPACE TO wc-post-value
               MOVE 'email' TO wc-post-name
               CALL 'get-post-value'
                    USING wn-rtn-code wc-post-name wc-post-value

               IF wn-rtn-code = ZERO
                   MOVE wc-post-value TO wc-user-email
                   SET is-valid-init TO true
               END-IF

               MOVE ZERO TO wn-rtn-code
               MOVE SPACE TO wc-post-value
               MOVE 'phone' TO wc-post-name
               CALL 'get-post-value'
                    USING wn-rtn-code wc-post-name wc-post-value

               IF wn-rtn-code = ZERO
                   MOVE wc-post-value TO wc-user-phonenumber
                   SET is-valid-init TO true
               END-IF

               MOVE ZERO TO wn-rtn-code
               MOVE SPACE TO wc-post-value
               MOVE 'username' TO wc-post-name
               CALL 'get-post-value'
                    USING wn-rtn-code wc-post-name wc-post-value

               IF wn-rtn-code = ZERO
                   MOVE wc-post-value TO wc-user-username
                   SET is-valid-init TO true
               END-IF

               MOVE ZERO TO wn-rtn-code
               MOVE SPACE TO wc-post-value
               MOVE 'password' TO wc-post-name
               CALL 'get-post-value'
                    USING wn-rtn-code wc-post-name wc-post-value

               IF wn-rtn-code = ZERO
                   MOVE wc-post-value TO wc-user-password
                   SET is-valid-init TO true
               END-IF

               MOVE ZERO TO wn-rtn-code
               MOVE SPACE TO wc-post-value
               MOVE 'program' TO wc-post-name
               CALL 'get-post-value'
                    USING wn-rtn-code wc-post-name wc-post-value

               IF wn-rtn-code = ZERO
                   MOVE function numval(wc-post-value)
                        TO wn-user-program-id
                   SET is-valid-init TO true
               END-IF

           END-IF
           .

       *>**************************************************
       B0100-connect.

           *>  connect
           MOVE  "openjensen"    TO   wc-database
           MOVE  "jensen"        TO   wc-username
           MOVE  SPACE           TO   wc-passwd

           EXEC SQL
               CONNECT :wc-username IDENTIFIED BY :wc-passwd
                                            USING :wc-database
           END-EXEC

           IF  SQLSTATE NOT = ZERO
                PERFORM Z0100-error-routine
           ELSE
                SET is-db-connected TO TRUE
           END-IF

           .


       *>**************************************************
       B0200-edit-dataitem.

           PERFORM B0210-does-id-exist

           IF is-id-in-table
               PERFORM B0220-change-dataitem
           ELSE
               MOVE 'Denna användare finns ej'
                    TO wc-printscr-string
               CALL 'stop-printscr' USING wc-printscr-string
           END-IF

           .

       *>**************************************************
       B0210-does-id-exist.

           *> Search tbl_users
           EXEC SQL
            SELECT user_id,
                   user_firstname,
                   user_lastname,
                   user_email,
                   user_phonenumber,
                   user_username,
                   user_password,
                   user_program
             INTO :t-user-id,
                  :t-user-firstname,
                  :t-user-lastname,
                  :t-user-email,
                  :t-user-phonenumber,
                  :t-user-username,
                  :t-user-password,
                  :t-user-program-id
             FROM tbl_user
             WHERE user_id = :wn-user-id
           END-EXEC

           IF  SQLSTATE NOT = ZERO
                PERFORM Z0100-error-routine
           ELSE
                *> set flag if in table
                IF wn-user-id = t-user-id
                     SET is-id-in-table TO TRUE

                MOVE t-user-id TO wn-cur-user-id
                MOVE t-user-firstname TO wc-cur-user-firstname
                MOVE t-user-lastname TO wc-cur-user-lastname
                MOVE t-user-email TO wc-cur-user-email
                MOVE t-user-phonenumber TO wc-cur-user-phonenumber
                MOVE t-user-username TO wc-cur-user-username
                MOVE t-user-password TO wc-cur-user-password
                MOVE t-user-program-id TO wn-cur-user-program-id
           END-IF

           .

       *>**************************************************
       B0220-change-dataitem.

           *> change any value that is different from existing

           *> any changes to Lokalnamn?
           IF wc-user-firstname NOT = wc-cur-user-firstname
                MOVE wc-user-firstname TO t-user-firstname
           ELSE
                MOVE wc-cur-user-firstname TO t-user-firstname
           END-IF

           IF wc-user-lastname NOT = wc-cur-user-lastname
                MOVE wc-user-lastname TO t-user-lastname
           ELSE
                MOVE wc-cur-user-lastname TO t-user-lastname
           END-IF

           IF wc-user-email NOT = wc-cur-user-email
                MOVE wc-user-email TO t-user-email
           ELSE
                MOVE wc-cur-user-email TO t-user-email
           END-IF

           IF wc-user-phonenumber NOT = wc-cur-user-phonenumber
                MOVE wc-user-phonenumber TO t-user-phonenumber
           ELSE
                MOVE wc-cur-user-phonenumber TO t-user-phonenumber
           END-IF

           IF wc-user-username NOT = wc-cur-user-username
                MOVE wc-user-username TO t-user-username
           ELSE
                MOVE wc-cur-user-username TO t-user-username
           END-IF

           IF wc-user-password NOT = wc-cur-user-password
                MOVE wc-user-password TO t-user-password
           ELSE
                MOVE wc-cur-user-password TO t-user-password
           END-IF

           IF wn-user-program-id NOT = wn-cur-user-program-id
                MOVE wn-user-program-id TO t-user-program-id
           ELSE
                MOVE wn-cur-user-program-id TO t-user-program-id
           END-IF

           *> finally update table
           MOVE wn-user-id TO t-user-id
           EXEC SQL
               UPDATE tbl_user
                SET
                    user_firstname = :t-user-firstname,
                    user_lastname = :t-user-lastname,
                    user_email = :t-user-email,
                    user_phonenumber = :t-user-phonenumber,
                    user_username = :t-user-username,
                    user_password = :t-user-password,
                    user_program = :t-user-program-id
               WHERE user_id = :t-user-id
           END-EXEC

           IF  SQLCODE NOT = ZERO
                PERFORM Z0100-error-routine
           ELSE
                PERFORM B0230-commit-work
                MOVE 'Användaren ändrad' TO wc-printscr-string
                CALL 'ok-printscr' USING wc-printscr-string
           END-IF

           .

       *>**************************************************
       B0230-commit-work.

           *>  commit work permanently
           EXEC SQL
               COMMIT WORK
           END-EXEC
           .

       *>**************************************************
       C0100-closedown.

           CALL 'wui-end-html' USING wn-rtn-code

           .

       *>**************************************************
       Z0100-error-routine.

           *> requires the ending dot (and no extension)!
           COPY z0100-error-routine.

           .

       *>**************************************************
       Z0200-disconnect.

       *>  disconnect
           EXEC SQL
               DISCONNECT ALL
           END-EXEC

           .

       *>**************************************************
       *> END PROGRAM
