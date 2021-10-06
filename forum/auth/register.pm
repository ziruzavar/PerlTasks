#!/usr/local/bin/perl

use strict;
use warnings;


use CGI;
use JSON;
use HTML::Template::Pro;

my $q = new CGI;

use DBI;
print $q->header('text/html');

my $template = HTML::Template::Pro->new(
	filename => '/usr/local/www/apache24/perl/forum/auth/register.tmpl'
);

if ($ENV{'REQUEST_METHOD'} eq 'GET'){
	print $template->output();
}else{
	print "<p>Here is the POST view</p>";
	my $dsn = "DBI:MariaDB:database=forum;host=127.0.0.1;port=3306";
	my $dbh = DBI->connect($dsn,'perl', 'password1')
		 or die "Couldn't connect to database: " . DBI->errstr;

	my $sth = $dbh->prepare_cached(
		'INSERT INTO users (username, password) values (?, ?)');
	my $password = $q->param('password');
	my $password1 = $q->param('password1');
	my $username = $q->param('username');
	if ($password eq $password1){
		if ($username =~ /^[a-zA-Z0-9]*$/){

			if ( 0 + $sth->execute($username, $password)){
				print "<p>Your account has been created succesfully</p>";				print "<a href='/perl/forum/index.pm'>you can now login</a>";
			}else{
			        print "<p style='color: red'>Username already exists</p>";
			}
		}else{
		         print "<p style='color: red'>Enter a valid username</p>";
		} 

	}else{
		print "<p style='color: red'>Password not matching</p>";
	}

	$dbh->disconnect();
}
