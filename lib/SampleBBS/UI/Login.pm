package SampleBBS::UI::Login;

use strict;
use warnings;

use parent 'SampleBBS::UI';

use Digest::SHA qw(sha256_hex);
use Log::Minimal;
use SampleBBS::Model;
use SampleBBS::FormValidator;

my $template = 'login.html';

sub process {
    my ($self, $req) = @_;
    
    unless ($req->param('login')) {
        return
            $self->render_tx($req, $template);
    }
    
    my $login_id = $req->param('login_id');
    my $password_hash = sha256_hex('SampleBBS' . $req->param('password'));
    
    $self->validate($req, [
        login_id => ['NOT_BLANK', 'ASCII'],
        password => ['NOT_BLANK']
    ], $template);
    
    # ログイン
    my $db = SampleBBS::Model->new;
    my $count = $db->count(admin => '*', { login_id => $login_id, password => $password_hash });
    $db->disconnect;
    
    # ログイン失敗
    unless ($count) {
        warnf('login failure: login_id=%s', $login_id);
        
        return
            $self->render_tx($req, $template, { login_failure => 1 });
    }
    
    # セッションIDの振りなおし
    $req->env->{'psgix.session.options'}->{'change_id'}++;
    
    # セッションにユーザを格納
    my $session = $req->env->{'psgix.session'};
    $session->{'admin_login_id'} = $login_id;
    
    # ログイン後トップページへリダイレクト
    my $url = sprintf '%s://%s/admin/index', $req->scheme, $req->env->{'HTTP_X_FORWARDED_HOST'};
    my $res = $req->new_response();
    $res->redirect($url);
    
    return $res;
}

1;
