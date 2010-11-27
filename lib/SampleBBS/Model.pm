package SampleBBS::Model;

use DBIx::Skinny connect_info => {
    dsn      => 'dbi:Pg:',
    username => 'sample-bbs',
    password => 'sample-bbs',
    connect_options => +{
        RaiseError => 1,
        PrintError => 0,
        AutoCommit => 1
    }
};

use DBIx::Skinny::Mixin modules => ['Pager'];

1;
