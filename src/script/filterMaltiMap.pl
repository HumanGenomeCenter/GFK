#! /usr/local/bin/perl
#
# Copyright Human Genome Center, Institute of Medical Science, the University of Tokyo
# @since 2012
#

use strict;
use warnings;

my $input = $ARGV[0];

my %titleHash = ();
$titleHash{"multi map1"} = 1;
$titleHash{"multi map2"} = 1;

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

my $mmIdx1 = $idxArr[0]; 
my $mmIdx2 = $idxArr[1]; 

open(IN,$input) || die "cannot open $input";
while(<IN>) {
  s/[\r\n]//g;
  my @curRow = split("\t", $_);

  next if ($curRow[$mmIdx1] =~ "chrUn");
  next if ($curRow[$mmIdx2] =~ "chrUn");
  next if ($curRow[$mmIdx1] =~ "random");
  next if ($curRow[$mmIdx2] =~ "random");
  
  print $_ . "\n";
}
close(IN);


