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

    my @starts = split(",", $F[8]);
    my @ends = split(",", $F[9]);

    for (my $i = 0; $i <= $#starts; $i++) {
        if ($F[1] =~ /chr[\dXYM]+$/) {
            print $F[1] . "\t" . $starts[$i] . "\t" . $ends[$i] . "\t" . $F[0] . "\n";
        }
    }
}
close(IN);

