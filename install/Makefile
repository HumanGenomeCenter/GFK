# install RNA pipeline

dataset: directory hg19_install db_install
dataset2: directory hg19_install2 db_install2 hg19_bowtie

directory:
	mkdir -p ../db/fusion
	mkdir -p ../ref/hg19/minor
	mkdir -p ../ref/hg19/major
	mkdir -p ../ref/knownGene_bowtie
	mkdir -p ../bin/blat
	mkdir -p ../data/input


################################################################################################
# hg19                                                                                         #
################################################################################################

hg19_install: hg19_decompress hg19_merge hg19_minor_decompress hg19_minor_merge hg19_all_fasta hg19_header
hg19_install2: hg19_merge hg19_minor_merge hg19_all_fasta hg19_header

hg19_decompress:
	gunzip ../ref/hg19/major/chr*.fa.gz

hg19_merge:
	cd ../ref/hg19/major && cat chr1.fa chr2.fa chr3.fa chr4.fa chr5.fa chr6.fa chr7.fa chr8.fa chr9.fa chr10.fa chr11.fa chr12.fa chr13.fa chr14.fa chr15.fa chr16.fa chr17.fa chr18.fa chr19.fa chr20.fa chr21.fa chr22.fa chrX.fa chrY.fa chrM.fa > hg19.major.fasta

hg19_minor_decompress:
	gunzip ../ref/hg19/minor/chr*.fa.gz

hg19_minor_merge:
	cd ../ref/hg19/minor && cat chr1_gl000191_random.fa chr1_gl000192_random.fa chr4_gl000193_random.fa chr4_gl000194_random.fa chr7_gl000195_random.fa chr8_gl000196_random.fa chr8_gl000197_random.fa chr9_gl000198_random.fa chr9_gl000199_random.fa chr9_gl000200_random.fa chr9_gl000201_random.fa chr11_gl000202_random.fa chr17_gl000203_random.fa chr17_gl000204_random.fa chr17_gl000205_random.fa chr17_gl000206_random.fa chr18_gl000207_random.fa chr19_gl000208_random.fa chr19_gl000209_random.fa chr21_gl000210_random.fa chrUn_gl000211.fa chrUn_gl000212.fa chrUn_gl000213.fa chrUn_gl000214.fa chrUn_gl000215.fa chrUn_gl000216.fa chrUn_gl000217.fa chrUn_gl000218.fa chrUn_gl000219.fa chrUn_gl000220.fa chrUn_gl000221.fa chrUn_gl000222.fa chrUn_gl000223.fa chrUn_gl000224.fa chrUn_gl000225.fa chrUn_gl000226.fa chrUn_gl000227.fa chrUn_gl000228.fa chrUn_gl000229.fa chrUn_gl000230.fa chrUn_gl000231.fa chrUn_gl000232.fa chrUn_gl000233.fa chrUn_gl000234.fa chrUn_gl000235.fa chrUn_gl000236.fa chrUn_gl000237.fa chrUn_gl000238.fa chrUn_gl000239.fa chrUn_gl000240.fa chrUn_gl000241.fa chrUn_gl000242.fa chrUn_gl000243.fa chrUn_gl000244.fa chrUn_gl000245.fa chrUn_gl000246.fa chrUn_gl000247.fa chrUn_gl000248.fa chrUn_gl000249.fa > hg19.minor.fasta

hg19_all_fasta:
	perl script/upper.pl  ../ref/hg19/major/hg19.major.fasta > ../ref/hg19/hg19.fasta
	cp -f ../ref/hg19/hg19.fasta ../ref/hg19/hg19.all.fasta
	perl script/upper.pl  ../ref/hg19/minor/hg19.minor.fasta >> ../ref/hg19/hg19.all.fasta

hg19_header:
	perl script/makeHeader.pl ../ref/hg19/hg19.fasta > ../ref/hg19/hg19.header


################################################################################################
# db                                                                                           #
################################################################################################

db_install: db_decompress db_info db_fasta db_ln
db_install2: db_info db_fasta db_ln

db_decompress:
	gunzip ../db/fusion/knownGene.txt.gz
	gunzip ../db/fusion/refGene.txt.gz
	gunzip ../db/fusion/ensGene.txt.gz

db_info:
	perl script/makeSpliceInfo_knownGene.pl ../db/fusion/knownGene.txt > ../db/knownGene.info

db_fasta:
	perl script/listExon.pl ../db/fusion/refGene.txt ../db/fusion/ensGene.txt ../db/fusion/knownGene.txt > ../db/fusion/exon.bed
	bash script/listExonProc.sh ../db/fusion/exon.bed > ../db/fusion/exon.proc.bed
	perl script/listEdges.pl ../db/fusion/refGene.txt ../db/fusion/ensGene.txt ../db/fusion/knownGene.txt > ../db/fusion/edge.bed
	perl script/listGenes.pl ../db/fusion/refGene.txt ../db/fusion/ensGene.txt ../db/fusion/knownGene.txt > ../db/fusion/gene.bed
	perl script/listCodingInfo.pl ../db/fusion/refGene.txt ../db/fusion/ensGene.txt ../db/fusion/knownGene.txt > ../db/fusion/codingInfo.txt
	../bin/BEDTools-Version-2.14.3/bin/fastaFromBed -fi ../ref/hg19/hg19.fasta -bed ../db/fusion/exon.proc.bed -fo ../db/fusion/exon.proc.tmp.fasta -tab -name
	perl script/catSeq.pl ../db/fusion/exon.proc.tmp.fasta > ../db/fusion/allGenes.tmp.fasta
	perl script/changeDuplicateID.pl ../db/fusion/allGenes.tmp.fasta > ../db/fusion/allGenes.fasta

db_ln:
	ln -f ../db/fusion/knownGene.txt ../ref/knownGene_bowtie/knownGene.txt


################################################################################################
# For Bowtie                                                                                   #
################################################################################################

hg19_bowtie:
	perl script/makePart_known.pl ../ref/knownGene_bowtie/knownGene.txt > ../ref/knownGene_bowtie/knownPart.bed
	../bin/BEDTools-Version-2.14.3/bin/fastaFromBed -fi ../ref/hg19/hg19.fasta -bed ../ref/knownGene_bowtie/knownPart.bed -fo ../ref/knownGene_bowtie/knownPart.fasta -tab -name
	perl script/catPart.pl ../ref/knownGene_bowtie/knownPart.fasta > ../ref/knownGene_bowtie/knownGene.fasta
