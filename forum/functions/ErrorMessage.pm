#!/usr/local/bin/perl
package ErrorMessage;

use strict;
use warnings;

sub display_error{
	my ($msg, $path, $q) = @_;

	print $q->header('text/html');
	print "<p style='color:red'>$msg<p>";
	print "<a href='/perl/forum/$path'>Try again</a>";

}
1;
