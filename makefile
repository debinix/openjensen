#
# Project: openjensen 
# 
# Top Makefile (recurs down in source directories)
#

#############################################################################
#	 -- EXTERNAL SHELL VARIABLES
#############################################################################

QUIET = @

ECHO := /bin/echo
CP := /bin/cp
MKDIR := mkdir -p

TAR := /bin/tar
GZIP := /bin/gzip
RMDIR := /bin/rm -fr


#############################################################################
#	 -- INTERNAL VARIABLES
#############################################################################

GZIPOPT = -9 -c
TAROPT = chof -

package = openjensen
version = 0.$(shell date +%Y%m%d.%H%M)
tarname = $(package)
distdir = /home/bekr/$(tarname)-$(version)

#############################################################################
#	1 -- MAKE ALL, BUILD, DIST, CLEAN, CLEANALL
#############################################################################

all clean cleanall build:

	cd src && $(MAKE) $@
	cd lib && $(MAKE) $@
	cd html && $(MAKE) $@

dist: $(distdir).tar.gz


$(distdir).tar.gz : $(distdir)
	$(QUIET) - $(TAR) $(TAROPT) $(distdir) | $(GZIP) $(GZIPOPT) > $@
	$(QUIET) - $(RMDIR) $(distdir)
	$(QUIET) $(ECHO) [makefile]: Archive $(distdir).tar.gz created


$(distdir):
	$(QUIET) $(MKDIR) $(distdir)
	$(QUIET) - $(CP) makefile $(distdir)
#
	$(QUIET) $(MKDIR) $(distdir)/src
	$(QUIET) - $(CP) src/makefile $(distdir)/src/.
	$(QUIET) - $(CP) src/*.cbl $(distdir)/src/.
	
	$(QUIET) $(MKDIR) $(distdir)/src/copy
	$(QUIET) - $(CP) src/copy/*.cbl $(distdir)/src/copy/.	
	$(QUIET) - $(CP) src/copy/*.cpy $(distdir)/src/copy/.		
#
	$(QUIET) $(MKDIR) $(distdir)/lib
	$(QUIET) - $(CP) lib/makefile $(distdir)/lib/.
	$(QUIET) - $(CP) lib/*.cbl $(distdir)/lib/.
	
	$(QUIET) $(MKDIR) $(distdir)/lib/copy
	$(QUIET) - $(CP) lib/copy/*.cbl $(distdir)/lib/copy/.	
	$(QUIET) - $(CP) lib/copy/*.cpy $(distdir)/lib/copy/.	



#############################################################################
#	2 -- PHONY TARGETS
#############################################################################

.PHONY: all clean cleanall build dist


