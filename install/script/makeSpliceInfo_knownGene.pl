#! /usr/local/bin/perl
#
# Copyright Human Genome Center, Institute of Medical Science, the University of Tokyo
# @since 2012
#

use strict;
use warnings;

my $input = $ARGV[0];
open(IN, $input) || die "cannot open $!";
while(<IN>) {
    s/[\r\n\"]//g;
    my @F = split("\t", $_);

    my @starts = split(",", $F[8]);
    my @ends = split(",", $F[9]);

    my @sites = (0);
    my $tempSite = 0;
    for (my $i = 0; $i <= $#starts; $i++) {
        $tempSite = $tempSite + $ends[$i] - $starts[$i];
        push @sites, $tempSite;
    }

    my @gaps = ();
    for (my $i = 0; $i <= ($#starts - 1); $i++) {
        push @gaps, $starts[$i + 1] - $ends[$i];
    }

    print $F[0] . "\t" . $F[1] . "\t" . join(",", @starts) . "\t" . join(",", @sites) . "\t" . join(",", @gaps) . "\n";
}
close(IN); 
