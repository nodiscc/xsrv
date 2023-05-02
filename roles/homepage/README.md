# xsrv.homepage

This role will setup a simple webserver homepage/dashboard:
- list and shortcuts to services installed on the host (if managed by xsrv [roles](https://xsrv.readthedocs.io/en/latest/#roles))

[![](https://i.imgur.com/oA8WG4e.png)](https://i.imgur.com/oA8WG4e.png)


## Requirements/dependencies/example playbook

See [meta/main.yml](meta/main.yml)

```yaml
- hosts: my.CHANGEME.org
  roles:
    - nodiscc.xsrv.common # (optional) base server setup, hardening
    - nodiscc.xsrv.monitoring # (optional) system/server monitoring and health checks
    - nodiscc.xsrv.apache # (required in the standard configuration) web server and SSL/TLS certificates
    - nodiscc.xsrv.shaarli # (example) any supported role, a link to this application on the homepage will be added
    - nodiscc.xsrv.nextcloud # (example) any supported role, a link to this application on the homepage will be added
    - nodiscc.xsrv.homepage # the homepage role must be deployed *after* application roles

# required variables:
# host_vars/my.CHANGEME.org/my.CHANGEME.org.yml
homepage_fqdn: "www.CHANGEME.org"
```

See [defaults/main.yml](defaults/main.yml) for all configuration variables


## Usage

Access the homepage in a [web browser](https://www.mozilla.org/firefox/) at the URL/domain name defined by `{{ homepage_fqdn }}`.


## Tags

<!--BEGIN TAGS LIST-->
```
homepage - setup simple webserver homepage
```
<!--END TAGS LIST-->


## License

[GNU GPLv3](../../LICENSE)


## References

- https://github.com/ThisIsDallas/Simple-Grid
