## OpenCobol System Development Setup

### Directory Structure

bekr@dell:~/openjensen (master)$ tree -L 1
bekr@dell:~/openjensen (master)$ tree -L 2 -d
.
├── build
│   ├── lib
│   └── src
├── doc
├── html
│   ├── backup
│   └── tmp
├── lib
│   ├── copy
│   └── tmp
├── sql
├── src
│   ├── copy
│   └── tmp
└── tools


### Exports of environment variables

Ensure that your bashrc have exports like so:

bekr@dell:~/openjensen/src (master)$ env | grep LD_LIB
LD_LIBRARY_PATH=/usr/local/lib
bekr@dell:~/openjensen/src (master)$ env | grep COB
COB_LIBRARY_PATH=../lib

1. The first is required for the pre-complier to find its library,
(since it is istalled in /usr/local/lib, and not system
default /usr/lib)

2. The second is required for any callable subroutines we create
and which we use CALL statements in our program. These are installed
in a paralell directory to the source directory.(../lib) seen from
the source directory when we build our source.

Set environment path for Copy books. E.g. that include 'sqlca.cbl'
for SQL pre-processor and other Cobol cpy-book code.
Move Copy-files in a sub directory directory to source-files.

In the make file (we have a make file in every directory).
$(COPYDIR) is the directory name were copybook are (e.g. 'copy')

export COBCPY=$(shell pwd)/$(COPYDIR)


### Run-time environment on server

To avoid path-problems, all binaries are in the same directory,
i.e. all *.cgi and all *.so files are in the /cgi-bin directory.

For the OCESQL library, export the environment like so:

    'LD_LIBRARY_PATH=/usr/local/bin
    
OpenCobol is installed (by debian) in the system library directory
(/usr/lib), thus nothing needs to be setup here.



