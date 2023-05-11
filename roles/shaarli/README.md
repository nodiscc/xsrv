# xsrv.shaarli

This role will install [Shaarli](https://shaarli.readthedocs.io/en/master/), a minimalist bookmark manager and link sharing service.

[![](https://gitlab.com/nodiscc/toolbox/-/raw/master/DOC/SCREENSHOTS/8wEBRSG.png)](https://gitlab.com/nodiscc/toolbox/-/raw/master/DOC/SCREENSHOTS/WWPfSj0.png) [![](https://gitlab.com/nodiscc/toolbox/-/raw/master/DOC/SCREENSHOTS/93PpLLs.png)](https://gitlab.com/nodiscc/toolbox/-/raw/master/DOC/SCREENSHOTS/V09kAQt.png) [![](https://gitlab.com/nodiscc/toolbox/-/raw/master/DOC/SCREENSHOTS/rrsjWYy.png)](https://gitlab.com/nodiscc/toolbox/-/raw/master/DOC/SCREENSHOTS/TZzGHMs.png) [![](https://gitlab.com/nodiscc/toolbox/-/raw/master/DOC/SCREENSHOTS/8iRzHfe.png)](https://gitlab.com/nodiscc/toolbox/-/raw/master/DOC/SCREENSHOTS/sfJJ6NT.png) [![](https://gitlab.com/nodiscc/toolbox/-/raw/master/DOC/SCREENSHOTS/GjZGvIh.png)](https://gitlab.com/nodiscc/toolbox/-/raw/master/DOC/SCREENSHOTS/QsedIuJ.png) [![](https://gitlab.com/nodiscc/toolbox/-/raw/master/DOC/SCREENSHOTS/TFZ9PEq.png)](https://gitlab.com/nodiscc/toolbox/-/raw/master/DOC/SCREENSHOTS/KdtF8Ll.png) [![](https://gitlab.com/nodiscc/toolbox/-/raw/master/DOC/SCREENSHOTS/uICDOle.png)](https://gitlab.com/nodiscc/toolbox/-/raw/master/DOC/SCREENSHOTS/27wYsbC.png) [![](https://gitlab.com/nodiscc/toolbox/-/raw/master/DOC/SCREENSHOTS/tVvD3gH.png)](https://gitlab.com/nodiscc/toolbox/-/raw/master/DOC/SCREENSHOTS/zGF4d6L.jpg), and optionally:
- [apache](tasks/apache.yml) webserver configuration and SSL/TLS certificates
- automatic local [backups](tasks/backup.yml)
- [fail2ban](tasks/fail2ban.yml) login bruteforce prevention
- monitoring and log aggregation through [netdata](tasks/netdata.yml) and [rsyslog](tasks/rsyslog.yml)
- [python client for the Shaarli API](https://github.com/shaarli/python-shaarli-client/)


## Requirements/dependencies/example playbook

See [meta/main.yml](meta/main.yml)

```yaml
# playbook.yml
- hosts: my.CHANGEME.org
  roles:
    - nodiscc.xsrv.common # (optional) base server setup, hardening, firewall, bruteforce prevention
    - nodiscc.xsrv.backup # (optional) automatic backups
    - nodiscc.xsrv.monitoring # (optional) apache monitoring
    - nodiscc.xsrv.apache # (required in the standard configuration) webserver, PHP interpreter and SSL certificates
    - nodiscc.xsrv.shaarli

# required variables:
# host_vars/my.CHANGEME.org/my.CHANGEME.org.yml
shaarli_fqdn: "links.CHANGEME.org"
# ansible-vault edit host_vars/my.example.org/my.example.org.vault.yml
shaarli_user: "CHANGEME"
shaarli_password: "CHANGEME"
shaarli_password_salt: "CHANGEME"
shaarli_api_secret: "CHANGEME"
```

See [defaults/main.yml](defaults/main.yml) for all configuration variables


## Usage

* [Demo](https://demo.shaarli.org/)
* [Documentation](https://shaarli.readthedocs.io/en/master/)
* [Github project](https://github.com/shaarli/shaarli)

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


## Tags

<!--BEGIN TAGS LIST-->
```
shaarli - setup shaarli bookmark service
shaarli-config - setup main shaarli configuration
```
<!--END TAGS LIST-->

## License

[GNU GPLv3](../../LICENSE)


## References

- https://shaarli.readthedocs.io/en/master/
