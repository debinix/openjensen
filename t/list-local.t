#!perl

use strict;
use warnings;

use Test::More tests => 5;
use Test::WWW::Mechanize;

my $oj = Test::WWW::Mechanize->new();

$oj->get_ok( 'http://www.mc-butter.se/wui-list-local.html' );
$oj->title_is( 'Visa Jensens utbildningslokaler' );

$oj->form_name( 'list-local' );

$oj->submit();
$oj->content_contains( 'A30' );
$oj->content_lacks( 'X98' );
$oj->content_contains( 'T66' );






