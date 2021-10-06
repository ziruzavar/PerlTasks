#!/usr/local/bin/perl
package QueryFromDB;

use strict;
use warnings;

use DBI;


sub query{
	my ($query, $args) = @_;
	my $dsn = "DBI:MariaDB:database=forum;host=127.0.0.1;port=3306";
	my $dbh = DBI->connect($dsn,'perl', 'password1')
		or die "Couldn't connect to database: " . DBI->errstr;
				 	
	my $sth = $dbh->prepare_cached($query);	
	$sth->execute(@$args);
	$dbh->disconnect();
}

1;
