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
    if ($_ =~ /^>/) {
        print $_ . "\n";
    } else {
        print uc($_) . "\n";
    }
}
close(IN);

