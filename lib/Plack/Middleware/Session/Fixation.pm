package Plack::Middleware::Session::Fixation;
use strict;
use warnings;

use parent 'Plack::Middleware::Session';

sub commit {
    my($self, $env) = @_;

    my $session = $env->{'psgix.session'};
    my $options = $env->{'psgix.session.options'};

    if ($options->{expire}) {
        $self->store->remove($options->{id});
    } elsif ($options->{change_id}) {
        $self->store->remove($options->{id});
        $options->{id} = $self->generate_id($env);
        $self->store->store($options->{id}, $session);
    } else {
        $self->store->store($options->{id}, $session);
    }
}

1;
