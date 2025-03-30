#!/bin/bash

max_number_of_replicas=4
max_wal_senders=8

master_db="pg_master"
replica="pg_replica"

function master_startup() {
  echo "[STARTUP] :: Loading db schema..."
  psql -U postgres -d postgres -f /tmp/00_init.sql

  echo "[STARTUP] :: Schema loaded successfully in $master_db"

  echo "[STARTUP] :: Configuring logical replication in master..."
  sed -i "s/^#*wal_level .*$/wal_level = logical/" /var/lib/postgresql/data/postgresql.conf
  sed -i "s/^#*max_replication_slots .*$/max_replication_slots = $max_number_of_replicas/" /var/lib/postgresql/data/postgresql.conf
  sed -i "s/^#*max_wal_senders .*$/max_wal_senders = $max_wal_senders/" /var/lib/postgresql/data/postgresql.conf
  grep -qxF "host replication all all md5" /var/lib/postgresql/data/pg_hba.conf || echo "host replication all all md5" >> /var/lib/postgresql/data/pg_hba.conf

  psql -U postgres -d testDB -c "DROP PUBLICATION IF EXISTS my_publication;"
  psql -U postgres -d testDB -c "CREATE PUBLICATION my_publication FOR TABLE orders;"

  echo "[STARTUP] :: Master node configured in $master_db"
}

function replica_startup() {
    echo "[STARTUP] :: Loading db schema..."
    psql -U postgres -d postgres -f /tmp/00_init.sql
    echo "Schema loaded successfully in $replica"

    psql -U postgres -d testDB -c "DROP SUBSCRIPTION IF EXISTS ${replica}_subscription;"
    psql -U postgres -d testDB -c "CREATE SUBSCRIPTION ${replica}_subscription CONNECTION 'dbname=testDB host=$master_db user=postgres password=postgres' PUBLICATION my_publication;"
    echo "$replica configured to replicate from $master_db."
}

case "$DB_NODE_TYPE" in
    "master")
        echo "[STARTUP] :: Executing master node startup..."
        master_startup
        ;;
    "replica")
        echo "This node is a replica."
        replica_startup
        ;;
    *)
        echo "Error: DB_NODE_TYPE must be either 'master' or 'replica'. Current value: $DB_NODE_TYPE"
        exit 1
        ;;
esac
