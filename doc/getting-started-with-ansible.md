## Ansible How-to

[Ansible](https://en.wikipedia.org/wiki/Ansible_(software)) is an open-source software provisioning, configuration management, and application-deployment tool. It provides:

- quick, automated, reproducible, consistent deployment, configuration and maintenance of one or many machines
- ensures machines/services are configured exactly as declared in the _playbook_ and configuration
- simple, readable, powerful scripting and configuration using YAML markup
- minimization and detection of side effects of configuration changes (idempotence)
- minimal requirements on the machines being configured

An ansible _playbook_ stores the desired configuration for one or more machines/environments, as a reduced set of text files (tasks to execute, configuration variables...). For example, try [this playbook](https://gitlab.com/nodiscc/xsrv) to install and configure many services on a home/personal server. This page shows a few basics of how ansible works, and how to configure and build your playbooks.

An ansible environment consists of _hosts_ (machines to configure), and a _controller_ (machine on which ansible is installed). The controller stores a _playbook_ that defines what tasks should be run on hosts (install software, copy files, run commands...), and configuration variables. When ansible runs on the controller, it reads your playbook and configuration variables, builds Python scripts, uploads them to remote hosts and executes them (using SFTP/SSH). The only host/server-side requirements for ansible are Python and a SSH server.

As text files, ansible playbooks allow you to track and manage configuration changes using a version control system (for example `git`).

![](https://i.imgur.com/Q6rPIMw.png)

<!-- MarkdownTOC -->

- [Directory structure](#directory-structure)
  - [roles](#roles)
  - [inventory.yml](#inventoryyml)
  - [playbook.yml](#playbookyml)
  - [Configuration variables](#configuration-variables)
    - [group_vars](#group_vars)
    - [host_vars](#host_vars)
  - [ansible.cfg](#ansiblecfg)
- [Examples](#examples)
  - [Adding a new host](#adding-a-new-host)
- [Building your own roles](#building-your-own-roles)
- [Using multiple environments](#using-multiple-environments)
- [Ansible documentation](#ansible-documentation)

<!-- /MarkdownTOC -->


## Directory structure

An example, basic file/directory structure for an ansible environment (playbook):

```
.
├── inventory.yml
├── playbook.yml
├── requirements.yml
├── ansible.cfg
├── group_vars/
│   └── all.yml
├── host_vars
│   └── host1.example.org.yml
│   └── host2.example.org.yml
└── roles/
    └── firewall/
    └── webserver/
    └── database-server/
    └── file-server/

```

### roles

This directory holds ansible roles. A role is a set of configuration steps (_tasks_) that will be applied to selected hosts. A role can install software, ensure configuration is in a specific state, run scripts... Roles carry the main logic of an ansible playbook and provide "blocks" of functionality. You could write tasks directly at the playbook level, but roles can be reused for many environments or machines, and can be updated and shared more easily.


Each role provides
- `tasks`: commands (ansible [modules](https://docs.ansible.com/ansible/latest/modules/list_of_all_modules.html)) to run on remote machines
- `defaults`: all [configuration variables](#configuration-variables) for the role, and their default values. `groups_vars` and `host_vars` override these (see below)
- `files`: static files (for example, files to copy on the remote machine)
- `templates`: files with dynamically generated content (variables, loops... using the [jinja2](http://jinja.pocoo.org/) templating engine)
- `handlers`: tasks that can be triggered by main tasks, but run exactly once
- `meta`: role metadata such as OS compatibility, ansible version, dependencies on other roles...

You can write your own roles, and/or download/update external roles by listing them in `requirements.yml` and running `ansible-galaxy install --roles-path roles/ --force --role-file requirements.yml`. Example requirements file:

```yaml
# A generic role to configure Linux machines
# The role will be downloaded over Git from this URL
# You can specify a git tag or branch to pull an exact version of a role
# This role will be downloaded to the directory specified with --roles-path
- src: git+https://gitlab.com/nodiscc/ansible-svr-common.git
  version: 1.0
  name: common
```

Roles in `requirements.yml` should be kept out of Git version control by listing them in `roles/.gitignore`.

You can find premade roles at https://galaxy.ansible.com/ or by searching software forges like https://github.com/search?q=ansible or https://gitlab.com/search?search=ansible. Inspect them carefully.


### inventory.yml

Target hosts/host groups are defined in `inventory.yml`.

_Note: Inventories can be written in many formats, here we use [yaml](https://docs.ansible.com/ansible/latest/plugins/inventory/yaml.html) but the default format uses a [INI](https://docs.ansible.com/ansible/latest/plugins/inventory/ini.html)-style syntax._

The simplest structure is an `all` group with 1 host:

```yaml
all:
  hosts:
    host1.example.org:
```

A group can have many hosts:

```yaml
all:
  hosts:
    host1.example.org:
    host2.example.org:
    host3.example.org:
    host4.example.org:
```

Each group can have a `hosts` attribute (dict of host names), a `vars` attribute (group-level variables, which are better kept in separate files, see below), and a `children` attribute which allows you to define sub-groups. For example, this defines a `all` group, made of 2 groups `intranet` and `extranet`:

```yaml
all:
  children:
    intranet:
      hosts:
        host1.example.org:
        host2.example.org:
    extranet:
      hosts:
        host3.example.org:
        host4.example.org:
```


### playbook.yml

A playbook is the basic level, at which you can apply roles to hosts. A basic example would look like:

```yaml
- hosts: host1.example.org
  roles:
    - common
    - monitoring
    - webserver
    - mysql
    - myapplication

- hosts: host2.example.com
  roles:
    - common
    - monitoring
    - backup
    - openldap
```

Each host will be configured according to the roles attached to it.

<!--- TODO REWRITE Roles

Remember that the host `host1.example.org` will pick automatically up config variables from `host_vars/host1.example.org.yml`. In this example, they can be generic ansible variables like the SSH user to connect with, the SSH port... or variables that override defaults for the `firewall`, `webserver`, and `database-server` roles. You can use an inventory group name for the `hosts:` field to apply roles to many hosts in parallel.


You can apply configuration variables to a group of hosts using configuration variables in `group_vars/`, and to a specific host using `host_vars`.

--->

### Configuration variables

[Variables](https://docs.ansible.com/ansible/latest/user_guide/playbooks_variables.html) can configure a specific aspect of a role (whether to enable a component or not, set a non-default username/password, a list of web server domains to configure...), or configure a basic ansible option like the SSH port, the connection method, etc. Variables can be left to their role/ansible default, or you can set another value for a group (or all) of hosts, or only some hosts.

This allows you to reuse the role in many environments, on different machines with specific settings, while not touching the main role code.

Some [special variables](https://docs.ansible.com/ansible/latest/reference_appendices/special_variables.html) are used to define general ansible options (SSH user, port, connection method...). Variables called [facts](https://docs.ansible.com/ansible/latest/modules/setup_module.html#setup-module) are automatically discovered from the remote host (IP addresses, environment, devices...), so they can be reused anywhere in your ansible play.


#### group_vars

`.yml` files in `group_vars/` directory define **group-level configuration variables**.

Group variables will take precedence over role defaults in `roles/*/defaults/`.

Hosts/host groups are defined in `inventory.yml`. For example, for this `inventory.yml` file:

```yaml
all:
  hosts:
    host1.example.org:
    host2.example.org:
    host3.example.org:
    host4.example.org:
```

And this `group_vars/all.yml` file:

```yaml
# System mail relay (SMTP server) to use, and authentication username/password
msmtp_host: smtp.example.com
msmtp_username: sysadmin
msmtp_password: hunter2
```

These variables would be applied to `host1.example.org`, `host2.example.org`, `host3.example.org`, `host4.example.org`.


For this example `inventory.yml` file:

```yaml
all:
  children:
    intranet:
      hosts:
        host1.example.org
        host2.example.org
    extranet:
      hosts:
        host3.example.org
        host4.example.org
```

Variables in `group_vars/all.yml` would apply to all 4 hosts, while `group_vars/intranet.yml` and `group_vars/extranet.yml` would apply to the hosts in the `intranet` or `extranet` group, respectively.

If you need to keep group variables out of version control (eg. hosted on a public Git repository), add `!README.md` to the `group_vars/.gitignore` file.


#### host_vars

`.yml` files in this directory define **per-host configuration variables**.

These variables take priority over group-level variables defined in `group_vars/`.

For example, for this `inventory.yml`:

```yaml
all:
  hosts:
    host1.example.org:
    host2.example.org:
    host3.example.org:
    host4.example.org:
```

Variables in `group_vars/host1.example.org.yml` would only apply to the `host1.example.org` machine (the yml file must have the exact same name as the inventory entry).

If you need to keep host variables out of version control (eg. hosted on a public Git repository), add `!README.md` to the `host_vars/.gitignore` file.



### ansible.cfg

This file contains generic ansible [configuration](https://docs.ansible.com/ansible/latest/installation_guide/intro_configuration.html), like local file paths for roles, the appearance/format of ansible text output, special SSH connection settings... In general the defaults are fine, so this file is only required in some situations:

```bash
[defaults]
# pretty-print ansible output
stdout_callback = debug
# use this inventory file by default
inventory = inventory.yml
```

## Examples

### Adding a new host

- Edit `inventory.yml` and add your new host's name (FQDN, must be resolvable/reachable over SSH) - for example `host3.example.org`
- Edit `playbook.yml` and add a new `hosts: host3.example.org` entry + a list of roles for this host.
- Create/edit `host_vars/host3.example.org.yml` and define configuration variables for this host. At the very least define `ansible_ssh_user` and/or `ansible_become_pass` if you don't want to have to type the sudo password every time.

## Building your own roles

TODO

## Using multiple environments

TODO

## Ansible documentation

- https://docs.ansible.com/ansible-tower/latest/html/userguide/main_menu.html
- https://docs.ansible.com/ansible/devel/user_guide/playbooks_reuse.html
- https://docs.ansible.com/ansible/devel/user_guide/playbooks_reuse_includes.html
- https://docs.ansible.com/ansible/latest/installation_guide/intro_configuration.html
- https://docs.ansible.com/ansible/latest/playbooks_loops.html
- https://docs.ansible.com/ansible/latest/plugins/lookup/subelements.html
- https://docs.ansible.com/ansible/latest/reference_appendices/config.html
- https://docs.ansible.com/ansible/latest/reference_appendices/galaxy.html
- https://docs.ansible.com/ansible/latest/reference_appendices/test_strategies.html
- https://docs.ansible.com/ansible/latest/scenario_guides/guide_docker.html
- https://docs.ansible.com/ansible/latest/user_guide/intro_adhoc.html
- https://docs.ansible.com/ansible/latest/user_guide/intro_inventory.html
- https://docs.ansible.com/ansible/latest/user_guide/playbooks_async.html
- https://docs.ansible.com/ansible/latest/user_guide/playbooks_checkmode.html
- https://docs.ansible.com/ansible/latest/user_guide/playbooks_conditionals.html
- https://docs.ansible.com/ansible/latest/user_guide/playbooks_error_handling.html
- https://docs.ansible.com/ansible/latest/user_guide/playbooks_filters_ipaddr.html
- https://docs.ansible.com/ansible/latest/user_guide/playbooks_intro.html
- https://docs.ansible.com/ansible/latest/user_guide/playbooks_lookups.html
- https://docs.ansible.com/ansible/latest/user_guide/playbooks_tags.html
- https://docs.ansible.com/ansible/latest/user_guide/playbooks_variables.html
- https://docs.ansible.com/ansible/latest/user_guide/vault.html
- https://docs.ansible.com/ansible/latest/reference_appendices/general_precedence.html

------------

- https://docs.ansible.com/ansible/latest/plugins/action.html
- https://docs.ansible.com/ansible/latest/plugins/cache.html
- https://docs.ansible.com/ansible/latest/plugins/callback.html
- https://docs.ansible.com/ansible/latest/plugins/connection.html
- https://docs.ansible.com/ansible/latest/plugins/connection/paramiko_ssh.html
- https://docs.ansible.com/ansible/latest/plugins/connection/ssh.html
- https://docs.ansible.com/ansible/latest/plugins/inventory.html
- https://docs.ansible.com/ansible/latest/plugins/inventory/yaml.html
- https://docs.ansible.com/ansible/latest/plugins/lookup.html
- https://docs.ansible.com/ansible/latest/plugins/lookup/password.html
- https://docs.ansible.com/ansible/latest/plugins/plugins.html
- https://docs.ansible.com/ansible/latest/plugins/shell.html
- https://docs.ansible.com/ansible/latest/plugins/strategy.html
- https://docs.ansible.com/ansible/latest/plugins/vars.html
- https://docs.ansible.com/ansible/latest/user_guide/plugin_filtering_config.html


-----------

- https://docs.ansible.com/ansible/latest/modules/list_of_all_modules.html
- https://docs.ansible.com/ansible/latest/modules/list_of_network_modules.html
- https://docs.ansible.com/ansible/latest/modules/list_of_notification_modules.html
- https://docs.ansible.com/ansible/latest/modules/acl_module.html
- https://docs.ansible.com/ansible/latest/modules/apt_module.html
- https://docs.ansible.com/ansible/latest/modules/archive_module.html
- https://docs.ansible.com/ansible/latest/modules/assemble_module.html
- https://docs.ansible.com/ansible/latest/modules/assert_module.html
- https://docs.ansible.com/ansible/latest/modules/at_module.html
- https://docs.ansible.com/ansible/latest/modules/authorized_key_module.html
- https://docs.ansible.com/ansible/latest/modules/blockinfile_module.html
- https://docs.ansible.com/ansible/latest/modules/command_module.html
- https://docs.ansible.com/ansible/latest/modules/copy_module.html
- https://docs.ansible.com/ansible/latest/modules/cron_module.html
- https://docs.ansible.com/ansible/latest/modules/debug_module.html
- https://docs.ansible.com/ansible/latest/modules/expect_module.html
- https://docs.ansible.com/ansible/latest/modules/fail_module.html
- https://docs.ansible.com/ansible/latest/modules/fetch_module.html
- https://docs.ansible.com/ansible/latest/modules/file_module.html
- https://docs.ansible.com/ansible/latest/modules/filesystem_module.html
- https://docs.ansible.com/ansible/latest/modules/find_module.html
- https://docs.ansible.com/ansible/latest/modules/firewalld_module.html
- https://docs.ansible.com/ansible/latest/modules/git_module.html
- https://docs.ansible.com/ansible/latest/modules/group_module.html
- https://docs.ansible.com/ansible/latest/modules/import_playbook_module.html
- https://docs.ansible.com/ansible/latest/modules/import_tasks_module.html
- https://docs.ansible.com/ansible/latest/modules/include_module.html
- https://docs.ansible.com/ansible/latest/modules/include_tasks_module.html
- https://docs.ansible.com/ansible/latest/modules/ini_file_module.html
- https://docs.ansible.com/ansible/latest/modules/iptables_module.html
- https://docs.ansible.com/ansible/latest/modules/jabber_module.html
- https://docs.ansible.com/ansible/latest/modules/ldap_attr_module.html
- https://docs.ansible.com/ansible/latest/modules/ldap_entry_module.html
- https://docs.ansible.com/ansible/latest/modules/lineinfile_module.html
- https://docs.ansible.com/ansible/latest/modules/lvg_module.html
- https://docs.ansible.com/ansible/latest/modules/lvol_module.html
- https://docs.ansible.com/ansible/latest/modules/mail_module.html
- https://docs.ansible.com/ansible/latest/modules/meta_module.html
- https://docs.ansible.com/ansible/latest/modules/mount_module.html
- https://docs.ansible.com/ansible/latest/modules/mysql_user_module.html
- https://docs.ansible.com/ansible/latest/modules/patch_module.html
- https://docs.ansible.com/ansible/latest/modules/pause_module.html
- https://docs.ansible.com/ansible/latest/modules/pip_module.html
- https://docs.ansible.com/ansible/latest/modules/raw_module.html
- https://docs.ansible.com/ansible/latest/modules/replace_module.html
- https://docs.ansible.com/ansible/latest/modules/script_module.html
- https://docs.ansible.com/ansible/latest/modules/selinux_module.html
- https://docs.ansible.com/ansible/latest/modules/service_module.html
- https://docs.ansible.com/ansible/latest/modules/set_fact_module.html
- https://docs.ansible.com/ansible/latest/modules/setup_module.html extensible with facter/ohai, filtering, can save facts to files
- https://docs.ansible.com/ansible/latest/modules/shell_module.html
- https://docs.ansible.com/ansible/latest/modules/slurp_module.html
- https://docs.ansible.com/ansible/latest/modules/stat_module.html
- https://docs.ansible.com/ansible/latest/modules/synchronize_module.html
- https://docs.ansible.com/ansible/latest/modules/systemd_module.html
- https://docs.ansible.com/ansible/latest/modules/template_module.html
- https://docs.ansible.com/ansible/latest/modules/ufw_module.html
- https://docs.ansible.com/ansible/latest/modules/unarchive_module.html
- https://docs.ansible.com/ansible/latest/modules/user_module.html
- https://docs.ansible.com/ansible/latest/modules/wait_for_module.html
- https://docs.ansible.com/ansible/latest/modules/xattr_module.html

-------

- https://adamj.eu/tech/2015/05/18/making-ansible-a-bit-faster/ - profiling plugin, pipelining, controlpersist
- https://benincosa.com/?p=3235 - Secrets with Ansible: Ansible Vault and GPG
- https://blog.confirm.ch/calling-ansible-handlers-based-on-os-distributions/
- https://blog.confirm.ch/deploying-ssl-private-keys-with-ansible/
- https://blog.zwindler.fr/2019/07/22/proxmox-en-5-min-ansible-tinc/
- https://devops.stackexchange.com/questions/3123/creating-ansible-host-vars-and-group-vars-files-dynamically
- https://en.wikipedia.org/wiki/Ansible_(software)
- https://gist.github.com/AdamOssenford/344ffe76db0a52e9051a - Ansible cheatsheet
- https://github.com/ansible/ansible-lint
- https://github.com/ansible/ansible/
- https://github.com/ansible/awx
- https://github.com/debops/debops/
- https://github.com/geerlingguy?tab=repositories
- https://github.com/sovereign/sovereign
- https://medium.com/@jezhalford/ansible-custom-facts-1e1d1bf65db8
- https://opensource.com/article/17/6/ansible-postgresql-operations
- https://opensource.com/article/18/7/sysadmin-tasks-ansible
- https://serverascode.com/2015/01/27/ansible-custom-facts.html
- https://serverfault.com/questions/875247/whats-the-difference-between-include-tasks-and-import-tasks
- https://stackoverflow.com/questions/22649333/ansible-notify-handlers-in-another-role
- https://stackoverflow.com/questions/29127560/whats-the-difference-between-defaults-and-vars-in-an-ansible-role
- https://stackoverflow.com/questions/30119973/how-to-run-a-task-when-variable-is-undefined-in-ansible
- https://stackoverflow.com/questions/33837679/copy-files-from-one-server-to-another-using-ansible
- https://stackoverflow.com/questions/33931610/ansible-handler-notify-vs-register
- https://stackoverflow.com/questions/35083756/ansible-set-variable-only-if-undefined
- https://stackoverflow.com/questions/35654286/how-check-a-file-exists-in-ansible
- https://stackoverflow.com/questions/47244834/how-to-join-a-list-of-strings-in-ansible
- https://www.ansible.com/products/awx-project/faq
- https://www.digitalocean.com/community/tutorials/how-to-manage-multistage-environments-with-ansible
- https://www.jeffgeerling.com/blog/2018/testing-your-ansible-roles-molecule
- https://yamllint.readthedocs.io/en/stable/configuration.html

------------------------

- https://stackoverflow.com/questions/46593974/ansible-include-a-file-if-it-exists-and-do-nothing-if-it-doesnt#47062902

```jinja2
{% for tool in tools %}
   {% set template = 'tools/' + tool.name + '/pbr.j2' %}
   {% include template ignore missing %}
{% endfor %}
```


-----------

- https://en.wikipedia.org/wiki/Idempotence
- https://stackoverflow.com/questions/29275576/ansible-how-to-check-files-is-changed-in-shell-command
- https://knpuniversity.com/screencast/ansible/idempotency-changed-when
- https://raymii.org/s/tutorials/Ansible_-_Only-do-something-if-another-action-changed.html

```yaml
# idempotence for the 'command/shell' ansible modules
- name: run a command, never report 'changed'
  command: /usr/bin/something
  changed_when: False

- name: run a command, don't report 'changed' when a specific string is present in stdout
  command: /usr/bin/something
  register: my_command_result
  changed_when: "not my_command_result.search('already exists. Skipped')"

- name: only run this task if the previous task reports 'changed'
  service:
    name: example
    state: restarted
  when: my_command_result.changed
```
