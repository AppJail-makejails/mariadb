# mariadb

MariaDB is a database server that offers drop-in replacement functionality for MySQL. MariaDB is built by some of the original authors of MySQL, with assistance from the broader community of Free and open source software developers. In addition to the core functionality of MySQL, MariaDB offers a rich set of feature enhancements including alternate storage engines, server optimizations, and patches.

MariaDB is primarily driven by developers at Monty Program, a company founded by Michael "Monty" Widenius, the original author of MySQL, but this is not the whole story about MariaDB. On the "About MariaDB" page you will find more information about all participants in the MariaDB community, including storage engines XtraDB and PBXT

wikipedia.org/wiki/MariaDB

![mariadb logo](https://upload.wikimedia.org/wikipedia/commons/thumb/c/ca/MariaDB_colour_logo.svg/250px-MariaDB_colour_logo.svg.png)

## How to use this Makejail

```
INCLUDE options/network.makejail
INCLUDE gh+AppJail-makejails/mariadb
```

Where `options/network.makejail` are the options that suit your environment, for example:

```
ARG network
ARG interface=mariadb

OPTION virtualnet=${network}:${interface} default
OPTION nat
```

Open a shell and run `appjail makejail`:

```
appjail makejail -j mariadb -- --network db
```

### Arguments

* `mariadb_version` (default: `106`): MariaDB server version. Valid values: 103, 104, 105, 106.
