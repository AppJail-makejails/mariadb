#!/bin/sh

. /scripts/lib.sh

USER="$1"
PASSWORD_HASH="$2"

ESCAPE_USER=`escape_name "${USER}"`
ESCAPE_PASSWORD_HASH=`escape_name "${PASSWORD_HASH}"`

cat << EOF >> /scripts/mysqlrc
CREATE USER IF NOT EXISTS '${ESCAPE_USER}'@'%';
ALTER USER '${ESCAPE_USER}'@'%' IDENTIFIED BY PASSWORD '${ESCAPE_PASSWORD_HASH}';
EOF
