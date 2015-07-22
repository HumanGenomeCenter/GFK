#! /usr/local/bin/perl
#
# Copyright Human Genome Center, Institute of Medical Science, the University of Tokyo
# @since 2012
#

use strict;
use warnings;

print "final junction" . "\t" . "first junction" . "\t" . "\#consistent read1 (first)" . "\t" . "\#consistent read2 (first)" . "\t";
print "second junction" . "\t" . "\#consistent read1 (second)" . "\t" . "\#consistent read2 (second)" . "\t";
print "junction sequence" . "\t" . "gene (first)" . "\t" . "gene (second)" . "\t" . "known edge (first)"  . "\t" . "known edge (second)" . "\t";
print "chain self" . "\t" . "contig" . "\t" . "contig1" . "\t" . "contig2" . "\t" . "multi map1" . "\t" . "cross map1" . "\t" . "multi map2" . "\t" . "cross map2" . "\t" . "pairNum" . "\t";
print "extended contig1" . "\t" . "extended contig2" . "\t" . "inframe pair" . "\t" . "gene region1" . "\t" . "gene region2" . "\n";

my $input = $ARGV[0];

open(IN, $input) || die "cannot open $!";
while(<IN>) {
    print $_;
}
close(IN);
    

