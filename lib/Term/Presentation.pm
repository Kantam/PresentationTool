package Term::Presentation;

use utf8;
use XML::Simple;
use Term::Presentation::Auto;
use Term::Presentation::Manual;

sub new{
  my $class=shift;
  my $filename=shift;
  my $data=XMLin($filename);
  my $self={
    file=>$filename,
    data=>$data
  };
  # warn "file isnot xml file." unless $filename =~ /$(\.xml)/;
  return bless $self,$class;
}

sub get{
  my $self=shift;
  my $number=shift;
  my $implement=shift;
  print $self->{data}->{anon}->{$number}->{$implement};
  return $self->{data}->{anon}->{$number}->{$implement};
}

sub out{
  my $self=shift;
  my $num=shift||20;
##ここでCONかTimeか判断
  if(($self->{data}->{anon}->{0}->{type} ne "HAND")&&($ARGV[0] ne "HAND")){
    for(my $i=0;$i<$num;$i++){
      if($self->{data}->{anon}->{$i}->{type} eq "Text"){
        $self->TimeText($i);
      }elsif($self->{data}->{anon}->{$i}->{type} eq "marquee"){
        $self->TimeMarquee($i);
      }elsif($self->{data}->{anon}->{$i}->{type} eq "AA"){
        $self->TimeAA($i);
      }elsif($self->{data}->{anon}->{$i}->{type} eq "Code"){
        $self->TimeCode($i);
      }
    }
  }else{
    my $slide=0;
    $self->ConText($slide);
    while($slide<$num){
      chomp(my $in=<STDIN>);
      if($in eq "f"){
        $slide++;
        if($self->{data}->{anon}->{$slide}->{type} eq "REPL"){
          $self->ConRepl($slide);
        }else{
          $self->ConText($slide);
        }
      }elsif($in eq "b"){
        if($slide>0){$slide--;}
        if($self->{data}->{anon}->{$slide}->{type} eq "REPL"){
          $self->ConRepl($slide);
        }else{
          $self->ConText($slide);
        }
      }
    }
  }
}

sub testget{
  my $self=shift;
  my $data=XMLin($self->{file});
  use Data::Dumper;
  warn Dumper $data->{anon};
}
sub testnumber{
  $self=shift;
  print ref $self->{anon};
}

1;

__END__

=encoding utf-8

=head1 NAME

Term::Presentation - Presentation　tool for Console

=head1 SYNOPSIS

perl -MTerm::Presentation -e "new Term::Presentation('slide.xml')->out(4);"

=head1 DESCRIPTION

Term::Presentation is Presentation tool for console.
There are two ways of doing this.One is automatic. The other is manual 

=head1 LICENSE

Copyright (C) kantam.
This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=head1 AUTHOR

Kantam

=cut
