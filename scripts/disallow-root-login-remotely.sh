#!/bin/sh

echo "======> Disallowing root login remotely ... <======"
echo "DELETE FROM mysql.global_priv WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');" >> /scripts/mysqlrc
