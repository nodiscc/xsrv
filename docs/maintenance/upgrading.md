# Upgrading

Security upgrades for Debian packages are applied [automatically/daily](roles/common). To upgrade roles to their latest versions (bugfixes, new features, latest stable releases of all unpackaged applications):

- Read the [release notes](https://gitlab.com/nodiscc/xsrv/-/blob/master/CHANGELOG.md) and/or subscribe to the [releases RSS feed](https://gitlab.com/nodiscc/xsrv/-/tags?format=atom)
- Download latest backups from the server (`xsrv backup-fetch`) and/or do a snapshot of the VM
- Upgrade roles in your playbook `xsrv upgrade` (use `BRANCH=<VERSION> xsrv upgrade` to upgrade to a specific release)
- (Optional) run checks and watch out for unwanted changes `xsrv check`
- Apply the playbook `xsrv deploy`

