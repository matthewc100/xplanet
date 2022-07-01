#!/usr/bin/perl

use strict;
use warnings;
use Image::magick;

my $image;
$image = Image::Magick->new;
open( IMAGE, '/Users/coblem/testing/rectangular.jpg' );
$image->Read( file=>\*IMAGE );

$image->Annotate( gravity=>'southeast', font=>'Arial', pointsize=>20, fill=>'red', x=>500, y=>100, text=>"Quake   Information Last Updated at: Mon Jul  1 21:09:46 2013" );

open( IMAGE, ">/Users/coblemtesting/rectangle.jpg" );
$image->write( file=>\*IMAGE, filename=>'/Users/coblem/testing/rectangle.jpg' );

close (IMAGE);