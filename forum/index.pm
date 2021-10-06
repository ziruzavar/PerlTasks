#!/usr/local/bin/perl

use strict;
use warnings;

use CGI;
use CGI::Session;
use CGI::Session::Plugin::Redirect;
use HTML::Template::Pro;
use CGI::Carp qw(fatalsToBrowser set_message);


our $q = new CGI;

my $session = CGI::Session->new();

my $cookie = $q->cookie(-name => $session->name,
			-value => $session->id );

print $q->header('text/html', -cookie=>$cookie);

my $form_template = HTML::Template::Pro->new(
	filename => '/usr/local/www/apache24/perl/forum/index.tmpl',
	);
our $username = $session->param("username") or '';

if (defined $username && $username ne ''){
	$form_template->param(username=>$username, bool=>1);
}else{	
	$form_template->param(bool=>0);
}
print $form_template->output();
