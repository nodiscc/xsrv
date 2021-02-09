# xsrv.mumble

This role will install [Mumble](https://en.wikipedia.org/wiki/Mumble_(software)) server, a voice chat ([VoIP](https://en.wikipedia.org/wiki/Voice_over_IP)) server. It is primarily designed for use by gamers and can replace commercial programs such as TeamSpeak or Ventrilo.

[![](https://i.imgur.com/jYSU9zC.png)](https://i.imgur.com/S5Z6IEw.png)


Requirements/Dependencies
------------

- Ansible >= 2.9
- The [common](../common/README.md) role (hardening/firewall/bruteforce prevention)
- The [backup](../backup/README.md) role (automatic backups, optional)


Configuration Variables
--------------

See [defaults/main.yml](defaults/main.yml)


Example Playbook
----------------

```yaml
- hosts: my.CHANGEME.org
  roles:
    - nodiscc.xsrv.common
    - nodiscc.xsrv.monitoring
    - nodiscc.xsrv.backup
    - nodiscc.xsrv.mumble

# ansible-vault edit host_vars/my.example.org/my.example.org.vault.yml
vault_mumble_password: "CHANGEME"
vault_mumble_superuser_password: "CHANGEME20"
```

Usage
-----

### Backups

See the included [rsnapshot configuration](templates/etc_rsnapshot.d/mumble-server.conf.j2) for the [backup](../backup/) role.

To restore backups, deploy the role and restore the `/var/lib/mumble-server/` directory:

```bash
sudo rsync -avP /var/backups/rsnapshot/daily.0/localhost/var/lib/mumble-server /var/lib/
```

### Clients

Mumble [clients](https://wiki.mumble.info/wiki/Main_Page) are available many computer/mobile operating systems (Windows/OSX/Linux/iOS/Android)

- [Desktop client (Linux/OSX/Windows)](https://wiki.mumble.info/wiki/Main_Page#Download_Mumble)
- Android: [Plumble](https://f-droid.org/en/packages/com.morlunk.mumbleclient/)

License
-------

[GNU GPLv3](../../LICENSE)


References
-----------------

- https://stdout.root.sx/links/?searchterms=mumble

