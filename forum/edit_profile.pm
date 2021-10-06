#!/usr/local/bin/perl

use strict;
use warnings;

use lib '/usr/local/www/apache24/perl/forum/functions';

use CGI;
use CGI::Session;
use CGI::Session::Plugin::Redirect;
use QueryFromDB;
use ErrorMessage;
use Image::Magick;
use CGI::Carp qw(fatalsToBrowser set_message);

$CGI::POST_MAX = 1024 * 5000;
my $upload_dir = '/usr/local/www/apache24/data/forum_static/user_pictures/';

our $q = new CGI;
my $session = CGI::Session->new();

#my $cookie = $q->cookie(-name => $session->name,
#	-value => $session->id );

my $username = $session->param("username");

my $filename = $q->param('img');

if ( !$filename ){
	ErrorMessage::display_error("There was a problem uploading your photo (try a smaller file","profile.pm", $q)
}else{
	my $im = Image::Magick->new();

	my $upload_filehandle = $q->upload("img");
	my $path_to_file = $q->tmpFileName($upload_filehandle);
	my ($width, $height, $size, $format) = $im->Ping($path_to_file);
	if (!$format){
		ErrorMessage::display_error("The given file was not an actual image.", "profile.pm", $q);

	}else{
		my $alphaNum = sprintf("%08X", rand(0xFFFFFFFF));
		$filename = $username .$alphaNum.'.'. $format;
	
		if ($width > 640 or $height > 480){
			print $q->header('text/html');
			print "$upload_filehandle";
			print "<p>Maximum size is 640x480</p>";
			print "<p>Current width: $width, height: $height</p>";
			print '<a href="/perl/forum/profile.pm">Try again</a>';

		}else{

			open ( UPLOADFILE, ">$upload_dir/$filename" ) or die "$!";
	
			binmode UPLOADFILE;
	
			while ( <$upload_filehandle> )
			{
			print UPLOADFILE;
			}
			close UPLOADFILE;
	
			my $query = 'UPDATE users SET image = ? WHERE username = ?';
			my @args = [$filename, $username];
			QueryFromDB::query($query, @args);
			
			print $session->redirect('http://localhost/apache24/perl/forum/profile.pm');
		}
	}
}

