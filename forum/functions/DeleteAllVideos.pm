#!/usr/local/bin/perl

use strict;
use warnings;

use DBI;

sub RmFromSystem{
	my @arr = ('large_movie', 'small_movie', 'movies');
	for my $movie (@arr){
		system("cd /usr/local/www/apache24/data/forum_static/$movie && rm *")
	}	
}

sub RemoveFromDB{
	my $query = "DELETE FROM cinema";

	my $dsn = "DBI:MariaDB:database=forum;host=127.0.0.1;port=3306";
	my $dbh = DBI->connect($dsn,'perl', 'password1')
		or die "Couldn't connect to database: " . DBI->errstr;
			 	
	my $sth = $dbh->prepare_cached($query);	
	$sth->execute();
}

RmFromSystem();
RemoveFromDB();
