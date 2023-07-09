#!/bin/sh

. /scripts/lib.sh

ROOT_HOST="$1"
PASSWORD=`random_password`

echo "======> root password: ${PASSWORD} <======"

/scripts/root-password.sh "${PASSWORD}" "${ROOT_HOST}"
