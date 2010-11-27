CREATE SEQUENCE admin_admin_id_seq START 100000;
CREATE TABLE admin (
    admin_id BIGINT NOT NULL PRIMARY KEY DEFAULT nextval('admin_admin_id_seq')
    , login_id TEXT NOT NULL UNIQUE
    , password TEXT NOT NULL
    , last_login TIMESTAMP
    , created_at TIMESTAMP DEFAULT now()
    , updated_at TIMESTAMP
);
COMMENT ON COLUMN admin.password IS 'ƒnƒbƒVƒ…';
CREATE SEQUENCE post_folder_id_seq START 100000;
CREATE TABLE post (
    folder_id BIGINT NOT NULL PRIMARY KEY DEFAULT nextval('post_folder_id_seq')
    , thread_id BIGINT NOT NULL REFERENCES thread ON DELETE CASCADE
    , author TEXT NOT NULL
    , title TEXT NOT NULL
    , body TEXT NOT NULL
    , created_at TIMESTAMP NOT NULL DEFAULT now()
);