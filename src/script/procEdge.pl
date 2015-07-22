#! /usr/local/bin/perl
#
# Copyright Human Genome Center, Institute of Medical Science, the University of Tokyo
# @since 2012
#

use strict;

my $input_junc = $ARGV[0];
my $input_edge = $ARGV[1];

my %edgePos2info = ();
open(IN, $input_edge) || die "cannot open $!";
while(<IN>) {
    s/[\r\n]//g;
    my @F = split("\t", $_);
    $edgePos2info{$F[0] . ":" . $F[1] . "-" . $F[2]} = $F[3];
}
close(IN);

open(IN, $input_junc) || die "cannot open $!";
while(<IN>) {
    s/[\r\n]//g;

    my @F = split("\t", $_);

    $F[0] =~ /(\w+):([\+\-])(\d+)\-(\w+):([\+\-])(\d+)\((\w*)\)/;
    my $chr11 = $1;
    my $pos11 = $3;
    my $strand11 = $2;

    my $chr12 = $4;
    my $pos12 = $6;
    my $strand12 = $5;
    my $clip1 = $7;

    $F[3] =~ /(\w+):([\+\-])(\d+)\-(\w+):([\+\-])(\d+)\((\w*)\)/;
    my $chr21 = $1;
    my $pos21 = $3;
    my $strand21 = $2;
    
    my $chr22 = $4;
    my $pos22 = $6;
    my $strand22 = $5;
    my $clip2 = $7;

    my @nums1 = ();
    my @nums2 = ();
    if ($pos11 <= $pos22) {
        @nums1 = ($pos11 .. $pos22);
    } else { 
        @nums1 = ($pos22 .. $pos11);
    }
    if ($strand11  eq "+") {
        @nums1 = map {$_ + 1} @nums1;
    }

    if ($pos21 <= $pos12) {
        @nums2 = ($pos21 .. $pos12);
    } else {
        @nums2 = ($pos12 .. $pos21);
    }
    if ($strand12 eq "+") { 
        @nums2 = map {$_ + 1} @nums2;
    }    

    if ($strand11 eq $strand12) {
        @nums2 = reverse @nums2;
    }

    my @edges1 = ();
    my @edges2 = ();
    my $eNum1 = $nums1[0];
    my $eNum2 = $nums2[0];


    if ($clip1 eq "" and $clip2 eq "" and $#nums1 == $#nums2) {

        for (my $i = 0; $i <= $#nums1; $i++) {

            my $query1 = $chr11 . ":" . ($nums1[$i] - 1) . "-" . $nums1[$i];
            my $query2 = $chr12 . ":" . ($nums2[$i] - 1) . "-" . $nums2[$i];        
    
            if (exists $edgePos2info{$query1} and exists $edgePos2info{$query2}) {

                push @edges1, $edgePos2info{$query1};
                push @edges2, $edgePos2info{$query2};
                $eNum1 = $nums1[$i]; 
                $eNum2 = $nums2[$i];

            }
        }                       

    }


    if ($#edges1 == -1 ) {

        for (my $i = 0; $i <= $#nums1; $i++) {

            for (my $j = 0; $j <= $#nums2; $j++) {

                my $query1 = $chr11 . ":" . ($nums1[$i] - 1) . "-" . $nums1[$i];
                my $query2 = $chr12 . ":" . ($nums2[$j] - 1) . "-" . $nums2[$j];

                if (exists $edgePos2info{$query1}) {

                    push @edges1, $edgePos2info{$query1};
                    $eNum1 = $nums1[$i];
                    $eNum2 = $nums2[$j];

                }
                if (exists $edgePos2info{$query2}) { 
 
                    push @edges2, $edgePos2info{$query2};
                    $eNum1 = $nums1[$i];
                    $eNum2 = $nums2[$j];
                }    
            }  

        }
    }


    $eNum1 = $strand11 eq "+" ? $eNum1 - 1 : $eNum1;
    $eNum2 = $strand12 eq "+" ? $eNum2 - 1 : $eNum2;

    my $juncKey = $chr11 . ":" . $strand11 . $eNum1 . "-" . $chr12 . ":" . $strand12 . $eNum2;
    
    my $edgeBar1 = $#edges1 > -1 ? join(",", @edges1) : "---";
    my $edgeBar2 = $#edges2 > -1 ? join(",", @edges2) : "---";

    print $juncKey . "\t" . join("\t", @F) . "\t" . $edgeBar1 . "\t" . $edgeBar2 . "\n";


}
close(IN);


