#!/usr/local/bin/perl
package SelectFromDB;

use strict;
use warnings;

use DBI;


sub select{
	my ($query, $args) = @_;
	my $dsn = "DBI:MariaDB:database=forum;host=127.0.0.1;port=3306";
	my $dbh = DBI->connect($dsn,'perl', 'password1')
		or die "Couldn't connect to database: " . DBI->errstr;
				 	
	my $sth = $dbh->prepare_cached($query);
	if ($args){
		$sth->execute(@$args);
	}else{
		$sth->execute();
	}
	return $sth;
}

1;
