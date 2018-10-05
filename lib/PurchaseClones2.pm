use strict; use warnings;
package PurchaseClones2;
use feature 'say';
use Moo;
use myfilter;
use FSA::Rules;
use Try::Tiny;

has key => (
   is      => 'rw',
   default => undef,
);

sub new_exchange {
   my ($slug,        $slugtxt, 
       $successmsg,  $successmsgtxt,
       $failuresmsg, $failuresmsgtxt,
       $steps_rc) = @_;
   return PurchaseClones2->new();
}

sub price { say "\t\t\tPurchaseClones price"; 1 }

sub station_area { say "\t\t\tPurchaseClones station_area"; 1 }

sub attempt { say "\t\t\tAttempt: finsh"; 1 }
sub Location  { say "\tLocation";  1 };
sub Wallet    { say "\tWallet";    1 };
sub Clone     { say "\tClone";     1 };
sub Stats     { say "\tStats";     1 };
sub Inventory { say "\tInventory"; 1 };
sub Event     { say "\tEvent";     1 };


sub func1 { say "\tfunc1"; 1 }
sub func2 { say "\tfunc2"; 1 }

sub testeee {
  my ($self) = @_;
    
  my $exchange = $self->new_exchange(
    Steps(
              func1( 1, 2, 3, 4),
              func2( 1, 2, 3, 4),
     ),
    );
}
1;
