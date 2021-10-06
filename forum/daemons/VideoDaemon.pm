#!/usr/local/bin/perl
package VideoDaemon;

use strict;
use warnings;
use Proc::Daemon;

my $daemon = Proc::Daemon->new(
    work_dir => '/usr/local/www/apache24/perl/forum/',
    exec_command => 'perl /usr/local/www/apache24/perl/forum/daemons/check_for_video.pm'
);

sub start{
	my $pid = $daemon->Init();

	$pid = $daemon->Status();
	print "$pid\n";

}

#start();
end();

sub end{

	my $stopped = $daemon->Kill_Daemon();
	print "$stopped\n"
}

1;
