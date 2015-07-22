#! /usr/local/bin/perl
#
# Copyright Human Genome Center, Institute of Medical Science, the University of Tokyo
# @since 2012
#

use strict;
use warnings;

my $input_contigs = $ARGV[0];
my $input_selected = $ARGV[1];

my $contigSeq = "";
my $contigSeq_1 = "";
my $contigSeq_2 = "";

open(IN, $input_selected) || die "cannot open $!";
$_ = <IN>;
s/[\r\n]//g;
my ($selectedContig0, $strand, $juncSite) = split("\t", $_);
close(IN);

my $selectedContig1 = ">" . $selectedContig0;
# print "(extractCont) selectedContig, strand, juncSite = " . $selectedContig1 . ", " . $strand . ", " . $juncSite . "\n\n";

open(IN, $input_contigs) || die "cannot open $!";
while(<IN>) {
    s/[\r\n]//g;
    last if ($_ =~ /$selectedContig1/);
}

while(<IN>) {
    s/[\r\n]//g;
    last if ($_ =~ /^>/);
    if ($contigSeq eq "") {
        $contigSeq = $_;
    } else {
        $contigSeq = $contigSeq . $_;
    }
}
close(IN);
        
# print "(extractCont) contigSeq = " . $contigSeq . "\n\n";

### Added by sito at 2014/10/22
if ( length($contigSeq) le $juncSite ) {

    print "";

} else {

    $contigSeq_1 = substr($contigSeq, 0, $juncSite);
    $contigSeq_2 = substr($contigSeq, $juncSite, length($contigSeq) - $juncSite);
 
# print "(extractCont) contigSeq(1,2) = " . $contigSeq_1 . ", " . $contigSeq_2 . "\n\n";

    if ($strand eq "+") {
	print $contigSeq . "\t" . $contigSeq_1 . "\t" . $contigSeq_2 . "\n";
    } else {
	print &complementSeq($contigSeq) . "\t" . &complementSeq($contigSeq_2) . "\t" . &complementSeq($contigSeq_1) . "\n";
    }

}
    
sub complementSeq {

    my $tseq = reverse($_[0]);

    $tseq =~ s/A/S/g;
    $tseq =~ s/T/A/g;
    $tseq =~ s/S/T/g;

    $tseq =~ s/C/S/g;
    $tseq =~ s/G/C/g;
    $tseq =~ s/S/G/g;

    return $tseq;
}

