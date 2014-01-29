#
# Project: openjensen 
# 
# Enter one of the following commands 
#
#  make, all, build		  Copy PHP files to LOCAL build directory
#
#  make clean, cleanall   Erases all PHP files in build directory
#
#  make install           Replace PHP files on REMOTE hosts directory
#                         (i.e. php) and runs make & make install.
#                         Requires script on remote host, and SSH key on host.
#
#############################################################################
#
#	VARIABLES & COMMANDS
#
#############################################################################

QUIET = @

CP := /bin/cp
ECHO := /bin/echo
CHOWN := /bin/chown
RMDIR := /bin/rm -f

SSH := /usr/bin/ssh
SCP := /usr/bin/scp

#############################################################################
#
#	MAKE ALL, MAKE BUILD (PHP)
#
#############################################################################

all build:
	$(QUIET) $(ECHO) [makefile]: Copy PHP files to build directory
	$(QUIET) - $(CP) *.php ../build/.
	$(QUIET) $(ECHO) [makefile]: Change ownership of PHP files 
	$(QUIET) - $(CHOWN) bekr:bekr ../build/*.php


#############################################################################
#
#	MAKE CLEAN, MAKE CLEANALL (PHP files in build directory)
#
#############################################################################

clean: cleanall

cleanall:
	$(QUIET) $(ECHO) [makefile]: Remove any PHP files in build directory
	$(QUIET) $(RMDIR) ../build/*.php


.PHONY: all build clean cleanall
