# xsrv.homepage

This role will setup a simple webserver homepage/dashboard:
- list and shortcuts to services installed on the host ([ssh/sftp (common)](../common), [nextcloud](../nextcloud), [rocketchat](../rocketchat), [shaarli](../shaarli), [tt-rss](../tt_rss), [transmission](../transmission), [gitea](../gitea), [mumble](../mumble), [netdata (monitoring)](../monitoring), [samba](../samba), [ldap-account-manager (openldap)](../openldap)...)

[![](https://i.imgur.com/3ZwPVQNs.png)](https://i.imgur.com/3ZwPVQN.png)


Requirements/Dependencies
------------

- Ansible >= 2.10
- Debian 9/10
- [apache](../apache) role (webserver, PHP interpreter and SSL certificates)


Configuration Variables
--------------

See [defaults/main.yml](defaults/main.yml)


Example Playbook
----------------

```yaml
- hosts: my.CHANGEME.org
  roles:
    - nodiscc.xsrv.common
    - nodiscc.xsrv.monitoring
    - nodiscc.xsrv.apache
    - nodiscc.xsrv.shaarli
    - nodiscc.xsrv.rocketchat
    - nodiscc.xsrv.homepage

# host_vars/my.CHANGEME.org/my.CHANGEME.org.yml
homepage_fqdn: "www.CHANGEME.org"
```


Usage
-----

Access the homepage in a [web browser](https://www.mozilla.org/firefox/) at the URL/domain name defined by `{{ homepage_fqdn }}`.


License
-------

[GNU GPLv3](../../LICENSE)


References
-----------------

- https://github.com/ThisIsDallas/Simple-Grid
