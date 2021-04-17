## Advanced usage

### Version control

Put your playbook directory (eg. `~/playbooks/default`) under version control/[git](https://stdout.root.sx/?searchtags=git+doc) if you need to track changes to your configuration.

**Reverting changes:**

- (optional) restore a VM snapshot from before the change (will cause loss of all data modified after the snapshot!), OR restore data from last known good backups (see each role's documentation for restoration instructions)
- `git checkout` your playbook directory as it was before the change
- run the playbook `xsrv deploy`

Refer to **[ansible documentation](https://docs.ansible.com/)** for more information.

**Uninstalling roles:**

Uninstalling roles is not supported at this time: components must be removed manually or using a ad-hoc playbook. Or a new server must be deployed and data restored from backups. Most roles provide variables to disable their services/functionality.


### Using as ansible collection

You can either:
- use the [`xsrv` script](usage.md#command-line-usage) to manage your ansible environments
- or use [roles](index.md#roles) through standard `ansible-*` [command-line tools](https://docs.ansible.com/ansible/latest/user_guide/command_line_tools.html). To download roles to your anisble controller:

```yaml
# create requirements.yml
collections:
  - name: https://gitlab.com/nodiscc/xsrv.git
    type: git
    version: release
```

```bash
# install the collection
$ ansible-galaxy collection install -r requirements.yml
```

```yaml
# include the collection and roles in your playbooks
# playbook.yml
- hosts: my.CHANGEME.org
  collections:
    - nodiscc.xsrv
  roles:
   - nodiscc.xsrv.common
   - nodiscc.xsrv.monitoring
   - nodiscc.xsrv.apache
   - ...
```

To upgrade the collection to the latest [release](https://gitlab.com/nodiscc/xsrv/-/blob/master/CHANGELOG.md):

```bash
$ ansible-galaxy collection install --force -r requirements.yml
```

See [`ansible-galaxy`](https://docs.ansible.com/ansible/latest/cli/ansible-galaxy.html), [Ansible documentation - Using collections](https://docs.ansible.com/ansible/latest/user_guide/collections_using.html)


### Continuous deployment

For production systems, it is strongly recommended to run the playbook and evaluate changes against a testing/staging environment first (eg. create separate `testing`,`prod` groups in `inventory.yml`, deploy changes to the `testing` environmnent with `xsrv deploy PLAYBOOK_NAME testing`). 

You can further automate deployment procedures using a CI/CD pipeline. See the example [`.gitlab-ci.yml`](https://gitlab.com/nodiscc/xsrv/-/blob/master/playbooks/xsrv/.gitlab-ci.yml) to get started.


## See also

- [awesome-selfhosted](https://github.com/awesome-selfhosted/awesome-selfhosted)
- <https://stdout.root.sx/xsrv/xsrv> (upstream)
- <https://github.com/nodiscc/xsrv> (mirror)
- <https://gitlab.com/nodiscc/xsrv> (mirror)
