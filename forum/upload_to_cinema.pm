#!/usr/local/bin/perl

use strict;
use warnings;

use lib '/usr/local/www/apache24/perl/forum/functions';

use CGI;
use CGI::Session;
use CGI::Session::Plugin::Redirect;
use HTML::Template::Pro;
use QueryFromDB;
use ErrorMessage;
use Time::Piece;
use MP4::Info;
use POSIX qw(strftime);
use CGI::Carp qw(fatalsToBrowser set_message);

our $upload_dir = '/usr/local/www/apache24/data/forum_static/movies/';


our $q = new CGI;
my $session = CGI::Session->new();

my $cookie = $q->cookie(-name => $session->name,
			-value => $session->id );

my $username = $session->param("username");

my $profile_template = HTML::Template::Pro->new(
	filename => '/usr/local/www/apache24/perl/forum/upload_movie.tmpl',
	);

if (defined $username && $username ne ''){
	if ($ENV{'REQUEST_METHOD'} eq 'GET'){
		print $q->header('text/html', -cookie=>$cookie);
		print $profile_template->output();
	}else{
		$CGI::POST_MAX = 1024 * 50000;
		my $filename = $q->param('movie');
		my @name_arr = split('\.', $filename);
		my $format = $name_arr[-1];
		if (!$filename){
			ErrorMessage::display_error("There was a problem uploading your video (try a smaller file).", 'upload_to_cinema.pm', $q);
	
		}else{
			my $upload_filehandle = $q->upload("movie");
			my $path_to_file = $q->tmpFileName($upload_filehandle);

			my $info = get_mp4info($upload_filehandle);

			if (!$info){
				ErrorMessage::display_error("The given file was not an actual video", 'upload_to_cinema.pm', $q);
			}else{
			my $alphaNum = sprintf("%08X", rand(0xFFFFFFFF));
			$filename = $username.$alphaNum.'.'.$format;
			
			save_files($path_to_file, $filename);
							
			my $time = localtime->strftime('%S:%M:%H');
			my $query = 'INSERT INTO status(status, start_time, movie, user)
				VALUES("pending", ?, ?, ?)';
			my @args = [$time, $filename, $username];
			
			QueryFromDB::query($query, @args);

			print $session->redirect('http://localhost/perl/forum/movies.pm');
			}
		}
	}
	
}else{
	print $session->redirect('http://localhost/perl/forum/index.pm');
}


sub save_files{
	my ($path_to_file, $filename) = @_;

	open(SRC, '<', $path_to_file) or die $!;
	open (UPLOADFILE, '>', "$upload_dir/$filename") or die "$!";
			
	while ( <SRC> )
	{
		print UPLOADFILE $_;
	}
	close (SRC);
	close UPLOADFILE;
}
