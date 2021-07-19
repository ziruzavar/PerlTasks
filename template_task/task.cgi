#!/usr/local/bin/perl

use strict;
use warnings;

use DBI;
use CGI;
use HTML::Template::Pro;

my $q = new CGI;

my %teams = ('A-team'=>'1', 'B-team'=>1, 'C-team'=>1, 'D-team'=>1, 'E-team'=>1);

print $q->header('text/html');

#Collecting input
my $start = $q->param('start_row');
my $limit = $q->param('end_row');
my $team = $q->param('teams');
my $order = $q->param('order') || 'ASC';

#Instantiating a new template object to render the errors
my $error_template = HTML::Template::Pro->new(
		filename => '/usr/local/www/perl/template_task/error.tmpl',
	);

#Checking my input
if ($start !~ /^\d+$/ or 399999 < $start  or $start < 0){
		$error_template->param(MESSAGE => "Start row should be a number in range 0-399999");
		print $error_template->output();
}
elsif ($limit !~ /^\d+$/ or 400000 < $limit or $limit < 0){
	$error_template->param(MESSAGE => "End row should be a number in range 1-400000");
		print $error_template->output();
}
elsif (not exists $teams{$team}){
	my $string =  join(" " , keys %teams);
	my $message = "Team needs to be one of these: " . $string;
	$error_template->param(MESSAGE => $message);
	print $error_template->output();
}
elsif ($limit - $start <= 0 or $limit - $start > 10000){
	$error_template->param(MESSAGE => "End row should be bigger than Start row and the difference between them should be max-10000 <> min-1");
	print $error_template->output();

}
elsif ($order ne 'DESC' and $order ne 'ASC'){
	$error_template->param(MESSAGE => "You can order only descendingly or ascendingly");
	print $error_template->output();

}else{	#If the input is ok proceed here =>
	#Setting the database connection
	my $dsn = "DBI:MariaDB:database=test1;host=127.0.0.1;port=3306";
	my $dbh = DBI->connect($dsn,'cgi', 'password')
	 or die "Couldn't connect to database: " . DBI->errstr;
	
 	#Preparing 'Select' statement
 	my $sth = $dbh->prepare_cached(
		"SELECT pk, name, num, choices FROM task WHERE choices = ? order by pk $order LIMIT ?, ?");
	
	#Executing my query
	my $end_row = $limit-$start;
	$sth->execute($team, $start, $end_row);
	
	#Preparing a data structure for HTML:Template
	my $rows = [];
	while (my $ref = $sth->fetchrow_hashref()){
		my $hashref = {
		   col_pk=>$ref->{'pk'},
		   col_name=>$ref->{'name'},
		   col_num=>$ref->{'num'},
		   col_team=>$ref->{'choices'}
		};
		push(@$rows, $hashref);
	}
	
	#Instantiating a new template and populating it with the values
	my $template = HTML::Template::Pro->new(
		filename => '/usr/local/www/perl/template_task/table.tmpl',
		loop_context_vars => 1,
	);
	$template->param(ROWS => $rows);
	
	#Visualizing the given template with relevant data
	print $template->output();

	$dbh->disconnect();
}



