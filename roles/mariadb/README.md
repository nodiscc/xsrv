# xsrv.mariadb

This role will install [MariaDB]https://en.wikipedia.org/wiki/MariaDB), a community-developed, commercially supported fork of the MySQL relational database management system (RDBMS)


## Requirements/dependencies/example playbook

See [meta/main.yml](defaults/main.yml)

```yaml
# playbook.yml
- hosts: my.CHANGEME.org
  roles:
     - nodiscc.xsrv.common # optional
     - nodiscc.xsrv.backup # (optional, automatic backups)
     - nodiscc.xsrv.mariadb

# ansible-vault edit host_vars/my.example.org/my.example.org.vault.yml
vault_mariadb_root_password: "CHANGEME"
```

See [defaults/main.yml](defaults/main.yml) for all configuration variables.


## Usage

**Backups**: See the included [rsnapshot configuration](templates/etc_rsnapshot.d_mariadb.conf.j2) for the [backup](../backup/README.md) role.


## License

- [GNU GPLv3](../../LICENSE)


## References

- https://stdout.root.sx/links?searchtags=database
