# xsrv.proxmox

This role will perform basic setup steps for [Proxmox](hhttps://en.wikipedia.org/wiki/Proxmox_Virtual_Environment) hypervisors:
- setup `pve-no-subscription` APT repositories
- protect from bruteforce on the login form using `fail2ban` (if `nodiscc.xsrv.common` role is deployed)

> Proxmox Virtual Environment (Proxmox VE or PVE) is an open-source software server for virtualization management. It is a Debian-based Linux distribution and allows deployment and management of virtual machines and containers. Proxmox VE includes a web console and command-line tools.

[![](https://i.imgur.com/7DYZfcC.png)](https://i.imgur.com/7DYZfcC.png)


## Requirements/dependencies/example playbook

See [meta/main.yml](meta/main.yml)

```yaml
# playbook.yml
- hosts: my.CHANGEME.org
  roles:
    - nodiscc.xsrv.common # (optional) hardening/bruteforce protection/automatic security upgrades
    - nodiscc.xsrv.monitoring # (optional) server monitoring and log aggregation
    - nodiscc.xsrv.proxmox
```

See [defaults/main.yml](defaults/main.yml) for all configuration variables


## Usage

### Backups

Backup the `/etc/pve/` directory to backup proxmox configuration including VM definitions. Backup `/var/lib/vz/dump` to backup VM snapshots.

## Tags

<!--BEGIN TAGS LIST-->
```
proxmox - setup proxmox hypervisor
```
<!--END TAGS LIST-->


## License

[GNU GPLv3](../../LICENSE)


## References

- https://stdout.root.sx/links/?searchterms=proxmox
- https://stdout.root.sx/links/?searchtags=virtualization
