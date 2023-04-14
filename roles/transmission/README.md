# xsrv.transmission

This role will install the [Transmission](https://en.wikipedia.org/wiki/Transmission_(BitTorrent_client)) Bittorrent client. [Bittorrent](https://en.wikipedia.org/wiki/BitTorrent) is a [Peer-to-peer](https://en.wikipedia.org/wiki/Peer-to-peer) file sharing network. Transmission allows you to manage torrent downloads from a web interface. Torrents will be downloaded to the server, and can be accessed them using file transfer services (SFTP, Nextcloud...) - also known as a [Seedbox](https://en.wikipedia.org/wiki/Seedbox).

[![](https://i.imgur.com/q1gcHRf.png)](https://i.imgur.com/q1gcHRf.png)


## Requirements/dependencies/example playbook

See [meta/main.yml](meta/main.yml)

```yaml
# playbook.yml
- hosts: my.CHANGEME.org
  roles:
    - nodiscc.xsrv.common # (optional) base server setup, hardening, firewall, bruteforce prevention
    - nodiscc.xsrv.monitoring # (optional) system/server monitoriong and health checks
    - nodiscc.xsrv.backup # (optional) automatic backups of download/torrent directory
    - nodiscc.xsrv.apache # (required) webserver/reverse proxy, SSL certificates
    - nodiscc.xsrv.transmission

# required variables
# ansible-vault edit host_vars/my.example.org/my.example.org.vault.yml
transmission_username: "CHANGEME"
transmission_password: "CHANGEME20"
```

See [defaults/main.yml](defaults/main.yml) for all configuration variables


## Usage

### Clients

- The Web interface can be used from a [web browser](https://www.mozilla.org/en-US/firefox/).
- Downloaded files can be accessed over SFTP (a link to the downloads directory is created in the admin user's home directory).
- If the [nextcloud](../nextcloud) role is installed, you may mount the downloads directory as an [External Storage](../nextcloud/README.md#transmission)


### Backups

See the included [rsnapshot configuration](templates/etc_rsnapshot.d_transmission.conf.j2) for the [backup](../backup) role.

To restore a backup:

```bash
# reinstall transmission by running the playbook/transmission role
xsrv deploy
# stop the transmission-daemon service
xsrv shell
sudo systemctl stop transmission-daemon
# Restore the data directory
rsync -avP /var/backups/rsnapshot/daily.0/localhost/var/lib/transmission-daemon/.config /var/lib/transmission-daemon/
rsync -avP /var/backups/rsnapshot/daily.0/localhost/var/lib/transmission-daemon/info /var/lib/transmission-daemon/
# restart the transmission-daemon service
xsrv shell
sudo systemctl start transmission-daemon
```


## Tags

<!--BEGIN TAGS LIST-->
```
transmission - setup transmission bittorrent client
```
<!--END TAGS LIST-->

## License

[GNU GPLv3](../../LICENSE)


## References

- https://stdout.root.sx/links/?searchtags=torrent
