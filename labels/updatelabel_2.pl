#!/opt/local/bin/perl

use strict;
use warnings;
use Image::magick;

my $image;
$image = Image::Magick->new;
open( IMAGE, '/Users/coblem/testing/rectangular.jpg' );
$image->Read( file=>\*IMAGE );

# initialize
my $i;
my $fh;
my $mtime;
my $color;
my $filename;
my $fontsize = "18";

my $directory = "/Users/coblem/xplanet/";
my $outfile = "markers/updatelabel";
my @labelpos = (+500, -500);

# for each component, we obtain:
#   - the marker file location and last modified time
#   - the warning threshold for that component
#   - the alarm threshold for that component

my @config_data = (
    ["Quake  ", "markers/quake", "3600", "21600", ],
    ["NORAD  ", "satellites/NORAD.tle", "86400", "259200", ],
    ["Cloud  ", "image_files/clouds_4096.jpg", "21600", "86400", ],
    ["Volcano", "markers/volcano", "86400", "604800", ],
    ["Fires  ", "markers/fires", "86400", "259200", ],
    ["Storm  ", "markers/storm", "21600", "192800", ],
        );

# processing

# draw the semi-transparent box for the label data.  This box is located at a
# fixed position on the graphic image.  The height of the box is dependent on the
# number of items to be listed, which the count of items in the config_data
# array.
# Then multiply the number of lines by the fontsize (which needs some padding)

my $box_height;
my $box_height = ($#config_data + 1) * ($fontsize + 2);
my $box_width = 600;
my $box_x = 2060;
my $box_y = 1180;

#my @rectangle = ( [($box_x - $box_width), ($box_y - $box_height) ], [$box_x, $box_y] );

# draw the box and fill it with semi-transparent color (the 'a' part of the
# rgba value.

$image->Draw( fill=>'rgba(0,0,0,0.55)', primitive=>'rectangle', points=>'($box_x - $box_width),($box_y - $box_height) $box_x,$box_y');


# loop through configuration data items and obtain:
# full path to marker file, if it exists.  If file does not exist, return error!
# time difference, in days, since script started and last modifed time (-M[FILENAME])
# use the 3rd and 4th columns as warning and alarm thresholds.  If the time
# difference is over the threshold, color code appropriately.

open $fh, ">", ($directory . $outfile);
foreach $i ( 0 .. $#config_data ) {
        $filename = $directory . $config_data[$i][1];
            if ( -e $filename) {             # test if file exists

                $mtime = -M $filename;       # use -M operator to get time difference
        
            if ( ($mtime * 86400) > $config_data[$i][3]) {  # if over alarm value, -->red
                $color = 'red';
            }
            elsif ( ($mtime * 86400) > $config_data[$i][2]) {  # if over alarm value, -->yellow
                $color = 'yellow';
            }
            else {
            $color = 'green';
        }

# print the label information
# at some point, may have to have a routine to calculate the label positions.
# right now, it starts in the upper right corner at -35,-1; and drops 10 pixels
# for every new line.
                
                print $fh ( ($labelpos[0] - ($i*10) ), " ", $labelpos[1], " ", $config_data[$i][0], " Information Last Updated at: ", scalar localtime((stat($filename))[9]), " color=$color image=none position=pixel\n");
    
        }
        else {
            print $fh ( ($labelpos[0] - ($i*10) ), " ", $labelpos[1], " ", "Error! Component \"", $config_data[$i][0], "\" does not exist!!! color=red image=none position=pixel\n");
        }

}
close $fh;