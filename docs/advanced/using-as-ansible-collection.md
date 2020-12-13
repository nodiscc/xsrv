# Using as ansible collection


You can either:
- use the [`xsrv` script](#command-line-usage) to manage your ansible environments
- or use components through standard `ansible-*` [command-line tools](https://docs.ansible.com/ansible/latest/user_guide/command_line_tools.html). See [Using as ansible collection](#using-as-ansible-collection).

If you just want to integrate the [roles](#roles) in your own playbooks, install them using [`ansible-galaxy`](https://docs.ansible.com/ansible/latest/cli/ansible-galaxy.html):

```bash
ansible-galaxy collection install git+https://gitlab.com/nodiscc/xsrv,release
```

And include them in your playbooks:

```yaml
# playbook.yml

- hosts: all
  collections:
   - nodiscc.xsrv

- hosts: my.CHANGEME.org
  roles:
   - nodiscc.xsrv.common
   - nodiscc.xsrv.monitoring
   - nodiscc.xsrv.apache
   - ...
```

To upgrade the collection to the latest [release](https://gitlab.com/nodiscc/xsrv/-/blob/master/CHANGELOG.md):

```bash
ansible-galaxy collection install --force git+https://gitlab.com/nodiscc/xsrv,release
```

See [Using collections](https://docs.ansible.com/ansible/latest/user_guide/collections_using.html)

