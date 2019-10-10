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