# xsrv.shaarli

This role will install [Shaarli](https://shaarli.readthedocs.io/en/master/), a minimalist bookmark manager and link sharing service.


* [Demo](https://demo.shaarli.org/)
* [Documentation](https://shaarli.readthedocs.io/en/master/)
* [Github project](https://github.com/shaarli/shaarli)

[![](https://i.imgur.com/8wEBRSG.png)](https://i.imgur.com/WWPfSj0.png) [![](https://i.imgur.com/93PpLLs.png)](https://i.imgur.com/V09kAQt.png) [![](https://i.imgur.com/rrsjWYy.png)](https://i.imgur.com/TZzGHMs.png) [![](https://i.imgur.com/8iRzHfe.png)](https://i.imgur.com/sfJJ6NT.png) [![](https://i.imgur.com/GjZGvIh.png)](https://i.imgur.com/QsedIuJ.png) [![](https://i.imgur.com/TFZ9PEq.png)](https://i.imgur.com/KdtF8Ll.png) [![](https://i.imgur.com/uICDOle.png)](https://i.imgur.com/27wYsbC.png) [![](https://i.imgur.com/tVvD3gH.png)](https://i.imgur.com/zGF4d6L.jpg)


Requirements
------------

- Ansible 2.9 or higher.


Role Variables
--------------

See [defaults/main.yml](defaults/main.yml)


Dependencies
------------

- [apache](../apache/README.md) role (webserver, PHP interpreter and SSL certificates)
- [common](../common/README.md) role (for fail2ban support)
- [backup](../backup/README.md) role (for automatic backups, optional)


Example Playbook
----------------

```yaml
- hosts: my.example.org
  roles:
    - common
    - monitoring
    - apache
    - shaarli

# ansible-vault edit host_vars/my.example.org/my.example.org.vault.yml
vault_shaarli_user: "CHANGEME"
vault_shaarli_password: "CHANGEME"
vault_shaarli_password_salt: "CHANGEME"
vault_shaarli_api_secret: "CHANGEME"
```

Usage
-----

### Clients

Shaarli RSS can be accessed through:

- a [web browser](https://www.mozilla.org/firefox/)
- [Browser addons or mobile applications](https://shaarli.readthedocs.io/en/doc-rework-setup/Community-and-related-software/)

### Backups

See the included [rsnapshot configuration](templates/etc_rsnapshot.d/shaarli.conf.j2) for the [backup](../backup/) role.

To restore backups, deploy the role and restore the `data/` directory:

```bash
sudo rsync -avP /var/backups/rsnapshot/daily.0/localhost/var/www/links.CHANGEME.org/data /var/www/links.CHANGEME.org/
```


### Upgrades

Re-apply the role on a regular basis to ensure the application stays up to date.

This role is not always idempotent - tt-rss is always upgraded to the latest available version (git `master` branch).


License
-------

[GNU GPLv3](../../LICENSE)


References
-----------------

- https://shaarli.readthedocs.io/en/master/
