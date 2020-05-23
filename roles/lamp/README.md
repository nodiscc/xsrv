lamp
====

This role will install a [LAMP](https://en.wikipedia.org/wiki/LAMP_(software_bundle)) stack:

- [Apache](https://en.wikipedia.org/wiki/Apache_HTTP_Server) web server
- [mod_php](https://en.wikipedia.org/wiki/PHP) interpreter
- [MariaDB](https://en.wikipedia.org/wiki/MariaDB) (MySQL) database server
- Configurable [virtual hosts](https://httpd.apache.org/docs/2.4/vhosts/)
- (optional) [Let's Encrypt](https://en.wikipedia.org/wiki/Let's_Encrypt) SSL/TLS certificates
- Self-signed SSL/TLS (HTTPS) certificates
- Hardened ([A+](https://www.ssllabs.com/ssltest/)) SSL/TLS configuration, automatic HTTP to HTTPS redirects
- (optional) `mod_evasive` to mitigate basic DoS attack attempts
- (optional) Disallow robots/crawlers from browsing/indexing sites (using robots.txt and X-Robots-Tag headers)
- (optional) basic auto-generated homepage/startpage based on installed roles
- (optional) simple setup of [reverse proxies](https://httpd.apache.org/docs/2.4/mod/mod_proxy.html#proxypass) to remote or local application servers


Requirements
------------

This role requires Ansible 2.8 or higher.


Configuration Variables
-----------------------

See [defaults/main.yml](defaults/main.yml)


Dependencies
------------

The [`common`](https://gitlab.com/nodiscc/ansible-xsrv-common) role


Example Playbook
----------------

```yaml
- hosts: my.example.org
  roles:
     - common
     - lamp
```

Usage
-----

- Backups: See the [backup](https://gitlab.com/nodiscc/ansible-xsrv-backup) role and the included [rsnapshot configuration](templates/etc_rsnapshot.d_letsencrypt.conf)

License
-------

- [GNU GPLv3](../../LICENSE)
- [Paper icons](https://github.com/snwh/paper-icon-theme) under [CC-BY-SA-4.0](https://creativecommons.org/licenses/by-sa/4.0/)


References
-----------------

- https://stdout.root.sx/links?searchtags=apache
- https://stdout.root.sx/links?searchtags=ssl
- https://stdout.root.sx/links?searchtags=database
- https://stdout.root.sx/links?searchtags=php
- https://stdout.root.sx/links?searchtags=web
