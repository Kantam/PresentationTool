#!/usr/bin/perl -w
package Term::Presentation::Manual;
use utf8;
use Encode;
use encoding "utf-8";
use Term::ANSIColor qw{colored};

use base qw(Exporter);
@Term::Presentation::Manual::EXPORT = qw(ConText ConRepl);

sub ConText{

  my $self=shift;
  my $number=shift;
  my $color=$self->{data}->{anon}->{$number}->{color}||"default";
  my $current=Time::HiRes::time;
  my $tm=$self->{data}->{anon}->{$number}->{tm}||30;
  my $head=$self->{data}->{anon}->{$number}->{head}||"header";
  my @data=split(/\n/, $self->{data}->{anon}->{$number}->{data});
  my $col=`tput cols`;
  system 'clear';
  my $length=scalar(@data);
  print colored($head."\n", "red");
  $sen="-"x ($col-1);
  print $sen."\n";
  for(my $j=0;$j<$length;$j++){
    if($color eq "default"){
      print substr($data[$j], 0, ($col))."\n";
    }else{
      print colored(substr($data[$j],0,($col))."\n","$color");
    }
  }

}

sub ConRepl{
  use Term::ReadLine;
  system 'clear';

  my $self=shift;
  my $number=shift;
  my $color=$self->{data}->{anon}->{$number}->{color}||"default";
  my $current=Time::HiRes::time;
  my $tm=$self->{data}->{anon}->{$number}->{tm}||30;
  my $head=$self->{data}->{anon}->{$number}->{head}||"header";
  my @data=split(/\n/, $self->{data}->{anon}->{$number}->{data});
  my $col=`tput cols`;
  system 'clear';
  my $length=scalar(@data);
  print colored($head."\n", "red");
  $sen="-"x ($col-1);
  print $sen."\n";
  $term = new Term::ReadLine 'my_term';
  $prompt = "input :";
  $OUT = $term->OUT || STDOUT;
  OUTER:while ( defined ($_ = $term->readline($prompt)) ) {
    if($_ eq "q"){last OUTER;}
    print $OUT "output:".eval($_)."\n";
    $term->addhistory($_) if /\S/;

  }
}

1;
