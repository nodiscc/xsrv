```
  ╻ ╻┏━┓┏━┓╻ ╻
░░╺╋╸┗━┓┣┳┛┃┏┛
  ╹ ╹┗━┛╹┗╸┗┛ 
```


[![](https://gitlab.com/nodiscc/xsrv/badges/master/pipeline.svg)](https://gitlab.com/nodiscc/xsrv/-/pipelines)
[![CII Best Practices](https://bestpractices.coreinfrastructure.org/projects/3647/badge)](https://bestpractices.coreinfrastructure.org/projects/3647)

**STATUS: rewrite in progress - Expect a stable release soon - The current version is partially broken and will require frequent adaptations to configuration files.**

**Install and manage self-hosted network services/applications on your own server(s).**

`xsrv` provides:

- a [command-line wrapper](#command-line-usage) around [`ansible`](https://en.wikipedia.org/wiki/Ansible_(software)) for easy deployment, maintenance and configuration
- a collection of ansible [roles](#roles) for various services/applications
- a base [playbook to setup a single server](#basic-deployment) for personal use or small/medium teams


## Roles

- [common](roles/common) - base system components (SSH, upgrades, users, hostname, networking, kernel, time/date)
- [backup](roles/backup) - incremental backup service (local and remote backups)
- [monitoring](roles/monitoring) - monitoring, alerting and log agregation system (netdata, rsyslog, other tools	)
- [apache](roles/apache) - Apache web server and PHP-FPM interpreter
- [postgresql](roles/postgresql) - PostgreSQL database server
- [mariadb](roles/mariadb) - MariaDB (MySQL) database server
- [nextcloud](roles/nextcloud) - File hosting/sharing/synchronization/groupware/"private cloud" service
- [tt_rss](roles/tt_rss) - Tiny Tiny RSS web feed reader
- [samba](roles/samba) - Cross-platform file and printer sharing service (SMB/CIFS)
- [shaarli](roles/shaarli) - personal, minimalist, super-fast bookmarking service
- [gitea](roles/gitea) - Lightweight self-hosted Git service/software forge
- [transmission](roles/transmission) - Bittorrent client/web interface/seedbox service
- [mumble](roles/mumble) - Low-latency voice-over-IP (VoIP) server
- [openldap](roles/openldap) - LDAP directory server
- _WIP_ [docker](roles/docker) - Docker container platform
- _WIP_ [gitlab](roles/gitlab) - Self-hosted software forge, project management, CI/CD tool suite
- _WIP_ [graylog](roles/graylog) - Log management and analysis software
- _WIP_ [icecast](roles/icecast) - Streaming media server
- _WIP_ [pulseaudio](roles/pulseaudio) - Network sound server
- _WIP_ [rocketchat](roles/rocketchat) - Realtime web chat/communication service

<!-- TODO demo screencast -->

[![](https://screenshots.debian.net/screenshots/000/015/229/thumb.png)](roles/monitoring)
[![](https://i.imgur.com/PPVIb6V.png)](roles/nextcloud)
[![](https://i.imgur.com/UoKs3x1.png)](roles/tt_rss)
[![](https://i.imgur.com/8wEBRSG.png)](roles/shaarli)
[![](https://i.imgur.com/Rks90zV.png)](roles/gitea)
[![](https://i.imgur.com/blWO4LL.png)](roles/transmission)
[![](https://i.imgur.com/jYSU9zC.png)](roles/mumble)



------------

**Table of contents**

<!-- MarkdownTOC -->

- [Requirements](#requirements)
- [Installation](#installation)
- [Usage](#usage)
  - [Basic deployment](#basic-deployment)
  - [Changing configuration](#changing-configuration)
  - [Command-line usage](#command-line-usage)
- [Maintenance](#maintenance)
  - [Backups](#backups)
  - [Upgrades](#upgrades)
  - [Tracking configuration changes](#tracking-configuration-changes)
  - [Uninstalling roles](#uninstalling-roles)
  - [Reverting changes](#reverting-changes)
  - [Using as ansible collection in your playbooks](#using-as-ansible-collection-in-your-playbooks)
- [Contributing/Issues/Work in progress](#contributingissueswork-in-progress)
- [License](#license)
- [Changelog](#changelog)
- [See also](#see-also)

<!-- /MarkdownTOC -->

------------

## Requirements

One or more target servers (_hosts_) to configure. See [server preparation](docs/server-preparation.md).
 


## Installation

A _controller_ machine will be used for deployment and remote administration. The controller can be any laptop desktop PC, dedicated server, container... where python, bash and ansible are available. On the controller:


```bash
# install requirements (example for debian-based systems)
sudo apt update && sudo apt install git bash python3-pip openssl ssh

# authorize your SSH key on target servers (hosts)
ssh-copy-id myusername@my.example.org

# clone the repository
sudo git clone -b release https://gitlab.com/nodiscc/xsrv /opt/xsrv # latest release
sudo git clone -b 1.0 https://gitlab.com/nodiscc/xsrv /opt/xsrv # OR specific release
sudo git clone -b master https://gitlab.com/nodiscc/xsrv /opt/xsrv # OR development version

# (optional) install the command line tool to your $PATH
sudo cp /opt/xsrv/xsrv /usr/local/bin/
```

You can either:
- use the [`xsrv` script](#command-line-usage) to manage your ansible environments
- or use components through standard `ansible-*` [command-line tools](https://docs.ansible.com/ansible/latest/user_guide/command_line_tools.html). See [Using as ansible collection](#using-as-ansible-collection).


## Usage

### Basic deployment

The [default playbook](playbooks/xsrv/playbook.yml) installs/manages a basic set of roles on a single server.

```bash
# create a base directory for your playbooks/environments
mkdir ~/playbooks/

# create a new playbook
xsrv init-playbook
```

Setup roles and required configuration before initial deployment:

```bash
# enable desired roles by uncommenting them
xsrv edit-playbook
# setup passwords and secret values
xsrv edit-vault
# edit configuration variables
xsrv edit-host
# to list all available variables, run xsrv show-defaults
```

Deploy changes to the host:

```bash
xsrv deploy
```

```bash
TODO ASCIINEMA
```

### Changing configuration

At any point in the future, to edit your configuration:
 - enable more roles with `xsrv edit-playbook`
 - show all available configuration variables, and their default value with `xsrv show-defaults`
 - edit configuration variables with `xsrv edit-host` (copy/paste any variable from defaults and edit is value)
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
utils           run the xsrv-utils script on a host
info            display quick access links for a host
logs            view system log on a host
help            show this message
fetch-backups   fetch backups from a host to the playbook backups directory
upgrade         ugrade xsrv script and roles to latest versions
show-defaults   show all available role variables and their default values

The following environment variables are supported:
TAGS=tag1,tag2     limit deploy/check to a list of ansible tags (eg. TAGS=common,monitoring xsrv deploy)
BRANCH=feature-xyz advanced (upgrade only): checkout/pull a specific branch before upgrade
XSRV_TEMPLATES_DIR advanced: path to role/playbook templates (/opt/xsrv)
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

- Read the [release notes](https://gitlab.com/nodiscc/xsrv/-/releases)
- Download latest backups from the server (`xsrv backup-fetch`) and/or do a snapshot of the VM
- Download the latest release and overwrite roles in your playbooks directory: `./xsrv upgrade`
- Adjust your configuration if needed (inventory, playbook, host vars)
- Run checks and watch out for unwanted changes `xsrv check`
- Apply the playbook `csrv deploy`


### Tracking configuration changes

Put your playbooks directory under version control if you need to track changes to your configuration.
Make sure no sensitive config values/secrets are commited as plaintext! Put sensitives values in vaulted host vars files:

```yaml
# plaintext host_vars file
xyz_password: {{ vault_xyz_password }}

# vauilted host vars file
vault_xyz_password: "$3CR3T"

```

For production systems, it is strongly recommended to run the playbook and evaluate changes against a testing/staging environment first. Setup **Continuous Deployment** and monitoring to automate delivery and testing. See the example [`.gitlab-ci.yml`](playbooks/xsrv/.gitlab-ci.yml) to get started.


### Uninstalling roles

Uninstalling roles is not supported at this time: components must be removed manually, or a new server must be deployed and data restored from backups. Most roles provide variables to disable their services/functionality.


### Reverting changes

 - restore a VM snapshot from before the change (will cause loss of all data modified after the snapshot!)
 - or, restore data from the last known good backups (see each role's documentation for restoration instructions)
 - `git checkout` the configuration as it was before the change
 - run the playbook `xsrv deploy`

Refer to **[ansible documentation](https://docs.ansible.com/)** for more information.


### Using as ansible collection

If you just want to integrate the [roles](#roles) in your own playbooks, install them through [`ansible-galaxy`](https://docs.ansible.com/ansible/latest/cli/ansible-galaxy.html):

```bash
ansible-galaxy collection install nodiscc.xsrv
```

And include the in your playbooks:

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

See [Using collections](https://docs.ansible.com/ansible/latest/user_guide/collections_using.html)


## Contributing/Issues/Work in progress

- Check the [Planned features/work in progress](docs/TODO.md) document [[1](https://git.lambdacore.network/xsrv/xsrv/issues)]
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