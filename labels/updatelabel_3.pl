#!/opt/local/bin/perl

use strict;
use warnings;

# initialize
my $i;
my $fh;
my $mtime;
my $color;
my $filename;

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
    ["Storm  ", "markers/storms", "21600", "192800", ],
        );

# processing

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
