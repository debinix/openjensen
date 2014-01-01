## Project Open Jensen

### An exercise in COBOL, embedded SQL and CGI

This is the repository for a project with the objective to create a web application
based on COBOL and a relational database back-end.


### Version information

Debian Wheezy (a.k.a. Debian 7.x) - the Linux distribution

Linux 3.2.0-4-amd64 #1 SMP Debian 3.2.51-1 x86_64 GNU/Linux - kernel information

PostgreSQL 9.1.11 - the open relation database system

Open COBOL 1.1 (Now GnuCobol) - the COBOL complier

OCESQL 1.0.0 - the pre-processor for embedded SQL


### Installation of Debian

Install the COBOL compiler and the SQL pre-processor:

    # aptitude install open-cobol, postgresql, postgresql-client
    
The OCESQL pre-processor is downloaded from OSS Consortium site.
    
    http://www.osscons.jp/osscobol/download/addtools/

Click to the right 'Open COBOL ESQL v1.0.0' text and download the archive.
Then install with ./configure, make and make install.


### Komodo Edit or Komodo IDE.

An editor like Komodo Editor (free) will just work well for COBOL system
development. On the wishlist, COBOL syntax checks and vertical guide lines.

The project directory structure for COBOL system development:

    $ tree -a
    .
    openjensen/
    ├── build
    │   ├── lib
    │   │   ├── bkgetusername.so
    │   │   ├── bkincrementer.so
    │   │   └── bkjustdisplay.so
    │   └── src
    │       ├── bkcaller.cgi
    │       ├── bkconnect.cgi
    │       ├── bkhello.cgi
    │       └── bktort.cgi
    ├── .gitignore
    ├── lib
    │   ├── bkgetusername.cbl
    │   ├── bkincrementer.cbl
    │   ├── bkjustdisplay.cbl
    │   ├── copy
    │   │   └── sqlca.cpy
    │   └── makefile
    ├── LICENSE.txt
    ├── makefile
    ├── README.md
    └── src
        ├── bkcaller.cbl
        ├── bkconnect.cbl
        ├── bkgnucobol.cbl
        ├── bkhello.cbl
        ├── bktort.cbl
        ├── copy
        │   └── sqlca.cpy
        └── makefile



