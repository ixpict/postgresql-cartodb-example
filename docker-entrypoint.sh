#!/bin/bash
chown -R postgres:postgres /data/postgresql /var/log/postgresql
cp postgresql.conf /etc/postgresql/10/main/postgresql.conf
cp pg_hba.conf /etc/postgresql/10/main/pg_hba.conf

chown -R postgres:postgres /etc/postgresql/10/main

echo "Check need init for postgresql data"
if [ ! -f /data/postgresql/PG_VERSION ]; then
  sudo -u postgres /usr/lib/postgresql/10/bin/initdb -k /data/postgresql
fi

echo "Run postgresql"
if [ -f /data/postgresql/PG_VERSION ]; then
  rm -f /data/postgresql/postmaster.pid
  sudo -u postgres /usr/lib/postgresql/10/bin/pg_ctl start -D /data/postgresql -l /var/log/postgresql/postgresql.log -s -o '-c config_file="/etc/postgresql/10/main/postgresql.conf" -c external_pid_file="/var/run/postgresql/10-main.pid"'
fi



echo "Create new database if not exists"
if ! $(psql -U postgres -Atc '\l' | grep cartodb > /dev/null); then
  psql -U postgres -Atc "create user cartodb with encrypted password 'cartodb';"
  psql -U postgres -Atc "create database cartodb WITH OWNER cartodb ENCODING 'UTF8' LC_COLLATE = 'en_US.UTF-8' LC_CTYPE = 'en_US.UTF-8';"
  psql -U postgres -Atc 'alter user cartodb with superuser;'
  for ext in postgis plpythonu cartodb postgis_topology fuzzystrmatch postgis_tiger_geocoder uuid-ossp; do
    psql -U cartodb cartodb -Atc "create extension if not exists \"${ext}\" ;";
  done
  echo "Now cartodb start"
fi

while : ; do
  tail -F /var/log/postgresql/postgresql.log
done