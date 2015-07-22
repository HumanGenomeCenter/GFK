#!/bin/bash

CONTIG=$1
FASTA=$2

LENGTH=`head -2 $FASTA | tail -1 | wc -c`

echo "#maximal read length" > $CONTIG
echo "max_rd_len=$LENGTH" >> $CONTIG
echo "[LIB]" >> $CONTIG
echo "#maximal read length in this lib" >> $CONTIG
#echo "rd_len_cutof=$LENGTH" >> $CONTIG
echo "rd_len_cutof=45" >> $CONTIG
echo "#average insert size" >> $CONTIG
echo "avg_ins=200" >> $CONTIG
echo "#if sequence needs to be reversed " >> $CONTIG
echo "reverse_seq=0" >> $CONTIG
echo "#in which part(s) the reads are used" >> $CONTIG
echo "asm_flags=3" >> $CONTIG
echo "#minimum aligned length to contigs for a reliable read location (at least 32 for short insert size)" >> $CONTIG
echo "map_len=32" >> $CONTIG
echo "#fastq file for read 1 " >> $CONTIG
echo "#q1=/path/**LIBNAMEA**/fastq_read_1.fq" >> $CONTIG
echo "#fastq file for read 2 always follows fastq file for read 1" >> $CONTIG
echo "#q2=/path/**LIBNAMEA**/fastq_read_2.fq" >> $CONTIG
echo "#fasta file for read 1 " >> $CONTIG
echo "#f1=/path/**LIBNAMEA**/fasta_read_1.fa" >> $CONTIG
echo "#fastq file for read 2 always follows fastq file for read 1" >> $CONTIG
echo "#f2=/path/**LIBNAMEA**/fasta_read_2.fa" >> $CONTIG
echo "#fastq file for single reads" >> $CONTIG
echo "#q=/path/**LIBNAMEA**/fastq_read_single.fq" >> $CONTIG
echo "#fasta file for single reads" >> $CONTIG
echo "#f=/path/**LIBNAMEA**/fasta_read_single.fa" >> $CONTIG
echo "#a single fasta file for paired reads" >> $CONTIG
echo "p=$FASTA" >> $CONTIG
