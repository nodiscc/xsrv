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
    - nodiscc.xsrv.common # (optional) base server setup, hardening, bruteforce prevention
    - nodiscc.xsrv.monitoring # (optional) system monitoring and application health checks
    - nodiscc.xsrv.backup # (optional) automatic backups
    - nodiscc.xsrv.apache # (required) webserver, PHP interpreter and SSL certificates
    - nodiscc.xsrv.postgresql # (required) database engine
    - nodiscc.xsrv.tt_rss

# required variables:
# host_vars/my.CHANGEME.org/my.CHANGEME.org.yml  
tt_rss_fqdn: "rss.CHANGEME.org"
# ansible-vault edit host_vars/my.example.org/my.example.org.vault.yml
tt_rss_user: "CHANGEME"
tt_rss_password: "CHANGEME"
tt_rss_db_password: "CHANGEME"
tt_rss_password_salt: "CHANGEME"
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
# copy the last dump somewhere readable by the postgres user
sudo cp /var/backups/rsnapshot/daily.0/localhost/var/backups/postgresql/ttrss.sql /tmp/
# create a plaintext sql dump from the custom-formatted dump
sudo -u postgres pg_restore --clean --create /tmp/ttrss.sql > /tmp/ttrss.txt.sql
# restore the plaintext sql dump
sudo -u postgres psql --echo-errors --file /tmp/ttrss.txt.sql
# remove temporary files
sudo rm /tmp/ttrss.sql /tmp/ttrss.txt.sql
```


### Upgrades

Re-apply the role on a regular basis to ensure the application stays up to date.

_Note: due to TT-RSS "rolling" release model (always install the latest `master` branch), the role may upgrade the application without warning. Pin `tt_rss_version` to a specific commit hash from https://git.tt-rss.org/fox/tt-rss/commits/branch/master if you need to prevent this (but remember to update it manually/periodically).

## Tags

<!--BEGIN TAGS LIST-->
```
tt_rss - setup tt-rss feed reader
tt_rss-postgresql - setup tt-rss postgresql database
tt_rss-app - setup tt-rss appllication
tt_rss-permissions - set/fix permissions/ownership on tt-rss directories
```
<!--END TAGS LIST-->

## License

[GNU GPLv3](../../LICENSE)


## References

- https://stdout.root.sx/links/?searchtag=rss
