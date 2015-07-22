#! /usr/local/bin/perl
#
# Copyright Human Genome Center, Institute of Medical Science, the University of Tokyo
# @since 2012
#


use strict;
use warnings;

my $input_list = $ARGV[0];
my $input_contig = $ARGV[1];

my %comb2contig = ();
my $comb = "";
open(IN, $input_contig) || die "cannot open $!";
while(<IN>) {
    s/[\r\n]//g;
   
    if ($_ =~ s/^>//) {
        $comb = $_;
	#print STDERR "(sito) comb   = " . $comb . "\n\n";
    } else {
        $comb2contig{$comb} = $_;
	#print STDERR "(sito) comb, contig = " . $comb . ", " . $comb2contig{$comb} . "\n\n";
    }
}
close(IN);

my $iter = 1;
open(IN, $input_list) || die "cannot open $!";
while(<IN>) {
    s/[\r\n]//g;
    my @F = split("\t", $_);

    # Added by sito at 2014/10/23
    #print STDERR "(sito) iter: F[0], comb2contig = " . $iter . ": " . $F[0] . ", " . $comb2contig{$F[0]} . "\n\n";
    if ( exists($comb2contig{$F[0]}) ) {
	my @contigs = split("\t", $comb2contig{$F[0]});
    
	while($#contigs < 2) {
	    push @contigs, "---";
	}        

	print join("\t", @F) . "\t" . join("\t", @contigs) .  "\n";
    }
    $iter++;
}

close(IN); 
