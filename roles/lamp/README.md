lamp
====

This role will install a [LAMP](https://en.wikipedia.org/wiki/LAMP_(software_bundle)) stack:

- [Apache](https://en.wikipedia.org/wiki/Apache_HTTP_Server) web server
- [mod_php](https://en.wikipedia.org/wiki/PHP) interpreter
- [MariaDB](https://en.wikipedia.org/wiki/MariaDB) (MySQL) database server
- Configurable [virtual hosts](https://httpd.apache.org/docs/2.4/vhosts/)
- Automatic SSL/TLS certificate generation and configuration:
 - [Let's Encrypt](https://en.wikipedia.org/wiki/Let's_Encrypt) using [mod_md](https://httpd.apache.org/docs/2.4/mod/mod_md.html)
  - Self-signed certificates
  - Hardened ([A+](https://www.ssllabs.com/ssltest/)) SSL/TLS configuration, automatic HTTP to HTTPS redirects
- (optional) `mod_evasive` to mitigate basic DoS attack attempts
- (optional) Disallow robots/crawlers from browsing/indexing sites (using robots.txt and X-Robots-Tag headers)
- (optional) simple setup of [reverse proxies](https://httpd.apache.org/docs/2.4/mod/mod_proxy.html#proxypass) to remote or local application servers

[![](https://i.imgur.com/E74kJx5.png)](https://i.imgur.com/Ij5dhjo.png)


Requirements
------------

This role requires Ansible 2.8 or higher.


Configuration Variables
-----------------------

See [defaults/main.yml](defaults/main.yml)


Dependencies
------------


The [`common`](https://gitlab.com/nodiscc/xsrv/-/tree/master/roles/common) role


Example Playbook
----------------

```yaml
- hosts: my.example.org
  roles:
     - common
     - lamp
  vars:
    apache_virtualhosts:
      - servername: "www.CHANGEME.org"
        documentroot: "/var/www/www.CHANGEME.org"
        https_mode: "selfsigned"
        allow_robots: no

# ansible-vault edit host_vars/my.example.org/my.example.org.vault.yml
vault_mariadb_root_password: "CHANGEME"
```

Usage
-----

- Backups: See the the included [rsnapshot configuration](templates/etc_rsnapshot.d_letsencrypt.conf) for the [backup](../backup/README.md) role

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
