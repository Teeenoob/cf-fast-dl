#!/usr/bin/perl
use strict;
use warnings;
use File::Basename;

my $dir = dirname(__FILE__);

opendir(my $dh, $dir) or die "Cannot open directory '$dir': $!";

my @maps = map { s/\.bsp$//i; $_ } grep { /\.bsp$/i } readdir($dh);

closedir($dh);

my $outfile = "$dir/mapcycle.txt";
open(my $fh, '>', $outfile) or die "Cannot open file '$outfile': $!";

foreach my $map (@maps) {
    print $fh "$map\n";
}

close($fh);
print "Map names written to $outfile\n";
