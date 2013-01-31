#!/usr/bin/perl

use Modern::Perl;

our $user     = 'term1';
our $password = 'term1';
our $patron   = '200000000042';
our $patron_pass = 'sip2-paasswd';
our $barcode  = '1302029710';

require 'config.pl' if -e 'config.pl';

use lib 'lib';
use SIP2::SC;

my $sc = SIP2::SC->new( $ENV{ACS} || '127.0.0.1:6001' );

# login
# print "login: ", $sc->message("9300CN$user|CO$password|");

# SC Status
# $sc->message("9900302.00");

# 6300020130130    104652          AOCPL|AA200000000042|ACsip2-paasswd|
# 6300020130130    104652          AA200000000042|ACsip2-paasswd|
# 63   20130131    103251          AO|AAdemo|AC|ADdemo|
# 63   20130131    121218          AO|AAdemo|AC|ADdemo|
# my $auth = $sc->message("6300020130130    104652          AA$patron|AC$password|");
# my $auth = $sc->message("63   20130131    103251          AO|AAdfghdfsghdfgh|AC|ADwrongpassword|");
my $auth = $sc->message("63   20130131    121218          AO|AAdemo|AC|ADde|");
say "auth: $auth";

__END__

# Checkout
$sc->message("11YN20130130    124436                  AO$loc|AA$patron|AB$barcode|AC$password|BON|BIN|");

# Checkin
$sc->message("09N20130130    08142820091214    081428AP|AO$loc|AB$barcode|AC|BIN|");


# checkout - invalid barcode
$sc->message("09N20130130    15320820091216    153208AP|AOFFZG|AB200903160190|ACviva2koha|BIN|");

# status
$sc->message("9900302.00");

