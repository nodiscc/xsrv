# xsrv.apache

This role will install and configure the [Apache](https://en.wikipedia.org/wiki/Apache_HTTP_Server) webserver:

- [mod_md](https://httpd.apache.org/docs/2.4/mod/mod_md.html) for [Let's Encrypt](https://en.wikipedia.org/wiki/Let's_Encrypt) SSL/TLS certificate management, hardened ([A+](https://www.ssllabs.com/ssltest/)) SSL/TLS configuration
- [php-fpm](https://php-fpm.org/) PHP interpreter
- (optional) basic authentication login form brutefore prevention with [fail2ban](tasks/fail2ban.yml)
- (optional) aggregation of apache log files to [syslog](tasks/rsyslog.yml)
- monitoring metrics exporter for [prometheus/victoriametrics](../monitoring/victoriametrics/)


## Requirements/dependencies/example playbook

- See [meta/main.yml](meta/main.yml)
- For Let's Encrypt certificates, ports tcp/80 and tcp/443 must be reachable from the Internet, and the each virtualhost's FQDN (ServerName) must have a A or CNAME record in the public DNS system.


```yaml
- hosts: my.CHANGEME.org
  roles:
     - nodiscc.xsrv.common # (optional) basic setup, hardening, firewall, bruteforce prevention
     - nodiscc.xsrv.monitoring.exporters # (optional) monitoring metrics exporters
     - nodiscc.xsrv.apache

# required variables:
# ansible-vault edit host_vars/my.CHANGEME.org/my.CHANGEME.org.vault.yml
apache_letsencrypt_email: "CHANGEME"
```

See [defaults/main.yml](defaults/main.yml) for all configuration variables


## Usage

**Backups:** See the the included [rsnapshot configuration](templates/etc_rsnapshot.d_letsencrypt.conf) for the [backup](../backup/README.md) role

**Integration with other roles:** Each role relying on this one must install its own configuration in `/etc/apache2/{conf,sites}-{available,enabled}/` and notify the `reload/restart apache` handlers.

**Allow a user to read apache/web applications files:** Add the user to the `www-data` group. For example using the [`common`](../common/) role:

```yaml
linux_users:
  - name: "{{ ansible_user }}"
    groups: www-data
    append: yes
    comment: "ansible user/allowed to read/write web application files"
```

**Let's Encrypt certificates**: newly generated certificates may take up to 1 minute to become available.


## Tags

<!--BEGIN TAGS LIST-->
```
apache - setup the apache web server
ssl - setup SSL certificates and configuration
apache-reverseproxy - setup apache custom reverseproxies
```
<!--END TAGS LIST-->

## License

[GNU GPLv3](../../LICENSE)


## References

- https://stdout.root.sx/links?searchtags=doc+apache
- https://stdout.root.sx/links?searchtags=doc+ssl
- https://stdout.root.sx/links?searchtags=doc+php
- https://stdout.root.sx/links?searchtags=doc+web
