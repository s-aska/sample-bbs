package SampleBBS::FormValidator;

use strict;
use warnings;

use base qw(Exporter);
our @EXPORT = qw(
    validate
);

use FormValidator::Simple;

use SampleBBS::Terminator;

# 入力チェク
sub validate {
    my ($self, $req, $rule, $failure, $param) = @_;
    
    # 入力チェク
    my $result = FormValidator::Simple->check( $req => $rule );
    
    # エラー
    if ( $result->has_error ) {
        
        $param->{'error'} = $result;
        
        my $res = $self->render_tx($req, $failure, $param);
        
        throw SampleBBS::Terminator $res;
    }
}

1;
