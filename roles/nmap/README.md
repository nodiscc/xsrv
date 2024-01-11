# xsrv.nmap

This role will run a [nmap](https://nmap.org/) scan against hosts listed in your inventory, and generate a report of up/down hosts and discovered services, that can be viewed from a web browser.

[![](https://gitlab.com/nodiscc/toolbox/-/raw/master/DOC/SCREENSHOTS/nmap.png)](https://gitlab.com/nodiscc/toolbox/-/raw/master/DOC/SCREENSHOTS/nmap.png)

## Requirements/dependencies/example playbook

See [meta/main.yml](meta/main.yml)

This role is better used through ansible [ad-hoc commands](https://docs.ansible.com/ansible/latest/user_guide/intro_adhoc.html). For example:

```bash
# using xsrv command-line
# generate markdown inventory for all hosts in the default project
xsrv nmap
# generate markdown inventory for all hosts in the myproject project
xsrv nmap myproject
```

```bash
# using ansible command-line tools
cd ~/playbooks/default
# generate markdown inventory for all hosts
ansible --ask-become-pass --module-name "ansible.builtin.import_role" --args "name=nodiscc.xsrv.nmap" localhost
# generate markdown inventory for a group only
ansible --ask-become-pass --module-name "ansible.builtin.import_role" --args "name=nodiscc.xsrv.nmap" --extra-vars "nmap_limit={{ groups['prod'] }}" localhost
# generate markdown inventory for listed hosts only
ansible --ask-become-pass --module-name "ansible.builtin.import_role" --args "name=nodiscc.xsrv.nmap" --extra-vars "readme_gen_limit={{ ['dev1.example.org', 'prod2.example.org'] }}" localhost
```

Note that because the role/nmap scan actually runs on the controller (`localhost`), and `nmap` requires root permissions to send raw packets, you will be prompted for the `sudo` password (`BECOME password:`) of the current user.


## Usage

See [defaults/main.yml](defaults/main.yml) for all configuration variables.

Since this role actually runs from `localhost`, you should place its configuration variables in the `group_vars` file for the `all` group (or alternatively for the `host_vars` file for `localhost`)

```yaml
# group_vars/all/all.yml
readme_gen_limit: "{{ groups['prod'] }}"
```


## License

[GNU GPLv3](../../LICENSE)


## References

- https://stdout.root.sx/links/?searchtags=network
- https://stdout.root.sx/links/?searchtags=security
- https://stdout.root.sx/links/?searchterm=nmap
