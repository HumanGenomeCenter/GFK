#! /usr/local/bin/perl
#
# Copyright Human Genome Center, Institute of Medical Science, the University of Tokyo
# @since 2012
#

use strict;
use warnings;

my $input = $ARGV[0];
my $ID = "";
my $seq = "";

print "\@HD" . "\t" . "VN:1.0" . "\t" . "SO:unsorted" . "\n";


open(IN, $input) || die "cannot open $!";
while(<IN>) {
    s/[\r\n\"]//g;  
    
    if (s/^>//) {

        if ($ID ne "") {
            print "\@SQ" . "\t" . "SN:" . $ID . "\t" . "LN:" . length($seq) . "\n";
        }

        my @F = split(" ", $_);
        $ID = $F[0];
        $seq = "";

    } else {

        $seq = $seq . $_;
    }
}

close(IN);

if ($ID ne "") {
    print "\@SQ" . "\t" . "SN:" . $ID . "\t" . "LN:" . length($seq)     . "\n";
}

 
 
