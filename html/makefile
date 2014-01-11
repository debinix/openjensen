#
# Project: openjensen 
# 
# Enter one of the following commands 
#
#  make, all, build		  Copy HTML, PNG and JS files to LOCAL build directory
#
#  make clean, cleanall   Erases all HTML, PNG and JS files in build directory
#
#  make install           Replace HTML, PNG, and JS files on REMOTE hosts
#                         directory (i.e. html) and runs make & make install.
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
#	MAKE ALL, MAKE BUILD (HTML, PNG and JS)
#
#############################################################################

all build:
	$(QUIET) $(ECHO) [makefile]: Copy HTML files to build directory
	$(QUIET) - $(CP) *.html ../build/.
	$(QUIET) $(ECHO) [makefile]: Change ownership of HTML files 
	$(QUIET) - $(CHOWN) bekr:bekr ../build/*.html
#
	$(QUIET) $(ECHO) [makefile]: Copy PNG files to build directory
	$(QUIET) - $(CP) *.png ../build/.
	$(QUIET) $(ECHO) [makefile]: Change ownership of PNG files 
	$(QUIET) - $(CHOWN) bekr:bekr ../build/*.png
#
	$(QUIET) $(ECHO) [makefile]: Copy JS files to build directory
	$(QUIET) - $(CP) *.js ../build/.
	$(QUIET) $(ECHO) [makefile]: Change ownership of JS files 
	$(QUIET) - $(CHOWN) bekr:bekr ../build/*.js

#############################################################################
#
#	MAKE CLEAN, MAKE CLEANALL (HTML, PNG and JS in build directory)
#
#############################################################################

clean: cleanall

cleanall:
	$(QUIET) $(ECHO) [makefile]: Remove any HTML files in build directory
	$(QUIET) $(RMDIR) ../build/*.html
#
	$(QUIET) $(ECHO) [makefile]: Remove any PNG files in build directory
	$(QUIET) $(RMDIR) ../build/*.png
#
	$(QUIET) $(ECHO) [makefile]: Remove any JS files in build directory
	$(QUIET) $(RMDIR) ../build/*.js

.PHONY: all build clean cleanall
