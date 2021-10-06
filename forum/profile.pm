#!/usr/local/bin/perl

use strict;
use warnings;

use lib '/usr/local/www/apache24/perl/forum/functions';

use CGI;
use CGI::Session;
use CGI::Session::Plugin::Redirect;
use HTML::Template::Pro;
use SelectFromDB;
use CGI::Carp qw(fatalsToBrowser set_message);


our $q = new CGI;
my $session = CGI::Session->new();

our $cookie = $q->cookie(-name => $session->name,
			-value => $session->id );

our $profile_template = HTML::Template::Pro->new(
	filename => '/usr/local/www/apache24/perl/forum/profile.tmpl',
	);
our $username = $session->param("username") or '';

if (defined $username && $username ne ''){
	load_profile();

}else{	
	print $session->redirect('http://localhost/perl/forum/index.pm');
}

sub load_profile{
	my @args = ($username);
	my $sth = SelectFromDB::select('SELECT * from users WHERE username = ?',\@args);	
	my $ref = $sth->fetchrow_hashref();
	my $image;

	if ($ref->{'image'}){
		$image = $ref->{'image'};
	}else{	
		$image = "profile.jpg";
	}

	$profile_template->param(username=>$username, image_src=>$image);

	print $q->header('text/html', -cookie=>$cookie);
	print $profile_template->output();

}
