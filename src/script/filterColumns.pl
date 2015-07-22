#! /usr/local/bin/perl
#
# Copyright Human Genome Center, Institute of Medical Science, the University of Tokyo
# @since 2012
#

use strict;
use warnings;

my $input = $ARGV[0];

my %titleHash = ();
$titleHash{"final junction"} = 1;
$titleHash{"gene (first)"} = 1;
$titleHash{"gene (second)"} = 1;
$titleHash{"known edge (first)"} = 1;
$titleHash{"known edge (second)"} = 1;
$titleHash{"chain self"} = 1;
$titleHash{"contig"} = 1;
$titleHash{"contig1"} = 1;
$titleHash{"contig2"} = 1;
$titleHash{"pairNum"} = 1;
$titleHash{"extended contig1"} = 1;
$titleHash{"extended contig2"} = 1;
$titleHash{"inframe pair"} = 1;
$titleHash{"gene region1"} = 1;
$titleHash{"gene region2"} = 1;

my @idxArr = ();

open(IN,$input) || die "cannot open $input";
$_ = <IN>;
s/[\r\n]//g;
my @curRow = split("\t", $_);
for( my $idx=0 ; $idx <= $#curRow ; $idx++ ) {
    if ( exists($titleHash{$curRow[$idx]}) ) {
        push( @idxArr, $idx );
    }
}
close(IN);

open(IN,$input) || die "cannot open $input";
while (<IN>) {
  s/[\r\n]//g;
  my @curRow = split("\t", $_);

  my $printRow = "";
  foreach my $idx (@idxArr) {
    #print "idx,curRow = " . $idx . ", " . $curRow[$idx] . "\n";
    print $curRow[$idx] . "\t";
  }
  $printRow = s/\t$//g;
  print $printRow . "\n";
}
close(IN);


