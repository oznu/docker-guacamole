#!/usr/bin/with-contenv sh

mkdir -p /config/postgres
chown postgres:postgres /config/postgres
chmod 0700 /config/postgres

if [ -e /config/postgres/postgresql.conf ]; then
  echo "Database already configured"
else
  s6-setuidgid postgres initdb
fi
