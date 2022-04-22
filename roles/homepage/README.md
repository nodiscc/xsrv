# xsrv.homepage

This role will setup a simple webserver homepage/dashboard:
- list and shortcuts to services installed on the host ([ssh/sftp (common)](../common), [nextcloud](../nextcloud), [rocketchat](../rocketchat), [shaarli](../shaarli), [tt-rss](../tt_rss), [transmission](../transmission), [gitea](../gitea), [mumble](../mumble), [netdata (monitoring)](../monitoring), [samba](../samba), [ldap-account-manager (openldap)](../openldap)...), [jellyfin](../jellyfin)

[![](https://i.imgur.com/9JGkA8E.png)](https://i.imgur.com/PTeVCM1.png)


## Requirements/dependencies/example playbook

See [meta/main.yml](meta/main.yml)

```yaml
- hosts: my.CHANGEME.org
  roles:
    - nodiscc.xsrv.common # (optional) base server setup, hardening
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

_Note:_ This role should be listed _after_ other roles it integrates with, else applications/services that are not yet deployed when the role runs, will not be listed.


## Usage

Access the homepage in a [web browser](https://www.mozilla.org/firefox/) at the URL/domain name defined by `{{ homepage_fqdn }}`.


## License

[GNU GPLv3](../../LICENSE)


## References

- https://github.com/ThisIsDallas/Simple-Grid
