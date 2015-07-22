#! /usr/local/bin/perl
#
# Copyright Human Genome Center, Institute of Medical Science, the University of Tokyo
# @since 2012
#

use strict;
use warnings;

my $input = $ARGV[0];

my $tempRef = "";
my $tempSeq = "";

open(IN, $input) || die "cannot open $!";
while(<IN>) {
    s/[\r\n\"]//g;
    my @F = split("\t", $_);

    if ($tempRef ne $F[0] and $tempRef ne "") {
        
        print ">" . $tempRef . "\n";
        print $tempSeq . "\n";

        $tempSeq = ""; 
    }

    $tempRef = $F[0];
    $tempSeq = $tempSeq . $F[1];

}
close(IN);


          
    
