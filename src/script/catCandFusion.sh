#! /bin/bash
#$ -S /bin/bash
#$ -cwd
#
# Copyright Human Genome Center, Institute of Medical Science, the University of Tokyo
# @since 2012
#

GFKDIR=$1
SHAREDDIR=$2
SAMPLE=$3

#echo "perl ../makeBeds.pl ./countJunc.txt ./cj_tmp1.bed ./cj_tmp2.bed"
perl ${GFKDIR}/makeBeds.pl ${SHAREDDIR}/countJunc.${SAMPLE}.txt ./cj_tmp1.${SAMPLE}.bed ./cj_tmp2.${SAMPLE}.bed

#echo "../intersectBed -a ./cj_tmp1.bed -b ./cj_tmp2.bed -wb > ./countJunc.inter.txt"
${GFKDIR}/intersectBed -a ./cj_tmp1.${SAMPLE}.bed -b ./cj_tmp2.${SAMPLE}.bed -wb > ./countJunc.inter.${SAMPLE}.txt

#echo "perl ../mergeJunc2.pl ./countJunc.inter.txt > ./juncList.txt"
perl ${GFKDIR}/mergeJunc2.pl ./countJunc.inter.${SAMPLE}.txt > ./juncList.${SAMPLE}.txt

#echo "../intersectBed -a ./cj_tmp1.bed -b ${DBDIR}/fusion/gene.bed -wao > ./cj_gene1.txt"
${GFKDIR}/intersectBed -a ./cj_tmp1.${SAMPLE}.bed -b ${GFKDIR}/gene.bed -wao > ./cj_gene1.${SAMPLE}.txt

#echo "../intersectBed -a ./cj_tmp2.bed -b ${DBDIR}/fusion/gene.bed -wao > ./cj_gene2.txt"
${GFKDIR}/intersectBed -a ./cj_tmp2.${SAMPLE}.bed -b ${GFKDIR}/gene.bed -wao > ./cj_gene2.${SAMPLE}.txt

#echo "perl ../makeJuncToGene.pl ./cj_gene1.txt > ./junc2gene1.txt"
perl ${GFKDIR}/makeJuncToGene.pl ./cj_gene1.${SAMPLE}.txt > ./junc2gene1.${SAMPLE}.txt

#echo "perl ../makeJuncToGene.pl ./cj_gene2.txt > ./junc2gene2.txt"
perl ${GFKDIR}/makeJuncToGene.pl ./cj_gene2.${SAMPLE}.txt > ./junc2gene2.${SAMPLE}.txt

#echo "perl ../addAnno.pl ./juncList.txt ./junc2gene1.txt ./junc2gene2.txt > ./juncList_anno0.txt"
perl ${GFKDIR}/addAnno.pl ./juncList.${SAMPLE}.txt ./junc2gene1.${SAMPLE}.txt ./junc2gene2.${SAMPLE}.txt > ${SHAREDDIR}/juncList_anno0.${SAMPLE}.txt


#echo "perl ../procEdge.pl ./juncList_anno0.txt ${DBDIR}/fusion/edge.bed > ./juncList_anno1.txt"
perl ${GFKDIR}/procEdge.pl ${SHAREDDIR}/juncList_anno0.${SAMPLE}.txt ${GFKDIR}/edge.bed > ${SHAREDDIR}/juncList_anno1.${SAMPLE}.txt

#echo "perl ../filterByGene.pl ./juncList_anno1.txt > ./juncList_anno2.txt"
perl ${GFKDIR}/filterByGene.pl ${SHAREDDIR}/juncList_anno1.${SAMPLE}.txt > ${SHAREDDIR}/juncList_anno2.${SAMPLE}.txt

#echo "perl ../makeJuncBed.pl ./juncList_anno2.txt > ./filtSeq.bed"
perl ${GFKDIR}/makeJuncBed.pl ${SHAREDDIR}/juncList_anno2.${SAMPLE}.txt > ${SHAREDDIR}/filtSeq.${SAMPLE}.bed

#echo "../fastaFromBed -fi ${REF_FA} -bed ./filtSeq.bed -fo ./filtSeq.fasta -name -tab"
${GFKDIR}/fastaFromBed -fi ${GFKDIR}/hg19.fasta -bed ${SHAREDDIR}/filtSeq.${SAMPLE}.bed -fo ${SHAREDDIR}/filtSeq.${SAMPLE}.fasta -name -tab

#echo "perl ../addSeq.pl ./juncList_anno2.txt ./filtSeq.fasta > ./juncList_anno3.txt"
perl ${GFKDIR}/addSeq.pl ${SHAREDDIR}/juncList_anno2.${SAMPLE}.txt ${SHAREDDIR}/filtSeq.${SAMPLE}.fasta > ${SHAREDDIR}/juncList_anno3.${SAMPLE}.txt

#echo "perl ../makePairBed.pl ./juncList_anno3.txt > ./juncList_pair3.txt"
perl ${GFKDIR}/makePairBed.pl ${SHAREDDIR}/juncList_anno3.${SAMPLE}.txt > ${SHAREDDIR}/juncList_pair3.${SAMPLE}.txt

#echo "../pairToPair -a ./juncList_pair3.txt -b ${DBDIR}/fusion/chainSelf.bedpe -is > ./juncList_chainSelf.bedpe"
${GFKDIR}/pairToPair -a ${SHAREDDIR}/juncList_pair3.${SAMPLE}.txt -b ${GFKDIR}/chainSelf.bedpe -is > ${SHAREDDIR}/juncList_chainSelf.${SAMPLE}.bedpe

#echo "perl ../addSelfChain.pl ./juncList_anno3.txt ./juncList_chainSelf.bedpe > ./juncList_anno4.txt"
perl ${GFKDIR}/addSelfChain.pl ${SHAREDDIR}/juncList_anno3.${SAMPLE}.txt ${SHAREDDIR}/juncList_chainSelf.${SAMPLE}.bedpe > ${SHAREDDIR}/juncList_anno4.${SAMPLE}.txt



# prepare for asssembly
# make the table for relationships between combinations of junctions and IDs
#echo "perl ../makeComb2ID.pl ./juncList_anno4.txt ./junc2ID.txt > ./comb2ID.txt"
perl ${GFKDIR}/makeComb2ID.pl ${SHAREDDIR}/juncList_anno4.${SAMPLE}.txt ${SHAREDDIR}/junc2ID.${SAMPLE}.txt > ${SHAREDDIR}/comb2ID.${SAMPLE}.txt

# add the data of reads aligned flanking the junctions
#echo "perl ../addComb2ID.pl ${OUTPUTDIR}/sequence/sequence.bam ./comb2ID.txt 20 ${SAMTOOLS_PATH} > ./comb2ID2.txt"
perl ${GFKDIR}/addComb2ID.pl ${GFKDIR} ${SHAREDDIR}/GFKdedup.${SAMPLE}.bam ${SHAREDDIR}/comb2ID.${SAMPLE}.txt 20 $SAMPLE > ${SHAREDDIR}/comb2ID2.${SAMPLE}.txt
