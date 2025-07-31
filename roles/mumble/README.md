# xsrv.mumble

This role will install [Mumble](https://en.wikipedia.org/wiki/Mumble_(software)) server, a voice chat ([VoIP](https://en.wikipedia.org/wiki/Voice_over_IP)) server. It is primarily designed for use by gamers and can replace commercial programs such as TeamSpeak or Ventrilo.

It also configures:
- (optional) login bruteforce prevention using [fail2ban](tasks/fail2ban.yml)
- (optional) aggregation of mumble server logs to [syslog](tasks/rsyslog.yml)

[![](https://gitlab.com/nodiscc/toolbox/-/raw/master/DOC/SCREENSHOTS/S5Z6IEw.png)](https://gitlab.com/nodiscc/toolbox/-/raw/master/DOC/SCREENSHOTS/S5Z6IEw.png)


## Requirements/dependencies/example playbook

See [meta/main.yml](meta/main.yml)

```yaml
# playbook.yml
- hosts: my.CHANGEME.org
  roles:
    - nodiscc.xsrv.common # (optional) base server setup, hardening, firewall, bruteforce prevention
    - nodiscc.xsrv.monitoring # (optional) server monitoring and log aggregation
    - nodiscc.xsrv.backup # (optional) automatic backups of mumble server database
    - nodiscc.xsrv.mumble

# required variables:
# ansible-vault edit host_vars/my.example.org/my.example.org.vault.yml
mumble_password: "CHANGEME"
mumble_superuser_password: "CHANGEME20"
```

See [defaults/main.yml](defaults/main.yml) for all configuration variables


## Usage

### Clients

Mumble [clients](https://wiki.mumble.info/wiki/Main_Page) are available many computer/mobile operating systems (Windows/OSX/Linux/iOS/Android)

- [Desktop client (Linux/OSX/Windows)](https://wiki.mumble.info/wiki/Main_Page#Download_Mumble)
- Android: [Plumble](https://f-droid.org/en/packages/com.morlunk.mumbleclient/)

### Backups

See the included [rsnapshot configuration](templates/etc_rsnapshot.d/mumble-server.conf.j2) for the [backup](../backup/) role.

To restore backups, deploy the role and restore the `/var/lib/mumble-server/` directory:

```bash
sudo rsync -avP /var/backups/rsnapshot/daily.0/localhost/var/lib/mumble-server /var/lib/
```

### Uninstallation

```bash
sudo systemctl stop mumble-server
sudo apt purge mumble-server
sudo firewall-cmd --zone public --remove-service mumble --permanent
sudo firewall-cmd --zone internal --remove-service mumble --permanent
sudo rm -rf /etc/mumble-server.ini /var/lib/mumble-server /etc/fail2ban/jail.d/mumble.conf /etc/rsnapshot.d/mumble-server.conf /etc/rsyslog.d/mumble.conf /etc/firewalld/services/mumble.xml /etc/ansible/facts.d/mumble.fact
sudo systemctl reload fail2ban
sudo systemctl restart rsyslog firewalld
```


## Tags

<!--BEGIN TAGS LIST-->
```
mumble - setup mumble voip server
```
<!--END TAGS LIST-->


## License

[GNU GPLv3](../../LICENSE)


## References

- https://stdout.root.sx/links/?searchterms=mumble

