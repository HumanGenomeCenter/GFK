include ../../../Makefile.in

CHR_URL=http://hgdownload.cse.ucsc.edu/goldenPath/hg19/chromosomes

FASTA_FILES=chr1_gl000191_random.fa chr1_gl000192_random.fa chr4_gl000193_random.fa \
	chr4_gl000194_random.fa chr7_gl000195_random.fa chr8_gl000196_random.fa \
	chr8_gl000197_random.fa chr9_gl000198_random.fa chr9_gl000199_random.fa \
	chr9_gl000200_random.fa chr9_gl000201_random.fa chr11_gl000202_random.fa \
	chr17_gl000203_random.fa chr17_gl000204_random.fa chr17_gl000205_random.fa \
	chr17_gl000206_random.fa chr18_gl000207_random.fa chr19_gl000208_random.fa \
	chr19_gl000209_random.fa chr21_gl000210_random.fa \
	chrUn_gl000211.fa chrUn_gl000212.fa chrUn_gl000213.fa chrUn_gl000214.fa \
	chrUn_gl000215.fa chrUn_gl000216.fa chrUn_gl000217.fa chrUn_gl000218.fa \
	chrUn_gl000219.fa chrUn_gl000220.fa chrUn_gl000221.fa chrUn_gl000222.fa \
	chrUn_gl000223.fa chrUn_gl000224.fa chrUn_gl000225.fa chrUn_gl000226.fa \
	chrUn_gl000227.fa chrUn_gl000228.fa chrUn_gl000229.fa chrUn_gl000230.fa \
	chrUn_gl000231.fa chrUn_gl000232.fa chrUn_gl000233.fa chrUn_gl000234.fa \
	chrUn_gl000235.fa chrUn_gl000236.fa chrUn_gl000237.fa chrUn_gl000238.fa \
	chrUn_gl000239.fa chrUn_gl000240.fa chrUn_gl000241.fa chrUn_gl000242.fa \
	chrUn_gl000243.fa chrUn_gl000244.fa chrUn_gl000245.fa chrUn_gl000246.fa \
	chrUn_gl000247.fa chrUn_gl000248.fa chrUn_gl000249.fa

.PHONY: all download clean distclean

all: hg19.minor.fasta

hg19.minor.fasta: $(FASTA_FILES)
	cat $^ > hg19.minor.fasta

download: $(FASTA_FILES)

$(FASTA_FILES):
	wget $(CHR_URL)/$@.gz
	gunzip $@.gz

clean:
	@$(RM) hg19.minor.fasta

distclean:
	@$(RM) $(FASTA_FILES) hg19.minor.fasta
