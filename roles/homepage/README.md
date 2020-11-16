# xsrv.homepage

This role will setup a webserver homepage:
- list of installed services/applications on the host and links/shortcuts to accees these services
- WIP custom message/html

[![](https://i.imgur.com/3ZwPVQNs.png)](https://i.imgur.com/3ZwPVQN.png)


Requirements
------------

- Ansible 2.10 or higher.


Role Variables
--------------

See [defaults/main.yml](defaults/main.yml)


Dependencies
------------

- [apache](../apache/README.md) role (webserver, PHP interpreter and SSL certificates)
- quick access links will be displayed for the services provided by the [ssh/sftp (common)](../common), [nextcloud](../nextcloud), [rocketchat](../rocketchat), [shaarli](../shaarli), [tt-rss](../tt_rss), [transmission](../transmission), [gitea](../gitea), [mumble](../mumble), [netdata (monitoring)](../monitoring), [samba](../samba), [ldap-account-manager (openldap)](../openldap) roles, if enabled.

Example Playbook
----------------

```yaml
- hosts: my.example.org
  roles:
    - common
    - monitoring
    - apache
    - shaarli
    - rocketchat
    - ...
    - homepage
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
