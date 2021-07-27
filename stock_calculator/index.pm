#!/usr/local/bin/perl

use strict;
use warnings;

use CGI;
use HTML::Template::Pro;

use Web::Query;

our $q = new CGI;
print $q->header('text/html');

my $template =  HTML::Template::Pro->new(
		filename => '/usr/local/www/perl/stock_calculator/index.tmpl',
	);

if ($ENV{'REQUEST_METHOD'} eq 'GET'){
	print $template->output();
}else{
	my $link = $q->param('link');
	if ($link =~ /https:\/\/gov.capital\/stock\/\w+-*\w*\//){
		my $template_list =  HTML::Template::Pro->new(
		filename => '/usr/local/www/perl/stock_calculator/list.tmpl',
	);
		our $arr = [];
		wq($link)	
		->find('tr.grid-group-row + tr td:nth-child(2)')
		->each(sub {
			my $i = shift;
			for my $res (@_){
			    my $hashref = {
				num=>$res->text	
			    };
			    push(@$arr, $hashref);
			}
			});
		$template_list->param(ROWS => $arr);
		print $template_list->output();

	}
	else{
		$template->output();
	}
}

