#!/usr/bin/perl -w
package Term::Presentation::Auto;
use utf8;
use Time::HiRes qw/sleep/;
use Image::Term256Color;
use Term::ANSIColor qw{colored};
use Encode;
use encoding "utf-8";

use base qw(Exporter);
@Term::Presentation::Auto::EXPORT = qw(Timephoto TimeText TimeMarquee TimeAA TimeCode);

our $start_time = Time::HiRes::time;

sub Timephoto{
  my $self=shift;
  my $filename=shift;
  for(my $i=0;$i<50;$i++){
    printf("time: %0.3f \n",Time::HiRes::time - $start_time);
    print Image::Term256Color::convert("$filename", {scale_ratio => 1} ) . "\n";
    sleep(0.1);
    system 'clear';
  }

}

sub TimeText{
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
  while(Time::HiRes::time-$current<$tm){
    printf("time: %0.3f \n", Time::HiRes::time - $start_time);
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
    sleep(0.2);
    system 'clear';
  }
}

sub TimeMarquee{
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
  my $col_str=" " x $col;
  my $max=0;
  my @str;
  for(my $j=0;$j<$length;$j++){
    $str[$j]=$col_str.$data[$j].$col_str;
    $max=length($data[$j])>$max?length($data[$j]):$max;
  }

  my $allArray=$col+$max;
  my $bias;
  if($tm/0.2>1){$bias=$tm/(0.2*$allArray)}else{$bias=1;}
  my $round=0;
  OUTER:while($round<$bias+1){
    for(my $i=0;$i<$allArray;$i++){
      if((Time::HiRes::time)-$current>$tm){last OUTER;}
      printf("time: %0.3f \n",Time::HiRes::time - $start_time);
      print colored($head."\n", "red");
      $sen="-"x ($col-1);
      print $sen."\n";
      for(my $j=0;$j<$length;$j++){
        if($color eq "default"){
          print substr($str[$j], $i, ($col))."\n";
        }else{
          print colored(substr($str[$j],$i,($col))."\n","$color");
        }
      }
      sleep(0.2);
      system 'clear';
    }
    $round++;
  }
}

sub TimeCode{
  my $self=shift;
  my $number=shift;
  my $color=$self->{data}->{anon}->{$number}->{color}||"default";
  my $current=Time::HiRes::time;
  my $tm=$self->{data}->{anon}->{$number}->{tm}||30;
  my $head=$self->{data}->{anon}->{$number}->{head}||"header";
  my @data=split(/\n/, $self->{data}->{anon}->{$number}->{data});
  for(my $i=0;$i<5;++$i){push(@data,"\n");}
  my $col=`tput cols`;
  system 'clear';
  my $length=scalar(@data);
  my $bias;
  my $top=0;
  if($tm/0.2>1){$bias=$tm/(0.2*$length)}else{$bias=1;}
  my $round=0;
  OUTER:while($round<$bias+1){
    for(my $i=0;$i<$allArray;$i++){
      if((Time::HiRes::time)-$current>$tm){last OUTER;}
      printf("time: %0.3f \n",Time::HiRes::time - $start_time);
      print colored($head."\n", "red");
      $sen="-"x ($col-1);
      print $sen."\n";
      $top=($round%($length-5));
      for(my $j=$top;$j<$top+5;$j++){
        if($color eq "default"){
          print substr($str[$j], 0, ($col))."\n";
        }else{
          print colored(substr($str[$j],0,($col))."\n","$color");
        }
      }
      sleep(0.2);
      system 'clear';
    }
    $round++;
  }
}

sub TimeAA{
  my $self=shift;
  my $number=shift;
  my $color=$self->{data}->{anon}->{$number}->{color}||"default";
  my $current=Time::HiRes::time;
  my $tm=$self->{data}->{anon}->{$number}->{tm}||30;
  my $head=$ARGV[0]||"data.txt";
  my @data=split(/\n/, $self->{data}->{anon}->{$number}->{data});
  my $file=$head;
  my @AA;
  open(FH,"$file");
  for(my $i;<FH>;$i++){
    chomp;
    $AA[$i]=$_;
  }
  close(FH);

  my $col=`tput cols`;
  system 'clear';

  my @str;
  my $col_str=" " x $col;
  my $max=0;
  for(my $j=0;$j<scalar(@AA);$j++){
    $str[$j]=$col_str.$AA[$j].$col_str;
    $max=length($AA[$j])>$max?length($AA[$j]):$max;
  }
  for(my $i=0;$i<($col+$max);$i++){
    print "\n\n";
    for(my $j=0;$j<scalar(@AA);$j++){
      print substr($str[$j],$i,$col)."\n";
    }
    sleep(0.1);
    system 'clear';
  }


}
1;