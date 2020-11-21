```
  ╻ ╻┏━┓┏━┓╻ ╻
░░╺╋╸┗━┓┣┳┛┃┏┛
  ╹ ╹┗━┛╹┗╸┗┛ 
```


[![](https://gitlab.com/nodiscc/xsrv/badges/master/pipeline.svg)](https://gitlab.com/nodiscc/xsrv/-/pipelines)
[![CII Best Practices](https://bestpractices.coreinfrastructure.org/projects/3647/badge)](https://bestpractices.coreinfrastructure.org/projects/3647)

**Install and manage self-hosted network services/applications on your own server(s).**

`xsrv` provides:

- a collection of ansible [roles](#roles) for various network services, web applications, and system administration
- a base [playbook to setup a single server](#basic-deployment) for personal use or small/medium teams
- a [command-line tool](#command-line-usage) (wrapper around  [`ansible`](https://en.wikipedia.org/wiki/Ansible_%28software%29)) for simple deployments, maintenance and configuration


## Roles

- [common](roles/common) - base system components (SSH, upgrades, users, hostname, networking, kernel, time/date)
- [backup](roles/backup) - incremental backup service (local and remote backups)
- [monitoring](roles/monitoring) - monitoring, alerting and log agregation system (netdata, rsyslog, other tools	)
- [apache](roles/apache) - Apache web server and PHP-FPM interpreter
- [homepage](role/homepage) - simple web server homepage
- [postgresql](roles/postgresql) - PostgreSQL database server
- [mariadb](roles/mariadb) - MariaDB (MySQL) database server
- [nextcloud](roles/nextcloud) - File hosting/sharing/synchronization/groupware/"private cloud" service
- [tt_rss](roles/tt_rss) - Tiny Tiny RSS web feed reader
- [samba](roles/samba) - Cross-platform file and printer sharing service (SMB/CIFS)
- [shaarli](roles/shaarli) - personal, minimalist, super-fast bookmarking service
- [gitea](roles/gitea) - Lightweight self-hosted Git service/software forge
- [transmission](roles/transmission) - Bittorrent client/web interface/seedbox service
- [mumble](roles/mumble) - Low-latency voice-over-IP (VoIP) server
- [openldap](roles/openldap) - LDAP directory server and web administration tools
- [docker](roles/docker) - Docker container platform
- [rocketchat](roles/rocketchat) - Realtime web chat/communication platform


<!-- TODO demo screencast -->

[![](https://screenshots.debian.net/screenshots/000/015/229/thumb.png)](roles/monitoring)
[![](https://i.imgur.com/PPVIb6V.png)](roles/nextcloud)
[![](https://i.imgur.com/UoKs3x1.png)](roles/tt_rss)
[![](https://i.imgur.com/8wEBRSG.png)](roles/shaarli)
[![](https://i.imgur.com/Rks90zV.png)](roles/gitea)
[![](https://i.imgur.com/blWO4LL.png)](roles/transmission)
[![](https://i.imgur.com/jYSU9zC.png)](roles/mumble)
[![](https://screenshots.debian.net/screenshots/000/006/946/thumb.png)](roles/openldap)
[![](https://i.imgur.com/OL7RZXb.png)](roles/rocketchat)
[![](https://i.imgur.com/3ZwPVQNs.png)](roles/homepage)


------------

**Table of contents**

- [Roles](#roles)
- [Installation](#installation)
- [Server preparation](#server-preparation)
- [Installation](#installation-1)
- [Usage](#usage)
  * [Basic deployment](#basic-deployment)
  * [Changing configuration](#changing-configuration)
  * [Command-line usage](#command-line-usage)
- [Maintenance](#maintenance)
  * [Backups](#backups)
  * [Upgrades](#upgrades)
  * [Storing sensitive configuration values](#storing-sensitive-configuration-values)
- [Advanced usage](#advanced-usage)
  * [Versioning your playbook](#versioning-your-playbook)
  * [Continuous Delivery](#continuous-delivery)
  * [Using as ansible collection](#using-as-ansible-collection)
- [Contributing/Issues/Work in progress](#contributing-issues-work-in-progress)
- [License](#license)
- [Changelog](#changelog)
- [See also](#see-also)

------------

## Installation

This tool runs on an administration machine (_controller_) and configures one or more remote servers (_hosts_), over the network using SSH.
 
![](docs/ansible-diagram.png)


## Server preparation

See **[server preparation](docs/server-preparation.md)**.


## Installation

A **controller** machine will be used for deployment and remote administration. The controller can be any laptop/desktop PC, dedicated server, VM or container where python and bash are available. On the controller:


```bash
# install requirements (example for debian-based systems)
sudo apt update && sudo apt install git bash python3-pip ssh pwgen

# clone the repository
sudo git clone -b release https://gitlab.com/nodiscc/xsrv /opt/xsrv # latest release
# sudo git clone -b 1.0 https://gitlab.com/nodiscc/xsrv /opt/xsrv # OR specific release
# sudo git clone -b master https://gitlab.com/nodiscc/xsrv /opt/xsrv # OR development version

# (optional) install the command line tool to your $PATH
sudo cp /opt/xsrv/xsrv /usr/local/bin/
```


## Usage

### Basic deployment

The [default playbook](playbooks/xsrv/playbook.yml) installs/manages a basic set of roles on a single server.

```bash
# authorize your SSH key on target server (host)
ssh-copy-id myusername@my.example.org

# create a base directory for your playbooks/environments
mkdir ~/playbooks/

# create a new playbook named 'default'
xsrv init-playbook
```

Setup roles and required configuration before initial deployment:

```bash
# enable desired roles by uncommenting them
xsrv edit-playbook
# setup passwords and secret values (replace any values labeled CHANGEME)
xsrv edit-vault
# edit configuration variables (replace any values labeled CHANGEME)
xsrv edit-host
```

Deploy changes to the host:

```bash
xsrv deploy
```

```bash
TODO ASCIINEMA
```

### Changing configuration

At any point, to edit your configuration:
 - enable more roles with `xsrv edit-playbook`
 - show all available configuration variables, and their default value with `xsrv show-defaults`
 - edit configuration variables with `xsrv edit-host` (copy/paste any variable from defaults and change its value)
 - edit secret/encrypted configuration variables with `xsrv edit-vault`

All commands support and additional playbook/host name parameter if you have multiple playbook/hosts. See below for advanced ussage.

**After any changes to the playbook, inventory or configuration variables**, apply your changes:

```bash
xsrv deploy
```

### Command-line usage

Full list of commands:

```bash
USAGE: xsrv COMMAND [playbook] [host]
init-playbook   initialize a new playbook
init-host       add a new host to an existing playbook
deploy          deploy a playbook
check           simulate deployment, report what would be changed
edit-playbook   edit a playbook
edit-inventory  edit inventory file for a playbook
edit-host       edit a host vars file
edit-vault      edit a host vault file
shell           open an interactive shell on a host
logs            view system log on a host
help            show this message
fetch-backups   fetch backups from a host to the playbook backups directory
upgrade         ugrade xsrv script and roles to latest versions
show-hosts      list hosts in a playbook/inventory
show-defaults   show all variables and their default values (accepts a role as argument)

The following environment variables are supported:
TAGS               comma-separated list of ansible tags (eg. TAGS=common,monitoring xsrv deploy)
BRANCH             advanced (upgrade only): git branch to checkout/pull before upgrade
XSRV_TEMPLATES_DIR advanced: path to role/playbook templates (default /opt/xsrv)
SKIP_VENV          advanced: skip creation of virtualenv/dependencies installation (yes/no, default no)
EDITOR             text editor to use (default nano)
PAGER              pager to use (default less)
```

Examples:

```bash
xsrv deploy default # deploy all hosts in the 'default' playbook
xsrv deploy # deploy all hosts in the default playbook (default is assumed when no playbook name is specified)
xsrv init-playbook infra # initialize a new playbook/environment named 'infra'
xsrv deploy infra # deploy all hosts in the playbook named 'infra'
xsrv init-host infra ex2.example.org # add a new host 'ex2.example.org' to the playbook named 'infra'
xsrv edit-host infra ex2.example.org # edit host variables for the host 'ex2.example.org' in the playbook 'infra'
xsrv edit-vault infra ex2.example.org # edit secret/vaulted variables for 'ex2.example.org' in the playbook 'infra'
xsrv deploy infra ex1.example.org,ex2.example.org # deploy only the hosts ex1.example.org and ex2.example.org in the playbook 'infra'
TAGS=nextcloud,gitea deploy infra ex3.example.org # run tasks tagged nextcloud or gitea on ex3.example.org
BRANCH=1.0.0 xsrv upgrade infra # upgrade roles in the playbook 'infra' to version 1.0.0
```


## Maintenance

- Self-hosting places your services and data under your own responsibility (availability, integrity, confidentiality...).
- Always have a plan in place if your server crashes, gets compromised or damaged.
- There is no High Availability mechanism configured by default.


### Backups

Always keep 3 copies of valuable data (the working data, a local backup - preferably on another drive, and an off-site backup).

The [backup](roles/backup) role performs automatic daily/weekly/monthly backups of your data, to a local directory `/var/backups/rsnapshot` on the server.

To download a copy of latest daily backups from a host, to the `backups/` directory on the controller, run:

```bash
# for a single default playbook with a single host
xsrv fetch-backups
# for playbooks with multiple hosts
xsrv fetch-backups myplaybook my.example.org
```

See each [role](#roles)'s documentation for information on how to restore backups.

Keep **off-line, off-site backups** of your `~/playbooks/` directory and user data.


### Upgrades

Security upgrades for Debian packages are applied [automatically/daily](roles/common). To upgrade roles to their latest versions (bugfixes, new features, latest stable releases of all unpackaged applications):

- Read the [release notes](https://gitlab.com/nodiscc/xsrv/-/blob/master/CHANGELOG.md) and/or subscribe to the [releases RSS feed](https://gitlab.com/nodiscc/xsrv/-/tags?format=atom)
- Download latest backups from the server (`xsrv backup-fetch`) and/or do a snapshot of the VM
- Upgrade roles in your playbook `xsrv upgrade` (use `BRANCH=<VERSION> xsrv upgrade` to upgrade to a specific release)
- (Optional) run checks and watch out for unwanted changes `xsrv check`
- Apply the playbook `xsrv deploy`


### Storing sensitive configuration values

Ensure no sensitive config values/secrets are stored as plaintext! Encrypt secret variables with ansible-vault:

```yaml
# xsrv edit-host
xyz_password: {{ vault_xyz_password }}

# xsrv edit-vault
vault_xyz_password: "$3CR3T"

```

## Advanced usage

### Versioning your playbook

Put your playbook directory (eg. `~/playbooks/default`) under version control/[git](https://stdout.root.sx/?searchtags=git+doc) if you need to track changes to your configuration.

**Reverting changes:**

- (optional) restore a VM snapshot from before the change (will cause loss of all data modified after the snapshot!), OR restore data from last known good backups (see each role's documentation for restoration instructions)
- `git checkout` your playbook directory as it was before the change
- run the playbook `xsrv deploy`

Refer to **[ansible documentation](https://docs.ansible.com/)** for more information.

**Uninstalling roles:**

Uninstalling roles is not supported at this time: components must be removed manually or using a ad-hoc playbook. Or a new server must be deployed and data restored from backups. Most roles provide variables to disable their services/functionality.


### Continuous Delivery

For production systems, it is strongly recommended to run the playbook and evaluate changes against a testing/staging environment first (eg. create separate `testing`,`prod` groups in `inventory.yml`, deploy changes to the `testing` environmnent with `xsrv deploy PLAYBOOK_NAME testing`). 

You can further automate deployment procedures using a CI/CD pipeline. See the example [`.gitlab-ci.yml`](playbooks/xsrv/.gitlab-ci.yml) to get started.


### Using as ansible collection


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

- hosts: my.example.org
  roles:
   - nodiscc.xsrv.common
   - nodiscc.xsrv.monitoring
   - nodiscc.xsrv.apache
   - ...
```

Tp upgrade the ollection to the latest [release](https://gitlab.com/nodiscc/xsrv/-/blob/master/CHANGELOG.md):

```bash
ansible-galaxy collection install git+https://gitlab.com/nodiscc/xsrv,release
```

See [Using collections](https://docs.ansible.com/ansible/latest/user_guide/collections_using.html)


## Contributing/Issues/Work in progress

- Check the [Planned features/work in progress](docs/TODO.md) [[1](https://git.lambdacore.network/xsrv/xsrv/issues)]
- Please report any problem on the [Gitlab issue tracker](https://gitlab.com/nodiscc/xsrv/issues) - include the following information:
  - expected results, steps to reproduce the problem, observed results
  - relevant technical information (configuration, logs, versions...)
  - if reporting a security issue, please check the `This issue is confidential` checkbox
- Please send patches by [Merge request](https://gitlab.com/nodiscc/xsrv/-/merge_requests) or attached to your bug reports
  - patches must pass CI checks, include relevant documentation, and be split in a meaningful way1
- Please contribute to upstream projects and report issues on relevant bug trackers


## License

[GNU GPLv3](LICENSE)


## Changelog

[CHANGELOG.md](CHANGELOG.md)


## See also

- [awesome-selfhosted](https://github.com/awesome-selfhosted/awesome-selfhosted)
- https://stdout.root.sx/gitea/xsrv/xsrv (upstream)
- https://github.com/nodiscc/xsrv (mirror)
- https://gitlab.com/nodiscc/xsrv (mirror)