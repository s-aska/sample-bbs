#!perl

use strict;
use warnings;

use opts;
use SampleBBS::Model;
use Digest::SHA qw(sha256_hex);

opts my $login_id => { isa => 'Str', required => 1, comment => 'admin login_id ex. -l demo' },
     my $password => { isa => 'Str', required => 1, comment => 'admin password ex. -l demo' };

my $password_hash = sha256_hex('SampleBBS' . $password);

my $db = SampleBBS::Model->new;

$db->insert('admin', {
    login_id => $login_id,
    password => $password_hash
});

$db->disconnect;

exit(0);
