# Usage

[Hosts (servers)](installation/server-preparation.md) configuration is stored on the [controller](installation/controller-preparation.md) machine, in [YAML](https://en.wikipedia.org/wiki/YAML) files in the `~/playbooks/` directory.

To [add roles or change configuration settings](#changing-configuration), edit the relevant configuration file, then [apply changes](#applying-configuration) using `xsrv deploy`.


-----------------------

## Command-line usage

Most commands support optional `playbook` and `host` parameters if you have multiple playbooks/hosts. You may also edit files directly in the playbook directory, and use [ansible command-line tools](#using-as-ansible-collection) to manage and deploy your configuration.

```bash
  ╻ ╻┏━┓┏━┓╻ ╻
░░╺╋╸┗━┓┣┳┛┃┏┛
  ╹ ╹┗━┛╹┗╸┗┛ vX.Y.Z

USAGE: xsrv COMMAND [playbook] [host]

# PLAYBOOK-LEVEL COMMANDS
init-playbook [playbook]         initialize a new playbook
edit-playbook [playbook]         edit/show playbook (list of roles)
edit-inventory [playbook]        edit/show inventory file (list of hosts)
show-defaults [playbook] [role]  show all variables and their default values

# HOST-LEVEL COMMANDS
init-host [playbook] [host]      add a new host to an existing playbook
check [playbook] [host]          simulate deployment, report what would be changed
deploy [playbook] [host]         deploy a playbook (apply configuration/roles)
edit-host [playbook] [host]      edit host configuration (host_vars)
edit-vault [playbook] [host]     edit encrypted (vault) host configuration
fetch-backups [playbook] [host]  fetch backups from a host to the local backups/ directory
upgrade [playbook] [host]        upgrade roles to latest version
shell [playbook] [host]          open an interactive shell on a host
logs [playbook] [host]           view system log on a host
ls                               list files in the playbooks directory (accepts a path)
help                             show this message

# OTHER COMMANDS
self-upgrade                     check for new releases/upgrade the xsrv script in-place

# ENVIRONMENT VARIABLES (usage: VARIABLE=VALUE xsrv COMMAND)
TAGS               comma-separated list of ansible tags (eg. TAGS=common,monitoring xsrv deploy)
SKIP_VENV          advanced: skip installation of pip dependencies (yes/no, default: no)
EDITOR             text editor to use (default: nano)
PAGER              pager to use (default: less)
```

Examples:

```bash
xsrv deploy default # deploy all hosts in the 'default' playbook
xsrv deploy # deploy all hosts in the default playbook (default is assumed when no playbook name is specified)
xsrv init-playbook infra # initialize a new playbook/environment named 'infra'
xsrv deploy infra # deploy all hosts in the playbook named 'infra'
xsrv init-host infra ex2.CHANGEME.org # add a new host 'ex2.CHANGEME.org' to the playbook named 'infra'
xsrv edit-host infra ex2.CHANGEME.org # edit host variables for the host 'ex2.CHANGEME.org' in the playbook 'infra'
xsrv edit-vault infra ex2.CHANGEME.org # edit secret/vaulted variables for 'ex2.CHANGEME.org' in the playbook 'infra'
xsrv deploy infra ex1.CHANGEME.org,ex2.CHANGEME.org # deploy only the hosts ex1.CHANGEME.org and ex2.CHANGEME.org in the playbook 'infra'
TAGS=nextcloud,gitea deploy infra ex3.CHANGEME.org # run tasks tagged nextcloud or gitea on ex3.CHANGEME.org
```


------------------------

## Changing configuration

**`xsrv show-defaults`**: show [all available configuration variables](configuration-variables.md), and their default values.

```yaml
# xsrv show-defaults
...
# HTTPS and SSL/TLS certificate mode for the gitea webserver virtualhost
#   letsencrypt: acquire a certificate from letsencrypt.org
#   selfsigned: generate a self-signed certificate (will generate warning in browsers and clients)
gitea_https_mode: selfsigned
...
```

**`xsrv edit-host`**: edit configuration variables (`host_vars`) for the host/its roles. To change one of the default values listed in `xsrv show-defaults`, add the variable to this file with the desired value. Example:

```yaml
# xsrv edit-host
...
gitea_https_mode: letsencrypt
...
```

**`xsrv edit-vault`**: edit secret/encrypted configuration variables. Any secret/sensitive variable should not be stored as plain text in `host_vars`/`xsrv edit-host`. "Vaulted" files are encrypted with [ansible-vault](https://docs.ansible.com/ansible/latest/cli/ansible-vault.html), and decrypted on the fly during deployment. Example:

```yaml
# xsrv edit-vault
ansible_become_pass: "UFjP82CgUT5h7-e"
nextcloud_user: "myadminusername"
nextcloud_password: "cyf58eAZFbbEUZ4v3y6B"
nextcloud_admin_email: "admin@example.org"
nextcloud_db_password: "ucB77fNLX4qOoj2GhLBy"
```

The master decryption password for the vault **must** be present in cleartext in `.ansible-vault-password` (it is generated automatically during initial playbook/environment creation). **Keep backups of this file** and protect it appropriately:

```bash
# $EDITOR ~/playbook/default/.ansible-vault-password
Kh5uysMgG5f9X£5ap_O_AS(n)XS1fuuY 
```

**`xsrv edit-group`**: edit group configuration (`group_vars` - configuration shared by all hosts in a group). Host-level configuration takes [precedence](https://docs.ansible.com/ansible/latest/reference_appendices/general_precedence.html) over group variables.

```bash
# xsrv edit-group default all
# enable msmtp mail client installation for all hosts
setup_msmtp: yes

# xsrv edit-host default dev.example.org
# except for this host
setup_msmtp: no
```


## Adding roles

**`xsrv edit-playbook`**: edit the list of roles ([playbook](https://docs.ansible.com/ansible/latest/user_guide/playbooks_intro.html)) enabled on your hosts. Add any [role](index.md#roles) you wish to enable to enable to the `roles:` list of your host. Example:

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
```

_Note:_ Uninstalling roles is not supported at this time: components must be removed manually or using a ad-hoc playbook. Or a new server must be deployed and data restored from backups. Most roles provide variables to temporarily disable their services/functionality.


## Applying configuration

**After any changes to the playbook, inventory or configuration variables**, apply changes to the target host(s):

```bash
xsrv deploy
```

You may also deploy the changes to a limited set/group of hosts:

```bash
xsrv deploy default dns.example.org,dev
```

## Adding a new host

To add a new host to the playbook, inventory, and create its `host_vars`/vault files:


```bash
xsrv init-host
```

And follow directions

<!-- TODO SCREENCAST -->

These variables are required for all hosts:

```yaml
ansible_user: "CHANGEME" # user account used for deployment (member of sudo and ssh groups)
ansible_become_pass: "CHANGEME" # sudo password for the deployment user account
```

In addition, these variables may be required for some hosts:

```yaml
# SSH port used to access the host, if different from 22
ansible_ssh_port: 123
# IP address or hostname used to contact the host, if its inventory name cannot be resolved
ansible_host: 1.2.3.4
```


## Managing multiple hosts

**`xsrv edit-inventory`**: edit the inventory file. This file lists all hosts in your environment and assigns them one or more groups.

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

See [YAML inventory](https://docs.ansible.com/ansible/latest/collections/ansible/builtin/yaml_inventory.html) documentation for details.


-------------------------------



-------------------------------

## Using as ansible collection

the [`xsrv` script](usage.md#command-line-usage) ensures your playbooks follow a simple and consistent structure, automates most frequent operations and ansible installation. You can also manage your playbooks manually, using your favorite text editor and standard [`ansible` command-line tools](https://docs.ansible.com/ansible/latest/user_guide/command_line_tools.html).

To import roles as a collection to your own playbooks:

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

See [`man ansible-galaxy`](https://docs.ansible.com/ansible/latest/cli/ansible-galaxy.html) and [Ansible documentation - Using collections](https://docs.ansible.com/ansible/latest/user_guide/collections_using.html)


## Directory structure

The directory structure assumed/enforced by `xsrv` is as follows:

```bash
$ tree -a ~/playbooks/default/
├── inventory.yml # inventory of managed hosts
├── playbook.yml # main entrypoint (assign roles to managed hosts)
├── group_vars # group variables (file names match group names from inventory.yml)
│   └── all.yml
├── host_vars # host variables (file names match host names from inventory.yml)
│   └── my.example.org
│       ├── my.example.org.vault.yml # plaintext host variables file
│       └── my.example.org.yml # encrypted/vaulted host variables file (for sensitive values)
├── data # local cache and data (should be kept out of version control)
│   ├── backups
│   └── cache
├── playbooks # custom playbooks for one-shot tasks, unused in the default configuration
│   ├── main.yml
│   └── operationXYZ.yml
├── public_keys # directory for additional public SSH keys, unused in the default configuration
│   └── user@laptop.pub
├── README.md # store any additional notes/information about your environments there
├── ansible.cfg # global ansible configuration (output format, verbosity, logging, paths...)
├── requirements.yml # list of required ansible collections and their versions
└── ansible_collections # directory to store downloaded collections
    └── nodiscc
        └── xsrv
```

## Advanced usage

The configuration/testing/deployment process can be automated further using [version controlled](#version-control) configuration, and [Continuous Deployment](#continuous-deployment) tools.


### Version control

Put your playbook directory (eg. `~/playbooks/default`) under version control/[git](https://stdout.root.sx/?searchtags=git+doc) if you need to track changes to your configuration.

```bash
# cd to you playbook directory
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

- (optional) restore a VM snapshot from before the change (will cause loss of all data modified after the snapshot!), OR restore data from last known good backups (see each role's documentation for restoration instructions)
- `git checkout` your playbook directory as it was before the change or `git reset --hard` to the desired, "good" commit.
- apply the playbook `xsrv deploy`

Refer to **[ansible documentation](https://docs.ansible.com/)** for more information.



## Continuous deployment

[Continuous Deployment](https://en.wikipedia.org/wiki/Continuous_deployment) tools can be tied to a version control/git repository for automated checks/deployments controlled by git operations ("GitOps").

This example [`.gitlab-ci.yml`](https://gitlab.com/nodiscc/xsrv/-/blob/master/playbooks/xsrv/.gitlab-ci.yml) implements a pipeline to run the playbook and evaluate changes against a testing/staging environment, before deploying to the actual production environment ("rolling" updates - strongly recommended for mission-critical systems).


<!-- TODO DETAILED CI/CD WALKTHROUGH -->


## See also

- [awesome-selfhosted](https://github.com/awesome-selfhosted/awesome-selfhosted)
- <https://stdout.root.sx/xsrv/xsrv> (upstream)
- <https://github.com/nodiscc/xsrv> (mirror)
- <https://gitlab.com/nodiscc/xsrv> (mirror)

