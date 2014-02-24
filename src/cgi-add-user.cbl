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

       01  wc-pagetitle   PIC X(25) VALUE 'Lägg till användare'.

       EXEC SQL BEGIN DECLARE SECTION END-EXEC.
       01  wc-database              PIC  X(30).
       01  wc-passwd                PIC  X(10).
       01  wc-username              PIC  X(30).
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

       01  wr-rec-vars.
             05  wn-user-id           PIC  9(4) VALUE ZERO.
             05  wc-firstname         PIC  x(40) VALUE SPACE.
             05  wc-lastname          PIC  x(40) VALUE SPACE.
             05  wc-user-email        PIC  x(40) VALUE SPACE.
             05  wc-user-phonenumber  PIC  x(40) VALUE SPACE.
             05  wc-user-username     PIC  x(40) VALUE SPACE.
             05  wc-user-password     PIC  x(40) VALUE SPACE.
             05  wn-user-usertype-id  PIC  9(4) VALUE ZERO.
             05  wn-user-program-id   PIC  9(4) VALUE ZERO.

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

                    PERFORM B0200-add-dataitem
                    PERFORM Z0200-disconnect

                END-IF

           END-IF

           PERFORM C0100-closedown

           GOBACK
        .
       *>**************************************************
       A0100-init.

           *> always send out the content-type before any other i/o
           CALL 'wui-print-header' USING wn-rtn-code
           *>  start html doc
           CALL 'wui-start-html' USING wc-pagetitle

           *> decompose and save current post string
           CALL 'write-post-string' USING wn-rtn-code

           IF wn-rtn-code = ZERO
               PERFORM A0110-init-add-action
           END-IF

        .
       *>**************************************************
       A0110-init-add-action.

           MOVE ZERO TO wn-rtn-code
           MOVE SPACE TO wc-post-value
           MOVE 'firstname' TO wc-post-name
           CALL 'get-post-value' USING wn-rtn-code
                                       wc-post-name wc-post-value

           IF wn-rtn-code = ZERO
               MOVE wc-post-value TO wc-firstname
               SET is-valid-init TO TRUE
           END-IF

           MOVE ZERO TO wn-rtn-code
           MOVE SPACE TO wc-post-value
           MOVE 'lastname' TO wc-post-name
           CALL 'get-post-value' USING wn-rtn-code
                                       wc-post-name wc-post-value

           IF wn-rtn-code = ZERO
               MOVE wc-post-value TO wc-lastname
               SET is-valid-init TO true
           END-IF

           MOVE ZERO TO wn-rtn-code
           MOVE SPACE TO wc-post-value
           MOVE 'email' TO wc-post-name
           CALL 'get-post-value' USING wn-rtn-code
                                       wc-post-name wc-post-value

           IF wn-rtn-code = ZERO
               MOVE wc-post-value TO wc-user-email
               SET is-valid-init TO true
           END-IF

           MOVE ZERO TO wn-rtn-code
           MOVE SPACE TO wc-post-value
           MOVE 'phone' TO wc-post-name
           CALL 'get-post-value' USING wn-rtn-code
                                       wc-post-name wc-post-value

           IF wn-rtn-code = ZERO
               MOVE wc-post-value TO wc-user-phonenumber
               SET is-valid-init TO true
           END-IF

           MOVE ZERO TO wn-rtn-code
           MOVE SPACE TO wc-post-value
           MOVE 'username' TO wc-post-name
           CALL 'get-post-value' USING wn-rtn-code
                                       wc-post-name wc-post-value

           IF wn-rtn-code = ZERO
               MOVE wc-post-value TO wc-user-username
               SET is-valid-init TO true
           END-IF

           MOVE ZERO TO wn-rtn-code
           MOVE SPACE TO wc-post-value
           MOVE 'password' TO wc-post-name
           CALL 'get-post-value' USING wn-rtn-code
                                       wc-post-name wc-post-value

           IF wn-rtn-code = ZERO
               MOVE wc-post-value TO wc-user-password
               SET is-valid-init TO true
           END-IF

           MOVE ZERO TO wn-rtn-code
           MOVE SPACE TO wc-post-value
           MOVE 'program' TO wc-post-name
           CALL 'get-post-value' USING wn-rtn-code
                                       wc-post-name wc-post-value

           IF wn-rtn-code = ZERO
               MOVE wc-post-value TO wn-user-program-id
               SET is-valid-init TO true
           END-IF

           MOVE ZERO TO wn-rtn-code
           MOVE SPACE TO wc-post-value
           MOVE 'usertype' TO wc-post-name
           CALL 'get-post-value' USING wn-rtn-code
                                       wc-post-name wc-post-value

           IF wn-rtn-code = ZERO
               MOVE wc-post-value TO wn-user-usertype-id
               SET is-valid-init TO true
           END-IF
       .
       *>**************************************************
       B0100-connect.

           *>  connect
           MOVE  "openjensen"    TO   wc-database
           MOVE  "jensen"        TO   wc-username
           MOVE  SPACE           TO   wc-passwd

           EXEC SQL
               CONNECT :wc-username identified BY :wc-passwd
                                            USING :wc-database
           END-EXEC

           IF  SQLSTATE NOT = ZERO
                PERFORM Z0100-error-routine
           ELSE
                SET is-db-connected TO true
           END-IF
        .

       *>**************************************************
       B0200-add-dataitem.

           PERFORM B0210-does-username-exist

           IF not name-is-in-table
               PERFORM B0220-get-new-row-number

               IF is-valid-table-position
                   PERFORM B0230-add-dataitem-to-table
               END-IF
           ELSE
           MOVE 'det finns redan användare med detta användarnamn'
                    TO wc-printscr-string
               CALL 'stop-printscr' USING wc-printscr-string
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

           PERFORM UNTIL SQLCODE NOT = ZERO

               *> set flag if already in the table
               IF FUNCTION UPPER-CASE (wc-user-username) =
                  FUNCTION UPPER-CASE (t-user-username)
                        SET name-is-in-table TO true
               END-IF

              *> fetch next row
               EXEC SQL
                   FETCH cursadduser
                       INTO :t-user-id, :t-user-username
               END-EXEC

           END-PERFORM


           *> end of data
           IF  sqlstate not = '02000'
                PERFORM Z0100-error-routine
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

           IF  SQLCODE NOT = ZERO
                PERFORM Z0100-error-routine
           ELSE
               SET is-valid-table-position TO TRUE
               *> next number for new row in table
               COMPUTE wn-user-id  = t-user-id  + 1
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

           MOVE wn-user-id TO t-user-id
           MOVE wc-firstname TO t-user-firstname
           MOVE wc-lastname TO t-user-lastname
           MOVE wc-user-email TO t-user-email
           MOVE wc-user-phonenumber TO t-user-phonenumber
           MOVE wc-user-username TO t-user-username
           MOVE wc-user-password TO t-user-password
           MOVE wn-user-usertype-id TO t-user-usertype-id
           MOVE wn-user-program-id TO t-user-program-id

           EXEC SQL
               INSERT INTO tbl_user
               VALUES (:t-user-id, :t-user-firstname,
                       :t-user-lastname, :t-user-email,
                       :t-user-phonenumber, :t-user-username,
                       :t-user-password, :t-user-lastlogin,
                       :t-user-usertype-id, :t-user-program-id)
           END-EXEC

           IF  SQLCODE NOT = ZERO
                PERFORM Z0100-error-routine
           ELSE
                PERFORM B0240-commit-work
                MOVE 'användare adderad' TO wc-printscr-string
                CALL 'ok-printscr' USING wc-printscr-string
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

          CALL 'wui-end-html' USING wn-rtn-code

        .

       *>**************************************************
       Z0100-error-routine.

           *> requires the ending dot (and no extension)!
           COPY z0100-error-routine.

       .

       *>**************************************************
       Z0200-disconnect.

           EXEC SQL
               DISCONNECT ALL
           END-EXEC

        .
