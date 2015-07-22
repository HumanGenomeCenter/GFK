########################################################################
#                                                                      #
#                    Makefile for Genomon-fusion                       #
#                                                                      #
########################################################################

include ../Makefile.in

.PHONY: all clean distclean download make_hg19 make_knownGene

all: make_hg19 make_knownGene install

download:
	(cd hg19 ; make download)


make_hg19:
	(cd hg19 ; make all)

make_knownGene:
	(cd knownGene_bowtie ; make all)


install:
	(cd hg19 ; make install)
	(cd knownGene_bowtie ; make install)

clean:
	(cd hg19 ; make clean)
	(cd knownGene_bowtie ; make clean)

distclean:
	(cd hg19 ; make distclean)
	(cd knownGene_bowtie ; make distclean)
