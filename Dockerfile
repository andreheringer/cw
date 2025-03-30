FROM postgres:17.4-alpine3.21

COPY scripts/startup.sh /docker-entrypoint-initdb.d/startup.sh
COPY scripts/00_init.sql /tmp/00_init.sql
