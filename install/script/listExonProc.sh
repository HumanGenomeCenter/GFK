#! /bin/bash
#
# Copyright Human Genome Center, Institute of Medical Science, the University of Tokyo
# @since 2012
#

readonly INPUT=$1

perl -F"\t" -a -n -e 'if ($F[0] =~ /^chr[\dXYM]+$/) {print join("\t", @F);}' ${INPUT}

