#!/usr/bin/perl

use DateTime;
use Modern::Perl;

our $user     = 'term1';
our $password = 'term1';
our $patronid = '200000000042';
our $patron_pass = 'sip2-paasswd';
our $barcode  = '1302029710';

unless ( $ARGV[0] && $ARGV[1] ) {
    say "Usage: sc-test.pl <username> <password>";
    exit;
}

use lib 'lib';
use SIP2::SC;

my $sc = SIP2::SC->new( '127.0.0.1:6001' );

# login
say "login: ", $sc->message("9300CN$user|CO$password|");

# SC Status
# $sc->message("9900302.00");

# 6300020130130    104652          AOCPL|AA200000000042|ACsip2-paasswd|
# 6300020130130    104652          AA200000000042|ACsip2-paasswd|
# 63   20130131    103251          AO|AAdemo|AC|ADdemo|
# 63   20130131    121218          AO|AAdemo|AC|ADdemo|
# my $auth = $sc->message("6300020130130    104652          AA$patron|AC$password|");
# my $auth = $sc->message("63   20130131    103251          AO|AAdfghdfsghdfgh|AC|ADwrongpassword|");

# Code for the message we want to send. 63 = Patron Information
my $code = '63'; 
# Language - 3 char, fixed lenght, required
my $lang = '   '; 
# Transaction date - 18 char, fixed length, required. Format: YYYYMMDDZZZZHHMMSS
my $dt = DateTime->now;
my $date = $dt->strftime("%Y%m%d    %H%M%S"); 
# Summary - 10 char, fixed lenght, required
my $summary = '          ';
# Institution ID - variable length, required field
my $inst = 'AO|';
# Patron identifier - variable length, required field
my $patron = $ARGV[0];
$patron = "AA$patron|";
# Terminal password - variable length, required field
my $term = "AC|";
# Patron password - variable length, required field
my $pass = $ARGV[1];
$pass = "AD$pass|";

my $msg = $code . $lang . $date . $summary . $inst . $patron . $term . $pass;
say "Message being sent: " . $msg;

say "auth: " . $sc->message( $msg );

__END__

# Checkout
$sc->message("11YN20130130    124436                  AO$loc|AA$patron|AB$barcode|AC$password|BON|BIN|");

# Checkin
$sc->message("09N20130130    08142820091214    081428AP|AO$loc|AB$barcode|AC|BIN|");


# checkout - invalid barcode
$sc->message("09N20130130    15320820091216    153208AP|AOFFZG|AB200903160190|ACviva2koha|BIN|");

# status
$sc->message("9900302.00");

