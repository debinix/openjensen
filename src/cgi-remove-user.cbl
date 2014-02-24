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
           COPY setupenv_openjensen.

           PERFORM a0100-init

           IF is-valid-post AND is-valid-init

                PERFORM B0100-connect
                IF is-db-connected
                    PERFORM B0200-cgi-delete-row
                END-IF

           END-IF

           PERFORM c0100-closedown

           goback
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

               SET is-valid-init TO true

               *> cgi post: remove row by local-id
               MOVE ZERO TO wn-rtn-code
               MOVE SPACE TO wc-post-VALUE
               MOVE 'user_id' TO wc-post-name
               CALL 'get-post-value' USING wn-rtn-code
                                           wc-post-name wc-post-value
               *> convert to number (space --> 0)
               MOVE function numval(wc-post-value) TO wn-user-id

           END-IF

           IF wn-user-id = 0
                MOVE 'Saknar användarens identifikation'
                    TO wc-printscr-string
                CALL 'stop-printscr' USING wc-printscr-string
           ELSE
                SET is-valid-post TO true
           END-IF

        .

       *>**************************************************
       B0100-connect.

           *>  connect
           MOVE  "openjensen"    TO   wc-database
           MOVE  "jensen"        TO   wc-username
           MOVE  SPACE        TO   wc-passwd

           EXEC SQL
               CONNECT :wc-username IDENTIFIED BY :wc-passwd
                                            USING :wc-database
           END-EXEC

           IF  SQLSTATE NOT = ZERO
                PERFORM Z0100-error-routine
           ELSE
                SET is-db-connected TO true
           END-IF

        .

       *>**************************************************
       B0200-cgi-delete-row.

           *> delete based on user_id
           IF wn-user-id NOT = 0

                *> the selected row to be removed
                MOVE wn-user-id TO t-user-id

                PERFORM B0210-is-id-found

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

                IF  sqlstate = ZERO
                    MOVE 'Användaren bortagen'
                    TO wc-printscr-string
                    CALL 'ok-printscr' USING wc-printscr-string
                ELSE
                    PERFORM Z0100-error-routine
                END-IF

           END-IF

           PERFORM B0300-commit-work

           PERFORM B0310-disconnect

        .

       *>**************************************************
       B0210-is-id-found.

           *> cursor for tbl_user
           EXEC SQL
             DECLARE curs1 CURSOR FOR
                 SELECT user_id
                 FROM tbl_user
                     WHERE user_id = :t-user-id
           END-EXEC

           *> open the cursor
           EXEC SQL
                OPEN curs1
           END-EXEC

           *> try a fetch
           EXEC SQL
               FETCH curs1
                   INTO :wn-user-id
           END-EXEC
            
           EXEC SQL
                CLOSE cur1
           END-EXEC
           
           IF SQLSTATE = ZERO
               SET is-id-found TO true
           END-IF

        .

       *>**************************************************
       B0300-commit-work.

           *>  commit work permanently
           EXEC SQL
               COMMIT WORK
           END-EXEC
        .

       *>**************************************************
       B0310-disconnect.

           *>  disconnect
           EXEC SQL
               DISCONNECT ALL
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
