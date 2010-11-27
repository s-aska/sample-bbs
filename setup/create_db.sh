# Install PostgreSQL8.4
# 
#   rpm -ivh http://yum.pgsqlrpms.org/reporpms/8.4/pgdg-centos-8.4-2.noarch.rpm
#   yum install postgresql84 postgresql84-libs postgresql84-server postgresql84-devel
#   su - postgres -c "initdb --no-locale -D /var/lib/pgsql/data"
#   /etc/init.d/postgresql start

# Create Database
su - postgres -c "createuser -S -R -D sample-bbs"
su - postgres -c "createdb -O sample-bbs sample-bbs -E UTF-8 -T template0"
