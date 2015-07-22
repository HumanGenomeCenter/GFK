#! /usr/local/bin/perl

use strict;

my $input = $ARGV[0];

my %kmer = ();
keys(%kmer) = 300000;

my $file = "$input/sequence1.txt";
my $iter = 0;
open(IN, $file) || die "cannot open $!";
while(<IN>) {

    $_ = <IN>;
    s/[\r\n]//g;

    if ( $iter % 9973 == 0 ) {
	my $reads = $_;

        for (my $i = 0; $i <= length($reads) - 10; $i+=5) {
	    my $temp = substr($reads, $i, 10);
	    #print "i = " . $i . " - " . ($i+9) . "\n";
	    #print "temp = " . $temp . "\n";

	    if (exists $kmer{$temp}){
		$kmer{$temp} = $kmer{$temp} + 1;
	    } 
	    else {
		$kmer{$temp} = 1;
	    }
        }
    }

    $_ = <IN>;
    $_ = <IN>;

    $iter += 1;
}
close(IN);

$file = "$input/sequence2.txt";
$iter = 0;
open(IN, $file) || die "cannot open $!";
while(<IN>) {

    $_ = <IN>;
    s/[\r\n]//g;

    if ( $iter % 9973 == 0 ) {
        my $reads = $_;

        for (my $i = 0; $i <= length($reads) - 10; $i+=5) {
            my $temp = substr($reads, $i, 10);
	    if (exists $kmer{$temp}){
		$kmer{$temp} = $kmer{$temp} + 1;
	    } 
	    else {
		$kmer{$temp} = 1;
	    }
	}
    }
    
    $_ = <IN>;
    $_ = <IN>;
    $iter += 1;
}
close(IN);

foreach my $key (sort keys %kmer) {
    my $value = $kmer{$key};
    print $key . "\t" . $value . "\n";
}
