#!/bin/sh

ROOT_HOST="$1"

echo "======> WARNING: root password is empty. <======"

/scripts/root-password.sh "" "${ROOT_HOST}"
