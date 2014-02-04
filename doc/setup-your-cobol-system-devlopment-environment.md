## OpenCobol System Development Setup


Create the base for the <user>-project directory:

```
$ mkdir /home/<user>/openjensen
```

### Exports of required environment variables

Ensure that <user> ~/.bashrc have exports like so:

```
LD_LIBRARY_PATH=/usr/local/lib
COB_LIBRARY_PATH=/home/<user>/openjensen/lib
```

Confirm with:

```
$ env | grep LD_LIBRARY_PATH
$ env | grep COB
```

1. The first is required for the pre-complier to find its library,
(since this is a source-install which defaults to /usr/local/lib)

2. The second is required for any sub-routines we create
and which we use Cobol CALL statements in our program. These are
installed in a paralell directory (../lib) to the source directory.

### Copybooks

Set the environment path for Copy books. Example include is the 'sqlca.cbl'
for the SQL pre-processor and other Cobol cpy-book code.
Copy-files are located in its own paralell directory.

Set in the .bashrc file:

```
export COBCPY=../copy
```

caveat: The OCESQL library expects copybooks to have  *.cbl as extension.
Our policy is to use extension *.cpy for all copybooks. To solve this
a symbolic link, points to *sqlca.cbl* from *sqlca.cpy*.


### Run-time environment on production server

To avoid environment problems, all binaries are placed the same directory,
i.e. the *.cgi and *.so files are in the /cgi-bin directory on server.

The OCESQL library, export the environment like so:

```
LD_LIBRARY_PATH=/usr/local/bin
```
    
OpenCobol is installed (by debian) in the system library directory
(/usr/lib), thus nothing needs to be setup here for run-time.

