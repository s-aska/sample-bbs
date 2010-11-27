package SampleBBS::UI;

use strict;
use warnings;

use Encode;
use Text::Xslate qw(mark_raw);
use HTML::FillInForm::Lite qw(fillinform);
use Plack::Session;
use File::Spec::Functions;

sub new {
    my ($class, $args) = @_;
    
    my $basedir = length $args->{'basedir'} ? $args->{'basedir'} : './';
    
    my $self = bless {
        basedir => $basedir
    }, $class;
    
    $self;
}

sub basedir { shift->{'basedir'} }

# 前処理
sub prepare {
    my ($self, $req) = @_;
    
    # 認証処理
    $self->prepare_authorize($req);
    
    # CSRF対策
    $self->prepare_csrf($req);
}

# 認証
sub prepare_authorize {
    my ($self, $req) = @_;
    
#    実装例
#    
#    my $session = $req->env->{'psgix.session'};
#    
#    unless ($session && $session->{'user'}) {
#        
#        my $res = $req->new_response(200);
#        $res->content_type('text/html; charset=UTF-8');
#        $res->body("please login.");
#        
#        return $res;
#    }
#    
#    return ;
}

# CSRF対策
sub prepare_csrf {
    my ($self, $req) = @_;
    
    # endで終わるURLのみを対象とする
    return if $req->path!~/end$/i;
    
    # セッション復帰
    my $session = Plack::Session->new($req->env);
    
    # セッションが存在し、パラメータと同じ場合のみアクセス許可
    unless ($session && ($session->id eq $req->param('session_id'))) {
        
        my $res = $req->new_response(200);
        $res->content_type('text/html; charset=UTF-8');
        $res->body('CSRF.');
        
        throw SampleBBS::Terminator $res;
    }
}

#sub process {
#    
#    warn "no override!!";
#    
#}

sub render_tx {
    my ($self, $req, $template, $params) = @_;
    
    $params ||= {};
    
    $params->{'req'} = $req;
    $params->{'session'} = $req->env->{'psgix.session'};
    $params->{'session_id'} = $req->env->{'psgix.session.options'}->{'id'};
    
    my $template_path = catfile($self->basedir, 'template');
    
    my $tx = Text::Xslate->new(
        syntax => 'TTerse',
        path => [$template_path],
        function => {
            fillinform => sub {
                my ($q) = @_;
                
                return sub { $q ? mark_raw(fillinform($_[0], $q)) : mark_raw($_[0]) };
            }
        }
    );
    
    my $res = $req->new_response(200);
    $res->content_type('text/html; charset=UTF-8');
    $res->body(encode('utf8', $tx->render($template, $params)));
    
    return $res;
}

sub finalize {
    my ($self, $req) = @_;
    
    # endで終わるURLのみを対象とする
    if ($req->path=~/end$/i) {
        
        # フォームセッションを初期化
        my $session = $req->env->{'psgix.session'};
        $session->{'form'} = undef;
    }
}

1;
