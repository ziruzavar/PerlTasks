#!/usr/local/bin/perl
use strict;
use warnings;

use lib '/usr/local/www/apache24/perl/forum/daemons';
use VideoDaemon;

VideoDaemon::start();
