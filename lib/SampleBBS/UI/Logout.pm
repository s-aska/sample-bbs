package SampleBBS::UI::Logout;

use strict;
use warnings;

use parent 'SampleBBS::UI';

use Plack::Session;

sub process {
    my ($self, $req) = @_;
    
    my $session = Plack::Session->new($req->env);
    
    $session->expire;
    
    # ログイン後トップページへリダイレクト
    my $url = sprintf '%s://%s/login?logout=1', $req->scheme, $req->env->{'HTTP_X_FORWARDED_HOST'};
    my $res = $req->new_response();
    $res->redirect($url);
    
    return $res;
}

1;
