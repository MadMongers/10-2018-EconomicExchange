use strict; use warnings;
use Perl6::Say;


sub _make_args {
   my $str = shift;
   my $args;
   foreach my $x (split/ => /,$str,3) {
#      $x =~ s/ //g;
      if ($x =~ /\A('|\$)/) {
         $args .= qq/$x, /;
      } elsif ($x =~ /\A\{/){
         $args .= qq/$x, /;
      } else {
         $args .= qq/'$x', /;
      }
   }
   return $args;
}
my $found = 0;
while (<DATA>) {
        if ($found == 0 and /Steps\(/) { 
          $found = 1; 
        }
        if ($found) {
          if (/;\s*\z/) {
	     $found = 0;
          } elsif (/\b(?<post_trans>FAILURE|ALWAYS|ASSERT)\(\s*(?<func>\w.*?)\(\s*(?<args>.*)\)\s*\)\s*\,\s*\z/) {
            my $argz = _make_args($+{args});
            $_ = "[ '$+{post_trans}', '$+{func}', [$argz],  ],\n";
          } else {
            if (   /\b(?<func>\w.*?)\(\s*(?<args>.*)\)/   ) {
              my $argz = _make_args($+{args});
              $_ = "[ undef, '$+{func}', [ $argz ],  ],\n";
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
