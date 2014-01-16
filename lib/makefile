###########################################################
#
# Makefile for COBOL source files (*.cbl) with or without
# inline SQL EXEC statements using the OCESQL pre-processor.
#
# Output is a dynamic library with extension 'filename.so',
# ready to be called or directly run by 'cobcrun filename'
#
#  PROGRAM-ID.               makefile
#  AUTHOR.                   BK.
#  DATE-WRITTEN.             2013-12-30.
#
# Pre-requsites
#	- Open Cobol 1.1 or higher.
#	- OC ESQL 1.0 or higher.
#
# Following convention is used:
#
# *.cbl : COBOL source file with/without embedded SQL.
# *.cob : A COBOL SQL pre-processed file (*.cob).
#
# OCESQL library is used for pre-processing the  
# embedded SQL statements before the final compilation.
#
# Set Copybook location in bashrc (Includes e.g. 'sqlca.cbl'):
# export COBCPY=../copy
#
###########################################################

FIND := /usr/bin/find
ERASE := /bin/rm -f
CP := /bin/cp
ECHO := /bin/echo

# make variables

LDFLAG = -l
CFLAG = -m
QUIET = @
OCESQL = ocesql
COBC = cobc

# ----------------------------------------------------------
# targets - find all cbl source files in current directory
# Note: do not place any copy books in the current directory!
# ----------------------------------------------------------

SRCS = $(wildcard *.cbl)
TGTLIST = $(basename $(SRCS))


all : $(TGTLIST)

# Automatic variables (my memo)
# ------------------------------
#  $<   prerequsite full filename
#  $@   target filename


# Link cob and create load module
# -------------------------------
# This is what this target do for e.g. connect:
# ---------------------------------------------
# connect : connect.cob
#       cobc -x -o connect.cgi -l ocesql connect.cob
#
% : %.cob
	$(COBC) $(CFLAG) -o $@ $(LDFLAG) $(OCESQL) $<
    
    
# Pre-process SQL cbl-source, creates an intermediate *.cob file
# --------------------------------------------------------------
#
# Note: if input cbl-source doesn't contain any SQL EXEC, the
# input is parsed (without any action) and renamed to *.cob.
#
# This is what this target do for e.g. connect.
# ---------------------------------------------
# connect.cob : connect.cbl
#       ocesql connect.cbl connect.cob
%.cob : %.cbl
	$(OCESQL) $< $@


.PHONY : all clean cleanall build

clean :
	$(ERASE) *.cob

cleanall:
	$(ERASE) *.cob
	$(FIND) . -type f -perm /u=x -print0 | xargs -0 $(ERASE)

build:
	$(QUIET) $(ECHO) [makefile]: Copy any shared library files to build directory ../build/lib
	$(QUIET) - $(CP) *.so ../build/lib/.
