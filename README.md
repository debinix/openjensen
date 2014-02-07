## Project Open Jensen

### An exercise in COBOL, embedded SQL, CGI and application integration

This is the repository for a project with the objective to create a web application
based on COBOL, a relational database back-end and front-end based on php.

The [web application](http://mc-butter.se/index.php) can only be viewed
from school and from members IP addresses due to firewall settings.


### Version information

Debian Wheezy (a.k.a. Debian 7.x) - the Linux distribution

Linux 3.2.0-4-amd64 #1 SMP Debian 3.2.51-1 x86_64 GNU/Linux - kernel information

PostgreSQL 9.1.11 - PostgreSQL open relational database manager

Open COBOL 1.1 (Now GnuCobol) - the COBOL compiler

OCESQL 1.0.0 - the pre-processor for embedded SQL

Apache/2.2.22 (Debian) - the web server

PHP 5.4.4 - PHP: Hypertext Preprocessor


### Debian (Linux) Installation

Install the COBOL compiler and the SQL database:

    # aptitude install open-cobol, postgresql, postgresql-client
    
The OCESQL pre-processor is downloaded from OSS Consortium site.
    
    http://www.osscons.jp/osscobol/download/addtools/

Click to the right 'Open COBOL ESQL v1.0.0' text and download the archive.
Then install with ./configure, make and make install.


### Komodo Edit (free) or Komodo IDE.

An editor like Komodo Edit will just work fine for COBOL system
development. On the wishlist, add support for COBOL syntax checks.

The directory structure for the system development team, with some files:
```
.
├── build
│   ├── bin
│   └── lib
├── copy
│   ├── sqlca.cpy
├── doc
│   └── setup-your-cobol-system-development-environment.md
├── html
├── lib
│   ├── error-printscr.cbl
│   ├── get-post-value.cbl
│   ├── ok-printscr.cbl
│   ├── stop-printscr.cbl
│   └── write-post-string.cbl
├── php
│   └── assets
├── postgresql
│   ├── pg_openjensen_create_all_tables.sql
│   ├── pg_openjensen_create_database.sql
│   ├── pg_openjensen_drop_all.sql
│   └── pg_openjensen_insert_all_data.sql
├── src
│   ├── cgi-add-local.cbl
│   ├── cgi-edit-local.cbl
│   ├── cgi-list-local.cbl
│   └── cgi-remove-local.cbl
├── t
│   └── test-tjlocal.t
└── tools
```

### Alternatives to PostgreSQL/OCESQL (i.e. OpenCobol ESQL pre-processor)

IBM offers DB2 Express-C for Linux, Unix and Windows (LUW) which
inludes both the DB2 SQL relational database manager as well
the required SQL pre-processor. Some limitation apply, which above
solution does not have otherwise it is *free to develop, free to deploy,
free to distribute*. This path have not been explored in depth, though.
