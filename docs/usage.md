# Usage


The `xsrv` command-line tool automates creation and maintenance of [projects](#manage-projects) on a [controller](installation/controller-preparation.md) machine. Configuration is stored in [YAML](https://en.wikipedia.org/wiki/YAML) files on the controller and deployed to target [hosts](installation/server-preparation.md) over SSH.

Use the `xsrv` command-line to manage your projects, or [include xsrv roles in your own ansible playbooks](#use-as-ansible-collection).

-----------------------

## Command-line usage


```
  ╻ ╻┏━┓┏━┓╻ ╻
░░╺╋╸┗━┓┣┳┛┃┏┛
  ╹ ╹┗━┛╹┗╸┗┛ v1.21.0

USAGE: xsrv COMMAND [project] [host]

COMMANDS:
init-project [project] [host]       initialize a new project (and optionally a first host)
edit-inventory [project]            edit/show inventory file (hosts/groups)
edit-playbook [project]             edit/show playbook (roles for each host)
edit-requirements [project]         edit ansible requirements/collections
edit-cfg [project]                  edit ansible configuration (ansible.cfg)
upgrade [project]                   upgrade a project's roles/collections to latest versions
init-host [project] [host]          add a new host to an existing project
edit-host [project] [host]          edit host configuration (host_vars)
edit-vault [project] [host]         edit encrypted (vault) host configuration (host_vars)
edit-group [project] [group]        edit group configuration (group_vars)
edit-group-vault [project] [group]  edit encrypted (vault) group configuration (group_vars)
check [project] [host|group]        simulate deployment, report what would be changed
deploy [project] [host|group]       deploy the main playbook (apply configuration/roles)
fetch-backups [project] [host]      fetch backups from a host to the local backups directory
shell|ssh [project] [host]          open interactive SSH shell on a host
logs [project] [host]               view system logs on a host
o|open [project]                    open the project directory in the default file manager
readme-gen [project]                generate a markdown inventory in the project's README.md
nmap [project]                      run a nmap scan against hosts in the project
show-defaults [project] [role]      show all variables and their default values
help                                show this message
help-tags [project]                 show the list of ansible tags and their descriptions
self-upgrade                        check for new releases/upgrade the xsrv script in-place
init-vm-template [--help] [options] initialize a new libvirt VM template
init-vm [--help] [options]          initialize a new libvirt VM from a template

If no project is specified, the 'default' project is assumed.
For edition/utility commands, if no host/group is specified, the first host/group in alphabetical order is assumed.
For deploy/check commands, if no host/group is specified, the 'all' group (all hosts) is assumed.

# ENVIRONMENT VARIABLES (usage: VARIABLE=VALUE xsrv COMMAND)
TAGS               deploy/check only: list of ansible tags (TAGS=ssh,samba,... xsrv deploy)
EDITOR             text editor to use (default: nano)
PAGER              pager to use (default: nano --syntax=YAML --view +1 -)
```

Examples:

```bash
# deploy all hosts in the default project
xsrv deploy # or xsrv deploy default
# initialize a new project named infra
xsrv init-project infra
# deploy all hosts in project infra
xsrv deploy infra
 # add a new host ex2.CHANGEME.org to project infra
xsrv init-host infra ex2.CHANGEME.org
# edit configuration for the host ex2.CHANGEME.org in project infra
xsrv edit-host infra ex2.CHANGEME.org
# edit secret/vaulted configuration for my.CHANGEME.org in project default
xsrv edit-vault default my.CHANGEME.org
# deploy only ex1.CHANGEME.org and ex2.CHANGEME.org
xsrv deploy infra ex1.CHANGEME.org,ex2.CHANGEME.org
# deploy only tasks tagged nextcloud or gitea on ex3.CHANGEME.org
TAGS=nextcloud,gitea xsrv deploy infra ex3.CHANGEME.org
# deploy all hosts except ex1 and ex7.CHANGEME.org
xsrv deploy default '!ex1.CHANGEME.org,!ex7.CHANGEME.org'
# deploy all hosts in group 'prod' in default project (dry-run/simulation mode)
xsrv check default prod
# deploy all hosts whose hostnames begin with srv
xsrv deploy default srv*
```


------------------------

## Manage projects

Each project contains:
- an [inventory](#manage-hosts) of managed servers (_hosts_)
- a list of [roles](#manage-roles) assigned to each host/group (_playbook_)
- [configuration](#manage-configuration) values for host/group (*host_vars/group_vars*)
- deployment logic/tasks used in your project ([collections](#use-as-ansible-collection)/roles)
- an independent/isolated ansible installation (_virtualenv_) and its configuration

Projects are stored in the `~/playbooks` directory by default (use the `XSRV_PROJECTS_DIR` environment variable to override this).

```bash
$ ls ~/playbooks/
default/  homelab/  mycompany/
```

A single project is suitable for most setups (you can still organize hosts as different [environments/groups](#manage-hosts) inside a project). Use multiple projects to separate setups with completely [different contexts/owners](maintenance.md).


### xsrv init-project

Initialize a new project from the [template](https://gitlab.com/nodiscc/xsrv/-/tree/master/playbooks/xsrv) - creates all necessary files and prepares a playbook/environment with a single host.

<!-- TODO screencast -->


### xsrv edit-requirements

Edit the project's [`requirements.yml`](https://gitlab.com/nodiscc/xsrv/-/blob/master/playbooks/xsrv/requirements.yml) file, which lists [ansible collections](https://docs.ansible.com/ansible/latest/collections_guide/index.html) (a distribution format for Ansible content) used by the project.

-----------------------

## Manage hosts

- All servers [(hosts)](installation/server-preparation.md) must be listed in the [inventory](#xsrv-edit-inventory) file.
- Their [roles](#manage-roles) must be listed in the [playbook](#xsrv-edit-playbook) file.
- Hosts configuration variables must be set in [host or group](#manage-configuration) configuration files.


### xsrv init-host

Add a new host to the inventory/playbook and create/update all required files. You will be asked for a [host name](#manage-hosts):

```bash
xsrv init-host
[xsrv] Host name to add to the default playbook (ex: my.CHANGEME.org): my.example.org
```
<!-- TODO full output -->

- An editor will let you set the list of [roles](#manage-roles) for the host
- An editor will let you set required [configuration variables](#manage-configuration).


### xsrv edit-inventory

Edit the inventory file. This file lists all hosts in your environment and assigns them one or more groups.

```yaml
# the simplest inventory, single host in a single group 'all'
all:
  my.example.org:
```
```yaml
# an inventory with multiple hosts/groups
all:
  children:
    tools:
      hosts:
        hypervisor.example.org:
        dns.example.org:
        siem.example.org:
    dev:
      hosts:
        dev.example.org:
        dev-db.example.org:
    staging:
      hosts:
        staging.example.org:
        staging-db.example.org:
    prod:
      hosts:
        prod.example.org:
        prod-db.example.org:
```

See [YAML inventory](https://docs.ansible.com/ansible/latest/collections/ansible/builtin/yaml_inventory.html).


---------------------

## Manage roles

### xsrv edit-playbook

Edit the list of [roles](index.md) (playbook file) that will be deployed to your hosts. Add any role you wish to enable to the `roles:` list.

The simplest playbook, a single host carrying multiple roles:

```yaml
# uncomment or add roles to this list to enable additional components
- hosts: my.example.org
  roles:
    - nodiscc.xsrv.common
    - nodiscc.xsrv.monitoring
    - nodiscc.xsrv.apache
    - nodiscc.xsrv.openldap
    - nodiscc.xsrv.nextcloud
    - nodiscc.xsrv.mumble
    # - nodiscc.xsrv.samba
    # - nodiscc.xsrv.jellyfin
    # - nodiscc.xsrv.transmission
    # - nodiscc.xsrv.gitea
    # - other.collection.role
```

A playbook that deploys some roles in parallel across hosts:

```yaml
# deploy the common role to all hosts in parallel
- hosts: all
  roles:
    - nodiscc.xsrv.common

# deploy the monitoring role to all hosts except demo35.example.org
- hosts: all:!demo35.example.org
  roles:
    - nodiscc.xsrv.monitoring

# deploy specific roles role to specific hosts
- hosts: ldap.example,app01.example.org
  roles:
    - nodiscc.xsrv.apache
- hosts: ldap.example.org
  roles:
    - nodiscc.xsrv.openldap
- hosts: backup.example.org
  roles:
    - nodiscc.xsrv.backup
- hosts: app01.example.org
  roles:
    - nodiscc.xsrv.postgresql
    - nodiscc.xsrv.nextcloud
    - nodiscc.xsrv.shaarli
    - nodiscc.xsrv.gitea
```

See [Intro to playbooks](https://docs.ansible.com/ansible/latest/user_guide/playbooks_intro.html).


**Removing roles:** Removing a role from the playbook does not remove its components or data from your hosts. To uninstall components managed by a role, run `xsrv deploy` with the appropriate `utils-remove-*` [tag](tags.md):

```bash
# remove all gitea role components and data from demo1.example.org
TAGS=utils-remove-gitea xsrv deploy default demo1.example.org
```

Then remove the role from your playbook.

You may also remove components manually using SSH/[`xsrv shell`](#xsrv-shell), or remove the role from the list, [prepare](installation/server-preparation.md) a new host, deploy the playbook again, and restore data from backups or shared storage.

Most roles provide variables to temporarily disable the services they manage.

-------------------------------

## Manage configuration

### xsrv show-defaults

Show [all role configuration variables](configuration-variables.md), and their default values.

```bash
# show variables for all roles
xsrv show-defaults myproject
# show variables only for a specific role
xsrv show-defaults myproject nextcloud
```


### xsrv edit-host

Edit configuration variables (`host_vars`) for a host.

The value in host_vars will take [precedence](https://docs.ansible.com/ansible/latest/reference_appendices/general_precedence.html) over default and [group](#xsrv-edit-group) values. Example:

```yaml
# $ xsrv show-defaults
# yes/no: enable the mumble service
mumble_enable_service: yes

# $ xsrv edit-host
# disable the mumble service on this host
mumble_enable_service: no
```

Use [`xsrv show-defaults`](#xsrv-show-defaults) to list all available variables and their default values.

You may also use [special variables](https://docs.ansible.com/ansible/latest/reference_appendices/special_variables.html) or [connection variables](https://docs.ansible.com/ansible/latest/collections/ansible/builtin/ssh_connection.html):

```yaml
# user account used for deployment
ansible_user: "deploy"
# SSH port used to contact the host (if different from 22)
ansible_ssh_port: 123
# IP/hostname used to contact the host if its inventory name is different/not resolvable
ansible_host: 1.2.3.4
```


### xsrv edit-vault

Edit encrypted configuration variables/secrets for a host.

Sensitive variables such as usernames/password/credentials should not be stored as plain text in [`host_vars`](#xsrv-edit-host). Instead, store them in an encrypted file:

```yaml
# xsrv edit-vault
# sudo password for the ansible_user account
ansible_become_pass: "ZplHu0b6q88_QkHNzuKwoa-9cb-Dxrrt"
# roles may require additional secrets/variables
nextcloud_user: "myadminusername"
nextcloud_password: "cyf58eAZFbbEUZ4v3y6B"
nextcloud_admin_email: "admin@example.org"
nextcloud_db_password: "ucB77fNLX4qOoj2GhLBy"
```

By default, Vault files are encrypted/decrypted by [ansible-vault](https://docs.ansible.com/ansible/latest/cli/ansible-vault.html) using the master password stored in plain text in `.ansible-vault-password`. A random strong master password is generated automatically during initial [project](#manage-projects) creation. 

```bash
# cat ~/playbooks/default/.ansible-vault-password
Kh5uysMgG5f9X£5ap_O_AS(n)XS1fuuY
```
**Keep backups of this file** and protect it appropriately (`chmod 0600 .ansible-vault-password`, full-disk encryption on underlying storage). By default this file is excluded from [Git version control](#version-control) if the project was created with [`xsrv init-project`](#xsrv-init-project).

You may also place a custom script in `.ansible-vault-password`, that will fetch the master password from a secret storage/keyring of your choice (in this case the file must be made executable - `chmod +x .ansible-vault-password`).

To disable reading the master password from a file/script: edit the `ansible.cfg` file in the project directory (`xsrv edit-cfg`), comment out the `vault_password_file` setting, and uncomment the `ask_vault_pass = True` setting. You will be asked for the `sudo` password before deployment. You may also specify a diffrent path to the password file.


### xsrv edit-group

Edit [group](#manage-hosts) configuration (*group_vars* - configuration shared by all hosts in a group).

```yaml
# $ xsrv edit-group default all
# enable msmtp mail client installation for all hosts
setup_msmtp: yes

# $ xsrv edit-host default dev.example.org
# except for this host
setup_msmtp: no
```

Group variables take priority over [default](#xsrv-show-defaults) values, but are overridden by [host](#xsrv-edit-host) variables.


### xsrv edit-group-vault

Edit encrypted [group](#manage-hosts) configuration - similar to [`xsrv edit-vault`](#xsrv-edit-vault), but for groups.

```yaml
# $ xsrv edit-group-vault all
# common outgoing mail credentials for all hosts
msmtp_username: "mail-notifications"
msmtp_password: "e9fozo8ItlH6XNoysyt7vdylXcttVu"
```

----------------------------

## Apply changes

### xsrv deploy

**After any changes to the playbook, inventory or configuration variables**, apply changes to the target host(s):

```bash
xsrv deploy
```

You may also deploy changes for a limited set/group of hosts or roles/tasks:

```bash
# deploy only to my.example2.org and the 'prod' group in the default project
xsrv deploy default my.example2.org,prod
# deploy only nextcloud and transmission roles
TAGS=nextcloud,transmission xsrv deploy default
```

Run `xsrv help-tags` or see the list of [all tags](tags.md).


### xsrv check

[Check mode](https://docs.ansible.com/ansible/latest/user_guide/playbooks_checkmode.html) will simulate changes and return the expected return status of each task (`ok/changed/skipped/failed`), but no actual changes will be made to the host (_dry-run_ mode).

```bash
# check what would be changed by running xsrv deploy default my.example2.org
xsrv check default my.example2.org
# TAGS can also be sued in check mode
TAGS=nextcloud,transmission xsrv check
```

Note: check mode may not reflect changes that will actually occur in a "real" deployment, as some conditions may change during actual deployment that will lead to other changes/actions to be triggered. Notably, running `xsrv check` before the first actual deployment of a host/role will output many errors that would not occur during an actual deployment. These errors are ignored if appropriate.

_Equivalent ansible commands: `ansible-playbook playbook.yml --limit=my.example2.org,production --tags=transmission,nextcloud --check`_


----------------------------

## Provision hosts

`xsrv` allows automated creation/provisioning of minimal Debian VMs using these commands:

- [`xsrv init-vm-template`](appendices/debian.md#automated-from-preseed-file)
- [`xsrv init-vm`](appendices/debian.md#automated-from-a-vm-template)

VMs created using this method can then be added to your project using [`xsrv init-host`](#xsrv-init-host) or equivalent, at which point you can start deploying your configuration/services to them.


----------------------------

## Upgrading

**Upgrade roles to the latest release:** (this is the default) run `xsrv upgrade` to upgrade to the latest stable [release](https://gitlab.com/nodiscc/xsrv/-/releases) at any point in time (please read release notes/upgrade procedures and check if manual steps are required).

**Upgrade roles to the latest development revision**: replace `release` with `master` (or any other branch/tag) in the [requirements.yml](https://gitlab.com/nodiscc/xsrv/-/blob/master/playbooks/xsrv/requirements.yml) file of your project (`xsrv edit-requirements`) , then run `xsrv upgrade`.

**Upgrade the xsrv script**: run `xsrv self-upgrade` to upgrade the `xsrv` command-line utility to the latest stable release.


----------------------------

## Other commands

### xsrv shell

Open a shell directly on the target host using SSH. This is equivalent to `ssh -p $SSH_PORT $USER@$HOST` but you only need to pass the host name - the port and user name will be detected automatically from the host's [configuration variables](#manage-configuration).

```bash
$ xsrv shell my.example.org
# or
$ xsrv ssh my.example.org
```

An alternative is to use the [`readme-gen`](#xsrv-readme-gen) command to generate a SSH client configuration file which will allow contacting the host with `ssh $HOST` without specifying the port/user.


### xsrv readme-gen

Adds a summary of basic information about your hosts (groups, IP addresses, OS/virtualization, CPU, memory, storage, quick access links to services deployed on the host, monitoring badges, custom comment...) in README.md at the root of your project, using Markdown. Running this command multiple times will update the summary with the latest information gathered from your hosts.

See the detailed [documentation](https://gitlab.com/nodiscc/xsrv/-/tree/master/roles/readme_gen).


### xsrv logs

Open the current `syslog` log with the [lnav](https://lnav.org/) log viewer on the remote host.

```bash
$ xsrv logs my.example.org
```

If the remote user is not allowed to read `/var/log/syslog` directly, the `sudo` password will be asked (a.k.a. `ansible_become_pass`). This assumes `lnav` is installed either by one of the [monitoring_rsyslog](https://gitlab.com/nodiscc/xsrv/-/tree/master/roles/monitoring_rsyslog)/[monitoring_utils](https://gitlab.com/nodiscc/xsrv/-/tree/master/roles/monitoring_utils)/[monitoring_netdata](https://gitlab.com/nodiscc/xsrv/-/tree/master/roles/monitoring_netdata) roles, or manually (for example using [`packages_install`](https://gitlab.com/nodiscc/xsrv/-/blob/master/roles/common/defaults/main.yml)). A quick introduction to `lnav` usage can be foudn [here](https://gitlab.com/nodiscc/xsrv/-/tree/master/roles/monitoring_utils#usage)



----------------------------

## Advanced

### Use without remote controller

Using the server/host as its own controller is not recommended, but can help with single-server setups where no separate administration machine is available. By not using a separate controller, you lose the ability to easily redeploy a new system from scratch in case of emergency/distaster, and centralized management of multiple hosts will become more difficult. Your host will also have access to configuration of other hosts in your project.

- [Install](installation/controller-preparation.md) the `xsrv` main script directly on the host
- During [initialization](#manage-projects) or by [editing configuration](#manage-configuration) set `ansible_connection: local` in the host's configuration variables (`xsrv edit-host`):

```yaml
##### CONNECTION
# SSH host/port, if different from my.example.org:22
# ansible_host: "my.example.org"
# ansible_port: 22
ansible_connection: local
```

<!--
### Interactive mode
TODO-->


### Use as ansible collection

The main [`xsrv` script](#command-line-usage) maintains a simple and consistent structure for your projects, automates frequent operations, and manages Ansible installation/environments. You can also manage your playbooks manually using your favorite text editor and [`ansible-*` command-line tools](https://docs.ansible.com/ansible/latest/user_guide/command_line_tools.html).

To import roles as a [collection](https://docs.ansible.com/ansible/latest/user_guide/collections_using.html) in your own playbooks, [install ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html) and create `requirements.yml` in the project directory:

```yaml
# cat requirements.yml
collections:
  - name: https://gitlab.com/nodiscc/xsrv.git
    type: git
    version: release
```

Install the collection (or upgrade it to the latest [release](https://gitlab.com/nodiscc/xsrv/-/releases)):

```bash
ansible-galaxy collection install --force -r requirements.yml
```

Include the collection and roles in your playbooks:

```yaml
# cat playbook.yml
- hosts: my.CHANGEME.org
  collections:
    - nodiscc.xsrv
  roles:
   - nodiscc.xsrv.common
   - nodiscc.xsrv.monitoring
   - nodiscc.xsrv.apache
   - ...
```

Note that `xsrv` roles may require a minimum ansible versino, specified in [`meta/runtime.yml`](https://gitlab.com/nodiscc/xsrv/-/blob/master/meta/runtime.yml)

See [`man ansible-galaxy`](https://docs.ansible.com/ansible/latest/cli/ansible-galaxy.html), [Using collections](https://docs.ansible.com/ansible/latest/user_guide/collections_using.html) and [roles](index.md) documentation.

Other collections:
- [nodiscc.toolbox](https://gitlab.com/nodiscc/toolbox/-/tree/master/ARCHIVE/ANSIBLE-COLLECTION) - less-maintained, experimental or project-specific roles (`awesome_selfhosted_html`, `docker`, `homepage_extra_icons`, `icecast`, `k8s`, `mariadb`, `nfs_server`, `planarally`, `proxmox`, `pulseaudio`, `reverse_ssh_tunnel`, `rocketchat`, `rss_bridge`, `rss2email`, `valheim_server`, `vscodium`, `znc`)
- [devsec.hardening](https://github.com/dev-sec/ansible-collection-hardening) - battle tested hardening for Linux, SSH, nginx, MySQL
- [debops.debops](https://galaxy.ansible.com/debops/debops) - general-purpose Ansible roles that can be used to manage Debian or Ubuntu hosts
- [Ansible Galaxy](https://galaxy.ansible.com/) - help other Ansible users by sharing the awesome roles and collections you create

Directory structure for a project:

```bash
# tree -a ~/playbooks/default/
├── inventory.yml # inventory of managed hosts
├── playbook.yml # playbook (assign roles to managed hosts)
├── group_vars/ # group variables (file names = group names from inventory.yml)
│   └── all.yml
├── host_vars/ # host variables (file names = host names from inventory.yml)
│   ├── my.example.org/
│   │   ├── my.example.org.vault.yml # plaintext host variables file
│   │   └── my.example.org.yml # encrypted/vaulted host variables file
│   └── my.other.org/
│       ├── my.other.org.vault.yml
│       └── my.other.org.yml
├── data/ # other data
│   ├── backups/
│   ├── cache/
│   ├── certificates/
│   └── public_keys/
├── playbooks # custom playbooks for one-shot tasks
│   ├── main.yml
│   └── operationXYZ.yml
├── README.md # documentation about your project
├── ansible.cfg # ansible configuration
├── requirements.yml # required ansible collections
└── ansible_collections # downloaded collections
    └── nodiscc
        └── xsrv
```

### Using ansible command-line tools

Ansible [command-line tools](https://docs.ansible.com/ansible/latest/command_guide/command_line_tools.html) can be used directly in projects managed by xsrv. The project's virtualenv must be activated manually:

```bash
# enter the project directory
cd ~/playbooks/default
# activate the virtualenv
source .venv/bin/activate
```

```bash
# run ansible commands directly
ansible-playbook playbook.yml --list-tasks
ansible-playbook playbook.yml --start-at-task 'run nextcloud upgrade command' --limit my.example.org,my2.example.org
ansible-inventory --list --yaml
ansible-vault encrypt_string 'very complex password'
ansible --become --module-name file --args 'state=absent path=/var/log/syslog.8.gz' my.example.org
```

### Version control

Configuration/testing/deployment/change management process can be automated further using [version-controlled](https://en.wikipedia.org/wiki/Version_control) configuration. Put your playbook directory (e.g. `~/playbooks/default`) under `git` version control and start tracking changes to your configuration:

```bash
# create a project
xsrv init-project default
# enter the project directory
cd ~/playbooks/default/
# start tracking changes
git init
# add initial files
git add .
git commit -m "initial commit"
# change a configuration value
xsrv edit-host default prod.example.org
# add and commit the change
git add host_vars/prod.example.org/prod.example.org.yml
git commit -m "prod.example.org: change x configuration to y"
# push your changes
git push
```

**Reverting changes:**

- `git checkout` your playbook directory as it was before the change or `git reset` to the desired, "good" commit.
- apply the playbook `xsrv deploy`

You may have to restore data from last known good [backups](maintenance.md)/a snapshot from before the change. See each role's documentation for restoration instructions.


### Continuous deployment

Projects stored in [git](#version-control) repositories can be tied to a [Continuous deployment](https://en.wikipedia.org/wiki/Continuous_deployment) (CI/CD) system that will perform automated checks and deployments, controlled by git operations (similar to [GitOps](https://about.gitlab.com/topics/gitops/)).

This example [`.gitea/workflows/ci.yml`](.gitea_workflows_ci.yml) for [Gitea Actions](https://docs.gitea.com/next/usage/actions/overview) will deploy your project against specific environments/hosts/groups (optionally running the playbook in `check` mode beforehand) automatically when changes are pushed. It should also work from [Github Actions](https://docs.github.com/en/actions) since the syntax is the same. Different target hosts/groups can be specified for master and non-master branches.

This example [`.gitlab-ci.yml`](https://gitlab.com/nodiscc/xsrv/-/blob/master/docs/.gitlab-ci.yml) for [Gitlab CI](https://docs.gitlab.com/ee/ci/) checks the playbook for syntax errors, simulates the changes against `staging` and `production` environments, and waits for manual action (click on `‣`) to run actual staging/production deployments. Pipeline execution time can be optimized by building a CI image that includes preinstalled dependencies: [`.gitlab-ci.Dockerfile`](https://gitlab.com/nodiscc/xsrv/-/blob/master/docs/.gitlab-ci.Dockerfile), [`.gitlab-ci.yml`](https://gitlab.com/nodiscc/xsrv/-/blob/master/docs/.gitlab-ci.docker.yml).


## External links

- [Ansible documentation](https://docs.ansible.com/)
- [Awesome-selfhosted](https://github.com/awesome-selfhosted/awesome-selfhosted)
- <https://stdout.root.sx/xsrv/xsrv> (upstream)
- <https://github.com/nodiscc/xsrv> (mirror)
- <https://gitlab.com/nodiscc/xsrv> (mirror)

