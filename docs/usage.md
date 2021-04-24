# Usage

`xsrv` is a wrapper around the [ansible](https://en.wikipedia.org/wiki/Ansible_%28software%29) suite of tools.

Server ([host](installation/server-preparation.md)) configuration is stored in the `~/playbooks/` directory on the [controller](installation/controller-preparation.md) in [YAML](https://en.wikipedia.org/wiki/YAML) files.

To [enable components or change server configuration](#changing-configuration), edit the relevant YAML configuration file, then apply changes using `xsrv deploy`.


## Changing configuration

- `xsrv edit-playbook`: edit the list of enabled roles ([playbook](https://docs.ansible.com/ansible/latest/user_guide/playbooks_intro.html)) for your hosts. Add any [role](index.md#roles) you wish to enable to enable to your host's `roles:` list. Example:

```yaml
# xsrv edit-playbook
- hosts: my.example.org
  roles:
    - nodiscc.xsrv.common
    - nodiscc.xsrv.monitoring
    - nodiscc.xsrv.apache
    - nodiscc.xsrv.openldap
    - nodiscc.xsrv.nextcloud
    - nodiscc.xsrv.mumble
    # - nodiscc.xsrv.jellyfin # uncomment or add roles to this list to enable additional components
```

- `xsrv show-defaults`: show [all available configuration variables](configuration-variables.md), and their default values.

```yaml
# xsrv show-defaults
...
# HTTPS and SSL/TLS certificate mode for the gitea webserver virtualhost
#   letsencrypt: acquire a certificate from letsencrypt.org
#   selfsigned: generate a self-signed certificate (will generate warning in browsers and clients)
gitea_https_mode: selfsigned
...
```

- `xsrv edit-host`: edit configuration (`host_vars`) for the host and its roles. To change one of the default values listed in `xsrv show-defaults`, add the variable to this file with the desired value. Example:

```yaml
# xsrv edit-host
...
gitea_https_mode: letsencrypt
...
```

- `xsrv edit-vault`: edit secret/encrypted configuration variables. Any secret/sensitive variable should not be stored as plain text in `host_vars`. "Vaulted" files are encrypted with [ansible-vault](https://docs.ansible.com/ansible/latest/cli/ansible-vault.html), and decrypted on the fly during deployment. Example:

```yaml
# xsrv edit-vault
ansible_become_pass: "UFjP82CgUT5h7-e"
nextcloud_user: "myadminusername"
nextcloud_password: "cyf58eAZFbbEUZ4v3y6B"
nextcloud_admin_email: "admin@example.org"
nextcloud_db_password: "ucB77fNLX4qOoj2GhLBy"
```

The decryption password for the vault must be present in `.ansible-vault-password`:

```bash
# $EDITOR ~/playbook/default/.ansible-vault-password
Kh5uysMgG5f9X£5ap_O_AS(n)XS1fuuY 
```



All commands support and additional playbook/host name parameter if you have multiple playbook/hosts. See below for complete usage examples.

You can also edit files directly from your favorite text editor, use plain [ansible command-line tools](#using-as-ansible-collection) and [git/version control](#version-control) to manage and deploy your playbooks.


**After any changes to the playbook, inventory or configuration variables**, apply changes to the target host:

```bash
xsrv deploy
```

## Command-line usage

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

-------------------------------

## Advanced

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


### Directory structure

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
├── ansible.cfg # global ansible configuration
├── requirements.yml # list of required ansible collections and their versions
└── ansible_collections # directory to store downloaded collections
    └── nodiscc
        └── xsrv
```


### Continuous deployment

For production systems, it is strongly recommended to run the playbook and evaluate changes against a testing/staging environment first (eg. create separate `testing`,`prod` groups in `inventory.yml`, deploy changes to the `testing` environmnent with `xsrv deploy PLAYBOOK_NAME testing`). 

You can further automate deployment procedures using a CI/CD pipeline. See the example [`.gitlab-ci.yml`](https://gitlab.com/nodiscc/xsrv/-/blob/master/playbooks/xsrv/.gitlab-ci.yml) to get started.


## See also

- [awesome-selfhosted](https://github.com/awesome-selfhosted/awesome-selfhosted)
- <https://stdout.root.sx/xsrv/xsrv> (upstream)
- <https://github.com/nodiscc/xsrv> (mirror)
- <https://gitlab.com/nodiscc/xsrv> (mirror)

