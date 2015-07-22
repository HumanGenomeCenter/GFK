#! /usr/local/bin/perl
#
# Copyright Human Genome Center, Institute of Medical Science, the University of Tokyo
# @since 2012
#

use strict;

my $input = $ARGV[0];

open(IN, $input) || die "cannot open $!";
while(<IN>) {
    s/[\r\n\"]//g;
    my @F = split("\t", $_);

    if ($F[8] eq "+") {
        print $F[2] . "\t" . $F[4] . "\t" . $F[5] . "\t" . $F[6] . "\t" . $F[9] . "\t" . $F[10] . "\t" . $F[11] . "\t" . $F[12] . "\t" . "+" . "\t" .  "+" . "\n";
    } else {
        print $F[2] . "\t" . $F[4] . "\t" . $F[5] . "\t" . $F[6] . "\t" . ($F[7] - $F[10]) . "\t" . ($F[7] - $F[9]) . "\t" . $F[11] . "\t" . $F[12] . "\t" . "+" . "\t" .  "-" . "\n";
    }
}
close(IN);

