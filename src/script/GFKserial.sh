#!/bin/sh -x
#PJM --rsc-list "rscgrp=small"
#PJM --rsc-list "node=1"
#PJM --rsc-list "elapse=3:00:00"
#PJM --stg-transfiles all
##PJM --mpi "use-rankdir"
#
##### for bowtie-build
##PJM --stgin "/home/hp120311/k01244/public/bin/bowtie-build-gnu ./"
##PJM --stgin "/home/hp120311/k01244/private/RNAseq/ref/knownGene_bowtie/knownGene.fasta ./"
##PJM --stgout "./knownGene.* ./"
##### for faToTwoBit
##PJM --stgin "/home/hp120311/k01244/public/Serial_blat/faToTwoBit ./"
##PJM --stgin "/home/hp120311/k01244/private/RNAseq/ref/hg19/hg19.fasta ./"
##PJM --stgout "./hg19.2bit ./"
##### makeOoc
#PJM --stgin "/home/hp120311/k01244/public/Serial_blat/blat ./"
#PJM --stgin "./hg19.2bit ./"
#PJM --stgout "./11.ooc ./"
############
#
. /work/system/Env_base
#
### 
#./bowtie-build-gnu knownGene.fasta knownGene
#./faToTwoBit hg19.fasta hg19.2bit
./blat -makeOoc=11.ooc -repMatch=2253 -tileSize=11 hg19.2bit test.fa test.psl
