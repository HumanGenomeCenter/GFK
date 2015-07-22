#! /usr/local/bin/perl
#
# Copyright Human Genome Center, Institute of Medical Science, the University of Tokyo
# @since 2012
#

use strict;

my $input = $ARGV[0];
open(IN, $input) || die "cannot open $!";
while(<IN>) {
    s/[\r\n]//g;
    my @F = split("\t", $_);

    # Added by sito at 2014/10/23
    if ( $F[14] ne ""  and  $F[15] ne "" ) {
	print ">" . $F[0] . "_contig1" . "\n" . $F[14] . "\n";
	print ">" . $F[0] . "_contig2" . "\n" . $F[15] . "\n";
    }

}
close(IN);


