package SampleBBS::UI::Admin::Index;

use strict;
use warnings;

use parent 'SampleBBS::UI::Admin';

sub process {
    my ($self, $req) = @_;
    
    $self->render_tx($req, 'admin/index.html');
}

1;
