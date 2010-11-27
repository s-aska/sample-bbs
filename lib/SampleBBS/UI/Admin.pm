package SampleBBS::UI::Admin;

use strict;
use warnings;

use parent 'SampleBBS::UI';

use SampleBBS::Terminator;
use SampleBBS::Model;

# 認証チェック
sub prepare_authorize {
    my ($self, $req) = @_;
    
    my $session = $req->env->{'psgix.session'};
    
    # ログインしているか
    unless ($session && $session->{'admin_login_id'}) {
        my $url = sprintf '%s://%s/login?session_expire=1', $req->scheme, $req->env->{'HTTP_X_FORWARDED_HOST'};
        my $res = $req->new_response();
        $res->redirect($url);
        
        throw SampleBBS::Terminator $res;
    }
    
    # DBに現存しているか（セッション有効期間中にDBから削除された場合、強制ログアウト）
    my $db = SampleBBS::Model->new;
    
    my $count = $db->count(
        admin => '*',
        {
            login_id => $session->{'admin_login_id'}
        }
    );
    
    $db->disconnect;
    
    unless ($count) {
        delete $session->{'admin_login_id'};
        
        my $url = sprintf '%s://%s/login?missing_admin=1', $req->scheme, $req->env->{'HTTP_X_FORWARDED_HOST'};
        my $res = $req->new_response();
        $res->redirect($url);
        
        throw SampleBBS::Terminator $res;
    }
    
}

1;
