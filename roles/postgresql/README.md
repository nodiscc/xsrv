# xsrv.postgresql

This role will install [PostgreSQL](https://en.wikipedia.org/wiki/PostgreSQL), a relational database management system (RDBMS) emphasizing extensibility and SQL compliance.

It allows running [pgmetrics](https://pgmetrics.io/) against the PostgreSQL instance.


## Requirements/Dependencies/example playbook

See [meta/main.yml](meta/main.yml)

```yaml
# playbook.yml
- hosts: my.CHANGEME.org
  roles:
    - nodiscc.xsrv.common # (required) base server setup, hardening, firewall, bruteforce prevention
    - nodiscc.xsrv.monitoring # (optional) system/server monitoring and health checks
    - nodiscc.xsrv.backup # (optional) automatic backups
    - nodiscc.xsrv.postgresql

# required variables:
# none
```

See [defaults/main.yml](defaults/main.yml) for all configuration variables


## Usage

### Backups

See the included [rsnapshot configuration](templates/etc_rsnapshot.d_postgresql.conf.j2) for the [backup](../backup/README.md) role.

To backup postgresql data from a remote host with the `nodiscc.xsrv.backup` role:

```yaml
# xsrv edit-host default backup.CHANGEME.org
rsnapshot_backup_execs:
  - 'ssh -oStrictHostKeyChecking=no rsnapshot@db.CHANGEME.org /usr/local/bin/postgres-dump-all-databases.sh'
rsnapshot_remote_backups:
  - { user: 'rsnapshot', host: 'db.CHANGEME.org', path: '/var/backups/postgresql' }
```
```yaml
# xsrv edit-host default db.CHANGEME.org
  - name: "rsnapshot"
    groups: [ "ssh-access", "sudo", "postgres" ]
    comment: "limited user account for remote backups"
    ssh_authorized_keys: ['data/public_keys/root@backup.CHANGEME.org.pub']
    sudo_nopasswd_commands: ['/usr/bin/rsync', '/usr/bin/psql', '/usr/bin/pg_dump', '/usr/bin/pg_dumpall' ]
```

### Metrics

To install and run [pgmetrics](https://pgmetrics.io/) against the installed PostgreSQL instance, pass the `utils-pgmetrics` tag to ansible-playbook:

```bash
# using xsrv
TAGS=utils-pgmetrics xsrv deploy
# using ansible-playbook
ansible-playbook playbook.yml --tags=utils-pgmetrics
```


### Upgrading clusters

When upgrading from a Debian release to the next (e.g. Debian 10 to 11), a new version of postgresql server will be installed. However, the previous version will stay installed, and your data will be kept in the cluster managed by the old database engine version. You may want to migrate data from the cluster managed by the "old" version, to a database cluster managed by the new version. You should perform a backup before attempting this operation.

List running clusters:

```bash
$ sudo pg_lsclusters
Ver Cluster Port Status Owner    Data directory              Log file
11  main    5432 online postgres /var/lib/postgresql/11/main /var/log/postgresql/postgresql-11-main.log
13  main    5433 online postgres /var/lib/postgresql/13/main /var/log/postgresql/postgresql-13-main.log
```

Verify that there are no databases in the postgresql 13 cluster:

```bash
$ sudo -u postgres psql --cluster 13/main
psql (13.11 (Debian 13.11-0+deb11u1))
Type "help" for help.

postgres=# \l
                                  List of databases
   Name    |  Owner   | Encoding |   Collate   |    Ctype    |   Access privileges
-----------+----------+----------+-------------+-------------+-----------------------
 postgres  | postgres | UTF8     | en_US.UTF-8 | en_US.UTF-8 |
 template0 | postgres | UTF8     | en_US.UTF-8 | en_US.UTF-8 | =c/postgres          +
           |          |          |             |             | postgres=CTc/postgres
 template1 | postgres | UTF8     | en_US.UTF-8 | en_US.UTF-8 | =c/postgres          +
           |          |          |             |             | postgres=CTc/postgres
(3 rows)

postgres=# \q
```

The `postgres`, `template0` and `template1` databases are default databases created on postgresql installation, so in this case, no databases that contain application data are present, and we can go forward with the migration.

Drop the empty postgresql 13 cluster (**this will delete all data in the cluster**) to make room for the migration:

```bash
$ sudo pg_dropcluster --stop 13 main
```

Then migrate data in the posgtresql 11 cluster to a cluster managed by postgresql 13:

```bash
$ sudo -u postgres pg_upgradecluster 11 main
Stopping old cluster...
[...]
Success. Please check that the upgraded cluster works.
```

Verify that the potsgresql 13 cluster has the status `online` using `sudo pg_lsclusters`. If not, start it using `sudo pg_ctlcluster 13 main start`. Verify that your applications work, then drop the postgresql 11 cluster:

```bash
$ sudo -u postgres pg_dropcluster 11 main
```

We can then stop the old postgresql 11 service and remove related packages:

```bash
$ sudo systemctl stop postgresql@11-main.service
$ sudo apt purge postgresql*11
Reading package lists... Done
Building dependency tree... Done
Reading state information... Done
Note, selecting 'postgresql-11' for glob 'postgresql*11'
Note, selecting 'postgresql-contrib-11' for glob 'postgresql*11'
Note, selecting 'postgresql-client-11' for glob 'postgresql*11'
Note, selecting 'postgresql-doc-11' for glob 'postgresql*11'
Note, selecting 'postgresql-11' instead of 'postgresql-contrib-11'
Package 'postgresql-doc-11' is not installed, so not removed
The following packages will be REMOVED:
  libicu63* libllvm7* postgresql-11* postgresql-client-11*
0 upgraded, 0 newly installed, 4 to remove and 0 not upgraded.
After this operation, 145 MB disk space will be freed.
Do you want to continue? [Y/n] Y
```


## Tags

<!--BEGIN TAGS LIST-->
```
postgresql - setup postgresql database server
utils-pgmetrics - (manual) get postgresql server metrics
```
<!--END TAGS LIST-->


## License

[GNU GPLv3](../../LICENSE)


## References

- https://stdout.root.sx/links/?searchterm=postgres
- https://stdout.root.sx/links/?searchtags=database
