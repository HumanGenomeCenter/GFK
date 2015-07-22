########################################################################
#                                                                      #
#                    Makefile for Genomon-fusion                       #
#                                                                      #
########################################################################

K_COMP=1
USE_FCC=0

### General settings
# Set the top directory
GFKDIR=$(HOME)/data/gfk/GFK

# Set install directory
#INSTDIR=$(GFKDIR)/bin
INSTDIR=..

# If each MPI process can't access the other rank's home,
# please modify this value at which all process can access.
#SHAREDDIR=.
SHAREDDIR=..

### C compiler settings
CC	= gcc
COPTIONS=
OPTFLAGS= -O3
INCLUDES= 
CFLAGS	= $(COPTIONS) $(OPTFLAGS) $(INCLUDES)

MPICC	= mpifccpx
MPICOPTIONS= -Xg -Kopenmp -DBLAT_OPENMP -DGFK_NO_CLEANUP
MPIOPTFLAGS= -Kfast
MPIINCLUDES= 
MPICFLAGS	= $(MPICOPTIONS) $(MPIOPTFLAGS) $(MPIINCLUDES)

CXX	= g++
CXXOPTIONS=
CXXOPTFLAGS= -O3
CXXINCLUDES= 
CXXFLAGS= $(CXXOPTIONS) $(CXXOPTFLAGS) $(CXXINCLUDES)

LD	= $(CC)
LDFLAGS	=
LIBS	= -lm
LIBDIR  = 

AR = ar cru
RANLIB = ranlib
CP = \cp -f
RM = \rm -rf
MV = \mv -f
