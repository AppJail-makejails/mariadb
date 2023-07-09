#!/bin/sh

. /scripts/lib.sh

DATABASE="$1"

ESCAPE_DATABASE=`escape_database_name "${DATABASE}"`

echo "======> Creating database: ${DATABASE} ... <======"
echo "CREATE DATABASE IF NOT EXISTS \`${ESCAPE_DATABASE}\`;" >> /scripts/mysqlrc
