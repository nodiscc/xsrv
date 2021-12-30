# xsrv.proxmox

This role will perform basic setup steps for a [Proxmox](https://www.proxmox.com/en/proxmox-ve) hypervisor:
- setup `pve-no-subscription` APT repositories
- protect from bruteforce on the login form using `fail2ban` (if `nodiscc.xsrv.common` role is deployed)


[![](https://www.proxmox.com/images/proxmox/screenshots/Proxmox-VE-6-1-Cluster-Summary-small.png)](https://www.proxmox.com/images/proxmox/screenshots/Proxmox-VE-6-1-Cluster-Summary.png)


## Requirements/eependencies/example playbook

See [meta/main.yml](meta/main.yml)

```yaml
# playbook.yml
- hosts: my.CHANGEME.org
  roles:
    - nodiscc.xsrv.common # (optional) hardening/bruteforce protection/automatic security upgrades
    - nodiscc.xsrv.monitoring # (optional) server monitoring and log aggregation
    - nodiscc.xsrv.proxmox
    - nodiscc.xsrv.mumble
```

See [defaults/main.yml](defaults/main.yml) for all configuration variables


### Backups

TODO

## License

[GNU GPLv3](../../LICENSE)


## References

- https://stdout.root.sx/links/?searchterms=proxmox
- https://stdout.root.sx/links/?searchtags=virtualization
