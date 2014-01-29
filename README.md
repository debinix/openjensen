## Project Open Jensen

### An exercise in COBOL, embedded SQL, CGI and application integration

This is the repository for a project with the objective to create a web application
based on COBOL, a relational database back-end and a mix of some front-end php.


### Version information

Debian Wheezy (a.k.a. Debian 7.x) - the Linux distribution

Linux 3.2.0-4-amd64 #1 SMP Debian 3.2.51-1 x86_64 GNU/Linux - kernel information

PostgreSQL 9.1.11 - PostgreSQL open relational database manager

Open COBOL 1.1 (Now GnuCobol) - the COBOL compiler

OCESQL 1.0.0 - the pre-processor for embedded SQL

Apache/2.2.22 (Debian) - the web server


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

The project directory structure for COBOL system development:
```
$ tree -a -L 2
.
├── build
│   ├── bin
│   └── lib
├── copy
│   ├── sqlca.cpy
│   └── z0100-error-routine.cpy
├── doc
│   └── setup-your-cobol-system-development-environment.md
├── html
│   ├── arrows.png
│   ├── index.html
│   ├── jquery-1.7.1.min.js
│   ├── makefile
│   ├── wui-add-local.html
│   ├── wui-edit-local.html
│   ├── wui-list-local.html
│   ├── wui-menu.html
│   └── wui-remove-local.html
├── lib
│   ├── error-printscr.cbl
│   ├── get-post-value.cbl
│   ├── makefile
│   ├── ok-printscr.cbl
│   ├── stop-printscr.cbl
│   ├── write-post-string.cbl
│   ├── wui-end-html.cbl
│   ├── wui-print-header.cbl
│   └── wui-start-html.cbl
├── LICENSE.txt
├── makefile
├── php
│   └── phpversion.php
├── README.md
├── src
│   ├── cgi-add-local.cbl
│   ├── cgi-edit-local.cbl
│   ├── cgi-list-local.cbl
│   ├── cgi-remove-local.cbl
│   └── makefile
├── t
│   └── test-tjlocal.t
└── tools
```

### Non Linux Installation

IBM offer DB2 Express-C for Linux, Unix and Windows (LUW) which
inludes both the DB2 SQL relational database manager as well
as the required SQL pre-processor. Some limitation apply, which above
solution does not have otherwise it is *free to develop, free to deploy,
free to distribute*. This path have not been explored in depth, though.
