# 10-2018-EconomicExchange

Business State Machine for Transactions Version 2
Proof of concept: Using FSA::Rules

MadMongers presentation Tues-13-Nov-2018

Please review the mdp presentation EEFEE.mdp

run.pl is a sample program ( $perl run.pl )

To see filter output
$ perl -d run.pl


--
main::(run.pl:6):	my $clone = PurchaseClones->new;

  DB<1> n
  
main::(run.pl:7):	$clone->purchase_clone;

DB<1> s

list the code of the lib/Purchase.pm your favorite way
