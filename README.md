                   GFK: Genomon-fusion for K computer                   

Copyright (c) 2015 Satoshi ITO, Yuichi SHIRAISHI, Kenichi CHIBA 

1. General

GFK is a parallelized version of Genomon-fusion. Genomon-fusion is a pip
eline software that performs alignment of FASTQ files of whole transcrip
tome sequencing data and detects fusion gene candidates. For further inf
ormation, see below:

  User guide:
    doc/UserGuide.pdf

  Genomon-fusion web site:
    http://genomon.hgc.jp/rna/

contact address: Satoshi ITO (sito@hgc.jp)


2. How to run
2.1 Prerequisite

  Parallel computer and the following software can be installed.

  - Message Passing Interface (MPI)
  - perl
  - blat (ver.35)
  - Bowtie (ver.0.12.7)
  - samtools (ver.0.1.20)
  - fasta36 (ver.36.3.5c)
  - SOAP denovo-Trans (ver.1.0.4)
  - bedtools (ver.2.14.3)

  Internet connection is also required if you use automatic download of 
  datasets by Makefile.


2.2 Prepare blat

  First, prepare blat and FaToTwoBit (blat utility). Then, copy them in
  to bin directory of this package.


2.3 Prepare Makefile.in 

  Sample Makefile.in for K-computer and Linux is located under etc/.
  So, copy appropriate sample to the top directory where this README is
  located, open with an editor, and set GFKDIR to the top directory.


2.4 Download tools and reference data

  Type "make download". This will download archives of external tools
  and reference data.


2.5 Compile tools and GFK binaries

  Type "make tool" to prepare external tools, and type "make src" to
  prepare GFK binaries under ./bin.


2.6 Prepare reference files

  Type "make ref" to prepare reference files under ./bin.

  If you are using K-computer, this step takes more than 14 hours, so it
  is recommended to run as a background job as follows:

  $ make ref > make-ref.log 2>&1 &


2.7 Prepare for test

  Change directory to test.
  Then, type "make", and an archive of executables and scripts for submi
  tting jobs will be created. Input data sequence1.txt and sequenc2.txt 
  of CCLE_COLO_783_RNA_08 are to be located in ./test/Input/Input1 direc
  tory.


2.8 Submit jobs

  Run GFKpre.sh

  $ cd Input
  $ ../../bin/GFKpre.sh ../input.txt
  $ ../../bin/GFKpre.sh -f ../input.txt
  $ cd ..


  Run GFKalign (Submit GFKalign.sh on K-computer)

  $ mpirun -np 624 ../bin/GFKalign Output

  or

  $ pjsub GFKalign.sh  (on K computer)


  Run GFKpost.sh

  $ cd Output
  $ ../../bin/GFKpost.sh ../Input/GFKPostProcess.txt
  $ cd ..


  Run GFKdedup (Submit GFKdedup.sh on K-computer)

  $ mpirun -np 1 ../bin/GFKdedup Output

  or

  $ pjsub GFKdedup.sh  (on K computer)


  Run GFKdetect (Submit GFKdetect.sh on K-computer)

  $ mpirun -np 44 ../bin/GFKdetect Output

  or

  $ pjsub GFKdetect.sh  (on K computer)


2.9 Result

  fusion.0.txt is the final result. Reference output is fusion.0.ref.
