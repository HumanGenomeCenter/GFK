#!/bin/sh
#PJM --rsc-list "rscgrp=small"
#PJM --rsc-list "node=1"
#PJM --rsc-list "elapse=12:00:00"
#PJM --stg-transfiles all
#PJM --stgin "../../bin/fastaFromBed ./"
#PJM --stgin "../../ref/hg19/hg19.fasta ./"
#PJM --stgin "exon.proc.bed ./"
#PJM --stgout "exon.proc.tmp.fasta ./"
#PJM -S
. /work/system/Env_base
./fastaFromBed -fi hg19.fasta -bed exon.proc.bed -fo exon.proc.tmp.fasta -tab -name
