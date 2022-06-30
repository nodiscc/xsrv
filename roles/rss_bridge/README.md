# xsrv.rss_bridge

This role will install [RSS-Bridge](https://github.com/RSS-Bridge/rss-bridge),  a PHP project capable of generating RSS and Atom feeds for websites that don't have one.

RSS-Bridge is not a feed reader or feed aggregator, but a tool to generate feeds that are consumed by feed readers and feed aggregators, for example [Tiny Tiny RSS](../tt_rss).

[![](https://i.imgur.com/th1p7L5.png)](https://i.imgur.com/th1p7L5.png)


## Requirements/dependencies/example playbook

See [meta/main.yml](meta/main.yml)

```yaml
# playbook.yml
- hosts: my.CHANGEME.org
  roles:
    - nodiscc.xsrv.common # (optional) base server setup, hardening, bruteforce prevention
    - nodiscc.xsrv.monitoring # (optional) server monitoring and log aggregation
    - nodiscc.xsrv.backup # (optional) automatic backups
    - nodiscc.xsrv.apache # (required) webserver, PHP interpreter and SSL certificates
    - nodiscc.xsrv.rss_bridge

# required variables:
# host_vars/my.example.org/my.example.org.vault.yml
rss_bridge_fqdn: "rss-bridge.CHANGEME.org"
# ansible-vault edit host_vars/my.example.org/my.example.org.vault.yml
rss_bridge_auth_username: "CHANGEME"
rss_bridge_auth_password: "CHANGEME"
```

See [defaults/main.yml](defaults/main.yml) for all configuration variables


## Usage

[Documentation](https://github.com/RSS-Bridge/rss-bridge/wiki)

### Troubleshooting


To consume RSS-Bridge feeds from another service on the same host, add an entry to the machine's `hosts` file:

```bash
$ cat /etc/hosts
10.0.0.21       rssbridge.CHANGEME.org # use the external interface IP address
# 127.0.0.1       rssbridge.CHANGEME.org # using the loopback address may not always work
```

If the service consuming RSS-Bridge feeds does not allow trusting a self-signed certificate, and your RSS-Bridge instance uses one, add the RSS-Bridge instance's self-signed certificate to the client's SSL trust store:

```bash
# example for Debian clients
$ rsync -avzP my.CHANGEME.org:/etc/ssl/certs/rssbridge.CHANGEME.org.crt ./
$ sudo cp rssbridge.CHANGEME.org.crt /usr/local/share/ca-certificates/
$ sudo update-ca-certificates
```

### Backup

There is no data to backup/restore.


## License

[GNU GPLv3](../../LICENSE)


## References

- https://stdout.root.sx/links?searchtags=rss
