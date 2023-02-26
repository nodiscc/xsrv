# xsrv.jitsi

This role will install [Jitsi Meet](https://jitsi.org/jitsi-meet/), a fully encrypted, 100% open source video conferencing solution that you can use all day, every day, for free.
- High quality audio and video meetings
- No account needed to join public rooms
- Encrypted by default, advanced security settings
- Web, desktop and mobile clients

[![](https://i.imgur.com/WyhF0tl.jpg)](https://i.imgur.com/WyhF0tl.jpg)


## Requirements/dependencies/example playbook

See [meta/main.yml](meta/main.yml)

```yaml
# playbook.yml
- hosts: my.CHANGEME.org
  roles:
    - nodiscc.xsrv.common # (optional) base server setup, hardening, firewall, bruteforce prevention
    - nodiscc.xsrv.monitoring # (optional) server monitoring, log aggregation
    - nodiscc.xsrv.apache # webserver/reverse proxy, SSL certificates
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

See [Jitsi documentation](https://jitsi.github.io/handbook/docs/devops-guide/devops-guide-requirements) on hardware and network requirements for acceptable performance.

## Usage

Access https://conference.CHANGEME.org from a Web browser or use the application for your mobile OS (Android: [F-droid](https://f-droid.org/en/packages/org.jitsi.meet/), [Google Play](https://play.google.com/store/apps/details?id=org.jitsi.meet), iOS: [App store](https://apps.apple.com/us/app/jitsi-meet/id1165103905))

See the [User Guide](https://jitsi.github.io/handbook/docs/user-guide/) for more information.

### Backups

There is no data worth backing up.


## License

[GNU GPLv3](../../LICENSE)


## References

- https://stdout.root.sx/links/?searchterm=jitsi
- https://stdout.root.sx/links/?searchtags=communication+selfhosted
