include ../../../Makefile.in

CHR_URL=http://hgdownload.cse.ucsc.edu/goldenPath/hg19/chromosomes

FASTA_FILES=chr1.fa chr2.fa chr3.fa chr4.fa chr5.fa chr6.fa chr7.fa chr8.fa \
	chr9.fa chr10.fa chr11.fa chr12.fa chr13.fa chr14.fa chr15.fa chr16.fa \
	chr17.fa chr18.fa chr19.fa chr20.fa chr21.fa chr22.fa chrX.fa chrY.fa chrM.fa

.PHONY: all download clean distclean

all: hg19.major.fasta

hg19.major.fasta: $(FASTA_FILES)
	cat $^ > hg19.major.fasta

download: $(FASTA_FILES)

$(FASTA_FILES):
	wget $(CHR_URL)/$@.gz
	gunzip $@.gz

clean:
	@$(RM) hg19.major.fasta

distclean:
	@$(RM) $(FASTA_FILES) hg19.major.fasta
