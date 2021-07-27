#!/usr/local/bin/perl

use strict;
use warnings;

use DBI;
use CGI;
use HTML::Template::Pro;
use CGI::Carp qw(fatalsToBrowser set_message);

my $q = new CGI;

my %teams = ('A-team'=>'1', 'B-team'=>1, 'C-team'=>1, 'D-team'=>1, 'E-team'=>1);

print $q->header('text/html');
#Instantiating a new template object to render the form
my $form_template = HTML::Template::Pro->new(
	filename => '/usr/local/www/perl/template_task/form.tmpl',
	);
if ($ENV{'REQUEST_METHOD'} eq 'GET'){
	print $form_template->output();
}else{
	#Storring the input in a hash
	my %hash_input = $q->Vars();

	my $valid = is_valid(\%hash_input);


	if ($valid eq 'True'){

		my $rows = get_data(\%hash_input);
		#Instantiating a new template and populating it with the values
		my $template = HTML::Template::Pro->new(
			filename => '/usr/local/www/perl/template_task/table.tmpl',
			loop_context_vars => 1,
		);
		$template->param(ROWS => $rows);
		
		#Visualizing the given template with relevant data
		print $template->output();
	
		}
	else{
		my $start_row = $hash_input{'start_row'};
		my $end_row = $hash_input{'end_row'};
		$form_template->param((start_row => $start_row, end_row => $end_row));
		print $form_template->output();	
		print "<p>$valid</p>";
	}

}


sub is_valid{
#Checking my input
	my $hashref = shift (@_);
	
	my $start = $hashref->{'start_row'};
	my $limit = $hashref->{'end_row'};
	my $team = $hashref->{'teams'};
	my $order = $hashref->{'order'} || 'ASC';

	my @arr;
	if ($start !~ /^\d+$/ or 399999 < $start  or $start < 0){
		return "Start row should be a number in range 0-399999";
	}
	elsif ($limit !~ /^\d+$/ or 400000 < $limit or $limit < 0){
		return "end row should be a number in range 1-400000";
	}
	elsif (not exists $teams{$team}){
		my $string =  join(" " , keys %teams);
		my $message = "Team needs to be one of these: " . $string;
		return $message;
	}
	elsif ($limit - $start <= 0 or $limit - $start > 10000){
		return "End row should be bigger than Start row and the difference between them should be max-10000 <> min-1";
	}
	elsif ($order ne 'DESC' and $order ne 'ASC'){
		return "You can order only descendingly or ascendingly";
	}else{
		return 'True';
	}
}


sub get_data{
	#If the input is ok proceed here =>
	#
	my $hashref = shift (@_);
	
	my $start = $hashref->{'start_row'};
	my $limit = $hashref->{'end_row'};
	my $team = $hashref->{'teams'};
	my $order = $hashref->{'order'} || 'ASC';

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
	$dbh->disconnect();
	return $rows;
}



