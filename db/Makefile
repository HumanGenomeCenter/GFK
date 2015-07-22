include ../Makefile.in

.PHONY: all download fasta install clean distclean

all: knownGene.info fasta install

download:
	(cd fusion ; make download)


knownGene.info: fusion/knownGene.txt
	perl ../install/script/makeSpliceInfo_knownGene.pl fusion/knownGene.txt > knownGene.info

fasta:
	(cd fusion ; make fasta)

fusion/knownGene.txt:
	(cd fusion ; make knownGene.txt)


install: knownGene.info
	if [ ! -d ../bin ]; then mkdir -p ../bin; fi
	$(CP) knownGene.info ../bin
	(cd fusion ; make install)

clean:
	(cd fusion ; make clean)
	@$(RM) knownGene.info

distclean:
	(cd fusion ; make distclean)
	@$(RM) knownGene.info
