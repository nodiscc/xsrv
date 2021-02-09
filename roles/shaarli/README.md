# xsrv.shaarli

This role will install [Shaarli](https://shaarli.readthedocs.io/en/master/), a minimalist bookmark manager and link sharing service.


* [Demo](https://demo.shaarli.org/)
* [Documentation](https://shaarli.readthedocs.io/en/master/)
* [Github project](https://github.com/shaarli/shaarli)

[![](https://i.imgur.com/8wEBRSG.png)](https://i.imgur.com/WWPfSj0.png) [![](https://i.imgur.com/93PpLLs.png)](https://i.imgur.com/V09kAQt.png) [![](https://i.imgur.com/rrsjWYy.png)](https://i.imgur.com/TZzGHMs.png) [![](https://i.imgur.com/8iRzHfe.png)](https://i.imgur.com/sfJJ6NT.png) [![](https://i.imgur.com/GjZGvIh.png)](https://i.imgur.com/QsedIuJ.png) [![](https://i.imgur.com/TFZ9PEq.png)](https://i.imgur.com/KdtF8Ll.png) [![](https://i.imgur.com/uICDOle.png)](https://i.imgur.com/27wYsbC.png) [![](https://i.imgur.com/tVvD3gH.png)](https://i.imgur.com/zGF4d6L.jpg)


## Requirements/dependencies/example playbook

See [meta/main.yml](meta/main.yml)

```yaml
# playbook.yml
- hosts: my.CHANGEME.org
  roles:
    - nodiscc.xsrv.common # fail2ban bruteforce protection
    - nodiscc.xsrv.backup # (optional) automatic backups
    - nodiscc.xsrv.monitoring # (optional) apache monitoring
    - nodiscc.xsrv.apache # webserver, PHP interpreter and SSL certificates
    - nodiscc.xsrv.shaarli

# host_vars/my.CHANGEME.org/my.CHANGEME.org.yml
shaarli_fqdn: "links.CHANGEME.org"

# ansible-vault edit host_vars/my.example.org/my.example.org.vault.yml
vault_shaarli_user: "CHANGEME"
vault_shaarli_password: "CHANGEME"
vault_shaarli_password_salt: "CHANGEME"
vault_shaarli_api_secret: "CHANGEME"
```

See [defaults/main.yml](defaults/main.yml) for all configuration variables


## Usage

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
