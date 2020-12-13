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

