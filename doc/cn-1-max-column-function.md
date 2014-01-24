## Cobol System Development Notes (CN #1)

### Task: find a unique lokal_id to add a new row to table T_JLOKAL

First idea (not working) is to use column function (MAX). Alternative
use COUNT(*) but that have other issue when removing numbers in between.
(General about Cobol column functions, see pp. 168-169 DB2/Cobol).

### Sample Code (not working):

```
EXEC SQL 
    SELECT MAX(:jlokal-lokal-id)
        INTO :jlokal-lokal-id
        FROM T_JLOKAL
END-EXEC

IF  SQLCODE NOT = ZERO
     PERFORM Z0100-error-routine
ELSE
    SET is-valid-table-position TO TRUE
    *> next row in table
    COMPUTE wn-lokal-id = jlokal-lokal-id + 1             
END-IF

DISPLAY '<br> -- Found jlokal-lokal-id is: ' jlokal-lokal-id
DISPLAY '<br> -- New lokal-id is: ' wn-lokal-id
```

This is the table T_JLOKAL

```           
 lokal_id | lokalnamn      | vaningsplan | maxdeltagare               
----------+----------------+-------------+----------------
        1 | S41            | 4           | 35                                      
        3 | LIA 1          |             | 
        4 | Examensarbete  |             | 
        5 | X99            | 9           |                                         
        2 | S02            |             | 40
```

Above code snippet will not work, jlokal-lokal-id is '2' after this completed run,
wn-lokal-id will be '3' which in turn will violate duplicate key ('3' alraedy exist)!

Reason above code doesn't work, is that jlokal-lokal-id is overwritten 5 times,
and that last value in table happens to be '2' which MAX moves into the variable.

### Solution:

Use cursor to retrieve table, and order by lokal_id (descending). Fetch
the first row which have the highest unique lokal_id. Add 1 to this value
for the new row id. Sorting simplifies, with a fetch required only once.

### Working code:

```
*> Cursor for T_JLOKAL
EXEC SQL
  DECLARE cursaddid CURSOR FOR
      SELECT Lokal_id
      FROM T_JLOKAL
      ORDER BY Lokal_id DESC
END-EXEC   

*> Open the cursor
EXEC SQL
     OPEN cursaddid
END-EXEC

*> fetch first row (which now have the highest id)
EXEC SQL
    FETCH cursaddid
        INTO :jlokal-lokal-id
END-EXEC       

IF  SQLCODE NOT = ZERO
     PERFORM Z0100-error-routine
ELSE
    SET is-valid-table-position TO TRUE
    *> next number for new row in table
    COMPUTE wn-lokal-id = jlokal-lokal-id + 1             
END-IF

*> close cursor
EXEC SQL 
    CLOSE cursaddid 
END-EXEC
```
