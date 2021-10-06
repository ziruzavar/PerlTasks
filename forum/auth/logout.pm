#!/usr/local/bin/perl

use strict;
use warnings;


use CGI;
use CGI::Session;
use CGI::Session::Plugin::Redirect;

my $q = new CGI;
my $session = CGI::Session->new();

my $cookie = $q->cookie(-name => $session->name,
			-value => $session->id );

$session->clear();
$session->delete();

print $session->redirect('http://localhost/perl/forum/index.pm');


