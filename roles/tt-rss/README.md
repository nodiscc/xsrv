tt-rss
=============

This role will install [Tiny Tiny RSS](https://tt-rss.org/), a web-based [News feed reader](https://en.wikipedia.org/wiki/News_aggregator) and aggregator.

A feed reader allows subscribing to many blogs/websites updates using the [RSS](https://en.wikipedia.org/wiki/RSS)/ATOM standard, and access all articles in a single, unified application. It comes with extensive fiiltering/sorting/searching/presentation options, and plugins to improve integration of content from subscribed pages.

* **[Homepage/features](https://tt-rss.org/)**
* **[Community/forums](https://discourse.tt-rss.org/)**

[![](https://i.imgur.com/UoKs3x1.png)](https://i.imgur.com/yDozQPU.jpg)
[![](https://i.imgur.com/7oO67Xq.png)](https://i.imgur.com/rNTiRva.png)
[![](https://i.imgur.com/CqoOfXo.png)](https://i.imgur.com/mv2fppi.jpg)

This role is not always idempotent - tt-rss is always upgraded to the latest available version (git master).

Requirements
------------

This role requires Ansible 2.8 or higher.


Role Variables
--------------

See [defaults/main.yml](defaults/main.yml)


Dependencies
------------

Recommended:

- The [lamp](https://gitlab.com/nodiscc/ansible-xsrv-lamp) role or similar apache setup
- The [common](https://gitlab.com/nodiscc/ansible-xsrv-common) role for fail2ban support
- The [backup](https://gitlab.com/nodiscc/ansible-xsrv-common) role automatic backups

Example Playbook
----------------

```yaml
- hosts: my.example.org
  roles:
    - common
    - monitoring
    - lamp
    - tt-rss
  vars:
    tt_rss_user: "CHANGEME"
    tt_rss_password: "CHANGEME"
```

Usage
-----

### Clients

Tiny Tiny RSS can be accessed through a web browser. Other applications can be used:

- [TTRSS-Reader](https://f-droid.org/repository/browse/?fdid=org.ttrssreader) (Android)
- [Liferea](https://lzone.de/liferea/) (Linux)
- [Awesome RSS](https://addons.mozilla.org/en-US/firefox/addon/awesome-rss/) Firefox extension

### Backups

See the included [rsnapshot configuration](templates/etc_rsnapshot.tt-rss.conf.j2) for the [backup](https://gitlab.com/nodiscc/ansible-xsrv-backup) role. To restore backups:

```bash
# remove the file indicating the database is populated
sudo rm /etc/ansible/facts.d/tt_rss.fact

# remove cached database credentials
sudo rm /root/tt_rss_admin_user_info.sql

# remove the application
sudo rm -r /var/www/my.example.com/tt-rss/

# remove the database and user
sudo mysql -e "DROP DATABASE ttrss; DROP USER 'ttrss'@'localhost';"

# from the ansible controller, reinstall the application, eg. ansible-playbook playbook.yml

# restore database backups
sudo mysql ttrss < /var/backups/rsnapshot/daily.0/localhost/mysql/tt-rss.sql
```

License
-------

[GNU GPLv3](../../LICENSE)


References
-----------------

- https://stdout.root.sx/links/?searchtag=rss
