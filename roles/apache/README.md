# xsrv.apache

This role will install and configure the [Apache](https://en.wikipedia.org/wiki/Apache_HTTP_Server) webserver:

- [mod_md](https://httpd.apache.org/docs/2.4/mod/mod_md.html) for [Let's Encrypt](https://en.wikipedia.org/wiki/Let's_Encrypt) SSL/TLS certificate management, hardened ([A+](https://www.ssllabs.com/ssltest/)) SSL/TLS configuration
- [php-fpm](https://php-fpm.org/) PHP interpreter
- (optional) `mod_evasive` to mitigate basic DoS attack attempts
- (optional) agregation of apache log files to syslog


## Requirements/dependencies/example playbook

- See [meta/main.yml](meta/main.yml)
- For Let's Encrypt certificates, ports tcp/80 and tcp/443 must be reachable from the Internet, and the each virtualhost's FQDN (ServerName) must have a A or CNAME record in the public DNS system.


```yaml
- hosts: my.CHANGEME.org
  roles:
     - nodiscc.xsrv.common # optional
     - nodiscc.xsrv monitoring # optional, apache/virtualhost monitoring/log aggregation
     - nodiscc.xsrv.apache
```

See [defaults/main.yml](defaults/main.yml) for all configuration variables


## Usage

**Backups:** See the the included [rsnapshot configuration](templates/etc_rsnapshot.d_letsencrypt.conf) for the [backup](../backup/README.md) role


**Integration with other roles:**

Each role relying on this one must install its own configuration in `/etc/apache2/*-enabled/` and notify the `reload/restart apache` handlers.



## License

[GNU GPLv3](../../LICENSE)


## References

- https://stdout.root.sx/links?searchtags=doc+apache
- https://stdout.root.sx/links?searchtags=doc+ssl
- https://stdout.root.sx/links?searchtags=doc+php
- https://stdout.root.sx/links?searchtags=doc+web
