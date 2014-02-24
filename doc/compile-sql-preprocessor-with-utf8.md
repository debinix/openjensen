## Set up OSS ESQL Cobol pre-processor with utf-8 character support

Open Cobol ESQL (ocesql) is an open-source Embedded SQL pre-compiler
and run-time library designed for COBOL applications which access 
an open-source database. Ocesql translates each EXEC SQL statements
into the standard COBOL CALL statements to the run-time library.

OSS objective is to provide support SJIS character encoding. This document
describes howto install the downloaded Cobol pre-processor on Debian Wheezy,
and optionally modify source to handle some utf8 encoding
combined with postgreSQl database. Note that this is experimental.

Ocesql is tested with several Cobol compilers e.g. OpenCOBOL 1.1 compiler.

    http://www.opencobol.org/

 
### Install the pre-processor (default install)

The OCESQL pre-processor is downloaded from OSS Consortium site.
    
    http://www.osscons.jp/osscobol/download/addtools/

If downloaded to ~/tmp, unpack archive with:

    $ tar -xzvf ocesql-1.0.0.tar.gz
    $ cd ocesql-1.0.0

Ensure that required debian packages are installed:

    $ apt-cache policy bison flex build-essential
    bison:
      Installed: 1:2.5.dfsg-2.1
      Candidate: 1:2.5.dfsg-2.1
      Version table:
     *** 1:2.5.dfsg-2.1 0
            999 http://ftp.us.debian.org/debian/ wheezy/main amd64 Packages
            100 /var/lib/dpkg/status
    flex:
      Installed: 2.5.35-10.1
      Candidate: 2.5.35-10.1
      Version table:
     *** 2.5.35-10.1 0
            999 http://ftp.us.debian.org/debian/ wheezy/main amd64 Packages
            100 /var/lib/dpkg/status
    build-essential:
      Installed: 11.5
      Candidate: 11.5
      Version table:
     *** 11.5 0
            999 http://ftp.us.debian.org/debian/ wheezy/main amd64 Packages
            100 /var/lib/dpkg/status
            
Install postgreSQL:

    $aptitude install postgresql postgresql-client

Read the README for ocesql and set up exports for usage with postgreSQL database,
find the right directories to export CPPFLAGS before ./configure:

    $ ls -l /usr/include/postgresql
    total 236
    drwxr-xr-x 3 root root  4096 Dec 23 22:04 9.1
    drwxr-xr-x 2 root root  4096 Dec 23 22:03 catalog
    -rw-r--r-- 1 root root 24402 Dec  5 06:39 c.h
    -rw-r--r-- 1 root root   714 Dec  5 06:39 ecpg_config.h
    -rw-r--r-- 1 root root  2540 Dec  5 06:39 ecpgerrno.h
    -rw-r--r-- 1 root root  2758 Dec  5 06:39 ecpg_informix.h
    -rw-r--r-- 1 root root  2601 Dec  5 06:39 ecpglib.h
    -rw-r--r-- 1 root root  2621 Dec  5 06:39 ecpgtype.h
    drwxr-xr-x 3 root root  4096 Dec 23 22:03 informix
    drwxr-xr-x 3 root root  4096 Dec 23 22:03 internal
    drwxr-xr-x 2 root root  4096 Dec 23 22:03 libpq
    -rw-r--r-- 1 root root  2211 Dec  5 06:39 libpq-events.h
    -rw-r--r-- 1 root root 20501 Dec  5 06:39 libpq-fe.h
    drwxr-xr-x 2 root root  4096 Dec 23 22:03 mb
    drwxr-xr-x 2 root root  4096 Dec 23 22:03 nodes
    -rw-r--r-- 1 root root 26779 Dec  5 06:39 pg_config.h
    -rw-r--r-- 1 root root  8037 Dec  5 06:39 pg_config_manual.h
    -rw-r--r-- 1 root root  1051 Dec  5 06:39 pg_config_os.h
    -rw-r--r-- 1 root root   290 Dec  5 06:39 pg_trace.h
    -rw-r--r-- 1 root root   754 Dec  5 06:39 pgtypes_date.h
    -rw-r--r-- 1 root root   530 Dec  5 06:39 pgtypes_error.h
    -rw-r--r-- 1 root root  1143 Dec  5 06:39 pgtypes_interval.h
    -rw-r--r-- 1 root root  2227 Dec  5 06:39 pgtypes_numeric.h
    -rw-r--r-- 1 root root   998 Dec  5 06:39 pgtypes_timestamp.h
    -rw-r--r-- 1 root root 14415 Dec  5 06:39 port.h
    -rw-r--r-- 1 root root  1778 Dec  5 06:39 postgres_ext.h
    -rw-r--r-- 1 root root   730 Dec  5 06:39 postgres_fe.h
    -rw-r--r-- 1 root root 20524 Dec  5 06:39 postgres.h
    -rw-r--r-- 1 root root   834 Dec  5 06:39 sql3types.h
    -rw-r--r-- 1 root root  1267 Dec  5 06:39 sqlca.h
    -rw-r--r-- 1 root root  1583 Dec  5 06:39 sqlda-compat.h
    -rw-r--r-- 1 root root   315 Dec  5 06:39 sqlda.h
    -rw-r--r-- 1 root root   820 Dec  5 06:39 sqlda-native.h
    drwxr-xr-x 2 root root  4096 Dec 23 22:03 utils

Export CPPFLAGS with:

    $ export CPPFLAGS=-I/usr/include/postgresql

