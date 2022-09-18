# ansible-playbook-default

Usage: `xsrv COMMAND default [HOST]`

[inventory](inventory.yml) · [playbook](playbook.yml) · [host variables](host_vars/) · [group variables](group_vars/) · [keepass keyring](default.kdbx) · [public keys](public_keys/) · [extra tasks](playbooks/) · [ansible.cfg](playbooks/) · [requirements/upgrades](requirements.yml) · [local backups/data/cache](data/)

<!--
## Monitoring
insert netdata badges here
-->

<!-- ## Documentation
![](diagram.png) Source ([Dia]((https://packages.debian.org/buster/dia)): [diagram.dia](diagram.dia)
- **Adding/removing/provisioning hosts: [PROXMOX.md](PROXMOX.md), [DEBIAN.md](DEBIAN.md), [PFSENSE.md](PFSENSE.md), [NAMING.md](NAMING.md)
- **Workstations:** [WORKSTATION-DEBIAN.md](WORKSTATION-DEBIAN.md); [WORKSTATION-WINDOWS.md](WORKSTATION-WINDOWS.md)
- **Printers:** [PRINTERS.md](PRINTERS.md)
- **Phones:** [PHONES.md](PHONES.md)
- **Cameras:** [CAMERAS.md](CAMERAS.md)
- **Appliances:** [APPLIANCES.md](APPLIANCES.md)
- **Licenses: [LICENSES.md](LICENSES.md)
- **Maintenance:** [MAINTENANCE.md](MAINTENANCE.md)

### Network

- Routing/NAT/firewall: [PFSENSE.md](PFSENSE.md)

#### VLANs

```yaml
- number: 1
  description: all company
  switch: sw1
  ports: 1-24
  networks: 10.0.0.0/24
- number: 2
  description: guest wifi
  switch: sw2
  ports: 25-26
  networks: 192.168.2.0/24, 192.168.3.0/24
```

#### Networks
```yaml
- network: 10.0.0.0/24
  addressing: static
```
-->