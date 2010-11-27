package SampleBBS::UI::Index;

use strict;
use warnings;

use parent 'SampleBBS::UI';

use Log::Minimal;

sub process {
    my ($self, $req) = @_;
    
    infof('index');
    
    $self->render_tx($req, 'index.html');
}

1;
