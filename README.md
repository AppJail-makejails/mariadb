# MariaDB

MariaDB is a database server that offers drop-in replacement functionality for MySQL. MariaDB is built by some of the original authors of MySQL, with assistance from the broader community of Free and open source software developers. In addition to the core functionality of MySQL, MariaDB offers a rich set of feature enhancements including alternate storage engines, server optimizations, and patches.

MariaDB is primarily driven by developers at Monty Program, a company founded by Michael "Monty" Widenius, the original author of MySQL, but this is not the whole story about MariaDB. On the "About MariaDB" page you will find more information about all participants in the MariaDB community, including storage engines XtraDB and PBXT

wikipedia.org/wiki/MariaDB

<img src="https://camo.githubusercontent.com/4d3a7bc71c08dbc12a16d70c5acd578ee02955f9f6cfb83f02e7b737ae9cfc5a/68747470733a2f2f75706c6f61642e77696b696d656469612e6f72672f77696b6970656469612f636f6d6d6f6e732f7468756d622f632f63612f4d6172696144425f636f6c6f75725f6c6f676f2e7376672f32353070782d4d6172696144425f636f6c6f75725f6c6f676f2e7376672e706e67" width="30%" height="auto" alt="MariaDB logo">

## How to use this Makejail

### Configuration

#### Port binding

By default, the database running within the container will listen on port 3306. You can expose the container port 3306 to the host port 3306 with the `-o expose="3306:3306"` argument to `appjail oci run`, like the command below:

```console
$ appjail oci run -Pd \
    -o overwrite=force \
    -o virtualnet=":<random> default" \
    -o nat \
    -o expose="3306:3306" \
    ghcr.io/appjail-makejails/mariadb:latest some-mariadb
```

**Note**: This will make your service accessible from external hosts. If you only want to use MariaDB from another jail or from your host, omit the `expose` option and simply use the jail’s IPv4 address or hostname.

#### Starting using a minimal configuration

The environment variables required to use this image involves the setting of the root user password:

```console
$ appjail oci run -Pd \
    -o overwrite=force \
    -o virtualnet=":<random> default" \
    -o nat \
    -e MARIADB_ROOT_PASSWORD=my-secret-pw \
    ghcr.io/appjail-makejails/mariadb:latest some-mariadb
```

or:

```console
$ appjail oci run -Pd \
    -o overwrite=force \
    -o virtualnet=":<random> default" \
    -o nat \
    -e MARIADB_ALLOW_EMPTY_ROOT_PASSWORD=1 \
    ghcr.io/appjail-makejails/mariadb:latest some-mariadb
```

or:

```console
$ appjail oci run -Pd \
    -o overwrite=force \
    -o virtualnet=":<random> default" \
    -o nat \
    -e MARIADB_RANDOM_ROOT_PASSWORD=1 \
    ghcr.io/appjail-makejails/mariadb:latest some-mariadb
```

... where the container logs will contain the generated root password.

#### ... via [`appjail-director`](https://github.com/DtxdF/director)

Example `appjail-director.yml` for `mariadb`:

```yaml
# Use root/example as user/password credentials

options:
  - virtualnet: ':<random> default'
  - nat:

services:
  db:
    name: mariadb
    makejail: gh+AppJail-makejails/mariadb
    oci:
      environment:
        - MARIADB_ROOT_PASSWORD: example
    options:
      - container: 'boot args:--pull'

  phpmyadmin:
    name: phpmyadmin
    makejail: gh+AppJail-makejails/phpmyadmin
    oci:
      environment:
        - PMA_ARBITRARY: 1
    options:
      - expose: '8080:80'
      - container: 'boot args:--pull'
```

Run `appjail-director up`, wait for it to initialize completely, and visit `http://phpmyadmin/` or `http://host-ip:8080` (as appropriate).

#### Start a `mariadb` server instance with user, password and database

```console
$ appjail oci run -Pd \
    -o overwrite=force \
    -o virtualnet=":<random> default" \
    -o nat \
    -e MARIADB_USER=example-user \
    -e MARIADB_PASSWORD=my_cool_secret \
    -e MARIADB_DATABASE=example-database \
    -e MARIADB_ROOT_PASSWORD=my-secret-pw \
    ghcr.io/appjail-makejails/mariadb:latest some-mariadb
```

#### Start a mariadb server instance in a network other than the default one

Examples in this document use the default network created by AppJail for simplicity. If you need to deploy MariaDB in other network, first create it, deploy MariaDB and your application.

