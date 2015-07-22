include ../../Makefile.in

DB_URL=http://hgdownload.cse.ucsc.edu/goldenpath/hg19/database

DBS_DL=knownGene.txt refGene.txt ensGene.txt chainSelf.txt

DBS_GEN=exon.bed exon.proc.bed edge.bed gene.bed codingInfo.txt allGenes.fasta chainSelf.bedpe

.PHONY: all download fasta install clean distclean

all: fasta

download: $(DBS_DL)

fasta: $(DBS_GEN)


exon.bed: refGene.txt ensGene.txt knownGene.txt
	perl ../../install/script/listExon.pl refGene.txt ensGene.txt knownGene.txt > exon.bed

exon.proc.bed: exon.bed
	bash ../../install/script/listExonProc.sh exon.bed > exon.proc.bed

edge.bed: refGene.txt ensGene.txt knownGene.txt
	perl ../../install/script/listEdges.pl refGene.txt ensGene.txt knownGene.txt > edge.bed

gene.bed: refGene.txt ensGene.txt knownGene.txt
	perl ../../install/script/listGenes.pl refGene.txt ensGene.txt knownGene.txt > gene.bed

codingInfo.txt: refGene.txt ensGene.txt knownGene.txt
	perl ../../install/script/listCodingInfo.pl refGene.txt ensGene.txt knownGene.txt > codingInfo.txt

exon.proc.tmp.fasta: ../../ref/hg19/hg19.fasta exon.proc.bed
	if [ $(K_COMP) -eq 1 ]; then \
		pjsub run_fastaFromBed.sh 2>&1 | sed -e 's/^.*Job //' -e 's/ submitted.//' > pjid.txt ; \
		while ( pjstat | grep -q `cat pjid.txt` ); do sleep 10; done ; \
	else \
		../../bin/fastaFromBed -fi ../../ref/hg19/hg19.fasta -bed exon.proc.bed -fo exon.proc.tmp.fasta -tab -name ; \
	fi

allGenes.fasta: exon.proc.tmp.fasta
	perl ../../install/script/catSeq.pl exon.proc.tmp.fasta > allGenes.tmp.fasta
	perl ../../install/script/changeDuplicateID.pl allGenes.tmp.fasta > allGenes.fasta
	rm -f allGenes.tmp.fasta

chainSelf.bedpe: chainSelf.txt
	perl ../../install/script/makeChainSelfBedpe.pl chainSelf.txt > chainSelf.bedpe

../../ref/hg19/hg19.fasta:
	(cd ../../ref/hg19 && make hg19.fasta)


knownGene.txt:
	wget $(DB_URL)/$@.gz
	gunzip $@.gz

refGene.txt:
	wget $(DB_URL)/$@.gz
	gunzip $@.gz

ensGene.txt:
	wget $(DB_URL)/$@.gz
	gunzip $@.gz

chainSelf.txt:
	wget $(DB_URL)/$@.gz
	gunzip $@.gz


install: $(DBS_DL) $(DBS_GEN)
	if [ ! -d ../../bin ]; then mkdir -p ../../bin; fi
	$(CP) $^ ../../bin

clean:
	@$(RM) $(DBS_GEN) exon.proc.tmp.fasta run_fastaFromBed.sh.* pjid.txt

distclean:
	@$(RM) $(DBS_DL) $(DBS_GEN) exon.proc.tmp.fasta
