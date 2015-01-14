package SIP2::SC;

=head1 NAME

SIP2::SC - SelfCheck system or library automation device dealing with patrons or library materials

=cut


use warnings;
use strict;

use IO::Socket::INET;
use Data::Dump qw(dump);
use autodie;

use lib 'lib';
use base qw(SIP2);

sub new {
	my $class = shift;
	my $self;
	$self->{sock} = IO::Socket::INET->new( @_ ) || die "can't connect to ", dump(@_), ": $!";
	warn "# connected to ", $self->{sock}->peerhost, ":", $self->{sock}->peerport, "\n";
	bless $self, $class;
	$self;
}

sub message {
	my ( $self, $send ) = @_;

	if (!$send =~ /^[0-9]{2}/) {
		$self->dump_message( "ILLEGAL MESSAGE - NOT SENDING!", $send);
	  return "ILLEGAL MESSAGE";
	}

	if ($send =~ /^\s*$/) {
		$self->dump_message( "EMPTY STRING - NOT SENDING!", "");
		return "EMPTY MESSAGE";
	}

	local $/ = "\r";

	my $sock = $self->{sock} || die "no sock?";
	my $ip = $self->{sock}->peerhost;

	# Run set of local mods before sending string
	$send = $self->transform_message($send) if $ENV{USE_LOCAL_MODS};

	$send =~ tr/^\n//d;                    # remove <LF> from response
	$send .= "\r" unless $send =~ m/\r/;   # Add <CR> if not already there


	$self->dump_message( ">>>> $ip ", $send );

	print $sock $send;                     # Send message to socket
	$sock->flush;

	my $in = <$sock>;

	warn "ERROR: no response from $ip\n" unless $in;
	$in =~ tr/^\n//d;                      # remove LF from response

	$self->dump_message( "<<<< $ip ", $in );

	return $in;
}

1;
