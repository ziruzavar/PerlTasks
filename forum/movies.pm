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

our $cookie = $q->cookie(-name => $session->name,
			-value => $session->id );

our $galery_template = HTML::Template::Pro->new(
	filename => '/usr/local/www/apache24/perl/forum/movies.tmpl',
	);
our $username = $session->param("username");

if (defined $username && $username ne ""){
	load_cinema();
}else{	
	print $session->redirect('http://localhost/perl/forum/index.pm');
}

sub load_cinema{
	
	my $sth = SelectFromDB::select("SELECT ci.small, ci.large, s.status, ci.user FROM cinema AS ci LEFT JOIN status AS s ON 'status.user'='cinema.user' UNION SELECT ci.small, ci.large, s.status, s.user FROM cinema as ci RIGHT JOIN status AS s ON 'status.user'='cinema.user'");	
	
	my $rows= [];
	while (my $ref = $sth->fetchrow_hashref()){
		my $hashref = {
		   username=>$ref->{'user'},
		   small=>$ref->{'small'},
		   large=>$ref->{'large'},
		   status=>$ref->{'status'}
		};
		if (!$hashref->{'status'}){
			$hashref->{'status'} = 'Completed';
		}
		push(@$rows, $hashref);
	}

	$galery_template->param(ROWS => $rows);

	print $q->header('text/html', -cookie=>$cookie);
	print $galery_template->output();	

}
