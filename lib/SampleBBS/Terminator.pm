package SampleBBS::Terminator;

use strict;
use warnings;

sub throw {
    my ($class, $res) = @_;
    
    my $self = bless { res => $res }, $class;
    
    die $self;
}

sub res {
    shift->{'res'}
}

1;
