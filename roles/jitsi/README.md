# xsrv.jitsi

This role will install [Jitsi Meet](https://jitsi.org/jitsi-meet/), a fully encrypted, 100% open source video conferencing solution that you can use all day, every day, for free.
- High quality audio and video meetings
- No account needed to join public rooms
- Encrypted by default, advanced security settings
- Web, desktop and mobile clients

[![](https://gitlab.com/nodiscc/toolbox/-/raw/master/DOC/SCREENSHOTS/WyhF0tl.jpg)](https://gitlab.com/nodiscc/toolbox/-/raw/master/DOC/SCREENSHOTS/WyhF0tl.jpg)


## Requirements/dependencies/example playbook

- See [meta/main.yml](meta/main.yml)
- See [Jitsi documentation](https://jitsi.github.io/handbook/docs/devops-guide/devops-guide-requirements) on hardware and network requirements for acceptable performance.


```yaml
# playbook.yml
- hosts: my.CHANGEME.org
  roles:
    - nodiscc.xsrv.common # (optional) base server setup, hardening, firewall, bruteforce prevention
    - nodiscc.xsrv.monitoring # (optional) server monitoring, log aggregation
    - nodiscc.xsrv.apache # (required in the standard configuration) webserver/reverse proxy, SSL certificates
    - nodiscc.xsrv.jitsi

# required variables
# host_vars/my.CHANGEME.org/my.CHANGEME.org.yml
jitsi_fqdn: "conference.CHANGEME.org"

# ansible-vault edit host_vars/my.CHANGEME.org/my.CHANGEME.org.vault.yml
jitsi_turn_secret: "CHANGEME"
jitsi_prosody_password: "CHANGEME"
jitsi_jvb_prosody_password: "CHANGEME"
jitsi_users:
  - name: CHANGEME
    password: CHANGEME
```

See [defaults/main.yml](defaults/main.yml) for all configuration variables.


## Usage

Access https://conference.CHANGEME.org from a Web browser or use the application for your mobile OS (Android: [F-droid](https://f-droid.org/en/packages/org.jitsi.meet/), [Google Play](https://play.google.com/store/apps/details?id=org.jitsi.meet), iOS: [App store](https://apps.apple.com/us/app/jitsi-meet/id1165103905))

See the [User Guide](https://jitsi.github.io/handbook/docs/user-guide/) for more information.

**Uninstallation:**

```bash
sudo systemctl stop prosody.service jitsi-videobridge2.service jicofo.service
sudo apt purge lua5.2 lua-unbound prosody prosody-modules jicofo jitsi-meet-web jitsi-meet-prosody jitsi-videobridge2
sudo firewall-cmd --zone public --remove-service jitsi --permanent
sudo firewall-cmd --zone internal --remove-service jitsi --permanent
sudo rm -r /etc/apt/sources.list.d/prosody.list /etc/apt/sources.list.d/jitsi.list /usr/share/keyrings/prosody.gpg /usr/share/keyrings/jitsi.gpg /etc/apt/preferences.d/jitsi /etc/jitsi/ /etc/prosody/ /usr/share/jitsi-meet/ /var/lib/prosody/ /etc/fail2ban/jail.d/prosody.conf /etc/fail2ban/filter.d/prosody-auth.conf /etc/rsyslog.d/jitsi.conf /etc/ansible/facts.d/jitsi.fact /etc/firewalld/services/jitsi.xml /etc/apache2/sites-available/jitsi.conf /etc/apache2/sites-enabled/jitsi.conf 
sudo systemctl reload fail2ban.service apache2
sudo systemctl restart rsyslog firewalld
```

### Backups

There is no data worth backing up.

## Tags

<!--BEGIN TAGS LIST-->
```
jitsi - setup jitsi videoconferencing server
jitsi-users - setup jitsi registered users
utils-jitsi-listusers - (manual) list jitsi (prosody) registered users
```
<!--END TAGS LIST-->


## License

[GNU GPLv3](../../LICENSE)


## References

- https://stdout.root.sx/links/?searchterm=jitsi
- https://stdout.root.sx/links/?searchtags=communication+selfhosted
