#!/usr/local/bin/perl

use strict;
use warnings;


use CGI;
use CGI::Session;
use CGI::Session::Plugin::Redirect;
use DBI;


our $q = new CGI;
login();

sub login{
	my $username = $q->param('username');
	my $password = $q->param('password');
	

	my $dsn = "DBI:MariaDB:database=forum;host=127.0.0.1;port=3306";
	my $dbh = DBI->connect($dsn,'perl', 'password1')
	 or die "Couldn't connect to database: " . DBI->errstr;

	my $sth = $dbh->prepare_cached('SELECT * from users WHERE username = ?');

	if ($sth->execute($username)){
		my $ref = $sth->fetchrow_hashref();
		if ($password eq $ref->{'password'}){
			my $session = CGI::Session->new();
			$session->param(username=>"$username");
			$session->expire('+1h');
			$session->flush();
			print $session->redirect('http://localhost/perl/forum/index.pm');
		}else{
			print $q->header('text/html');
			print <<"MES";
			<SCRIPT TYPE="TEXT/JAVASCRIPT">
			alert("Wrong password");
			</SCRIPT>
MES
			print "<a href='/perl/forum/index.pm'>Try again</a>";

		}
	}else{
		print $q->header('text/html');
		print <<"MES";
		<SCRIPT TYPE="TEXT/JAVASCRIPT">
		alert("Wrong username");
		</SCRIPT>
MES
		print "<a href='/perl/forum/index.pm'>Try again</a>";

	}
$dbh->disconnect();
}



