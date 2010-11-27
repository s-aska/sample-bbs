


# DB作成
su - postgres -c "createuser -S -R -D sample-bbs"
su - postgres -c "createdb -O sample-bbs sample-bbs -E UTF-8 -T template0"

# DDL流しこみ
psql -U sample-bbs sample-bbs -f ./setup/ddl.sql

# ApacheのReverseProxyに組み込む場合
ln -s /opt/sample-bbs/apache-conf/sample-bbs.conf /etc/httpd/conf.d/sample-bbs.con
/etc/init.d/httpd restart

# 手動で起動 (開発時)
SAMPLE_BBS_BASEDIR=./ plackup -p 18080 -a app.psgi -r -R ./lib,./template

- cpanm等で予めPlackをインストール
- 足りないモジュールは都度インストール

# Initスクリプトで起動 (デーモン)
/opt/sample-bbs/init.d/sample-bbs.sh start

# chkconfig 登録
ln -s /opt/sample-bbs/init.d/sample-bbs.sh /etc/init.d/sample-bbs
chkconfig sample-bbs on



