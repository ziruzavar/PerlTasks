#!/usr/local/bin/perl

use strict;
use warnings;

use CGI;
use HTML::Template::Pro;

my $q = new CGI;

print $q->header('text/html');
my $template = HTML::Template::Pro->new(
	filename => '/usr/local/www/perl/template_task/form.tmpl',
	);
print $template->output();
print "MOD_PERL: $ENV{MOD_PERL}"