```console
$ appjail network add some-network 192.168.5.0/24
$ appjail oci run -Pd \
    -o overwrite=force \
    -o virtualnet="some-network:<random> default" \
    -e MARIADB_USER=example-user \
    -e MARIADB_PASSWORD=my_cool_secret \
    -e MARIADB_ROOT_PASSWORD=my-secret-pw \
    ghcr.io/appjail-makejails/mariadb:latest some-mariadb
$ appjail oci run -Pd \
    -o overwrite=force \
    -o virtualnet="some-network:<random> default" \
    -o nat \
    -e APP_DB_HOST=some-mariadb \
    -e APP_DB_USER=example-user \
    -e APP_DB_PASSWD=my_cool_secret \
    some-application some-application
```

... where `some-network` is a newly created network (other than `ajnet` as the default network), `some-mariadb` is the name you want to assign to your container, `my-secret-pw` is the password to be set for the MariaDB root user. See the list above for relevant tags to match your needs and environment. `some-application` and then environment variable `APP_DB_HOST`, `APP_DB_USER` and `APP_DB_PASSWD` are the application's configuration for its database connection.

Keep in mind that, unlike `some-app`, MariaDB does not use the `nat` option. This means that no mapping is created between your host and the MariaDB container, so the container cannot communicate with the outside world. If you need more precise control over what your jails can see from a network perspective, check out the [Security Group](https://github.com/DtxdF/AppJail/wiki/filter) hook.

##### Connect to MariaDB from the MariaDB command line client

The following command starts another mariadb container instance and runs the mariadb command line client against your original mariadb container, allowing you to execute SQL statements against your database instance:

```console
$ appjail oci run \
    -o overwrite=force \
    -o virtualnet="some-network:<random> default" \
    -o ephemeral \
    ghcr.io/appjail-makejails/mariadb:latest mariadb-cli \
    mariadb -h some-mariadb.some-network.appjail -u example-user -p --ssl-verify-server-cert=false
```

... where `some-mariadb` is the name of your original mariadb container (connected to the `some-network` AppJail network).

This image can also be used as a client for non-AppJail or remote instances:

```console
$ appjail oci run \
    -o overwrite=force \
    -o virtualnet="some-network:<random> default" \
    -o ephemeral \
    ghcr.io/appjail-makejails/mariadb:latest mariadb-cli \
    mariadb --host <server container IP> --user example-user --password --database test
```

That will give you a standard MariaDB prompt. You can test it with:

```
example-user@some-mariadb.some-network.appjail [(none)]> \s
--------------
mariadb from 12.3.2-MariaDB, client 15.2 for FreeBSD15.0 (amd64) using  EditLine wrapper

Connection id:		7
Current database:	
Current user:		example-user@192.168.5.2
SSL:			Cipher in use is TLS_AES_256_GCM_SHA384, cert is UNKNOWN
Current pager:		stdout
Using outfile:		''
Using delimiter:	;
Server:			MariaDB
Server version:		12.3.2-MariaDB FreeBSD Ports
Protocol version:	10
Connection:		some-mariadb.some-network.appjail via TCP/IP
Server characterset:	utf8mb4
Db     characterset:	utf8mb4
Client characterset:	utf8mb4
Conn.  characterset:	utf8mb4
TCP port:		3306
Uptime:			9 min 44 sec

Threads: 1  Questions: 8  Slow queries: 0  Opens: 17  Open tables: 10  Queries per second avg: 0.013
--------------

example-user@some-mariadb.some-network.appjail [(none)]>
```

... which will give you the version and connection information. You can then use `exit` to leave the MariaDB command line client and the client container.

More information about the MariaDB command-line client can be found in the [MariaDB Knowledge Base : MariaDB Command Line Client](https://mariadb.com/kb/en/mariadb-command-line-client/).

### Container shell access

The `appjail oci exec` command allows you to run commands inside the running container. The following command line will give you a bash shell inside your `mariadb` container:

```console
$ appjail oci exec some-mariadb bash
```

### MariaDB-Backup

As MariaDB-Backup is highly coupled with the server version, it can be useful to use the `mariadb-backup` in the mariadb container of an explicit version:

```console
$ mkdir -p /backup-volume
$ appjail oci run \
    -o fstab="/backup-volume /backup" \
    -o overwrite=force \
    -o virtualnet=":<random> default" \
    -o nat \
    -o ephemeral \
    ghcr.io/appjail-makejails/mariadb:15.1-106 mariadb-backup \
    mariadb-backup --help
```

### Container viewing MariaDB logs

The log is available through AppJail's container log:

```console
$ appjail oci run -Pd \
    -o overwrite=force \
    -o virtualnet=":<random> default" \
    -o nat \
    -e MARIADB_ROOT_PASSWORD=my-secret-pw \
    ghcr.io/appjail-makejails/mariadb:latest some-mariadb
...
[00:00:22] [ info  ] [some-mariadb] Detached: pid:70968, log:jails/some-mariadb/container/2026-07-09.log
$ appjail logs tail jails/some-mariadb/container/2026-07-09.log -f
```

### Using a custom MariaDB configuration file

Custom configuration files should end in `.cnf` and be mounted read only at the directory `/usr/local/etc/mysql/conf.d`. These files should contain the minimal changes from the MariaDB workload required for your application/environment. A MariaDB configuration file will have a `[mariadb]` group followed by `variable` = `value` settings per Setting [Server System Variables](https://mariadb.com/kb/en/server-system-variables/#setting-server-system-variables) or [option-prefix-variable](https://mariadb.com/kb/en/configuring-mariadb-with-option-files/#option-prefixes).

The `mariadb` image configuration contains the FreeBSD MariaDB variables with two custom changes for the container:

* [`host-cache-size=0`](https://mariadb.com/kb/en/server-system-variables/#host_cache_size)
* [`skip-name-resolve`](https://mariadb.com/kb/en/server-system-variables/#skip_name_resolve)

These disable the authentication of `user@hostname` users. To re-enable the `skip-name-resolve` use `disable-skip-name-resolve` as variable or argument. When enabled, the `host-cache-size` should be sufficient for the number of containers connecting to the `mariadb`.

To view the resulting configuration of your `mariadb` container:

```console
$ appjail oci run -Pd \
    -o fstab="/my/custom /usr/local/etc/mysql/conf.d" \
    -o overwrite=force \
    -o virtualnet=":<random> default" \
    -o nat \
    ghcr.io/appjail-makejails/mariadb:latest some-mariadb \
    my_print_defaults --mysqld
```

#### Configuration without a `cnf` file

Many configuration options can be passed as flags to `mariadbd`. This will give you the flexibility to customize the container without needing a `cnf` file. For example, if you want to run on port 3808 just run the following:

```console
$ appjail oci run -Pd \
    -o overwrite=force \
    -o virtualnet=":<random> default" \
    -o nat \
    ghcr.io/appjail-makejails/mariadb:latest some-mariadb \
    --port 3808
```

If you would like to see a complete list of available options, just run:

```console
$ appjail oci run \
    -o overwrite=force \
    -o virtualnet=":<random> default" \
    -o nat \
    -o ephemeral \
    ghcr.io/appjail-makejails/mariadb:latest some-mariadb \
    --verbose --help
```

### Environment Variables

When you start the mariadb image, you can adjust the initialization of the MariaDB instance by passing one or more environment variables on the `appjail oci run` command line. Do note that all of the variables, except `MARIADB_AUTO_UPGRADE`, will have no effect if you start the container with a data directory that already contains a database. I.e. any pre-existing database will always be left untouched on container startup.

One of `MARIADB_RANDOM_ROOT_PASSWORD`, `MARIADB_ROOT_PASSWORD_HASH`, `MARIADB_ROOT_PASSWORD` or `MARIADB_ALLOW_EMPTY_ROOT_PASSWORD` (or equivalents, including `*_FILE`), is required. The other environment variables are optional.

There is a large list of environment variables and the complete list is documented on [MariaDB's Knowledge Base : MariaDB Server Docker Official Image Environment Variables](https://mariadb.com/kb/en/mariadb-server-docker-official-image-environment-variables/).

### `MARIADB_AUTO_UPGRADE`

When this environment variable is set, this will run the [mariadb-upgrade](https://mariadb.com/kb/en/mariadb-upgrade/), if needed, so any changes in the MariaDB system tables required to expose new features will be made. This may impeed some [downgrade options](https://mariadb.com/kb/en/downgrading-between-major-versions-of-mariadb/). Unless the environment variable `MARIADB_DISABLE_UPGRADE_BACKUP` is set, there will be a backup of the system tables created as `system_mysql_backup_*.sql.zst` in the top level of the data directory to assist in the downgrade if needed.

### Initializing the database contents

When a container is started for the first time, a new database with the specified name will be created and initialized with the provided configuration variables. Furthermore, it will execute files with extensions `.sh`, `.sql`, `.sql.gz`, `.sql.xz` and `.sql.zst` that are found in `/entrypoint-initdb.d`. Files will be executed in alphabetical order. `.sh` files without file execute permission are sourced rather than executed. You can easily populate your mariadb services by [mounting a SQL dump into that directory](https://appjail.readthedocs.io/en/latest/fs-mgmt/) and provide [custom images](https://man.freebsd.org/cgi/man.cgi?query=Containerfile) with contributed data. SQL files will be imported by default to the database specified by the `MARIADB_DATABASE` variable.

### Caveats

#### Where to Store Data

1. Create a data directory on a suitable volume on your host system, e.g. `/my/own/datadir`.
2. Start your `mariadb` container like this:

   ```console
   $ appjail oci run -Pd \
       -o overwrite=force \
       -o virtualnet=":<random> default" \
       -o nat \
       -o fstab="/my/own/datadir /var/db/mysql" \
       -e MARIADB_ROOT_PASSWORD=my-secret-pw \
       ghcr.io/appjail-makejails/mariadb:latest some-mariadb
   ```

The `-o fstab="/my/own/datadir /var/db/mysql"` part of the command mounts the `/my/own/datadir` directory from the underlying host system as `/var/db/mysql` inside the container, where MariaDB by default will write its data files.

#### No connections until MariaDB init completes

If there is no database initialized when the container starts, then a default database will be created. While this is the expected behavior, this means that it will not accept incoming connections until such initialization completes. This may cause issues when using automation tools, such as `appjail-director`, which start several containers simultaneously.

#### Health/Liveness/Readiness Checking

You can use the `/healthcheck.sh` script to choose from a (non-exhaustive) list of tests to check for whatever you consider health/liveness/readiness. Refer to the [MariaDB Knowledge Base : Using Healthcheck.sh](https://mariadb.com/kb/en/using-healthcheck-sh-script/) to learn about how to use it and which exact tests are provided.

#### Usage against an existing database

If you start your `mariadb` container instance with a data directory that already contains a database (specifically, a `mysql` subdirectory), no environment variables that control initialization will be needed or examined, and no pre-existing databases will be changed. The only exception is the non-default `MARIADB_AUTO_UPGRADE` environment variable, that might cause `mysql_upgrade`/`mariadb-upgrade` to run, which might change the system tables.

#### Backups and Restores

Backing up and restoring databases is important in containers too. The documentation on how to do this can be found on the [MariaDB Knowledge Base : Container Backup and Restoration](https://mariadb.com/kb/en/backups-and-restoration/).

#### Frequently Asked Questions / How to reset root and user passwords

This is documented on [MariaDB Knowledge Base : Adding Plugins to the Docker Official Image](https://mariadb.com/kb/en/adding-plugins-to-the-mariadb-docker-official-image/).

**Note**: In FreeBSD, the plugins directory is `/usr/local/lib/mysql/plugin`.

### Arguments (stage: build)

* `mariadb_from` (default: `ghcr.io/appjail-makejails/mariadb`): Location of OCI image. See also [OCI Configuration](#oci-configuration).
* `mariadb_tag` (default: `latest`): OCI image tag. See also [OCI Configuration](#oci-configuration).

### Environment (OCI image)

* `PGID` (default: `1000`): Equivalent to `PUID` but for the Process Group ID.
* `PUID` (default: `1000`): Process User ID for the container's main process, allowing you to match the owner of files written to mounted host volumes to your host system's user. Writable volumes are changed based on this environment variable.

### Volumes

| Name | Owner | Group | Perm | Type | Mountpoint |
| --- | --- | --- | --- | --- | --- |
| appjail-f4f268a87e-var_db_mysql | `${PUID}` | `${PGID}` | - | - | /var/db/mysql |

## OCI Configuration

```yaml
build:
  variants:
    - tag: 15.1-106
      containerfile: Containerfile
      args:
        FREEBSD_RELEASE: "15.1"
        MARIADBVER: "106"
        NO_PKGCLEAN: "1"
      cache_dirs: ["pkgcache0:/var/cache/pkg"]
    - tag: 15.1-1011
      containerfile: Containerfile
      args:
        FREEBSD_RELEASE: "15.1"
        MARIADBVER: "1011"
        NO_PKGCLEAN: "1"
      cache_dirs: ["pkgcache0:/var/cache/pkg"]
    - tag: 15.1-114
      containerfile: Containerfile
      args:
        FREEBSD_RELEASE: "15.1"
        MARIADBVER: "114"
        NO_PKGCLEAN: "1"
      cache_dirs: ["pkgcache0:/var/cache/pkg"]
    - tag: 15.1-118
      containerfile: Containerfile
      args:
        FREEBSD_RELEASE: "15.1"
        MARIADBVER: "118"
        NO_PKGCLEAN: "1"
      cache_dirs: ["pkgcache0:/var/cache/pkg"]
    - tag: 15.1-123
      containerfile: Containerfile
      aliases: ["latest"]
      default: true
      args:
        FREEBSD_RELEASE: "15.1"
        MARIADBVER: "123"
        NO_PKGCLEAN: "1"
      cache_dirs: ["pkgcache0:/var/cache/pkg"]
```
