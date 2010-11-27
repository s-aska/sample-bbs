package SampleBBS::Model::Schema;

use strict;
use warnings;

use DBIx::Skinny::Schema;
use DBIx::Skinny::InflateColumn::DateTime;

install_utf8_columns qw/author title body/;

# 管理者
install_table admin => schema {
    pk 'admin_id';
    columns qw/
        admin_id
        login_id
        password
        last_login
        created_at
        updated_at
    /
};

# 投稿
install_table post => schema {
    pk 'folder_id';
    columns qw/
        folder_id
        thread_id
        author
        title
        body
        created_at
    /
};

1;