Find the right directories to export LDFLAGS before ./configure:

    $ ls -l /usr/lib/postgresql/9.1/lib
    total 4172
    -rw-r--r-- 1 root root    6016 Dec  5 06:39 ascii_and_mic.so
    -rw-r--r-- 1 root root   14208 Dec  5 06:39 cyrillic_and_mic.so
    -rw-r--r-- 1 root root  333776 Dec  5 06:39 dict_snowball.so
    -rw-r--r-- 1 root root   10112 Dec  5 06:39 euc2004_sjis2004.so
    -rw-r--r-- 1 root root    6016 Dec  5 06:39 euc_cn_and_mic.so
    -rw-r--r-- 1 root root   14208 Dec  5 06:39 euc_jp_and_sjis.so
    -rw-r--r-- 1 root root    6016 Dec  5 06:39 euc_kr_and_mic.so
    -rw-r--r-- 1 root root   10784 Dec  5 06:39 euc_tw_and_big5.so
    -rw-r--r-- 1 root root   10120 Dec  5 06:39 latin2_and_win1250.so
    -rw-r--r-- 1 root root   10112 Dec  5 06:39 latin_and_mic.so
    -rw-r--r-- 1 root root   14208 Dec  5 06:39 libpqwalreceiver.so
    -rw-r--r-- 1 root root   10120 Dec  5 06:39 pg_upgrade_support.so
    drwxr-xr-x 4 root root    4096 Dec 23 22:04 pgxs
    -rw-r--r-- 1 root root  157640 Dec  5 06:39 plpgsql.so
    -rw-r--r-- 1 root root   26488 Dec  5 06:39 tsearch2.so
    -rw-r--r-- 1 root root    6016 Dec  5 06:39 utf8_and_ascii.so
    -rw-r--r-- 1 root root  225488 Dec  5 06:39 utf8_and_big5.so
    -rw-r--r-- 1 root root   10144 Dec  5 06:39 utf8_and_cyrillic.so
    -rw-r--r-- 1 root root  189576 Dec  5 06:39 utf8_and_euc2004.so
    -rw-r--r-- 1 root root  125184 Dec  5 06:39 utf8_and_euc_cn.so
    -rw-r--r-- 1 root root  217040 Dec  5 06:39 utf8_and_euc_jp.so
    -rw-r--r-- 1 root root  137680 Dec  5 06:39 utf8_and_euc_kr.so
    -rw-r--r-- 1 root root  336336 Dec  5 06:39 utf8_and_euc_tw.so
    -rw-r--r-- 1 root root 1019800 Dec  5 06:39 utf8_and_gb18030.so
    -rw-r--r-- 1 root root  354712 Dec  5 06:39 utf8_and_gbk.so
    -rw-r--r-- 1 root root    6024 Dec  5 06:39 utf8_and_iso8859_1.so
    -rw-r--r-- 1 root root   35496 Dec  5 06:39 utf8_and_iso8859.so
    -rw-r--r-- 1 root root  278848 Dec  5 06:39 utf8_and_johab.so
    -rw-r--r-- 1 root root  189064 Dec  5 06:39 utf8_and_sjis2004.so
    -rw-r--r-- 1 root root  127528 Dec  5 06:39 utf8_and_sjis.so
    -rw-r--r-- 1 root root  281856 Dec  5 06:39 utf8_and_uhc.so
    -rw-r--r-- 1 root root   31192 Dec  5 06:39 utf8_and_win.so

Set the export:

    $ export LDFLAGS=-L/usr/lib/postgresql/9.1/lib

### Configure, make and make check

Finally, run:

    $ ./configure
    $ make
    $ make check
    
To install switch to root and run:

    # make install
    
This installs the binary library to */usr/local*, unless configured different.
To have the application, at run time find the osesql library export:

    export LD_LIBRARY_PATH=/usr/local/lib
    
Ensure that ocesql find it library by a symbolic link like so:

    $ cd /usr/lib
    $ ln -s /usr/local/lib/libocesql.so.0.0.0 libocesql.so.0

To setup the development environment, see the document named:

    /doc/development-setup.md
    
Test your setup with the file in /tools directory. Copy to server /cgi-bin and
run direct from the command line:

    $ ./anslutdb.cgi
    
This file is hard coded to a specific database and table.


### Re-compile for UTF-8 character support

First check and the remove previous installation (as root):

    # ls -l libocesql*
    -rw-r--r-- 1 root staff 165658 Feb 20 09:40 libocesql.a
    -rwxr-xr-x 1 root staff    841 Feb 20 09:40 libocesql.la
    lrwxrwxrwx 1 root staff     18 Feb 20 09:40 libocesql.so -> libocesql.so.0.0.0
    lrwxrwxrwx 1 root staff     18 Feb 20 09:40 libocesql.so.0 -> libocesql.so.0.0.0
    -rwxr-xr-x 1 root staff 100904 Feb 20 09:40 libocesql.so.0.0.0

Now, remove the original non-utf8 installation with *rm libocesql* (backup first).
Remove also the symbolic link in */usr/lib* with:

    # rm /usr/lib/libocesql.so.0

Install the pre-processor as above, and unpack from the original archive to
have a new original source to work with. This time, we will patch one source file
before the usual ./configure, make, make test and make install as above.

The only single change required is to change one line in the c source file:

    ~/tmp/ocesql-1.0.0/dblib/ocesql.c
    
Open the file in a text editor , locate the *_ocesqlConnectMain()* routine.
It should be around row 149. In that file comment out and add a line as below:

	//char *cencoding = "SJIS";
	char *cencoding = "UTF8";
    
Save and close the editor and you are ready to recompile as above. With this
the pre-processor will accept utf-8 encoded characters. According to the developers
a new version will be released which in some way will have an option for this.
