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


        }
        if ($found) {
          if (/Steps\(/) { 
#==============================================================================
          $_ = <<"STUFF0";
(sub {
   my \@behaviors;
   my \$fsa = FSA::Rules->new(
STUFF0
#==============================================================================
          }
          elsif (/;\s*\z/) {
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

          } elsif (/(?<post_trans>FAILURE|ALWAYS|ASSERT)(\()(?<rest>\N.*)(\))\s*,\s*\z/) {

		  #         my \$rc = $+{func};
#==============================================================================
             my $str = <<"STUFF3";
   step$i => {
      do => sub {
         my \$rc = $+{rest};
         my \$state = shift;
         \$state->result(\$rc);
      },
   },
STUFF3
#==============================================================================
             $_ = $str;
             $behaves[$i] = $+{post_trans};
             $i++;

          } elsif (/\(.*(\))\s*,\s*\z/) {
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

      Steps(
                  Location( $self      => is_in_area   => 'clonevat'              ),
                  Wallet(   $self      => pay          => $self->price('cloning') ),
                  Clone(    $self      => gestate      => $self->station_area     ),
         FAILURE( Wallet(   $character => remove       => $bet_amount ) ),
         ALWAYS(  Wallet( $character => show_balance ) ),
      ),
   )->attempt;

 my $exchange = $self->new_exchange(
    slug => 'scavenge',
    Steps(
      ASSERT( Location( $self => can_scavenge => $station_area )),
      ASSERT( Stats( $self => minimum_required => { curr_stamina => $stamina_cost, focus => $focus_cost, })),
              Location( $self => scavenge => { station_area => $station_area, key => $key, }),
      ALWAYS( Stats( $self => remove => { curr_stamina => $stamina_cost })),
              Stats( $self => remove => { focus => $focus_cost }),
              Inventory( $inventory => add_item => { item => $key, new_key => 'found' }),
              Event( $self => store => { event_type => 'find', stashed    => { item => $key } }),
    ),
  );
