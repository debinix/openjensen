## pg_query


pg_query — Execute a query

### Description

```php
resource pg_query ([ resource $connection ], string $query )
```

pg_query() executes the query on the specified database connection.
pg_query_params() should be preferred in most cases.

If an error occurs, and FALSE is returned, details of the error can be
retrieved using the pg_last_error() function if the connection is valid.

    Note: Although connection can be omitted, it is not recommended,
    since it can be the cause of hard to find bugs in scripts. 

### Parameters

*connection*

    PostgreSQL database connection resource. When connection is not present,
    the default connection is used. The default connection is the last
    connection made by pg_connect() or pg_pconnect().

*query*

    The SQL statement or statements to be executed. When multiple statements
    are passed to the function, they are automatically executed as one
    transaction, unless there are explicit BEGIN/COMMIT commands included
    in the query string. However, using multiple transactions in one function
    call is not recommended.
    
    **Warning**

    String interpolation of user-supplied data is extremely dangerous and is
    likely to lead to SQL injection vulnerabilities. In most cases
    pg_query_params() should be preferred, passing user-supplied values as
    parameters rather than substituting them into the query string.

    Any user-supplied data substituted directly into a query string should
    be properly escaped.

### Return Values

A query result resource on success or FALSE on failure.

### Examples

Example #1 pg_query() example

```php
<?php

$conn = pg_pconnect("dbname=publisher");
if (!$conn) {
  echo "An error occurred.\n";
  exit;
}

$result = pg_query($conn, "SELECT author, email FROM authors");
if (!$result) {
  echo "An error occurred.\n";
  exit;
}

while ($row = pg_fetch_row($result)) {
  echo "Author: $row[0]  E-mail: $row[1]";
  echo "<br />\n";
}
 
?>
```

Example #2 Using pg_query() with multiple statements

```php
<?php

$conn = pg_pconnect("dbname=publisher");

// these statements will be executed as one transaction

$query = "UPDATE authors SET author=UPPER(author) WHERE id=1;";
$query .= "UPDATE authors SET author=LOWER(author) WHERE id=2;";
$query .= "UPDATE authors SET author=NULL WHERE id=3;";

pg_query($conn, $query);

?>
```

### References

[PHP manual: pg_query](http://www.php.net/manual/en/function.pg-query.php)

Copyright © 2001-2014 The PHP Group