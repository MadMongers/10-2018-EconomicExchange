#!/usr/bin/env perl
use strict; use warnings;
use Perl6::Say;
use Data::Dumper;
use Ouch;
use Try::Tiny;

my $argz1 = [
        [ 'ASSERT', 'Location', [0], ],
        [ 'ASSERT', 'Location', [1], ],
        [ undef,    'Location', [2], ],
        [ undef,    'Wallet',   [3], ],
        [ undef,    'Clone',    [4], ],
        [ 'FAILURE','Wallet',   [5], ],
        [ 'ALWAYS', 'Wallet',   [6], ],
];
my $argz2 = [
        [ 'ASSERT', 'Location',      [0], ],
        [ 'ASSERT', 'Location',      [1], ],
        [ undef,    'Wallet',        [2], ],
        [ undef,    'Beavis',        [3], ],
        [ undef,    'Clone',         [4], ],
        [ 'FAILURE','Fail-Wallet',   [5], ],
        [ 'ALWAYS', 'Always-Wallet', [6], ],
        [ undef,    'Wallet',        [7], ],
        [ undef,    'Clone',         [8], ],
];

sub st {
   my ($fsa, $to, $from, $args) = @_;
   my $rc=0;
   my $pos1;
   try {
     my $rc = 1;
     for my $j ($to..$from) {
       $pos1 = $j;
       if ((defined($$args[$j][0])) and ($$args[$j][0] eq 'ASSERT')) {
         $rc = say $j, ': ', $$args[$j][1];
	 return if (not ($rc));   # an ASSERT w/ FALSE return code, runaway
       }
       else { last; }
     }
     my $pos2;
     for my $j ($pos1..$from) {
       $pos2 = $j;
       if ( not (defined($$args[$j][0])) ) {
         $rc = say $j, ': ', $$args[$j][1];
	 last if (not ($rc));
       } elsif ((defined($$args[$j][0])) and ($$args[$j][0] eq 'ALWAYS')) {
         $rc = say $j, ': ', $$args[$j][1];
	 last if (not ($rc));
       }
     }
     # have a FALSE return code
     if (not ($rc)) {
       # hit all FAILUREs, starting where ASSERTs left off
       for my $j ($pos1..$from) {
         if ((defined($$args[$j][0])) and ($$args[$j][0] eq 'FAILURE')) {
           $rc = say $j, ': ', $$args[$j][1];
	   # what do you do with a bad return code??
         }
       }
       # find all ALWAYS that were not executed
       # we left off at $pos2
       $pos2++;
       for my $j ($pos2..$from) {
         if ((defined($$args[$j][0])) and ($$args[$j][0] eq 'ALWAYS')) {
           $rc = say $$args[$j][1];
	   # what do you do with a bad return code??
         }
       }
     } 
   } 
   catch {
      die $_; # rethrow
   };

}

#st (undef, 0, $#{$argz1}, \@{$argz1});
st (undef, 0, $#{$argz2}, \@{$argz2});
exit 0;

