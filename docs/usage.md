# Usage


The `xsrv` command-line tool automates creation and maintenance of [projects](#manage-projects) on a [controller](installation/controller-preparation.md) machine. Configuration is stored in [YAML](https://en.wikipedia.org/wiki/YAML) files on the controller and deployed to target [hosts](installation/server-preparation.md) over SSH.

Use the `xsrv` command-line to manage your projects, or [include xsrv roles in your own ansible playbooks](#use-as-ansible-collection).

-----------------------

## Command-line usage


```bash
  ╻ ╻┏━┓┏━┓╻ ╻
░░╺╋╸┗━┓┣┳┛┃┏┛
  ╹ ╹┗━┛╹┗╸┗┛ v1.6.0

USAGE: xsrv COMMAND [project] [host]

init-project [project] [host]       initialize a new project (and optionally a first host)
edit-inventory [project]            edit/show inventory file (hosts/groups)
edit-playbook [project]             edit/show playbook (roles for each host)
show-defaults [project] [role]      show all variables and their default values
edit-requirements [project]         edit ansible requirements/collections
edit-cfg [project]                  edit ansible configuration (ansible.cfg)
init-host [project] [host]          add a new host to an existing project
check [project] [host]              simulate deployment, report what would be changed
deploy [project] [host]             deploy the main playbook (apply configuration/roles)
edit-host [project] [host]          edit host configuration (host_vars)
edit-vault [project] [host]         edit encrypted (vault) host configuration (host_vars)
edit-group [project] [group]        edit group configuration (group_vars)
edit-group-vault [project] [group]  edit encrypted (vault) group configuration (group_vars)
fetch-backups [project] [host]      fetch backups from a host to the local backups directory
shell [project] [host]              open interactive shell on a host
logs [project] [host]               view system logs on a host
ls                                  list files in the projects directory (accepts a path)
help                                show this message
help-tags [project]                 show the list of ansible tags and their descriptions
upgrade [project]                   upgrade roles/collections to latest versions
self-upgrade                        check for new releases/upgrade the xsrv script in-place
init-vm [--help] [options]          initialize a new libvirt VM from a template

# ENVIRONMENT VARIABLES (usage: VARIABLE=VALUE xsrv COMMAND)
TAGS               deploy/check only: list of ansible tags (TAGS=ssh,samba,... xsrv deploy)
EDITOR             text editor to use (default: nano)
PAGER              pager to use (default: nano --syntax=YAML --view +1 -)

# DOCUMENTATION
https://xsrv.readthedocs.io/en/master/usage.html
```

If no `[project]` is specified, the `default` project is assumed. If no `[limit]` is specified, `all` hosts are assumed.

Examples:

```bash
xsrv deploy # deploy all hosts in the default project
xsrv deploy default # deploy all hosts in the default project
xsrv init-project infra # initialize a new project named infra
xsrv deploy infra # deploy all hosts in project infra
xsrv init-host infra ex2.CHANGEME.org # add a new host ex2.CHANGEME.org to project infra
xsrv edit-host infra ex2.CHANGEME.org # edit host variables for the host'ex2.CHANGEME.org in project infra
xsrv edit-vault infra ex2.CHANGEME.org # edit secret/vaulted variables for ex2.CHANGEME.org in project infra
xsrv deploy infra ex1.CHANGEME.org,ex2.CHANGEME.org # deploy only the hosts ex1.CHANGEME.org and ex2.CHANGEME.org in project infra
TAGS=nextcloud,gitea xsrv deploy infra ex3.CHANGEME.org # run tasks tagged nextcloud or gitea on ex3.CHANGEME.org in project infra
xsrv deploy default '!ex1.CHANGEME.org,!ex7.CHANGEME.org' # deploy all hosts except ex1 and ex7.CHANGEME.org
```


------------------------

## Manage projects

Each project contains:
- an independent/isolated ansible installation (_virtualenv_) and its configuration
- an [inventory](#manage-hosts) of managed servers and their [roles](#manage-roles) (_playbook_)
- [configuration](#manage-configuration) values specific to each host/group (*host_vars/group_vars*)
- [collections](#use-as-ansible-collection)/roles used by your project

Projects are stored in the `~/playbooks` directory by default (use the `XSRV_PROJECTS_DIR` environment variable to override this).

A single project is suitable for most setups (you can still organize hosts as different [environments/groups](#manage-hosts) inside a project). Use multiple projects to separate setups with completely [different contexts/owners](maintenance.md).

```bash
$ ls ~/playbooks/
default/  homelab/  mycompany/
```

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
├── data/ # local cache and data
│   ├── backups/
│   └── cache/
├── README.md # documentation about your project
├── ansible.cfg # ansible configuration
├── requirements.yml # required ansible collections
└── ansible_collections # downloaded collections
    └── nodiscc
        └── xsrv
```

<!--TODO
 (output format, verbosity, logging, paths...)
├── public_keys/ # public SSH keys
│   └── user@laptop.pub
 and their versions
├── playbooks # custom playbooks for one-shot tasks
│   ├── main.yml
│   └── operationXYZ.yml
```
-->

### xsrv init-project

Initialize a new project from the [template](https://gitlab.com/nodiscc/xsrv/-/tree/master/playbooks/xsrv) - creates all necessary files and prepares a playbook/environment with a single host.


## Manage hosts

All servers [(hosts)](installation/server-preparation.md) must be listed in the inventory file. Their [roles](#manage-roles) must be listed in the playbook file. Hosts [configuration](#manage-configuration) must be set in [host_vars/group_vars](#manage-configuration) files.


### xsrv init-host

Add a new host to the inventory/playbook and create/update all required files. You will be asked for a [host name](#manage-hosts):

```yaml
# xsrv init-host
# [xsrv] Host name to add to the default playbook (ex: my.CHANGEME.org): my.example.org
```

- An editor will let you set the list of [roles](#manage-roles) for the host
- An editor wil let you set required [configuration variables](#manage-configuration).


### xsrv edit-inventory

Edit the inventory file. This file lists all hosts in your environment and assigns them one or more groups.

```yaml
# the simplest inventory, single host in a single group 'all'
all:
  my.example.org:

# an inventory with mutiple hosts/groups
all:
  children:
    tools:
      hypervisor.example.org:
      dns.example.org:
      siem.example.org:
    dev:
      dev.example.org:
      dev-db.example.org:
    staging:
      staging.example.org:
      staging-db.example.org:
    prod:
      prod.example.org:
      prod-db.example.org:
```

See [YAML inventory](https://docs.ansible.com/ansible/latest/collections/ansible/builtin/yaml_inventory.html).


## Manage roles

### xsrv edit-playbook

Edit the list of [roles](index.md) (playbook file) for your hosts. Add any role you wish to enable to the `roles:` list.

This is the simplest playbook, with a single host carrying multple roles:

```yaml
# xsrv edit-playbook
# uncomment or add roles to this list to enable additional components
- hosts: my.example.org
  roles:
    - nodiscc.xsrv.common
    - nodiscc.xsrv.monitoring
    - nodiscc.xsrv.apache
    - nodiscc.xsrv.openldap
    - nodiscc.xsrv.nextcloud
    - nodiscc.xsrv.mumble
    # - nodiscc.xsrv.jellyfin
    # - nodiscc.xsrv.transmission
    # - nodiscc.xsrv.gitea
    # - nodiscc.xsrv.samba
    # - other.collection.role
```

See [Intro to playbooks](https://docs.ansible.com/ansible/latest/user_guide/playbooks_intro.html).

Other examples:

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
- hosts: proxmox1.example.org
  roles:
    - nodiscc.xsrv.proxmox
- hosts: ldap.example.org
  roles:
    - nodiscc.xsrv.apache
    - nodiscc.xsrv.openldap
- hosts: backup.example.org
  roles:
    - nodiscc.xsrv.backup
- hosts: app01.example.org
  roles:
    - nodiscc.xsrv.apache
    - nodiscc.xsrv.postgresql
    - nodiscc.xsrv.nextcloud
    - nodiscc.xsrv.shaarli
    - nodiscc.xsrv.gitea
```


### Remove roles

Removing a role from the list does not remove its components from your hosts. To uninstall components managed by a role:
- Set the appropriate `*_uninstall` variable to `yes` ([`xsrv show-defaults`](#xsrv-show-defaults)) and apply changes ([`xsrv deploy`](#xsrv-deploy)). You may then remove the role from the list
- Or remove components manually using SSH/[`xsrv shell`](#xsrv-shell). You may then remove the role from the list
- Or remove the role from the list, [prepare](installation/server-preparation.md) a new host, apply the updated configuration/roles list, and restore data from backups

Most roles provide variables to temporarily disable the services they manage.


## Manage configuration

### xsrv show-defaults

Show [all role configuration variables](configuration-variables.md), and their default values.



### xsrv edit-host

Edit configuration variables (`host_vars`) for the host/roles deployed to it.

To change one of the default values listed in [`xsrv show-defaults`](#xsrv-show-defaults), add the variable to this file with the desired value. The value in host_vars will take [precedence](https://docs.ansible.com/ansible/latest/reference_appendices/general_precedence.html) over [default](#xsrv-show-defaults) role values and [group](#xsrv-edit-group) values. Example:

```yaml
# xsrv show-defaults
# yes/no: enable rocketchat services
rocketchat_enable_service: yes

# xsrv edit-host
rocketchat_enable_service: no
```

You may also use [special variables](https://docs.ansible.com/ansible/latest/reference_appendices/special_variables.html) in your hosts/groups configuration.

```yaml
# this variable is required for all hosts
ansible_user: "CHANGEME" # user account used for deployment

# these variables may be required in some cases
# SSH port used to contact the host if different from 22
ansible_ssh_port: 123
# IP/hostname used to contact the host if its inventory name is different/not resolvable
ansible_host: 1.2.3.4
```


### xsrv edit-vault

Edit encrypted configuration variables/secrets.

Sensitive variables such as usernames/password/credentials should not be stored as plain text in `host_vars`. Instead, store them in a file encrypted with [ansible-vault](https://docs.ansible.com/ansible/latest/cli/ansible-vault.html):

```yaml
# xsrv edit-vault
# this variable is required for all hosts
ansible_become_pass: "CHANGEME" # sudo password for this account
# roles may require additional secrets/variables
nextcloud_user: "myadminusername"
nextcloud_password: "cyf58eAZFbbEUZ4v3y6B"
nextcloud_admin_email: "admin@example.org"
nextcloud_db_password: "ucB77fNLX4qOoj2GhLBy"
```

Vault files are encrypted/decrypted using the master password stored in plain text in `.ansible-vault-password`. A random strong master password is generated automatically during initial [project](#manage-projects) creation. **Keep backups of this file** and protect it appropriately.

```bash
# cat ~/playbooks/default/.ansible-vault-password
Kh5uysMgG5f9X£5ap_O_AS(n)XS1fuuY 
```

You may also write a custom script in `.ansible-vault-password` that will fetch the master password from a secret storage/keyring of your choice (in that case `.ansible-vault-password` must be made executable).


### xsrv edit-group

Edit [group](#manage-hosts) configuration (*group_vars* - configuration shared by all hosts in a group).

```bash
# xsrv edit-group default all
# enable msmtp mail client installation for all hosts
setup_msmtp: yes

# xsrv edit-host default dev.example.org
# except for this host
setup_msmtp: no
```

### xsrv edit-group-vault

Edit encrypted [group](#manage-hosts) configuration - similar to [`xsrv edit-vault`](#xsrv-edit-vault) but for groups.

```bash
# xsrv edit-group-vault all
# common outgoing mail credentials for all hosts
msmtp_username: "mail-notifications"
msmtp_password: "e9fozo8ItlH6XNoysyt7vdylXcttVu"
```


## Apply changes

### xsrv deploy

**After any changes to the playbook, inventory or configuration variables**, apply changes to the target host(s):

```bash
xsrv deploy
```

You may also deploy changes for a limited set/group of hosts or roles/tasks:

```bash
# deploy configuration only to my.example2.org and the production group
xsrv deploy default my.example2.org,production
# deploy only nextcloud and transmission roles
TAGS=nextcloud,transmission xsrv deploy
```

### xsrv check

[Check mode](https://docs.ansible.com/ansible/latest/user_guide/playbooks_checkmode.html) will simulate changes and return the expected return status of each task (`ok/changed/skipped/failed`), but no actual changes will be made to the host.

_Equivalent ansible commands: `ansible-playbook playbook.yml --limit=my.example2.org,production --tags=transmission,nextcloud --check`_

## Usage without remote controller


- [Install](installation/controller-preparation.md) the `xsrv` main script directly on the host
- During [initialization](#manage-projects) or by [editing configuration](#manage-configuration) set `connection: local` in the playbook for this host:

```yaml
# xsrv edit-playbook
- hosts: my.example.org
  connection: local
  roles:
    - nodiscc.xsrv.common
```

Using the server/host as its own controller is not recommended, but can help with single-server setups where no separate administration machine is available. By not using a separate controller, you lose the ability to easily redeploy a new system from scratch in case of emergency/distaster, and centralized management of multiple hosts will become more difficult. Your host will also have access to configuration of other hosts in your project.

<!--
### Interactive mode
TODO-->


## Use as ansible collection

The main [`xsrv` script](#command-line-usage) maintains a simple and consistent structure for your projects, automates frequent operations, and manages ansible installation/environments. You can also manage your playbooks manually using your favorite text editor and [`ansible-*` command-line tools](https://docs.ansible.com/ansible/latest/user_guide/command_line_tools.html).

To import roles as a [collection](https://docs.ansible.com/ansible/latest/user_guide/collections_using.html) in your own playbooks, [install ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html) and create `requirements.yml` in your playbook directory:

```yaml
# cat requirements.yml
collections:
  - name: https://gitlab.com/nodiscc/xsrv.git
    type: git
    version: release
```

Install the collection:

```bash
ansible-galaxy collection install -r requirements.yml
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

To upgrade the collection to the latest [release](https://gitlab.com/nodiscc/xsrv/-/blob/master/CHANGELOG.md):

```bash
$ ansible-galaxy collection install --force -r requirements.yml
```

See [`man ansible-galaxy`](https://docs.ansible.com/ansible/latest/cli/ansible-galaxy.html), [Using collections](https://docs.ansible.com/ansible/latest/user_guide/collections_using.html) and [roles](index.md) documentation.


## Version control

Configuration/testing/deployment/change management process can be automated further using [version-controlled](https://en.wikipedia.org/wiki/Version_control) configuration.

Put your playbook directory (eg. `~/playbooks/default`) under `git` version control and start tracking changes to your configuration:

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
- run the playbook `xsrv deploy`

You may have to restore data from last known good [backups](maintenance.md)/a snapshot from before the change. See each role's documentation for restoration instructions.


## Continuous deployment

[Continuous deployment](https://en.wikipedia.org/wiki/Continuous_deployment) systems can be tied to a version control/git repository for automated checks and deployments controlled by git operations ("GitOps").

This example [`.gitlab-ci.yml`](https://docs.gitlab.com/ee/ci/) checks the playbook for syntax errors, simulates the changes against `staging` and `production` environments, and waits for manual action (click on `‣`) to run actual staging/production deployments.

```yaml
image: debian:buster-backports

# These variables must be set in the environment (Settings > CI/CD > variables)
# ANSIBLE_VAULT_PASSWORD (contents of .ansible-vault-password, type variable, masked)
# GITLAB_CI_SSH_KEY (contents of private SSH key authorized on remote hosts, terminated by newline, type file)

stages:
  - staging
  - production

variables:
  ANSIBLE_CONFIG: ansible.cfg
  ANSIBLE_HOST_KEY_CHECKING: "False"
  ANSIBLE_FORCE_COLOR: "True"
  XSRV_PLAYBOOKS_DIR: "../"
  PIP_CACHE_DIR: "$CI_PROJECT_DIR/pip-cache"
  TAGS: "all"

cache:
  paths:
    - "$CI_PROJECT_DIR/pip-cache"
    - "$CI_PROJECT_DIR/.venv"

include: # only run pipelines for branches/tags, not merge requests
  - template: 'Workflows/Branch-Pipelines.gitlab-ci.yml'

before_script:
  - export ANSIBLE_PRIVATE_KEY_FILE="$GITLAB_CI_SSH_KEY"
  - chmod 0600 "$ANSIBLE_PRIVATE_KEY_FILE"
  - echo "$ANSIBLE_VAULT_PASSWORD" > .ansible-vault-password
  - echo 'Apt::Install-Recommends "false";' >> /etc/apt/apt.conf.d/99-norecommends
  - apt update && apt -y git bash python3-pip python3-venv
  - wget -O /usr/local/bin/xsrv https://gitlab.com/nodiscc/xsrv/-/raw/release/xsrv
  - chmod a+x /usr/local/bin/xsrv


##### STAGING #####

check-staging:
  stage: staging
  script:
    - TAGS=$TAGS xsrv check staging
  interruptible: true # stop this job when a new pipeline starts on the same branch
  needs: [] # don't wait for other jobs to complete before starting this job

deploy-staging:
  stage: staging
  script:
    - TAGS=$TAGS xsrv deploy staging
  resource_group: staging # only allow one job to run concurrently on this resource group/environment
  needs:
    - check-staging

##### PRODUCTION #####

check-production:
  stage: check
  script:
    - TAGS=$TAGS xsrv check production
  interruptible: true
  needs: []

deploy-production:
  stage: production
  script:
    - TAGS=$TAGS xsrv deploy production
  when: manual # require manual action/click to start deployment
  resource_group: production
  needs:
    - check-production
    - deploy-staging
  only: # only allow deployment of the master branch or tags to production
    - master
    - tags
```

<!-- TODO PIPELINE SCREENSHOT -->

The pipeline run time can be optimized by pre-building a CI image that already includes dependencies from the `before_script` directive:

```Dockerfile
<!-- TODO .gitlab-ci.Dockerfile example -->
```

## Use the development version

To use the development version of the roles, replace `release` with `master` (or any other branch/tag) in the [requirements.yml](https://gitlab.com/nodiscc/xsrv/-/blob/master/playbooks/xsrv/requirements.yml) file of your project (`xsrv edit-requirements [project]`), then run `xsrv upgrade [project]`. Other collections can also be added to this file.


## External links

- [Ansible documentation](https://docs.ansible.com/)
- [Awesome-selfhosted](https://github.com/awesome-selfhosted/awesome-selfhosted)
- <https://stdout.root.sx/xsrv/xsrv> (upstream)
- <https://github.com/nodiscc/xsrv> (mirror)
- <https://gitlab.com/nodiscc/xsrv> (mirror)

