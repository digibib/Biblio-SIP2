# Simple 3M SIP2 Standard Interchange Protocol implementation in perl

## Setup / Requirements

In Ubuntu, to install Data::Dump module

    sudo apt-get install -y libdata-dump-perl

## Usage

to run the acl proxy server

    ./acl-proxy.pl <listen host:port> <sipserver host:port>

e.g.

    ./acs-proxy.pl localhost:6002 192.168.50.12:6001

to run the emulation:

    cp config.pl.example config.pl

modify `connfig.pl` to use real users and barcodes, and run

    ACL=<sipserver host:port> ./sc-emulation

## Tests

./prove

## Why do we need another SIP2 implementation?

That's a great question! Mostly because others are wrong in one way or another, most
importantly: 


	protocol specifies that messages must end with <CR> (ASCII 13)

	most implementation put CR/LF or (even worse) just LF


This is very annoying, and creating simple and correct implementation seems to make sense.


References:

* http://solutions.3m.com/wps/portal/3M/en_US/library/home/resources/protocols/

Exiting implementations:

* http://openncip.org/
* http://www.rice.edu/perl4lib/archives/2003-05/msg00032.html
* http://code.google.com/p/php-sip2/source/browse/trunk/sip2.class.php

