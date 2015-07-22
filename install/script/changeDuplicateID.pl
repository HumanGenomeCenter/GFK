#! /usr/local/bin/perl
#
# Copyright Human Genome Center, Institute of Medical Science, the University of Tokyo
# @since 2012
#

use strict;

my $input = $ARGV[0];

my %idHash = ();
my %duplicateIDs = ();

open(IN, $input) || die "cannot open $!";
while(<IN>) {
  s/[\r\n\"]//g;

  if ($_ =~ s/^>//) {
    if (defined $idHash{$_}) {
      $duplicateIDs{$_} = "A";
    }
    else {
      $idHash{$_} = 1;
    }
  }
}
close(IN);

open(IN, $input) || die "cannot open $!";
while(<IN>) {
  s/[\r\n\"]//g;

  if ($_ =~ s/^>//) {
    if (defined $duplicateIDs{$_}) {
      print ">" . $_ . "_" . $duplicateIDs{$_} . "\n";
      $duplicateIDs{$_} = ++($duplicateIDs{$_});
    } else {
      print ">" . $_ . "\n";
    }
  } else {
    print $_ . "\n";
  }
}
close(IN);

