## mysql_num_rows

mysql_num_rows — Get number of rows in result


### Description

```php
int mysql_num_rows ( resource $result )
```

Retrieves the number of rows from a result set. This command is only valid for statements like SELECT or SHOW that return an actual result set. To retrieve the number of rows affected by a INSERT, UPDATE, REPLACE or DELETE query, use mysql_affected_rows().

### Parameters

*result*

    The result resource that is being evaluated. This result comes from a call to mysql_query().

### Return Values

The number of rows in a result set on success or FALSE on failure.

### Examples

Example #1 mysql_num_rows() example

```php
<?php

$link = mysql_connect("localhost", "mysql_user", "mysql_password");
mysql_select_db("database", $link);

$result = mysql_query("SELECT * FROM table1", $link);
$num_rows = mysql_num_rows($result);

echo "$num_rows Rows\n";

?>
```

### Notes

    Note:

    If you use mysql_unbuffered_query(), mysql_num_rows() will not return the correct value until all the rows in the result set have been retrieved.

    Note:

    For backward compatibility, the following deprecated alias may be used: mysql_numrows()

### References

[PHP manual: mysql_num_rows](http://www.php.net/manual/en/function.mysql-num-rows.php)