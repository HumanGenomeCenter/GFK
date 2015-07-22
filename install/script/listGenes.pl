#! /usr/local/bin/perl

use strict;

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
    my $start = $F[4];
    my $end = $F[5];
    my $gene = $F[1];
    my $symbol = $F[12];

    print $chr . "\t" . $start . "\t" . $end . "\t" . $symbol . "(" . $gene . ")" . "\n"; 

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
    
    my $chr = $F[2];
    my $start = $F[4];
    my $end = $F[5];
    my $gene = $F[1];

    print $chr . "\t" . $start . "\t" . $end . "\t" . $gene . "\n";


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

    my $chr = $F[1];
    my $start = $F[3];
    my $end = $F[4];
    my $gene = $F[0];
   
    print $chr . "\t" . $start . "\t" . $end . "\t" . $gene . "\n";
 
          
    $n = $n + 1;
    if ($n % 1000 == 0) {
        print STDERR "$n genes completed.\n";
    }
 
}
close(IN);

print STDERR "Reading knownGene.txt completed.\n";



