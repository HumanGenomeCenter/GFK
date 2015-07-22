########################################################################
#                                                                      #
#                    Makefile for Genomon-fusion                       #
#                                                                      #
########################################################################
include Makefile.in

.PHONY: all tool ref src download clean distclean

all: download tool src

tool:
	if [ $(K_COMP) -eq 1 ]; then \
		echo '. /work/system/Env_base; cd tools; make all' | pjsub --interact --rsc-list "node=1" --rsc-list "elapse=6:00:00" ; \
	else \
		(cd tools ; make all) \
	fi

ref:
	if [ $(K_COMP) -eq 1 ]; then \
		echo '. /work/system/Env_base; cd ref; make all' | pjsub --interact --rsc-list "node=1" --rsc-list "elapse=6:00:00" ; \
	else \
		(cd ref ; make all) \
	fi
	(cd db ; make all)

src:
	(cd src ; make)

download:
	(cd tools ; make download)
	(cd db ; make download)
	(cd ref ; make download)

clean:
	(cd src ; make clean)
	(cd tools ; make clean)
	(cd ref ; make clean)
	(cd db ; make clean)

distclean:
	(cd src ; make distclean)
	(cd tools ; make distclean)
	(cd ref ; make distclean)
	(cd db ; make distclean)
	@rm -f bin/*
