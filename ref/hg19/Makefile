include ../../Makefile.in

REFS=hg19.fasta hg19.all.fasta hg19.header hg19.2bit hg19.all.2bit 11.ooc

.PHONY: all download install clean distclean

all: $(REFS)

download:
	(cd major ; make download)
	(cd minor ; make download)


hg19.fasta: major/hg19.major.fasta
	perl ../../install/script/upper.pl  major/hg19.major.fasta > hg19.fasta

hg19.all.fasta: hg19.fasta minor/hg19.minor.fasta
	cp -f hg19.fasta hg19.all.fasta
	perl ../../install/script/upper.pl  minor/hg19.minor.fasta >> hg19.all.fasta

hg19.header: hg19.fasta
	perl ../../install/script/makeHeader.pl hg19.fasta > hg19.header


hg19.2bit: hg19.fasta
	../../bin/faToTwoBit hg19.fasta hg19.2bit

hg19.all.2bit: hg19.all.fasta
	../../bin/faToTwoBit hg19.all.fasta hg19.all.2bit

11.ooc: hg19.2bit
	env OMP_NUM_THREADS=1 ../../bin/blat -makeOoc=11.ooc -repMatch=2253 -tileSize=11 hg19.2bit ./test.fa ./test.psl
	$(RM) test.psl


major/hg19.major.fasta:
	(cd major ; make hg19.major.fasta)

minor/hg19.minor.fasta:
	(cd minor ; make hg19.minor.fasta)


install: $(REFS)
	if [ ! -d ../../bin ]; then mkdir -p ../../bin; fi
	$(CP) $^ ../../bin

clean:
	(cd major ; make clean)
	(cd minor ; make clean)
	@$(RM) $(REFS) hg19.fasta.fai

distclean:
	(cd major ; make distclean)
	(cd minor ; make distclean)
	@$(RM) $(REFS) hg19.fasta.fai
