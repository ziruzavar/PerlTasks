#!/usr/local/bin/perl

use strict;
use warnings;


use CGI;

my $q = new CGI;

print $q->header('text/html');
my $file_to_read = 'landing_page.html';
open(FH, '<', $file_to_read) or die $!; 

while(<FH>){
print $_;
}
close(FH);
