#!/usr/bin/perl

use strict;
use warnings;
use File::Copy;

# run this script on the first of every month to copy the updated
# monthly Blue Marble image into the working directory.  

# initialize
my $blue_marble_dir = "~/GitHub/xplanet/image_files/Blue_Marble";
my $working_dir = "~/GitHub/xplanet/image_files";

#     0    1    2     3     4    5     6     7     8
my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) =
localtime(time);

my @abbr = qw( Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec );

# process
my $newmonth = $mon + 1;

# this had better not occur - ever!
if ($newmonth > 12) {
    $newmonth = $newmonth - 12
}

my $filemonth = sprintf ("%02d", $newmonth);
my $newfile = $blue_marble_dir . "/world.2004" . $filemonth . ".3x21600x10800.jpg";

my $dest_file = $working_dir . "/earth.jpg";

copy( $newfile, $dest_file ) or die "Copy failed: $!";
