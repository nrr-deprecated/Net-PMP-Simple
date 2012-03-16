#!perl -T

use Test::More tests => 1;

BEGIN {
    use_ok( 'Net::PMP::Simple' ) || print "Bail out!\n";
}

diag( "Testing Net::PMP::Simple $Net::PMP::Simple::VERSION, Perl $], $^X" );
