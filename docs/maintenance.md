# Maintenance

Self-hosting places your services and data under your own responsibility (availability, integrity, confidentiality...). Always have a plan in place if your server crashes, gets compromised or damaged. There is no High Availability mechanism configured by default.


## Backups

Always keep 3 copies of valuable data (the working data, a local backup - preferably on a dedicated drive, and an off-line, off-site backup).

The [backup](roles/backup) role performs automatic daily/weekly/monthly backups of your data, to a local directory `/var/backups/rsnapshot` on the server. These backups are suitable for restoration after a minor incident or limited data loss.

In case of catastrophic failure (destroyed/compromised server, disk failure), an off-site backup must be restored. To download a copy of latest daily backups from a host, to the `data/backups/` directory on the controller, run:

```bash
# for a single default playbook with a single host
xsrv fetch-backups
# for playbooks with multiple hosts
xsrv fetch-backups myplaybook backupserver.CHANGEME.org
```

See each [role](index.md#roles)'s documentation for information on how to restore backups.

Also keep off-line, off-site backups of your `~/playbooks/` directory.


## Upgrading

Security upgrades for software provided by the Linux distribution are applied [automatically, daily](roles/common). To upgrade roles to the latest [release](https://gitlab.com/nodiscc/xsrv/-/blob/master/CHANGELOG.md) [[1]](https://gitlab.com/nodiscc/xsrv/-/tags?format=atom) (bugfixes, new features/roles, latest releases of all applications):

- Ensure you have a valid [backup](#backups) of the server's data and/or do a snapshot of the machine
- Upgrade roles in your playbook: `xsrv upgrade`
- (Optional) run checks and validate changes: `xsrv check`
- Apply changes: `xsrv deploy`


## Security

Isolation between services/applications relies on [file permissions, ownership and groups](https://wiki.debian.org/Permissions) and [AppArmor](https://wiki.debian.org/AppArmor) confinement. Each service/application should only have read/write access to the required resources (principle of least privilege). Compromise of a single service or account must not allow compromise of other services and accounts.

<!-- TODO PHP web applications currently share the same user. -->

The administration account (`ansible_user`) has unlimited access through SSH/[`sudo`](https://wiki.debian.org/sudo) (requires both an authorized SSH key and a password). Be careful when performing manual operations from this account. Protect your private SSH key and the `.ansible-vault-password` file.

The system is designed to host data and services with the same classification level and tenant. If you need different security contexts (for example public or private facing services, different sets of end users/multitenancy, ...), split your infrastructure across different VMs/machines/networks and setup additional access controls and isolation mechanisms.

```
We trust you have received the usual lecture from the local System
Administrator. It usually boils down to these three things: 

#1) Respect the privacy of others.
#2) Think before you type.
#3) With great power comes great responsibility.
```
