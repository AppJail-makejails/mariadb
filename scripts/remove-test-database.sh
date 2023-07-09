#!/bin/sh

echo "======> Dropping test database ... <======"
echo "DROP DATABASE IF EXISTS test;" >> /scripts/mysqlrc

echo "======> Removing privileges on test database ... <======"
echo "DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';" >> /scripts/mysqlrc
