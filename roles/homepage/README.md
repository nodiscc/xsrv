# xsrv.homepage

This role will setup a simple webserver homepage/dashboard:
- list and shortcuts to services installed on the host ([ssh/sftp (common)](../common), [nextcloud](../nextcloud), [rocketchat](../rocketchat), [shaarli](../shaarli), [tt-rss](../tt_rss), [transmission](../transmission), [gitea](../gitea), [mumble](../mumble), [netdata (monitoring)](../monitoring), [samba](../samba), [ldap-account-manager (openldap)](../openldap)...), [jellyfin](../jellyfin)

[![](https://i.imgur.com/KDJZuFO.png)](https://i.imgur.com/wkgmogw.png)


## Requirements/dependencies/example playbook

See [meta/main.yml](meta/main.yml)

```yaml
- hosts: my.CHANGEME.org
  roles:
    - nodiscc.xsrv.common # (optional) basic setup, hardening, firewall
    - nodiscc.xsrv.monitoring # (optional) system/server monitoring and health checks
    - nodiscc.xsrv.apache # (enabled automatically) web server and SSL/TLS certificates
    - nodiscc.xsrv.shaarli # (example) any supported role, a link to this application on the homepage will be added
    - nodiscc.xsrv.rocketchat # (example) any supported role, a link to this application on the homepage will be added
    - nodiscc.xsrv.homepage

# required variables:
# host_vars/my.CHANGEME.org/my.CHANGEME.org.yml
homepage_fqdn: "www.CHANGEME.org"
```

See [defaults/main.yml](defaults/main.yml) for all configuration variables

## Usage

Access the homepage in a [web browser](https://www.mozilla.org/firefox/) at the URL/domain name defined by `{{ homepage_fqdn }}`.


## License

[GNU GPLv3](../../LICENSE)


## References

- https://github.com/ThisIsDallas/Simple-Grid
