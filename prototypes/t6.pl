use strict; use warnings;
use Perl6::Say;
use FSA::Rules;


my ($found, $i) = (0,0);
my $first_in_rule_group;
my @behaves;
my $first_time = 0;
while (<DATA>) {
        if ($found == 0 and /Steps\(/) { 
          $found = 1; 
          my $first_time = 1;
          $first_in_rule_group = $i;

#==============================================================================
          $_ = <<"STUFF0";
(sub {
   my \@behaviors;
   my \$fsa = FSA::Rules->new(
STUFF0
#==============================================================================

        }
        if ($found) {
          if (/;\s*\z/) {
             $found = 0;
             my $save = $_;
#             $_ = "$first_in_rule_group.." . ($i-1) . "\n"; 
             my @sublist = @behaves[$first_in_rule_group..($i-1)];
#             $_ .=    "@sublist\n";
             my $str;
             for my $l (@sublist) {
               if (not(defined($l))) {
                  $str .= 'undef, ';
               } else {
                  $str .= "'$l', ";
               }
             }
             
             my $k = $i-1;

#==============================================================================
             $_ = <<"STUFF2";
   begin => {
      do => sub {
         my \$state = shift;
         \$state->result( begin_trans() );
      },
   },

   end => {
      do => sub {
         my \$state = shift;
         \$state->result( end_trans() );
      },
   },

   ); # end of FSA::Rules->new()
   \@behaviors = ($str);
   try {
      for my \$j ($first_in_rule_group..$k) {
        \$fsa->curr_state("step\$j");
        say \$fsa->curr_state->name;
        my \$label = \$fsa->curr_state->label;
      }
   }
   catch {
      die \$_; # rethrow
   };
   return 1;
} # end of anonymous sub
)->(),
$save
STUFF2
#==============================================================================

          } elsif (/\b(?<post_trans>FAILURE|ALWAYS|ASSERT)\(\s*(?<func>.*?)\)\s*\,\s*\z/) {

#==============================================================================
             my $str = <<"STUFF3";
   step$i => {
      do => sub {
         my \$rc = $+{func};
         my \$state = shift;
         \$state->result(\$rc);
      },
   },
STUFF3
#==============================================================================
             $_ = $str;
             $behaves[$i] = $+{post_trans};
             $i++;

          } elsif ( /\b(?<func>\w.*?)\(\s*(?<args>.*)\)/ ) {
             s/^\s+//;
             s/,\Z//;
             chomp;
             my $temp = $_;

#==============================================================================
             $_ = <<"STUFF4";

   step$i => {
      do => sub {
         my \$rc = $temp;
         my \$state = shift;
         \$state->result(\$rc);
      },
   },
STUFF4
#==============================================================================

             $behaves[$i] = undef;
             $i++;
          } else {
             if (/\s*\),\s*\z/) {
                $_ = "\n";
             }
          }
        }
   print;

}
exit 0;
__DATA__

sub scavenge {
   PurchaseSomeStuffFromGameCrafter(
      'arg1',
      'arg2',
      Steps(
                  func0(),
                  func1(),
                  func2(),
         FAILURE( func3() ),
         ALWAYS(  func4() ),
      ),
   )->attempt;
}
