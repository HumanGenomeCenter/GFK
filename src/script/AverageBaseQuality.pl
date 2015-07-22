#! /usr/local/bin/perl

use strict;

my $input = $ARGV[0];

my %qual2count = ();
my $iter = 1;
open(IN, $input) || die "cannot open $!";
while(<IN>) {

    $_ = <IN>;
    $_ = <IN>;
    $_ = <IN>;
    s/[\r\n]//g;

    if ( $iter % 9973 == 0 ) {
        my @quals = split("", $_);

        for (my $i = 0; $i <= $#quals; $i++) {
            $qual2count{$quals[$i]} = $qual2count{$quals[$i]} + 1;
        }
    }
    $iter += 1;
}
close(IN);


my $baseSum = 0;
my $qualSum = 0;
foreach my $qual (sort keys %qual2count) {
    my $qualValue = ord($qual) - 33;
    $baseSum = $baseSum + $qual2count{$qual};
    $qualSum = $qualSum + $qual2count{$qual} * $qualValue;
    # print $qualValue . "\t" . $qual . "\t" . $qual2count{$qual} . "\n";
}

print $qualSum / $baseSum . "\n";
