# xsrv.readme_gen

This role automatically inserts useful information about your hosts in your project's README.md file.

[![](https://gitlab.com/nodiscc/toolbox/-/raw/master/DOC/SCREENSHOTS/G96iP0G.png)](https://gitlab.com/nodiscc/toolbox/-/raw/master/DOC/SCREENSHOTS/G96iP0G.png)

## Requirements/dependencies/example playbook

See [meta/main.yml](meta/main.yml)

This role is better used through ansible [ad-hoc commands](https://docs.ansible.com/ansible/latest/user_guide/intro_adhoc.html). For example:

```bash
# using xsrv command-line
# generate markdown inventory for all hosts in the default project
xsrv readme-gen
# generate markdown inventory for all hosts in the myproject project
xsrv readme-gen myproject
```

```bash
# using ansible command-line tools
cd ~/playbooks/default
# generate markdown inventory for all hosts
ansible --module-name setup all
ANSIBLE_CACHE_PLUGIN_TIMEOUT=3600 ansible --module-name "ansible.builtin.import_role" --args "name=nodiscc.xsrv.readme_gen" localhost
# generate markdown inventory for a group only
ansible --module-name setup prod
ANSIBLE_CACHE_PLUGIN_TIMEOUT=3600 ansible --module-name "ansible.builtin.import_role" --args "name=nodiscc.xsrv.readme_gen" --extra-vars "readme_gen_limit={{ groups['prod'] }}" localhost
# generate markdown inventory for listed hosts only
ansible --module-name setup dev1.example.org,prod2.example.org
ANSIBLE_CACHE_PLUGIN_TIMEOUT=3600 ansible --module-name "ansible.builtin.import_role" --args "name=nodiscc.xsrv.readme_gen" --extra-vars "readme_gen_limit={{ ['dev1.example.org', 'prod2.example.org'] }}" localhost
```

You should run the role **after** other hosts/roles have been fully deployed, as it uses Ansible [facts](https://docs.ansible.com/ansible/latest/user_guide/playbooks_vars_facts.html) installed by other roles and generates README.md content from these.

Fact [caching](https://docs.ansible.com/ansible/latest/playbook_guide/playbooks_vars_facts.html#caching-facts) must be enabled through `fact_caching = yaml` in your [ansible configuration file](../../playbooks/xsrv/ansible.cfg) (`xsrv edit-cfg`/`ansible.cfg`).

Cached facts can be cleared manually by deleting the `data/cache/facts/` directory under your playbook directory (or the directory defined by `fact_caching_connection` in your `ansible/cfg`)


## Usage

To control where the automatically added section appears in the README.md file, add/adjust the position of these markers in the file:

```markdown
<!-- BEGIN AUTOMATICALLY GENERATED CONTENT - README_GEN ROLE -->
<!-- END AUTOMATICALLY GENERATED CONTENT - README_GEN ROLE -->
```

The [default template](templates/readme_gen.md.j2) adds quick access links to services managed by the [xsrv](https://xsrv.readthedocs.io/) collection, and generates a SSH client configuration that can be installed to `~/.ssh/$project.conf`.
If these variable are present in a host's `host_vars`, they will be added to the README as well:

```yaml
# free-form comment or description (markdown is supported)
# for example, physical location/hosting provider/link to the VM console/serial number...
readme_gen_comment: "[hypervisor 1 VM 112](https://proxmox1.CHANGEME.org:8006/#v1:0:=qemu%2F112:4:::::8::)"
# example using multi-line YAML comment - https://yaml-multiline.info/
readme_gen_comment: |
  - This host has a faulty power supply
  - This host's warranty expires on 2099/01/01
```

You may also use your own/customized template instead:

```yaml
# group_vars/all/all.yml
readme_gen_template: '{{ playbook_dir }}/data/templates/mycompany.readme_gen.j2'
readme_gen_limit: "{{ groups['prod'] }}"
```
See [defaults/main.yml](defaults/main.yml) for all configuration variables.


## License

[GNU GPLv3](../../LICENSE)


## References

- https://stdout.root.sx/links/?searchtags=ansible
- https://stdout.root.sx/links/?searchtags=markdown
- https://stdout.root.sx/links/?searchterm=jinja
- https://stdout.root.sx/links/?searchterm=cmdb
