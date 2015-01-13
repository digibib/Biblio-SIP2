package SIP2;
use Data::Dump qw();
our $message_codes;
foreach ( <DATA> ) {
	chomp;
	my ($code,$description) = split(/\t/,$_,2);
	$message_codes->{$code} = $description;
}
# warn "# message_codes ", Data::Dump::dump $message_codes;
sub dump_message {
	my ( $self, $prefix, $message ) = @_;
	my $code = substr($message,0,2);
	#warn $prefix, " ", $message_codes->{$code}, " ", Data::Dump::dump($message), "\n";
}
1;
__DATA__
09  Checkin
10  Checkin_Response
11  Checkout
12  Checkout_Response
15  Hold
16  Hold_Response
17  Item_Information
18  Item_Information_Response
19  Item_Status_Update
20  Item_Status_Update_Response
23  Patron_Status
24  Patron_Status_Response
25  Patron_Enable
26  Patron_Enable_Response
29  Renew
30  Renew_Response
35  End_Patron_Session
36  End_Session_Response
37  Fee_Paid
38  Fee_Paid_Response
63  Patron_Information
64  Patron_Information_Response
65  Renew_All
66  Renew_All_Response
93  Login
94  Login_Response
98  ACS_Status
99  SC_Status