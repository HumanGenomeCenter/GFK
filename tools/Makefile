########################################################################
#                                                                      #
#                    Makefile for Genomon-fusion                       #
#                                                                      #
########################################################################

include ../Makefile.in

.PHONY: all clean distclean install fasta bedtools samtools soap bowtie download
all: fasta bedtools samtools soap bowtie install

download: fasta-36.3.5c BEDTools-Version-2.14.3 samtools-0.1.20 SOAPdenovo-Trans-src-v1.04 bowtie-0.12.7

#
# fasta
#

fasta-36.3.5c.tar.gz:
	wget http://faculty.virginia.edu/wrpearson/fasta/fasta36/fasta-36.3.5c.tar.gz

fasta-36.3.5c: fasta-36.3.5c.tar.gz
	tar xvzf fasta-36.3.5c.tar.gz

fasta: fasta-36.3.5c/COPYRIGHT
	(cd fasta-36.3.5c/src; make -f ../make/Makefile.linux64 CC="$(CC) $(CFLAGS)")

#
# BEDTools
#

BEDTools.v2.14.3.tar.gz:
	wget http://bedtools.googlecode.com/files/BEDTools.v2.14.3.tar.gz

BEDTools-Version-2.14.3: BEDTools.v2.14.3.tar.gz
	tar xvzf BEDTools.v2.14.3.tar.gz
	(cd BEDTools-Version-2.14.3; patch -p1 < ../BEDTools-Version-2.14.3_fix.patch)

bedtools: BEDTools-Version-2.14.3/LICENSE
	(cd BEDTools-Version-2.14.3; make clean; make CXX="$(CXX)" CXXFLAGS="$(CXXFLAGS) -D_FILE_OFFSET_BITS=64 -fPIC" all)

#
# samtools
#

samtools-0.1.20.tar.gz:
	wget https://github.com/samtools/samtools/archive/0.1.20.tar.gz
	mv 0.1.20.tar.gz samtools-0.1.20.tar.gz

samtools-0.1.20: samtools-0.1.20.tar.gz
	tar xvzf samtools-0.1.20.tar.gz
	if [ $(K_COMP) = 1 ]; then \
		(cd samtools-0.1.20; patch -p1 < ../samtools-0.1.20_K.patch); \
		if [ $(USE_FCC) = 1 ]; then \
			(cd samtools-0.1.20; patch -p1 < ../samtools-0.1.20_fcc.patch); \
		fi \
	fi

samtools: samtools-0.1.20/AUTHORS
	(cd samtools-0.1.20; make CC="$(CC)" CFLAGS="$(CFLAGS)")

#
# SOAPdenovo-Trans
#

SOAPdenovo-Trans-src-v1.04.zip:
	wget http://sourceforge.net/projects/soapdenovotrans/files/SOAPdenovo-Trans/src/v1.04/SOAPdenovo-Trans-src-v1.04.zip

SOAPdenovo-Trans-src-v1.04: SOAPdenovo-Trans-src-v1.04.zip
	unzip SOAPdenovo-Trans-src-v1.04.zip
	if [ $(K_COMP) = 1 ]; then \
		(cd SOAPdenovo-Trans-src-v1.04; patch -p1 < ../SOAPdenovo-Trans-src-v1.04_K.patch); \
		if [ $(USE_FCC) = 1 ]; then \
			(cd SOAPdenovo-Trans-src-v1.04; patch -p1 < ../SOAPdenovo-Trans-src-v1.04_fcc.patch); \
		fi \
	fi

soap: SOAPdenovo-Trans-src-v1.04/INSTALL
	cp samtools-0.1.20/libbam.a SOAPdenovo-Trans-src-v1.04/src/inc
	(cd SOAPdenovo-Trans-src-v1.04; sh make.sh)

#
# bowtie
#

bowtie-0.12.7-src.zip:
	wget http://sourceforge.net/projects/bowtie-bio/files/bowtie/0.12.7/bowtie-0.12.7-src.zip

bowtie-0.12.7: bowtie-0.12.7-src.zip
	unzip bowtie-0.12.7-src.zip
	if [ $(K_COMP) = 1 ]; then \
		(cd bowtie-0.12.7; patch -p1 < ../bowtie-0.12.7_K.patch); \
		if [ $(USE_FCC) = 1 ]; then \
			(cd bowtie-0.12.7; patch -p1 < ../bowtie-0.12.7_FCC.patch); \
		fi \
	fi

bowtie: bowtie-0.12.7/AUTHORS
	(cd bowtie-0.12.7; make CC="$(CC)" CPP="$(CXX)" CFLAGS="$(CFLAGS)" CXXFLAGS="$(CXXFLAGS)")


clean:
	@if [ -d fasta-36.3.5c ]; then \
		(cd fasta-36.3.5c; $(RM) src/*.o bin/*) \
	fi
	@if [ -e BEDTools-Version-2.14.3 ]; then \
		 (cd BEDTools-Version-2.14.3; make clean) \
	fi
	@if [ -d samtools-0.1.20 ]; then \
		(cd samtools-0.1.20; make clean) \
	fi
	@if [ -d SOAPdenovo-Trans-src-v1.04 ]; then \
		(cd SOAPdenovo-Trans-src-v1.04; sh clean.sh) \
	fi
	@if [ -d bowtie-0.12.7 ]; then \
		(cd bowtie-0.12.7; make clean) \
	fi

distclean:
	@$(RM) fasta-36.3.5c fasta-36.3.5c.tar.gz
	@$(RM) BEDTools-Version-2.14.3 BEDTools.v2.14.3.tar.gz
	@$(RM) samtools-0.1.20 samtools-0.1.20.tar.gz
	@$(RM) SOAPdenovo-Trans-src-v1.04 SOAPdenovo-Trans-src-v1.04.zip
	@$(RM) bowtie-0.12.7 bowtie-0.12.7-src.zip


install:
	if [ ! -d ../bin ]; then mkdir ../bin; fi
	$(CP) fasta-36.3.5c/bin/* ../bin/
	$(CP) BEDTools-Version-2.14.3/bin/* ../bin/
	$(CP) samtools-0.1.20/samtools ../bin/
	$(CP) SOAPdenovo-Trans-src-v1.04/SOAPdenovo-Trans-* ../bin/
	(cd bowtie-0.12.7; $(CP) bowtie bowtie-* ../../bin/)
