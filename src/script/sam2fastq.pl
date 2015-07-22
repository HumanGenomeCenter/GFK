#! /usr/local/bin/perl

use strict;
use warnings;

if (@ARGV != 2){
  print STDERR "The wrong number of argument.";
}

my $fastq1 = $ARGV[0];
my $fastq2 = $ARGV[1];
open(FASTQ1, ">".$fastq1) || die "cannot open $!";
open(FASTQ2, ">".$fastq2) || die "cannot open $!";

while(<STDIN>) {

  next if ($_ =~ /^\@/);

  s/[\r\n]//g;
  my $line1 = $_;
  my @F1 = split("\t", $line1);
  my @flags1 = split("", sprintf("%012b", $F1[1]));
  my $read_paired = $flags1[11];
  
  next if ($read_paired == 0);
  
  my $line2 = <STDIN>;
  $line2 =~ s/[\r\n]//g;
  my @F2 = split("\t", $line2);
  my @flags2 = split("", sprintf("%012b", $F2[1]));
  
  my $first_in_pair1 = $flags1[5];
  my $second_in_pair1 = $flags1[4];
  my $first_in_pair2 = $flags2[5];
  my $second_in_pair2 = $flags2[4];

  my $ID1 = $F1[0];
  my $ID2 = $F2[0];
  
  if ($first_in_pair1 == $first_in_pair2 or $second_in_pair1 == $second_in_pair2) {
  
    if ($ID1 =~ /\/[0-9]$/ and $ID2 =~ /\/[0-9]$/) {

      my $id1_pair_code = substr($ID1,-1);
      my $id2_pair_code = substr($ID2,-1);

      if ($id1_pair_code == 1 and $id2_pair_code == 2) {
        $first_in_pair1 = 1;
        $second_in_pair1 = 0;
        $first_in_pair2 = 0;
        $second_in_pair2 = 1;
      }
      elsif ($id1_pair_code == 2 and $id2_pair_code == 1) {
        $first_in_pair1 = 0;
        $second_in_pair1 = 1;
        $first_in_pair2 = 1;
        $second_in_pair2 = 0;
      } 
      else {
        print STDERR "The wrong sam flags [Error1]: \n";
        print STDERR $ID1."\t".$F1[1]."\n";
        print STDERR $ID2."\t".$F2[1]."\n";
        exit 1;
      }
    }
    else {
      print STDERR "The wrong sam flags [Error2]: \n";
      print STDERR $ID1."\t".$F1[1]."\n";
      print STDERR $ID2."\t".$F2[1]."\n";
      exit 1;
    }
  }

  $ID1 =~ s/\/[0-9]$//g;
  $ID2 =~ s/\/[0-9]$//g;
 
  if ($ID1 ne $ID2) {
    print STDERR "The wrong IDs Pair: \n";
    print STDERR $ID1."\n";
    print STDERR $ID2."\n";
    exit 1;
  }

  # read1
  my $read_reverse_strand1 = $flags1[7];
  my $seq1 = $F1[9];
  my $qual1 = $F1[10];
  if ($read_reverse_strand1 == 1) {
    $seq1 = &complementSeq($seq1);
    $qual1 = reverse($qual1);
  }

  if ($first_in_pair1 == 1) {
    print FASTQ1 "@".$ID1."/1\n";
    print FASTQ1 $seq1."\n"; 
    print FASTQ1 "+\n";
    print FASTQ1 $qual1."\n";
  }
  elsif ($second_in_pair1 == 1) {
    print FASTQ2 "@".$ID1."/2\n";
    print FASTQ2 $seq1."\n";
    print FASTQ2 "+\n";
    print FASTQ2 $qual1."\n";
  }
  else {
    print STDERR "An unexpected error has occurred. ";
    print STDERR "Please check the sam flags : \n";
    print STDERR $ID1."\t".$F1[1]."\n";
    exit 1;
  }

  # read2
  my $read_reverse_strand2 = $flags2[7];
  my $seq2 = $F2[9];
  my $qual2 = $F2[10];
  if ($read_reverse_strand2 == 1) {
    $seq2 = &complementSeq($seq2);
    $qual2 = reverse($qual2);
  }

  if ($first_in_pair2 == 1) {
    print FASTQ1 "@".$ID2."/1\n";
    print FASTQ1 $seq2."\n";
    print FASTQ1 "+\n";
    print FASTQ1 $qual2."\n";
  }
  elsif ($second_in_pair2 == 1) {
    print FASTQ2 "@".$ID2."/2\n";
    print FASTQ2 $seq2."\n";
    print FASTQ2 "+\n";
    print FASTQ2 $qual2."\n";
  }
  else {
    print STDERR "An unexpected error has occurred. ";
    print STDERR "Please check the sam flags : \n";
    print STDERR $ID2."\t".$F2[1]."\n";
    exit 1;
  }
}
close(FASTQ1);
close(FASTQ2);

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

