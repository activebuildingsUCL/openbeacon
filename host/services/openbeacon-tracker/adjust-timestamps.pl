#!/usr/bin/perl -w
#***************************************************************
# *
# * OpenBeacon.org - a script that can be used in a pipeline
# * to "fix" the output of openbeacon-sdcard by converting from
# * milliseconds to seconds and applying an offset POSIX time
# * corresponding to when data collection started (i.e. reader was 
# * turned on). Will read from stdin, so should be used in a pipeline
# * ex. usage 
# * ./openbeacon-sdcard LOGFILEA.BIN CONVERTED_LOGFILEA.BIN
# * ./openbeacon-tracker CONVERTED_LOGFILEA.BIN | ./adjust-timestamps.pl 1364855267 | ./filter-mongodb
# *
# * Copyright 2013 Marek Laskowski <mareklaskowski at gmail dot com>
# *
# ***************************************************************/

#/*
# This program is free software; you can redistribute it and/or modify
# it under the terms of the GNU Affero General Public License as published
# by the Free Software Foundation; version 3.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU Affero General Public License
# along with this program; if not, write to the Free Software Foundation,
# Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
#*/

$numArgs = $#ARGV + 1;
if($numArgs != 1)
{
	print "adjust-timestamps.pl usage: adjust-timestamps.pl <offset time (unix format)>\n";
	print "but you probably want to use it in a pipeline like so:\n";
	print "./openbeacon-tracker CONVERTED_LOGFILEA.BIN | ./adjust-timestamps.pl 1364855267 | ./filter-mongodb\n";
	exit(0);
}
$offset = $ARGV[0];
foreach $line ( <STDIN> ) {
    chomp( $line );
    if($line =~ m/(^\s+\"time\"\:\d+,$)/)
    {
	#print $line;
	$line =~ m/(\d+)/;
	$time = $1;
    	#print "time is : $time\n";
    	$time = $time/1000; #convert to seconds
    	$time += $offset; #add the time offset
    	$time = int($time);
    	$line = "  \"time\":" . $time . ","
    }
    print "$line\n";
}
