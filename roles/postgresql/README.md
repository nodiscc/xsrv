# xsrv.postgresql

This role will install [PostgreSQL](https://en.wikipedia.org/wiki/PostgreSQL), a relational database management system (RDBMS) emphasizing extensibility and SQL compliance.

[![](https://i.imgur.com/UoKs3x1.png)](https://i.imgur.com/yDozQPU.jpg)
[![](https://i.imgur.com/7oO67Xq.png)](https://i.imgur.com/rNTiRva.png)
[![](https://i.imgur.com/CqoOfXo.png)](https://i.imgur.com/mv2fppi.jpg)


Requirements/Dependencies/example playbook
------------

See [meta/main.yml](meta/main.yml)

```yaml
# playbook.yml
- hosts: my.CHANGEME.org
  roles:
    - nodiscc.xsrv.common # bruteforce prevention
    - nodiscc.xsrv.monitoring # (optional)
    - nodiscc.xsrv.backup # (optional) automatic backups
    - nodiscc.xsrv.postgresql
```

## Usage

**Backups**: See the included [rsnapshot configuration](templates/etc_rsnapshot.d_postgresql.conf.j2) for the [backup](../backup/README.md) role.


## License

[GNU GPLv3](../../LICENSE)


## References

- https://stdout.root.sx/links/?searchterm=postgresql
- https://stdout.root.sx/links/?searchtags=database
