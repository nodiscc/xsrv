# xsrv.monitoring.goaccess

This role will install and configure [goaccess](https://goaccess.io/), a real-time web log analyzer and interactive viewer.
- Terminal based (`ncurses`), fast, real-time dashboards
- HTML dashboards updated on a configurable schedule
- Detailed statistics for each webserver virtualhost
- Integration with the [`nodiscc.xsrv.apache`](../apache) role

[![](https://gitlab.com/nodiscc/toolbox/-/raw/master/DOC/SCREENSHOTS/goaccess-bright.png)](https://gitlab.com/nodiscc/toolbox/-/raw/master/DOC/SCREENSHOTS/goaccess-bright.png)


## Requirements/dependencies/example playbook

See [meta/main.yml](meta/main.yml)

```yaml
# playbook.yml
- hosts: my.CHANGEME.org
  roles:
    - nodiscc.xsrv.common # (optional) base server setup, hardening, firewall, bruteforce prevention
    - nodiscc.xsrv.monitoring # (optional) server monitoring, log aggregation
    - nodiscc.xsrv.apache # (required) web server, webserver/reverse proxy, SSL certificates
    - nodiscc.xsrv.monitoring.goaccess

# required variables
# host_vars/my.CHANGEME.org/my.CHANGEME.org.yml
goaccess_fqdn: "goaccess.CHANGEME.org"

# ansible-vault edit host_vars/my.CHANGEME.org/my.CHANGEME.org.vault.yml
goaccess_username: "CHANGEME"
goaccess_password: "CHANGEME"
```

See [defaults/main.yml](defaults/main.yml) for all configuration variables.


## Usage

Access the HTML report from a web browser, at https://`{{ goaccess_fqdn }}`. Access is restricted by the `goaccess_username`/`goaccess_password` credentials. You can also fetch the HTML report to your local machine, by downloading `/var/www/{{ goaccess_fqdn }}/index.html` from the remote host over SFTP/rsync.

Use the `utils-goaccess-update` ansible tag to force an regenerating/updating the HTML report immediately, without waiting for the timer:

```bash
# using xsrv
TAGS=utils-goaccess-update xsrv deploy default my.CHANGEME.org
# using ansible command-line tools
ansible-playbook playbook.yml --tags utils-goaccess-update --limit my.CHANGEME.org
```

Statistics are persisted in `/var/lib/goaccess/db/`. To remove old statistics, and only keep statistics for your apache log retention period (15 days by default), delete `/var/lib/goaccess/db/*` and regenerate the report.


**Uninstallation:**

```bash
sudo userdel --remove goaccess
sudo apt -y purge goaccess
sudo systemctl disable --now goaccess-update.timer goaccess-update.service
sudo rm -rf /etc/ssl/private/goaccess.CHANGEME.org.key /etc/ssl/private/goaccess.CHANGEME.org.csr /etc/ssl/certs/goaccess.CHANGEME.org.crt /etc/goaccess /var/www/goaccess.CHANGEME.org /etc/systemd/system/goaccess-update.service /etc/systemd/system/goaccess-update.timer /etc/ansible/facts.d/goaccess.fact /etc/apache2/sites-available/goaccess.conf /etc/apache2/sites-enabled/goaccess.conf
sudo systemctl daemon-reload
sudo systemctl reload apache2
```

### Backups

There is no data worth backing up.


## Tags

<!--BEGIN TAGS LIST-->
```
goaccess - setup goaccess web log analyzer/viewer
utils-goaccess-update - (manual) update/regenerate goacess report immediately
```
<!--END TAGS LIST-->


## License

[GNU GPLv3](../../LICENSE)


## References

- https://stdout.root.sx/links/?searchterm=goaccess
