## mysql_select_db

mysql_select_db — Select a MySQL database


### Description

```php
bool mysql_select_db ( string $database_name
                                [, resource $link_identifier = NULL ] )
```

Sets the current active database on the server that's associated with the
specified link identifier.
Every subsequent call to mysql_query() will be made on the active database.

### Parameters

*database_name*

    The name of the database that is to be selected.

*link_identifier*

    The MySQL connection. If the link identifier is not specified, the last
    link opened by mysql_connect() is assumed. If no such link is found, it
    will try to create one as if mysql_connect() was called with no arguments.
    If no connection is found or established,
    an E_WARNING level error is generated.

### Return Values

Returns TRUE on success or FALSE on failure.

### Examples

Example #1 mysql_select_db() example

```
<?php

$link = mysql_connect('localhost', 'mysql_user', 'mysql_password');
if (!$link) {
    die('Not connected : ' . mysql_error());
}

// make foo the current db
$db_selected = mysql_select_db('foo', $link);
if (!$db_selected) {
    die ('Can\'t use foo : ' . mysql_error());
}
?>
```

### Notes

    Note:

    For backward compatibility, the following deprecated alias may be
    used: mysql_selectdb()

### References

[PHP manual: mysql_select_db](http://www.php.net/manual/en/function.mysql-select-db.php)

