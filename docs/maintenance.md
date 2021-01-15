# Maintenance

Self-hosting places your services and data under your own responsibility (availability, integrity, confidentiality...). Always have a plan in place if your server crashes, gets compromised or damaged. There is no High Availability mechanism configured by default.


## Backups

Always keep 3 copies of valuable data (the working data, a local backup - preferably on another drive, and an off-site backup).

The [backup](roles/backup) role performs automatic daily/weekly/monthly backups of your data, to a local directory `/var/backups/rsnapshot` on the server.

To download a copy of latest daily backups from a host, to the `backups/` directory on the controller, run:

```bash
# for a single default playbook with a single host
xsrv fetch-backups
# for playbooks with multiple hosts
xsrv fetch-backups myplaybook my.CHANGEME.org
```

See each [role](index.md#roles)'s documentation for information on how to restore backups.

Keep **off-line, off-site backups** of your `~/playbooks/` directory and user data.


## Upgrading

Security upgrades for Debian packages are applied [automatically/daily](roles/common). To upgrade roles to their latest versions (bugfixes, new features, latest stable releases of all unpackaged applications):

- Read the [release notes](https://gitlab.com/nodiscc/xsrv/-/blob/master/CHANGELOG.md) and/or subscribe to the [releases RSS feed](https://gitlab.com/nodiscc/xsrv/-/tags?format=atom)
- Download latest backups from the server (`xsrv backup-fetch`) and/or do a snapshot of the VM
- Upgrade roles in your playbook `xsrv upgrade` (use `BRANCH=<VERSION> xsrv upgrade` to upgrade to a specific release)
- (Optional) run checks and watch out for unwanted changes `xsrv check`
- Apply the playbook `xsrv deploy`


## Security model

- Isolation between services/applications relies on proper use of [file permissions, ownership and groups](https://wiki.debian.org/Permissions) and partial [AppArmor](https://wiki.debian.org/AppArmor) confinement. Each service/application should only have read/write access to the required resources (principle of least privilege). <!-- php applications currently share the same user - TODO --> Compromise of a single service or account must not allow compromise of other services and accounts.
- Usage of the server admin user with [`sudo`](https://wiki.debian.org/sudo) privileges requires both a correct/authorized SSH key and a password.
- Be careful when performing manual operations from a shell, managing users and file permissions. Protect your private SSH key and the `.ansible-vault-password` file
- The system is designed to host data and services with the same classification level. If you need different security contexts (for example public or private facing services, different sets of end users, ...), split your infrastructure across different VMs/machines/networks and setup additional access controls.

```
We trust you have received the usual lecture from the local System
Administrator. It usually boils down to these three things: 

#1) Respect the privacy of others.
#2) Think before you type.
#3) With great power comes great responsibility.
```




