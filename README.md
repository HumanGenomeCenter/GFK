1. Prepare blat

First, prepare blat and FaToTwoBit (blat utility). Then,
copy them into bin directory of this package.


2. Prepare Makefile.in 

Sample Makefile.in for K-computer and Linux is located under etc/.
So, copy appropriate sample to the top directory where this README is
located, open with an editor, and set GFKDIR to the top directory.


3. Download tools and reference data

Type "make download". This will download archives of external tools
and reference data.


4. Compile tools and GFK binaries

Type "make tool" to prepare external tools, and type "make src" to
prepare GFK binaries under ./bin.


5. Prepare reference files

Type "make ref" to prepare reference files under ./bin.

If you are using K-computer, this step takes more than 14 hours, so it
is recommended to run as a background job as follows:
$ make ref > make-ref.log 2>&1 &


6. Prepare for test

Change directory to test.
Then, type "make", and an archive of executables and scripts for
submitting jobs will be created.
Input data sequence1.txt and sequenc2.txt of CCLE_COLO_783_RNA_08 are
to be located in ./test/Input/Input1 directory.


7. Submit jobs

Run GFKpre.sh
$ cd Input
$ ../../bin/GFKpre.sh ../input.txt
$ ../../bin/GFKpre.sh -f ../input.txt
$ cd ..

Run GFKalign (Submit GFKalign.sh on K-computer)
$ mpirun -np 624 ../bin/GFKalign Output
or
$ pjsub GFKalign.sh

Run GFKpost.sh
$ cd Output
$ ../../bin/GFKpost.sh ../Input/GFKPostProcess.txt
$ cd ..

Run GFKdedup (Submit GFKdedup.sh on K-computer)
$ mpirun -np 1 ../bin/GFKdedup Output
or
$ pjsub GFKdedup.sh

Run GFKdetect (Submit GFKdetect.sh on K-computer)
$ mpirun -np 44 ../bin/GFKdetect Output
or
$ pjsub GFKdetect.sh


8. Result

fusion.0.txt is the final result. Reference output is fusion.0.ref.
