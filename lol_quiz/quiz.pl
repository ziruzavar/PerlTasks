#!/usr/local/bin/perl

use strict;
use warnings;


use CGI;
use JSON;

my $q = new CGI;
#
use DBI;

my $dsn = "DBI:MariaDB:database=lol;host=127.0.0.1;port=3306";
my $dbh = DBI->connect($dsn,'perl', 'password1')
	 or die "Couldn't connect to database: " . DBI->errstr;

my $sth = $dbh->prepare_cached(
	'SELECT name, fi_choice,se_choice,th_choice,fo_choice,answer from quiz');
$sth->execute();
my @arr = ();
while (my $ref = $sth->fetchrow_hashref()){
	my %h = %$ref;
	my $json = encode_json \%h;
	push(@arr, $json);
}
my $json_arr = encode_json(\@arr);

$dbh->disconnect();
print $q->header('text/html');
my $file_to_read = 'quiz.html';

open(FH, '<', $file_to_read) or die $!; 

while(<FH>){
     if ($_ =~ /<body onload="script\(\)">/){
          print "<body onload='script($json_arr)'>"	     
     }else{
          print $_;
     }
}
close(FH);
