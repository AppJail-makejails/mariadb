#!/bin/sh

BASEDIR=`dirname -- "$0"` || exit $?
BASEDIR=`realpath -- "${BASEDIR}"` || exit $?

. "${BASEDIR}/update.conf"

set -xe
set -o pipefail

cat -- "${BASEDIR}/Makejail.template" |\
    sed -E \
        -e "s/%%TAG1%%/${TAG1}/g" \
        -e "s/%%MARIADB4%%/${MARIADB4}/g" > "${BASEDIR}/../Makejail"

cat -- "${BASEDIR}/build.makejail.template" |\
    sed -E \
        -e "s/%%MARIADB1%%/${MARIADB1}/g" \
        -e "s/%%MARIADB2%%/${MARIADB2}/g" \
        -e "s/%%MARIADB3%%/${MARIADB3}/g" \
        -e "s/%%MARIADB4%%/${MARIADB4}/g" > "${BASEDIR}/../build.makejail"

cat -- "${BASEDIR}/README.md.template" |\
    sed -E \
        -e "s/%%TAG1%%/${TAG1}/g" \
        -e "s/%%TAG2%%/${TAG2}/g" \
        -e "s/%%MARIADB1%%/${MARIADB1}/g" \
        -e "s/%%MARIADB2%%/${MARIADB2}/g" \
        -e "s/%%MARIADB3%%/${MARIADB3}/g" \
        -e "s/%%MARIADB4%%/${MARIADB4}/g" > "${BASEDIR}/../README.md"
