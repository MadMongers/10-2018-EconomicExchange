package myfilter;
use strict; use warnings;

use Filter::Util::Call;

sub _make_args {
   my $str = shift;
   my $args;
   foreach my $x (split/ => /,$str,3) {
#     Can not tell if a literal string would have a space in it.
#     Leaving to programmers spacing habits
#      $x =~ s/ //g;
#      $x=~s/\s+/ /g ;
#
#     Going with ltrim
      $x =~ s/^\s+//;
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

sub import {
  my ($self,)=@_;
  my ($found)=0;
  my $i=0;
  my $first_in_rule_group;
  my @behaves;
  my $first_time = 0;

  filter_add( 
    sub {
      my ($status) ;

      if (($status = filter_read()) > 0) {
        if ($found == 0 and /Steps\(/) { 
          $found = 1; 
          my $first_time = 1;
          $first_in_rule_group = $i;
          $_ = "(sub {\nmy \@behaviors;\nmy \$fsa = FSA::Rules->new(\n";
        }
        if ($found) {
          if (/;\s*\z/) {
	     $found = 0;
             $found = 0;
             my $save = $_;
             my @sublist = @behaves[$first_in_rule_group..($i-1)];
             my $str;
             for my $l (@sublist) {
               if (not(defined($l))) { $str .= 'undef, '; } 
               else { $str .= "'$l', "; }
             }

             my $k = $i-1;

             $_ = "begin => {\n  do => sub {\n    my \$state = shift;\n    \$state->result( begin_trans() );\n  },\n},\n\nend => {\n  do => sub {\n    my \$state = shift;\n    \$state->result( end_trans() );\n  },\n},\n\n); # end of FSA::Rules->new()\n";
             $_ .= "  \@behaviors = ($str);\n  try {\n    for my \$j ($first_in_rule_group..$k) {\n    \$fsa->curr_state(\"step\$j\");\n    say \$fsa->curr_state->name;\n    my \$label = \$fsa->curr_state->label;\n    }\n  }";
             $_ .= " catch {\n    die \$_; # rethrow\n  };\n  return 1;\n} # end of anonymous sub\n)->(),\n$save\n";
          } elsif (/\b(?<post_trans>FAILURE|ALWAYS|ASSERT)\(\s*(?<func>\w.*?)\(\s*(?<args>.*)\)\s*\)\s*\,\s*\z/) {
             my $argz = _make_args($+{args});
             $_  = "step$i => {\n  do => sub {\n    my \$rc = $+{func}";
             $_ .= "($argz);\n";
             $_ .= "    my \$state = shift;\n    \$state->result(\$rc);\n  },\n},\n";
             $behaves[$i] = $+{post_trans};
             $i++;
          } elsif (   /\b(?<func>\w.*?)\(\s*(?<args>.*)\)/   ) {
             s/^\s+//;
             s/,\Z//;
             chomp;
             my $temp = $_;
             $_ = "\nstep$i => {\ndo => sub {\n    my \$rc = $temp;\n    my \$state = shift;\n    \$state->result(\$rc);\n  },\n},\n";
             $behaves[$i] = undef;
             $i++;
          } else {
             if (/\s*\),\s*\z/) {
                $_ = "\n";
             }
          }
        }
      }
      $status;  # return status;
    } 
 )
}
1 ;
