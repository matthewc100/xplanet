#!/opt/local/bin/perl

use strict;
use warnings;
use File::stat;

# initialize

my $element;
my $filename;
my $fh;
my @files;
my $sb;

@files = qw( markers/quake markers/volcano satellites/NORAD.tle);
my $directory = "/Users/coblem/xplanet/";

foreach $element (@files) {

    $filename = $directory . $element;
    open $fh, '<', $filename;
    $sb = stat($fh);
    
    printf "File is %s, size is %s, perm %04o, mtime %s\n",
    $filename, $sb->size, $sb->mode & 07777,
    scalar localtime $sb->mtime;

}


