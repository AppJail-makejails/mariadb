ARG FREEBSD_RELEASE

FROM ghcr.io/appjail-makejails/core:${FREEBSD_RELEASE}

ARG MARIADBVER
ARG NO_PKGCLEAN

LABEL org.opencontainers.image.title="MariaDB" \
    org.opencontainers.image.description="Multithreaded SQL database (server)" \
    org.opencontainers.image.source="https://github.com/AppJail-makejails/mariadb" \
    org.opencontainers.image.url="https://github.com/AppJail-makejails/mariadb" \
    org.opencontainers.image.vendor="DtxdF" \
    org.opencontainers.image.authors="Jesús Daniel Colmenares Oviedo <dtxdf@disroot.org>"

RUN set -xe; \
    \
    pkg update; \
    pkg install -U mariadb${MARIADBVER}-server \
        pwgen \
        bash \
        coreutils \
        gnugrep \
        gsed \
        gawk \
        FreeBSD-xz; \
    \
    if [ -z "${NO_PKGCLEAN}" ]; then \
        pkg clean -a; \
        rm -rf /var/cache/pkg/* /var/db/pkg/repos/*; \
    fi; \
    \
    find /usr/local/etc/mysql/ -name '*.cnf' -print0 \
		| xargs -0 ggrep -lZE '^(bind-address|log|user\s)' \
		| xargs -rt -0 gsed -Ei 's/^(bind-address|log|user\s)/#&/'; \
# don't reverse lookup hostnames, they are usually another container
	printf "[mariadb]\nhost-cache-size=0\nskip-name-resolve\n" > /usr/local/etc/mysql/conf.d/05-skipcache.cnf; \
    chmod 644 /usr/local/etc/mysql/conf.d/05-skipcache.cnf

ENV LANG C.UTF-8
ENV MARIADBVER ${MARIADBVER}

VOLUME ["/var/db/mysql"]

COPY entrypoint.sh /entrypoint.sh
COPY healthcheck.sh /healthcheck.sh
ENTRYPOINT ["/entrypoint.sh"]

RUN chmod 555 /entrypoint.sh \
        /healthcheck.sh && \
    mkdir -p /var/db/mysql \
        /var/run/mysql \
        /entrypoint-initdb.d && \
    chmod 765 /var/db/mysql \
        /var/run/mysql \
        /entrypoint-initdb.d && \
    echo -e '#!/bin/sh\nexec /usr/local/libexec/mariadbd "$@"' > /usr/local/bin/mariadbd && \
    chmod 555 /usr/local/bin/mariadbd

EXPOSE 3306
CMD ["mariadbd"]
