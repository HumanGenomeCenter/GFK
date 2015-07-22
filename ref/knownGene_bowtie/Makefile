include ../../Makefile.in

.PHONY: all build install clean distclean

all: build install

knownPart.bed: knownGene.txt
	perl ../../install/script/makePart_known.pl knownGene.txt > knownPart.bed

knownPart.fasta: ../hg19/hg19.fasta knownPart.bed
	../../bin/fastaFromBed -fi ../hg19/hg19.fasta -bed knownPart.bed -fo knownPart.fasta -tab -name

knownGene.fasta: knownPart.fasta
	perl ../../install/script/catPart.pl knownPart.fasta > knownGene.fasta


build: knownGene.fasta
	../../bin/bowtie-build knownGene.fasta knownGene


knownGene.txt: ../../db/fusion/knownGene.txt
	ln -f ../../db/fusion/knownGene.txt knownGene.txt


../hg19/hg19.fasta:
	(cd ../hg19 && make hg19.fasta)

../../db/fusion/knownGene.txt:
	(cd ../../db/fusion && make knownGene.txt)


install:
	if [ ! -d ../../bin ]; then mkdir -p ../../bin; fi
	$(CP) knownGene.* ../../bin

clean:
	@$(RM) knownGene.* knownPart.*

distclean:
	@$(RM) knownGene.* knownPart.*
