# mariadb

MariaDB is a database server that offers drop-in replacement functionality for MySQL. MariaDB is built by some of the original authors of MySQL, with assistance from the broader community of Free and open source software developers. In addition to the core functionality of MySQL, MariaDB offers a rich set of feature enhancements including alternate storage engines, server optimizations, and patches.

MariaDB is primarily driven by developers at Monty Program, a company founded by Michael "Monty" Widenius, the original author of MySQL, but this is not the whole story about MariaDB. On the "About MariaDB" page you will find more information about all participants in the MariaDB community, including storage engines XtraDB and PBXT

wikipedia.org/wiki/MariaDB

![mariadb logo](https://upload.wikimedia.org/wikipedia/commons/thumb/c/ca/MariaDB_colour_logo.svg/250px-MariaDB_colour_logo.svg.png)

## How to use this Makejail

### Basic usage

```
INCLUDE options/network.makejail
INCLUDE gh+AppJail-makejails/mariadb
```

Where `options/network.makejail` are the options that suit your environment, for example:

```
ARG network?
ARG interface=mariadb

OPTION virtualnet=${network}:${interface} default
OPTION nat
```

Open a shell and run `appjail makejail`:

```sh
appjail makejail -j mariadb
# or use a network explicitly
appjail makejail -j mariadb -- --network db
```

### Create a database and a user with full access to it

```sh
appjail makejail -j mariadb -- \
    --mariadb_user "example-user" \
    --mariadb_password "my_cool_secret" \
    --mariadb_database "appdb" \
    --mariadb_root_password "my-secret-pw"
```

### stage: mariadb\_dump\_all

```sh
appjail run -s mariadb_dump_all -p password="some-pw" mariadb
```

#### Arguments

* `user` (default: `root`)
* `password` (optional)

### stage: mariadb\_mysql\_secure\_installation

```sh
appjail run -s mariadb_mysql_secure_installation mariadb
```

### Arguments

* `mariadb_tag` (default: `13.2-1011`): see [#tags](#tags).
* `mariadb_allow_empty_root_password` (default: `0`): Set an empty password for the root user. Takes precedence over `--mariadb_root_password_hash`, `--mariadb_root_password` and `--mariadb_random_root_password`.
* `mariadb_root_password_hash` (optional): Use a hashed password generated by the `PASSWORD()` function instead of a plain text password. Takes precedence over `--mariadb_root_password` and `--mariadb_random_root_password`.
* `mariadb_root_password` (optional): Use a plain text password. Takes precedence over `--mariadb_random_root_password`.
* `mariadb_random_root_password` (default: `1`): Use a random password. The password is displayed as `root password: ...`.
* `mariadb_user` (optional): Create a user. `--mariadb_password_hash` or `--mariadb_password` are required.
* `mariadb_password_hash` (optional): Hashed password generated by the `PASSWORD()` function instead of a plain text password. Takes precedence over `--mariadb_password`.
* `mariadb_password` (optional): Plain text password for the `mariadb_user` user.
* `mariadb_database` (optional): Create a new database. The user will have full access to this database.
* `mariadb_root_host` (default: `localhost`): This is the hostname part of the root user created when it does not exist. See [Host Name Component](https://mariadb.com/kb/en/create-user/#host-name-component) for details.
* `mariadb_remove_anonymous_users` (default: `1`): By default, a MariaDB installation has an anonymous user, allowing anyone to log into MariaDB without having to have a user account created for them.  This is intended only for testing, and to make the installation go a bit smoother.  You should remove them before moving into a production environment.
* `mariadb_disallow_root_login_remotely` (default: `1`): Normally, root should only be allowed to connect from 'localhost'.  This ensures that someone cannot guess at the root password from the network. You should also set `--mariadb_root_host`.
* `mariadb_remove_test_database` (default: `1`): By default, MariaDB comes with a database named 'test' that anyone can access.  This is also intended only for testing, and should be removed before moving into a production environment.

## How to build the Image

Make any changes you want to your image.

```
INCLUDE options/network.makejail
INCLUDE gh+AppJail-makejails/mariadb --file build.makejail
```

Build the jail:

```sh
appjail makejail -j mariadb -- --mariadb_version 106
```

Remove unportable or unnecessary files and directories and export the jail:

```sh
appjail stop mariadb
appjail cmd local mariadb sh -c "rm -f var/log/*"
appjail cmd local mariadb sh -c "rm -f var/cache/pkg/*"
appjail cmd local mariadb sh -c "rm -f var/run/*"
appjail cmd local mariadb vi etc/rc.conf
appjail image export mariadb
```

### Arguments

* `mariadb_version` (default: `1011`): MariaDB server version. Valid values: 105, 106, 1011.

## Tags

| Tag         | Arch    | Version           | Type   | `mariadb_version` |
| ----------- | ------- | ----------------- | ------ | ----------------- |
| `13.2-1011` | `amd64` | `13.2-RELEASE-p1` | `thin` |       1011        |
| `13.2-106`  | `amd64` | `13.2-RELEASE-p1` | `thin` |       106         |
| `13.2-105`  | `amd64` | `13.2-RELEASE-p1` | `thin` |       105         |

## Notes

1. The `mariadb_dump_all` custom stage uses `-ARE --single-transaction` flags. See the `mysqldump` / `mariadb-dump` documentation to see if these flags suit your environment and/or configuration.
2. `bind-address` is set to `0.0.0.0`.
