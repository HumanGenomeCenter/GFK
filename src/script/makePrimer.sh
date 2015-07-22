#! /bin/bash
#$ -S /bin/bash
#$ -cwd
#
# Copyright Human Genome Center, Institute of Medical Science, the University of Tokyo
# @since 2012
#

GFKDIR=$1
rank=$2
OMP_FLAG=$3

#echo "cp ${ALLGENEREF} ${FUSIONDIR}/transcripts.allGene_cuff.fasta"
cp ${GFKDIR}/allGenes.fasta ./transcripts.allGene_cuff.${rank}.fasta


# mapping the contigs to the .fasta file
#echo "${BLAT_PATH}/blat -maxIntron=5 ${FUSIONDIR}/transcripts.allGene_cuff.fasta ${FUSIONDIR}/juncContig.fa ${FUSIONDIR}/juncContig_allGene_cuff.psl"
${GFKDIR}/blat -maxIntron=5 ./transcripts.allGene_cuff.${rank}.fasta ./juncContig.${rank}.fa ./juncContig_allGene_cuff.${rank}.psl
if [ $OMP_FLAG -eq 1 ]; then
    cat ./juncContig_allGene_cuff.${rank}.psl.* > ./juncContig_allGene_cuff.${rank}.psl
    rm -f ./juncContig_allGene_cuff.${rank}.psl.*
fi

#echo "perl ${COMMAND_FUSION}/psl2bed_junc.pl ${FUSIONDIR}/juncContig_allGene_cuff.psl > ${FUSIONDIR}/juncContig_allGene_cuff.bed"
perl ${GFKDIR}/psl2bed_junc.pl ./juncContig_allGene_cuff.${rank}.psl > ./juncContig_allGene_cuff.${rank}.bed


if [ -f ./transcripts.allGene_cuff.${rank}.fasta.fai ]; then
  #echo "rm -rf ${FUSIONDIR}/transcripts.allGene_cuff.fasta.fai"
  rm -rf ./transcripts.allGene_cuff.${rank}.fasta.fai
fi


#echo "${BEDTOOLS_PATH}/fastaFromBed -fi ${FUSIONDIR}/transcripts.allGene_cuff.fasta -bed ${FUSIONDIR}/juncContig_allGene_cuff.bed -fo ${FUSIONDIR}/juncContig_allGene_cuff.txt -tab -name -s"
${GFKDIR}/fastaFromBed -fi ./transcripts.allGene_cuff.${rank}.fasta -bed ./juncContig_allGene_cuff.${rank}.bed -fo ./juncContig_allGene_cuff.${rank}.txt -tab -name -s



#echo "perl ${COMMAND_FUSION}/summarizeExtendedContig.pl ${FUSIONDIR}/juncList_anno7.txt ${FUSIONDIR}/juncContig_allGene_cuff.txt | uniq > ${FUSIONDIR}/comb2eContig.txt"
perl ${GFKDIR}/summarizeExtendedContig.pl ./juncList_anno7.${rank}.txt ./juncContig_allGene_cuff.${rank}.txt | uniq > ./comb2eContig.${rank}.txt


#echo "perl ${COMMAND_FUSION}/psl2inframePair.pl ${FUSIONDIR}/juncContig_allGene_cuff.psl ${DBDIR}/fusion/codingInfo.txt > ${FUSIONDIR}/comb2inframe.txt"
perl ${GFKDIR}/psl2inframePair.pl ./juncContig_allGene_cuff.${rank}.psl ${GFKDIR}/codingInfo.txt > ./comb2inframe.${rank}.txt


#echo "perl ${COMMAND_FUSION}/psl2geneRegion.pl ${FUSIONDIR}/juncContig_allGene_cuff.psl ${DBDIR}/fusion/codingInfo.txt > ${FUSIONDIR}/comb2geneRegion.txt"
perl ${GFKDIR}/psl2geneRegion.pl ./juncContig_allGene_cuff.${rank}.psl ${GFKDIR}/codingInfo.txt > ./comb2geneRegion.${rank}.txt


#echo "perl ${COMMAND_FUSION}/addGeneral.pl ${FUSIONDIR}/juncList_anno7.txt ${FUSIONDIR}/comb2eContig.txt 2 > ${FUSIONDIR}/juncList_anno8.txt"
perl ${GFKDIR}/addGeneral.pl ./juncList_anno7.${rank}.txt ./comb2eContig.${rank}.txt 2 > ./juncList_anno8.${rank}.txt


#echo "perl ${COMMAND_FUSION}/addGeneral.pl ${FUSIONDIR}/juncList_anno8.txt ${FUSIONDIR}/comb2inframe.txt 1 > ${FUSIONDIR}/juncList_anno9.txt"
perl ${GFKDIR}/addGeneral.pl ./juncList_anno8.${rank}.txt ./comb2inframe.${rank}.txt 1 > ./juncList_anno9.${rank}.txt


#echo "perl ${COMMAND_FUSION}/addGeneral.pl ${FUSIONDIR}/juncList_anno9.txt ${FUSIONDIR}/comb2geneRegion.txt 2 > ${FUSIONDIR}/juncList_anno10.txt"
perl ${GFKDIR}/addGeneral.pl ./juncList_anno9.${rank}.txt ./comb2geneRegion.${rank}.txt 2 > ./juncList_anno10.${rank}.txt


#echo "perl ${COMMAND_FUSION}/addHeader.pl ${FUSIONDIR}/juncList_anno10.txt > ${FUSIONDIR}/${TAG}.fusion.all.txt"
perl ${GFKDIR}/addHeader.pl ./juncList_anno10.${rank}.txt > ./fusion.all.${rank}.txt


#echo "perl ${COMMAND_FUSION}/filterMaltiMap.pl ${FUSIONDIR}/${TAG}.fusion.all.txt > ${FUSIONDIR}/${TAG}.fusion.filt1.txt"
perl ${GFKDIR}/filterMaltiMap.pl ./fusion.all.${rank}.txt > ./fusion.filt1.${rank}.txt


#echo "perl ${COMMAND_FUSION}/filterColumns.pl ${FUSIONDIR}/${TAG}.fusion.filt1.txt > ${FUSIONDIR}/${TAG}.fusion.txt"
perl ${GFKDIR}/filterColumns.pl ./fusion.filt1.${rank}.txt > ./fusion.${rank}.txt


