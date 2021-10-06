#!/usr/local/bin/perl

use strict;
use warnings;

use lib '/usr/local/www/apache24/perl/forum/functions';

use SelectFromDB;
use QueryFromDB;

my $movie_dir = '/usr/local/www/apache24/data/forum_static';

while (1){	
	my $sth = SelectFromDB::select('SELECT id, status, movie, user FROM status WHERE status="pending" ORDER BY id');
	my $ref = $sth->fetchrow_hashref();
	
	if ($ref){	
		resize($ref);
	}else{
		sleep(15);
	}
	}

sub resize{
	my ($ref) = @_;
	my @args = ($ref->{'id'});
	QueryFromDB::query('UPDATE status SET status="in progress" WHERE id=?',\@args);

	my $movie = $ref->{'movie'};

	system("ffmpeg -i $movie_dir/movies/$movie -vf scale=iw/2:-1 $movie_dir/small_movie/S$movie");
	system("ffmpeg -i $movie_dir/movies/$movie -vf scale=iw\\*1.5:-1 $movie_dir/large_movie/L$movie");


	my $s_movie = "S$movie";
	my $l_movie = "L$movie";
	
	QueryFromDB::query('DELETE FROM status WHERE id=?', \@args);
	
	my @new_args = ($s_movie, $l_movie, $ref->{'user'});
	QueryFromDB::query('INSERT INTO cinema (small, large, user) VALUES (?, ?, ?)', \@new_args);
}
