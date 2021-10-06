#!/usr/local/bin/perl

use strict;
use warnings;

use lib '/usr/local/www/apache24/perl/forum/functions';

use CGI;
use CGI::Session;
use CGI::Session::Plugin::Redirect;
use SelectFromDB;
use HTML::Template::Pro;
use CGI::Carp qw(fatalsToBrowser set_message);

our $q = new CGI;
my $session = CGI::Session->new();

my $cookie = $q->cookie(-name => $session->name,
			-value => $session->id );

our $galery_template = HTML::Template::Pro->new(
	filename => '/usr/local/www/apache24/perl/forum/galery.tmpl',
	);
our $username = $session->param("username");

if (defined $username && $username ne ''){
	load_galery();

}else{	
	print $session->redirect('http://localhost/perl/forum/index.pm');
}

sub load_galery{
	my $sth = SelectFromDB::select('SELECT * from galery');	

	my $rows= [];
	while (my $ref = $sth->fetchrow_hashref()){
		my $hashref = {
		   username=>$ref->{'user'},
		   date=>$ref->{'date'},
		   small=>$ref->{'small'},
		   medium=>$ref->{'medium'},
		   large=>$ref->{'large'}
		};
		push(@$rows, $hashref);
	}

	$galery_template->param(ROWS => $rows);
	
	print $q->header('text/html', -cookie=>$cookie);
	print $galery_template->output();
}
