#!/usr/local/bin/perl

use strict;
use warnings;


use CGI;

my $q = new CGI;

use DBI;

my $dsn = "DBI:MariaDB:database=lol;host=127.0.0.1;port=3306";
my $dbh = DBI->connect($dsn,'perl', 'password1')
	 or die "Couldn't connect to database: " . DBI->errstr;

my $sth = $dbh->prepare_cached(
	'SELECT name, answer from quiz');
$sth->execute();

print $q->header('text/html');
my $file_to_read = 'finish_page.html';

open(FH, '<', $file_to_read) or die $!; 

my $right = $q->param('right');

while(<FH>){
     print $_;
}
if ($right <= 1){
    print "<h4 style='color: red'>You scored $right / 2</h4><h4 style='color: darkred'>Try harder next time!</h4>";	
}else{
    print " <h4 style='color: green'>You scored $right / 2</h4><h4 style='color:slateblue; border-bottom: solid green;'>You did a great job!</h4>";
}
print "<ul>";
while(my $ref = $sth->fetchrow_hashref()){
	print "<li>Right answer to question \"$ref->{'name'}\": $ref->{'answer'}</li>";
}
print "</ul>";
print "</body></html>";


close(FH);
