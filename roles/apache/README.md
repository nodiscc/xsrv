# xsrv.apache

This role will install and configure the [Apache](https://en.wikipedia.org/wiki/Apache_HTTP_Server) webserver:

- [mod_md](https://httpd.apache.org/docs/2.4/mod/mod_md.html) for [Let's Encrypt](https://en.wikipedia.org/wiki/Let's_Encrypt) SSL/TLS certificate management, hardened ([A+](https://www.ssllabs.com/ssltest/)) SSL/TLS configuration
- [php-fpm](https://php-fpm.org/) PHP interpreter
- (optional) `mod_evasive` to mitigate basic DoS attack attempts


Requirements/Dependencies
------------

- Ansible => 2.9
- Debian 10
- [`common`](https://gitlab.com/nodiscc/xsrv/-/tree/master/roles/common) role
- For Let's Encrypt certificates, port 80/tcp must be reachable from the Internet, and the each virtualhost's FQDN (ServerName) must have a A record in the public DNS system
- Each role relying on this one must install its own configuration in `/etc/apache2/*-enabled/` and notify the `reload/restart apache` handlers


Configuration Variables
-----------------------

See [defaults/main.yml](defaults/main.yml)


Example Playbook
----------------

```yaml
- hosts: my.CHANGEME.org
  roles:
     - nodiscc.xsrv.common
     - nodiscc.xsrv.apache
```

Usage
-----

**Backups:** See the the included [rsnapshot configuration](templates/etc_rsnapshot.d_letsencrypt.conf) for the [backup](../backup/README.md) role

License
-------

[GNU GPLv3](../../LICENSE)


References
-----------------

- https://stdout.root.sx/links?searchtags=doc+apache
- https://stdout.root.sx/links?searchtags=doc+ssl
- https://stdout.root.sx/links?searchtags=doc+php
- https://stdout.root.sx/links?searchtags=doc+web
