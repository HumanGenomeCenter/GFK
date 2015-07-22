#! /usr/local/bin/perl

use strict;

my $input = $ARGV[0]; # input file
my $splitNum = $ARGV[1]; # the number of split files 
my $output = $ARGV[2]; # output file prefix

my @outFiles_handle = ();

# set the filenames (suffixes) and obtain file handles associated to each filename
my $n = 0;
my $char1 = "a";
my $char2 = "a";
my $char3 = "a";
while ($n < $splitNum) {

    
    # get the file names associated to the current characters and file handles.
    #my $filename = $input . "." . ($char3 . $char2 . $char1);
    my $filename = $output . "." . ($char3 . $char2 . $char1);
    open (my $fh,'>', $filename) or die "cannot open $!";
    push @outFiles_handle, $fh;

    # change the current suffix 
    if ($char1 eq "z") {
        if ($char2 eq "z") {
            $char3 = chr(ord($char3) + 1);
            $char1 = "a";
            $char2 = "a";    
        } else {
            $char2 = chr(ord($char2) + 1);
            $char1 = "a";
        }
    } else {
            $char1 = chr(ord($char1) + 1);
    }
    $n = $n + 1;
}


open(IN, $input) || die "cannot open $!";
my $fhInd = 0; # this variable represents the index for each file handle
while(<IN>) {
    print {$outFiles_handle[$fhInd]} $_;
    $_ = <IN>;
    print {$outFiles_handle[$fhInd]} $_;
    $_ = <IN>;
    print {$outFiles_handle[$fhInd]} $_;
    $_ = <IN>;
    print {$outFiles_handle[$fhInd]} $_;

    $fhInd = ($fhInd + 1) % $splitNum;
}
        

