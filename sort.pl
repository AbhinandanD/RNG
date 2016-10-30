#! /usr/bin/perl
use strict;
#use warnings;
use Data::Dumper;
use Getopt::Std;

sub usage{
  print STDERR <<_EOM_
 ---------------------------------------------------------
 Usage: $0 -f <file to sort> -c <column id> -n
 ---------------------------------------------------------
_EOM_
;
  exit 1;
}

my %opts;
getopts('f:c:n',\%opts);

my $file = $opts{f} if(defined $opts{f} && -f $opts{f});
my $numeric = $opts{n};
my $fld = $opts{c} if(defined $opts{c} && $opts{c} =~ /^\d+$/);

&usage if(! defined $file);

$fld = 0 if(! defined $fld);

my @values;

open my $fh, "$file" or die "Error: reading file $!";
while( my $line = <$fh>)
{
  chomp $line;
  my @flds = split(/\s+/, $line);
  push @values, [@flds]; 
}
close $fh;

@values = sort { ($numeric)?($a->[$fld] <=> $b->[$fld]):($a->[$fld] cmp $b->[$fld]) } @values;

foreach my $a (@values){
  foreach my $t (@$a){
    printf "%s\t", $t;
  }
  printf "\n";
}


