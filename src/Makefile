########################################################################
#                                                                      #
#                    Makefile for Genomon-fusion                       #
#                                                                      #
########################################################################

include ../Makefile.in

TARGET=GFKalign GFKdedup GFKdetect

.PHONY: all install clean distclean
.PRECIOUS: %.c
.SUFFIXES: .c .template

.template.c:
	sed -e "s%GFKDIR%${INSTDIR}%g" \
	    -e "s%SHAREDDIR%${SHAREDDIR}%g" $< > $@

all: $(TARGET) install

%: %.c
	$(MPICC) $(MPICFLAGS) $< -o $@

clean:
	@$(RM) *~ *.c

distclean: clean
	@$(RM) $(TARGET)

install: $(TARGET)
	$(CP) $^ ../bin/
	$(CP) script/* ../bin/
