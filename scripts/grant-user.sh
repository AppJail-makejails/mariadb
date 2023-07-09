#!/bin/sh

. /scripts/lib.sh

USER="$1"
DATABASE="$2"

ESCAPE_USER=`escape_name "${USER}"`
ESCAPE_DATABASE=`escape_database_name "${DATABASE}"`

echo "======> Granting privileges to \`${ESCAPE_USER}\` on \`${ESCAPE_DATABASE}\` database ... <======"
echo "GRANT ALL ON \`${ESCAPE_DATABASE}\`.* TO '${ESCAPE_USER}'@'%' WITH GRANT OPTION;" >> /scripts/mysqlrc
