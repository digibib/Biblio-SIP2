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

my $sc = SIP2::SC->new( '127.0.0.1:1965' );

# login
# say "login: ", $sc->message("9300CN$user|CO$password|");

# SC Status
# $sc->message("9900302.00");

# 6300020130130    104652          AOCPL|AA200000000042|ACsip2-paasswd|
# 6300020130130    104652          AA200000000042|ACsip2-paasswd|
# 63   20130131    103251          AO|AAdemo|AC|ADdemo|
# 63   20130131    121218          AO|AAdemo|AC|ADdemo|
# my $auth = $sc->message("6300020130130    104652          AA$patron|AC$password|");
# my $auth = $sc->message("63   20130131    103251          AO|AAdfghdfsghdfgh|AC|ADwrongpassword|");

my $patron = $ARGV[0];
my $pass   = $ARGV[1];

## Send the Patron Status Request
say "Patron Status Request";

# Code for the message we want to send. 23 = Patron Status Request
my $code23 = '23'; 
# Language - 3 char, fixed lenght, required
my $lang23 = '   '; 
# Transaction date - 18 char, fixed length, required. Format: YYYYMMDDZZZZHHMMSS
my $dt23 = DateTime->now;
my $date23 = $dt23->strftime("%Y%m%d    %H%M%S"); 
# Institution ID - variable length, required field
my $inst23 = 'AO|';
# Patron identifier - variable length, required field
my $patron23 = "AA$patron|";
# Terminal password - variable length, required field
my $term23 = "AC|";
# Patron password - variable length, required field
my $pass23 = "AD$pass|";

my $msg23 = $code23 . $lang23 . $date23 . $inst23 . $patron23 . $term23 . $pass23;
say "\tMessage:  " . $msg23;

my $record23 = $sc->message( $msg23 );
$record23 = _clean_sip2_reply( $record23 );
say "\tResponse: " . $record23;

## Send the Patron Information message
say "Patron Information";

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
$patron = "AA$patron|";
# Terminal password - variable length, required field
my $term = "AC|";
# Patron password - variable length, required field
$pass = "AD$pass|";

my $msg = $code . $lang . $date . $summary . $inst . $patron . $term . $pass;
say "\tMessage:  " . $msg;

say "\tResponse: " . $sc->message( $msg );

sub _clean_sip2_reply {

    my ( $s ) = @_;

    # Borrowed from Koha's C4::SIP::Sip
    $s =~ s/^\s*[^A-z0-9]+//s; # Every line must start with a "real" character.  Not whitespace, control chars, etc. 
    $s =~ s/[^A-z0-9]+$//s;    # Same for the end.  Note this catches the problem some clients have sending empty fields at the end, like |||
    $s =~ s/\015?\012//g;      # Extra line breaks must die
    $s =~ s/\015?\012//s;      # Extra line breaks must die
    $s =~ s/\015*\012*$//s;    # treat as one line to include the extra linebreaks we are trying to remove!
    
    return $s;

}

__END__

# Checkout
$sc->message("11YN20130130    124436                  AO$loc|AA$patron|AB$barcode|AC$password|BON|BIN|");

# Checkin
$sc->message("09N20130130    08142820091214    081428AP|AO$loc|AB$barcode|AC|BIN|");


# checkout - invalid barcode
$sc->message("09N20130130    15320820091216    153208AP|AOFFZG|AB200903160190|ACviva2koha|BIN|");

# status
$sc->message("9900302.00");

