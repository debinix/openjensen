## pg_connect


pg_connect — Open a PostgreSQL connection

### Description

```php
resource pg_connect ( string $connection_string [, int $connect_type ] )
```

pg_connect() opens a connection to a PostgreSQL database specified by
the connection_string.

If a second call is made to pg_connect() with the same connection_string
as an existing connection, the existing connection will be returned
unless you pass PGSQL_CONNECT_FORCE_NEW as connect_type.

The old syntax with multiple parameters $conn = pg_connect("host", "port",
                    "options", "tty", "dbname") has been deprecated.

### Parameters

*connection_string*

    The connection_string can be empty to use all default parameters,
    or it can contain one or more parameter settings separated by whitespace.
    Each parameter setting is in the form keyword = value. Spaces around
    the equal sign are optional. To write an empty value or a value
    containing spaces, surround it with single quotes, e.g.,
    keyword = 'a value'. Single quotes and backslashes within the value
    must be escaped with a backslash, i.e., \' and \\.

    The currently recognized parameter keywords are: host, hostaddr,
    port, dbname (defaults to value of user), user, password, connect_timeout,
    options, tty (ignored), sslmode, requiressl (deprecated in favor of
    sslmode), and service. Which of these arguments exist depends on your
    PostgreSQL version.

    The options parameter can be used to set command line parameters to be
    invoked by the server.

*connect_type*

    If PGSQL_CONNECT_FORCE_NEW is passed, then a new connection is created,
    even if the connection_string is identical to an existing connection.

### Return Values

PostgreSQL connection resource on success, FALSE on failure.

### Examples

Example #1 Using pg_connect()

```php
<?php
$dbconn = pg_connect("dbname=mary");
//connect to a database named "mary"

$dbconn2 = pg_connect("host=localhost port=5432 dbname=mary");
// connect to a database named "mary" on "localhost" at port "5432"

$dbconn3 = pg_connect("host=sheep port=5432 dbname=mary user=lamb
                                                        password=foo");
//connect to a database named "mary" on the host "sheep"
// with a username and password

$conn_string = "host=sheep port=5432 dbname=test user=lamb password=bar";
$dbconn4 = pg_connect($conn_string);
//connect to a database named "test" on the host "sheep"
// with a username and password

$dbconn5 = pg_connect("host=localhost options='--client_encoding=UTF8'");
//connect to a database on "localhost" and set the command line parameter
// which tells the encoding is in UTF-8
?>
```

### References

[PHP manual: pg_connect](http://www.php.net/manual/en/function.pg-connect.php)

Copyright © 2001-2014 The PHP Group