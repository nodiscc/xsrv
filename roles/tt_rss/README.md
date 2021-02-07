# xsrv.tt-rss

This role will install [Tiny Tiny RSS](https://tt-rss.org/), a web-based [News feed reader](https://en.wikipedia.org/wiki/News_aggregator) and aggregator.

A feed reader allows subscribing to many blogs/websites updates (using the [RSS](https://en.wikipedia.org/wiki/RSS)/ATOM standard), and access all articles in a single, unified application. It comes with extensive fiiltering/sorting/searching/presentation options, and plugins to improve integration of content from subscribed pages.

* **[Homepage/features](https://tt-rss.org/)**
* **[Community/forums](https://discourse.tt-rss.org/)**

[![](https://i.imgur.com/UoKs3x1.png)](https://i.imgur.com/yDozQPU.jpg)
[![](https://i.imgur.com/7oO67Xq.png)](https://i.imgur.com/rNTiRva.png)
[![](https://i.imgur.com/CqoOfXo.png)](https://i.imgur.com/mv2fppi.jpg)


## Requirements/dependencies/example playbook

See [meta/main.yml](meta/main.yml)

```yaml
# playbook.yml
- hosts: my.CHANGEME.org
  roles:
    - nodiscc.xsrv.common # bruteforce prevention
    - nodiscc.xsrv.monitoring # (optional)
    - nodiscc.xsrv.backup # (optional) automatic backups
    - nodiscc.xsrv.postgresql # database engine
    - nodiscc.xsrv.apache # webserver, PHP interpreter and SSL certificates
    - nodiscc.xsrv.tt_rss

# host_vars/my.CHANGEME.org/my.CHANGEME.org.yml  
tt_rss_fqdn: "rss.CHANGEME.org"

# ansible-vault edit host_vars/my.example.org/my.example.org.vault.yml
vault_tt_rss_user: "CHANGEME"
vault_tt_rss_password: "CHANGEME"
vault_tt_rss_db_password: "CHANGEME"
vault_tt_rss_password_salt: "CHANGEME"
```

See [defaults/main.yml](defaults/main.yml) for all configuration variables


## Usage

### Clients

Tiny Tiny RSS can be accessed through:

- a [web browser](https://www.mozilla.org/firefox/)
- [TTRSS-Reader](https://f-droid.org/repository/browse/?fdid=org.ttrssreader) (Android)
- [Liferea](https://lzone.de/liferea/) (Linux)
- [Awesome RSS](https://addons.mozilla.org/en-US/firefox/addon/awesome-rss/) Firefox extension


### Backups

See the included [rsnapshot configuration](templates/etc_rsnapshot.tt-rss.conf.j2) for the [backup](../backup/README.md) role.

To restore backups:

```bash
# remove the file indicating the database is populated
sudo rm /etc/ansible/facts.d/tt_rss.fact

# remove cached database credentials
sudo rm /root/tt_rss_admin_user_info.sql

# remove the application
sudo rm -r /var/www/my.example.com/tt-rss/

# remove the database and user
sudo -u postgres psql -c "DROP DATABASE ttrss; DROP USER ttrss;"

# from the ansible controller, reinstall the application, eg. ansible-playbook playbook.yml

# restore database backups
sudo -u postgres pg_restore /var/backups/rsnapshot/daily.0/localhost/var/backups/postgresql/ttrss.sql
```


### Upgrades

Re-apply the role on a regular basis to ensure the application stays up to date.

This role is not always idempotent - tt-rss is always upgraded to the latest available version (git `master` branch).


License
-------

[GNU GPLv3](../../LICENSE)


References
-----------------

- https://stdout.root.sx/links/?searchtag=rss
