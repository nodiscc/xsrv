# Version control

Put your playbook directory (eg. `~/playbooks/default`) under version control/[git](https://stdout.root.sx/?searchtags=git+doc) if you need to track changes to your configuration.

**Reverting changes:**

- (optional) restore a VM snapshot from before the change (will cause loss of all data modified after the snapshot!), OR restore data from last known good backups (see each role's documentation for restoration instructions)
- `git checkout` your playbook directory as it was before the change
- run the playbook `xsrv deploy`

Refer to **[ansible documentation](https://docs.ansible.com/)** for more information.

**Uninstalling roles:**

Uninstalling roles is not supported at this time: components must be removed manually or using a ad-hoc playbook. Or a new server must be deployed and data restored from backups. Most roles provide variables to disable their services/functionality.

