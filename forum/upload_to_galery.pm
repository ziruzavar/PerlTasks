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
use Image::Scale;
use POSIX qw(strftime);
use CGI::Carp qw(fatalsToBrowser set_message);

our $base_dir = '/usr/local/www/apache24/data/forum_static';


our $q = new CGI;
my $session = CGI::Session->new();

my $cookie = $q->cookie(-name => $session->name,
			-value => $session->id );

my $username = $session->param("username");

my $profile_template = HTML::Template::Pro->new(
	filename => '/usr/local/www/apache24/perl/forum/upload.tmpl',
	);

if (defined $username && $username ne ''){
	if ($ENV{'REQUEST_METHOD'} eq 'GET'){
		print $q->header('text/html', -cookie=>$cookie);
		print $profile_template->output();
	}else{
		$CGI::POST_MAX = 1024 * 5000;
		my %mult = ('small'=>1.2, 'medium'=>1.5, 'large'=>2);
		my $filename = $q->param('img');
		my @name_arr = split('\.', $filename);
		my $format = $name_arr[-1];
		if (!$filename){
			ErrorMessage::display_error("There was a problem uploading your photo (try a smaller file)", "upload_to_galery.pm", $q);
		}else{
		
			my $upload_filehandle = $q->upload("img");
			my $path_to_file = $q->tmpFileName($upload_filehandle);
			
			my $im = Image::Scale->new($path_to_file);
			if (!$im){
				ErrorMessage::display_error("The given file was not an actual image.", "upload_to_galery.pm", $q);
			}else{
			my $width = $im->width();
			my $height = $im->height();

			my $alphaNum = sprintf("%08X", rand(0xFFFFFFFF));
			$filename = $username.$alphaNum;
			if ($width > 640 or $height > 480){
				print $q->header('text/html');
				print "<p>Maximum size is 640x480</p>";
				print "<p>Current width: $width, height: $height</p>";
				print '<a href="/perl/forum/upload_to_galery.pm">Try again</a>';
			}else{
				
				my $small_filename="${filename}small.${format}";
				my $medium_filename="${filename}medium.${format}";
				my $large_filename="${filename}large.${format}";
				
				#Setting the image width to be the same as before,
				#in order to save the original image.
				$im->resize_gd({width=>$width});
				$im->save_jpeg("$base_dir/original/$filename.$format");	

				while (my ($key, $value) = each (%mult)){
				   my $img = Image::Scale->new($path_to_file);
				   my $n_width = $width * $value;
				   my $n_height = $height * $value;
					
				   $img->resize_gd({width=>$n_width, height=>$n_height});
				   my $name = "${filename}${key}.$format";

				   $img->save_jpeg("$base_dir/$key/$name");
				}
				my $date = localtime->strftime('%d/%m/%Y');
				my $query = "INSERT INTO galery(small, medium, large, user, date) VALUES (? , ? , ? , ? , ?)";
				my @args = [$small_filename, $medium_filename, $large_filename, $username, $date];
				QueryFromDB::query($query, @args);
						
				print $session->redirect('http://localhost/perl/forum/galery.pm');

			}

		    }
			
		}
	
	}
}else{
	print $session->redirect('http://localhost/perl/forum/index.pm');
}
	
