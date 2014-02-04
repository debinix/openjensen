## pg_fetch_assoc

pg_fetch_assoc — Fetch a row as an associative array

### Description

```php
array pg_fetch_assoc ( resource $result [, int $row ] )
```

pg_fetch_assoc() returns an associative array that corresponds to the
fetched row (records).

pg_fetch_assoc() is equivalent to calling pg_fetch_array() with PGSQL_ASSOC
as the optional third parameter. It only returns an associative array.
If you need the numeric indices, use pg_fetch_row().

    Note: This function sets NULL fields to the PHP NULL value.

pg_fetch_assoc() is NOT significantly slower than using pg_fetch_row(),
and is significantly easier to use.

### Parameters

*result*

    PostgreSQL query result resource, returned by pg_query(),
    pg_query_params() or pg_execute() (among others).

*row*

    Row number in result to fetch. Rows are numbered from 0 upwards.
    If omitted or NULL, the next row is fetched.

### Return Values

An array indexed associatively (by field name). Each value in the array is
represented as a string. Database NULL values are returned as NULL.

FALSE is returned if row exceeds the number of rows in the set, there are
no more rows, or on any other error.

### Changelog

Version 	Description
4.1.0 	The parameter row became optional.

### Examples

Example #1 pg_fetch_assoc() example

```php
<?php 
$conn = pg_connect("dbname=publisher");
if (!$conn) {
  echo "An error occurred.\n";
  exit;
}

$result = pg_query($conn, "SELECT id, author, email FROM authors");
if (!$result) {
  echo "An error occurred.\n";
  exit;
}

while ($row = pg_fetch_assoc($result)) {
  echo $row['id'];
  echo $row['author'];
  echo $row['email'];
}
?>
```

### References

[PHP manual: pg_fetch_assoc](http://www.php.net/manual/en/function.pg-fetch-assoc.php)

Copyright © 2001-2014 The PHP Group