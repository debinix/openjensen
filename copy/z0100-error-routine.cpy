        *>   
        *> Copybook z0100-error-routine.cpy
        *> Put in the /copy directory.
        *>
           DISPLAY "<br>*** SQL ERROR ***".
           DISPLAY "<br>*** Felstatus (SQLSTATE): " SQLSTATE.
           
           EVALUATE SQLSTATE
              WHEN  "02000"
                 DISPLAY "<br>*** Data återfinns ej i databasen."
              WHEN  "08003"
              WHEN  "08001"
                 DISPLAY "<br>*** Anslutning till databas misslyckades."
              WHEN  "23503"
                 DISPLAY "<br>*** Kan ej ta bort data - pga beroenden."               
              WHEN  SPACE
                 DISPLAY "<br>*** Obekant fel!"
              WHEN  OTHER
                 DISPLAY "<br>Felkod (SQLCODE): "   SQLCODE
                 DISPLAY "<br>Felmeddelande (SQLERRMC): "  SQLERRMC
           END-EVALUATE
           