
use lib qw(lib);
use Plack::Request;
use Plack::Builder;
use Plack::Middleware::Session;
use Plack::Session::Store::File;
use File::Spec::Functions;
use File::Stamped;
use Log::Minimal;
use UNIVERSAL::require;

my $base_class = 'SampleBBS';

my $basedir = $ENV{'SAMPLE_BBS_BASEDIR'} || './';

# ログのパスを生成 (/opt/sample-bbs/log/applog.20101127.log)
my $log_pattern = catfile($basedir, 'log', 'applog.%Y%m%d.log');

my $fh = File::Stamped->new(pattern => $log_pattern);

$Log::Minimal::PRINT = sub {
    my ( $time, $type, $message, $trace) = @_;
    $fh->print("$time [$type] $message at $trace\n");
};

my $app = sub {
    my $env = shift;
    
    my $req = Plack::Request->new($env);
    
    my $path = substr($req->path, -1, 1) eq '/' ? $req->path . 'index' : $req->path;
    
    my $controller = join '::', map { ucfirst($_) } split('/', $path);
    
    my $args = {
        basedir => $basedir
    };
    
    my $res;
    
    my $controller = $base_class . '::UI' . $controller;
    
    infof('controller: %s', $controller);
    
    $controller->use || die $@;
    $controller = $controller->new($args);
    eval {
        $controller->prepare($req);
        $res = $controller->process($req);
        $controller->finalize($req);
    };if ($@) {
        if (UNIVERSAL::isa($@, 'SampleBBS::Terminator')) {
            $res = $@->res;
        } else {
            $res = $req->new_response(200);
            $res->content_type('text/html; charset=UTF-8');
            $res->body($@);
            return $res->finalize;
        }
    }
    
    return $res->finalize;
};

my $session_dir = '/tmp/sessions';

if (!-d $session_dir) {
    mkdir $session_dir;
}

builder {
    enable 'Session::Fixation',
        store => Plack::Session::Store::File->new(
            dir => $session_dir
        );
    $app;
};

