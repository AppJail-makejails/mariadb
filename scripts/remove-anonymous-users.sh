#!/bin/sh

echo "======> Removing anonymous users ... <======"
echo "DELETE FROM mysql.global_priv WHERE User='';" >> /scripts/mysqlrc
