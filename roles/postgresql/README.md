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
    groups: [ "ssh", "sudo", "postgres" ]
    comment: "limited user account for remote backups"
    ssh_authorized_keys: ['data/public_keys/root@backup.CHANGEME.org.pub']
    sudo_nopasswd_commands: ['/usr/bin/rsync', '/usr/bin/psql', '/usr/bin/pg_dump', '/usr/bin/pg_dumpall' ]
```

### Metrics

To install and run [pgmetrics](https://pgmetrics.io/) agains the installed PostgreSQL instance, pass the `utils-pgmetrics` tag to ansible-playbook:

```bash
# using xsrv
TAGS=utils-pgmetrics xsrv deploy
# using ansible-playbook
ansible-playbook playbook.yml --tags=utils-pgmetrics
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

- https://stdout.root.sx/links/?searchterm=postgresql
- https://stdout.root.sx/links/?searchtags=database
