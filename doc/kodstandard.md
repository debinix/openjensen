<big><b>Kodstandard för OpenJensen projektet</b></big>

<i><b>1.0	Programnamnsstandard</b></i>

Tre olika programtyper: CGI moduler, SQL moduler och webbgränssnittsmoduler.
Programnamnet kan vara upp till 32 tecken långt och bör vara så beskrivande som möjligt.
Det ska skrivas med små bokstäver. Standard suffixet ”cbl” ska användas.
CGI moduler ska ha prefixet ”cgi-”. SQL moduler ska ha prefixet ”sql-” och webbgränssnittsmoduler ska ha prefixet ”wui-”.

<i><b>2.0	Kodstandard</b></i>

Projektspråket är engelska. Man bör undvika att blanda svenska och engelska. Kommentarer och dyl. bör alltså skrivas på engelska.
De standard areor (A och B) och det standard tabulatoravstånd (4 tecken) som av hävd används vid kodning av COBOL kod ska användas.
Koden bör struktureras tydligt. Använd utkommenterade rader av separatortecken som skiljelinjer.
För uppdelning av kden används en rad av "*>*****************************************".

<b>2.1	Variabler</b>

Konstanter skrivs med stora bokstäver.
Globala variabler skrivs med stor bokstav i varje ord. Orden binds ihop med bindestreck.
Lokala variabler skrivs med småbokstäver.
För variabler i working storage används prefixet "wc" om det är ett alfanumeriskt fält och "wn" om det är ett numeriskt. För variabler i linkage section används på samma sätt "lc" respektive "ln".

<b>2.2	Procedurnamn</b>

Procedurerna grupperas i fem grupper:

    0: main/start
	A: initieringsprocedurer.
	B: Övriga bearbetningsprocedurer.
	C: avslutningsprocedurer.
	Z: ”utility” procedurer som används på flera ställen i koden.
	
<b>2.3	Procedurnummrering</b>

Procedurerna numreras med fyrställiga ordningsnummer. O000-Main är ingångsproceduren och den kör A0100-Init, B0100-XXXX och C0100-Exit.

<b>2.4	Nästlade subrutiner</b>

Nästlade subrutiner använder samma kodstandard som huvudprogram gör. Notera att alla variabler i en nästlad subrutin är lokala.



