#!/bin/bash

source /etc/environment

mkdir -p $PGDATA /data/bitcoind
chown -R postgres "$PGDATA"
chown -R webapp /data/bitcoind
rm -rf /var/lib/postgresql/9.6/main
ln -s $PGDATA /var/lib/postgresql/9.6/main
chown -R postgres "$PGDATA"
chown -R postgres /var/lib/postgresql/9.6/main

if [ ! -f $PGDATA/postgresql.conf ]; then #we can assume its first run
    gosu postgres /usr/lib/postgresql/9.6/bin/initdb --encoding=UTF-8 --local=en_US.UTF-8 -D $PGDATA
    sudo service postgresql start
    sudo -u postgres psql -c "CREATE USER webapp WITH PASSWORD 'Password1' LOGIN;"
    sudo -u postgres psql -c "ALTER USER webapp CREATEDB;"
    sudo -u postgres psql -c "CREATE DATABASE webapp WITH OWNER webapp ENCODING 'UTF-8' TEMPLATE template1;"
    rm /first_run.marker
else
    service postgresql start
fi

echo Starting abe
su - webapp -c "cd /home/webapp/bitcoin-abe && python -m Abe.abe --config abe-pg.conf --commit-bytes 100000 --no-serve"

echo Starting bitcoin daemon
su - webapp -c "bitcoind -par=1 -datadir=/data/bitcoind -disablewallet -rpcallowip=127.0.0.1"

