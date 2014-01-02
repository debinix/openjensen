#
# Project: openjensen 
# 
# Enter one of the following commands 
#
#  make, all, build		  Copy HTML file to build directory
#
#  make clean, cleanall   Erases all HTML files in build directory
#
#############################################################################
#
#	VARIABLES
#
#############################################################################

QUIET = @

CP := /bin/cp
ECHO := /bin/echo
CHOWN := /bin/chown
RMDIR := /bin/rm -f

#############################################################################
#
#	MAKE ALL, MAKE BUILD
#
#############################################################################

all build:
	$(QUIET) $(ECHO) [makefile]: Copy files to build directory
	$(QUIET) - $(CP) *.html ../build/.
	$(QUIET) $(ECHO) [makefile]: Change ownership of HTML files 
	$(QUIET) - $(CHOWN) bekr:bekr ../build/*.html

#############################################################################
#
#	MAKE CLEAN, MAKE CLEANALL
#
#############################################################################

clean: cleanall

cleanall:
	$(QUIET) $(ECHO) [makefile]: Remove any html files in build directory
	$(QUIET) $(RMDIR) ../build/*.html

.PHONY: all build clean cleanall
