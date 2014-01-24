#!perl

use strict;
use warnings;

use Test::More tests => 2;
use Test::WWW::Mechanize;

my $oj = Test::WWW::Mechanize->new();

$oj->get_ok( 'http://www.mc-butter.se' );
$oj->title_is( 'Open Jensen' );




