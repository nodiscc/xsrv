apache
====

This role will install and configure the [Apache](https://en.wikipedia.org/wiki/Apache_HTTP_Server) webserver:

- Configurable [virtual hosts](https://httpd.apache.org/docs/2.4/vhosts/)
- SSL/TLS certificates:
  - [Let's Encrypt](https://en.wikipedia.org/wiki/Let's_Encrypt) using [mod_md](https://httpd.apache.org/docs/2.4/mod/mod_md.html)
  - Self-signed certificates
  - Hardened ([A+](https://www.ssllabs.com/ssltest/)) SSL/TLS configuration
  - Automatic HTTP to HTTPS redirects
- [mod_php](https://en.wikipedia.org/wiki/PHP) interpreter
- (optional) `mod_evasive` to mitigate basic DoS attack attempts
- (optional) Disallow robots/crawlers from browsing/indexing sites (using robots.txt and X-Robots-Tag headers)
- (optional) simple setup of [reverse proxies](https://httpd.apache.org/docs/2.4/mod/mod_proxy.html#proxypass) to remote or local application servers


Requirements/Dependencies
------------

- Ansible 2.9 or higher.
- [`common`](https://gitlab.com/nodiscc/xsrv/-/tree/master/roles/common) role (optional)
- For Let's Encrypt certificates, port 80/tcp must be reachable from the Internet, and the virtualhost ServerName must have a Arecord in the public DNS system


Configuration Variables
-----------------------

See [defaults/main.yml](defaults/main.yml)


Example Playbook
----------------

```yaml
- hosts: my.example.org
  roles:
     - common
     - apache
  vars:
    apache_virtualhosts:
      - servername: "www.CHANGEME.org"
        documentroot: "/var/www/www.CHANGEME.org"
        https_mode: "selfsigned"
        allow_robots: no
```

Usage
-----

**Backups:** See the the included [rsnapshot configuration](templates/etc_rsnapshot.d_letsencrypt.conf) for the [backup](../backup/README.md) role

License
-------

[GNU GPLv3](../../LICENSE)


References
-----------------

- https://stdout.root.sx/links?searchtags=apache
- https://stdout.root.sx/links?searchtags=ssl
- https://stdout.root.sx/links?searchtags=database
- https://stdout.root.sx/links?searchtags=php
- https://stdout.root.sx/links?searchtags=web
