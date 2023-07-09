#!/bin/sh

. /scripts/lib.sh

USER="$1"
PASSWORD="$2"

ESCAPE_USER=`escape_name "${USER}"`
ESCAPE_PASSWORD=`escape_name "${PASSWORD}"`

cat << EOF >> /scripts/mysqlrc
CREATE USER IF NOT EXISTS '${ESCAPE_USER}'@'%';
ALTER USER '${ESCAPE_USER}'@'%' IDENTIFIED BY '${ESCAPE_PASSWORD}';
EOF
