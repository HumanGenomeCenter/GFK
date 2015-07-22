#! /usr/local/bin/perl
#
# Copyright Human Genome Center, Institute of Medical Science, the University of Tokyo
# @since 2012
#

use strict;

my %junction2annot = ();
keys(%junction2annot) = 10000000;

my $inputRefGene = $ARGV[0];
my $inputEnsGene = $ARGV[1];
my $inputKnownGene = $ARGV[2];

print STDERR "Start reading refGene.txt\n";
my $n = 0;
open(IN, $inputRefGene) || die "cannot open $!";
while(<IN>) {
    s/[\r\n\"]//g;
    my @F = split("\t", $_);

    my $chr = $F[2]; 
    my @starts = split(",", $F[9]);
    my @ends = split(",", $F[10]);
    my $strand = $F[3];
    my $exonNum = $F[8];
    my $gene = $F[1];
    my $symbol = $F[12];

    for (my $i = 0; $i <= $#starts; $i++) {

        my $annot = "";
        my $key = $chr . "\t" . $starts[$i] . "\t" . ($starts[$i] + 1);
        if ($strand eq "+") {
            $annot = $symbol . "(" . $gene . ")" . "." . $i . ".start";
        } else {
            $annot = $symbol . "(" . $gene . ")" . "." . ($exonNum - $i) . ".end";
        }

        if (exists $junction2annot{$key}) {
            $junction2annot{$key} = $junction2annot{$key} . "," . $annot;
        } else {
            $junction2annot{$key} = $annot;
        }
    }

    for (my $i = 0; $i <= $#ends; $i++) {
        
        my $annot = ""; 
        my $key = $chr . "\t" . $ends[$i] . "\t" . ($ends[$i] + 1);
        if ($strand eq "+") {
            $annot = $symbol . "(" . $gene . ")" . "." . $i . ".end";
        } else {
            $annot = $symbol . "(" . $gene . ")" . "." . ($exonNum - $i) . ".start";
        }
        
        if (exists $junction2annot{$key}) {
            $junction2annot{$key} = $junction2annot{$key} . "," . $annot;
        } else {
            $junction2annot{$key} = $annot;
        }
    }

    $n = $n + 1;
    if ($n % 1000 == 0) {
        print STDERR "$n genes completed.\n";
    }

}
close(IN);
print STDERR "Reading refGene.txt completed.\n";

print STDERR "Start reading endGene.txt.\n";
my $n = 0;
open(IN, $inputEnsGene) || die "cannot open $!";
while(<IN>) {
    s/[\r\n\"]//g;
    my @F = split("\t", $_);
    
    my @starts = split(",", $F[9]);
    my @ends = split(",", $F[10]);
    my $chr = $F[2];
    my @starts = split(",", $F[9]);
    my @ends = split(",", $F[10]);
    my $strand = $F[3];
    my $exonNum = $F[8];
    my $gene = $F[1];

    for (my $i = 0; $i <= $#starts; $i++) {

        my $annot = "";
        my $key = $chr . "\t" . $starts[$i] . "\t" . ($starts[$i] + 1);
        if ($strand eq "+") {
            $annot = $gene . "." . $i . ".start";
        } else {
           $annot = $gene . "." . ($exonNum - $i) . ".end";
        }

        if (exists $junction2annot{$key}) {
            $junction2annot{$key} = $junction2annot{$key} . "," . $annot;
        } else {
            $junction2annot{$key} = $annot;
        }
    }

    for (my $i = 0; $i <= $#ends; $i++) {

        my $annot = "";
        my $key = $chr . "\t" . $ends[$i] . "\t" . ($ends[$i] + 1);
        if ($strand eq "+") {
            $annot = $gene . "." . $i . ".end";
        } else {
            $annot = $gene . "." . ($exonNum - $i) . ".start";
        }

        if (exists $junction2annot{$key}) {
            $junction2annot{$key} = $junction2annot{$key} . "," . $annot;
        } else {
            $junction2annot{$key} = $annot;
        }
    }

    $n = $n + 1;
    if ($n % 1000 == 0) {
        print STDERR "$n genes completed.\n";
    }

}
close(IN);   

print STDERR "Reading ensGene.txt completed.\n";

print STDERR "Start reading knownGene.txt.\n";

my $n = 0;
open(IN, $inputKnownGene) || die "cannot open $!";
while(<IN>) {
    s/[\r\n\"]//g;
    my @F = split("\t", $_);

    my @starts = split(",", $F[8]);
    my @ends = split(",", $F[9]);
    my $chr = $F[1];
    my $strand = $F[2];
    my $exonNum = $F[7];
    my $gene = $F[0];

    for (my $i = 0; $i <= $#starts; $i++) {

        my $annot = "";
        my $key = $chr . "\t" . $starts[$i] . "\t" . ($starts[$i] + 1);
        if ($strand eq "+") {
            $annot = $gene . "." . $i . ".start";
        } else {
           $annot = $gene . "." . ($exonNum - $i) . ".end";
        }

        if (exists $junction2annot{$key}) {
            $junction2annot{$key} = $junction2annot{$key} . "," . $annot;
        } else {
            $junction2annot{$key} = $annot;
        }
    }

    for (my $i = 0; $i <= $#ends; $i++) {

        my $annot = "";
        my $key = $chr . "\t" . $ends[$i] . "\t" . ($ends[$i] + 1);
        if ($strand eq "+") {
            $annot = $gene . "." . $i . ".end";
        } else {
            $annot = $gene . "." . ($exonNum - $i) . ".start";
        }

        if (exists $junction2annot{$key}) {
            $junction2annot{$key} = $junction2annot{$key} . "," . $annot;
        } else {
            $junction2annot{$key} = $annot;
        }
    }
          
    $n = $n + 1;
    if ($n % 1000 == 0) {
        print STDERR "$n genes completed.\n";
    }
 
}
close(IN);

print STDERR "Reading knownGene.txt completed.\n";

foreach my $junction (sort keys %junction2annot) {
    print $junction . "\t" . $junction2annot{$junction} . "\n";
}


