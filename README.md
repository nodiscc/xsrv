```
  ╻ ╻┏━┓┏━┓╻ ╻
░░╺╋╸┗━┓┣┳┛┃┏┛
  ╹ ╹┗━┛╹┗╸┗┛ 
```


[![](https://gitlab.com/nodiscc/xsrv/badges/master/pipeline.svg)](https://gitlab.com/nodiscc/xsrv/commits/master)
[![CII Best Practices](https://bestpractices.coreinfrastructure.org/projects/3647/badge)](https://bestpractices.coreinfrastructure.org/projects/3647)

**STATUS: rewrite in progress - Expect a stable release soon - The current version is partially broken and will require frequent adaptations to configuration files.**

Install and manage self-hosted network services and applications on your own server(s):
- a collection of [ansible](https://en.wikipedia.org/wiki/Ansible_(software)) [roles](#roles) for various services/applications
- a premade default [playbook to setup a single server](#basic-deployment) for personal use or small/medium teams
- an optional [command-line tool](#usage) for easy deployment, common maintenance and configuration changes


## Roles

- [common](roles/common) - base system components (SSH, upgrades, users, hostname, networking, kernel, time/date)
- [backup](roles/backup) - incremental backup service (local and remote backups)
- [monitoring](roles/monitoring) - monitoring, alerting and log agregation system (netdata, rsyslog, other tools	)
- [apache](roles/apache) - Apache web server and PHP interpreter module
- [postgresql](roles/postgresql) - PostgreSQL database server
- [mariadb](roles/mariadb) - MariaDB (MySQL) database server
- [nextcloud](roles/nextcloud) - File hosting/sharing/synchronization/groupware/"private cloud" service
- [tt_rss](roles/tt_rss) - Tiny Tiny RSS web feed reader
- [samba](roles/samba) - Cross-platform file and printer sharing service (SMB/CIFS)
- [shaarli](roles/shaarli) - personal, minimalist, super-fast bookmarking service
- [gitea](roles/gitea) - Lightweight self-hosted Git service/software forge
- [transmission](roles/transmission) - Bittorrent client/web interface/seedbox service
- [mumble](roles/mumble) - Low-latency voice-over-IP (VoIP) server
- _WIP_ [docker](roles/docker) - Docker container platform
- _WIP_ [gitlab](roles/gitlab) - Self-hosted software forge, project management, CI/CD tool suite
- _WIP_ [graylog](roles/graylog) - Log management and analysis software
- _WIP_ [icecast](roles/icecast) - Streaming media server
- _WIP_ [pulseaudio](roles/pulseaudio) - Network sound server
- _WIP_ [openldap](roles/openldap) - LDAP directory service and management tools
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

This tool requires:
 - one or more target servers (_hosts_): see [server preparation](docs/server-preparation.md)
 - a remote administration machine (_controller_) from which playbooks will be run against your _hosts_. See [ansible controller preparation](docs/ansible-controller-preparation.md)


## Usage

### Basic deployment

The [default playbook](playbooks/xsrv/playbook.yml) installs/manages a basic set of roles on a single server.

```bash
# create a base directory for your playbooks/environments
mkdir ~/playbooks/

# create a new playbook
xsrv init-playbook
```

[Edit roles and configuration](#changing-configuration) before initial deployment:

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

The default configuration should work out of the box. If you need to change the default config (before first deployment or at any later point):

```bash
# Edit the list of hosts (inventory)
xsrv edit-inventory

# Edit the list of roles to apply to hosts (playbook)
xsrv edit-playbook

# Edit configuration variables for a host (host vars)
xsrv edit-host

# Edit secret (vaulted) configuration variables
xsrv edit-vault
```

To list all available variables for all roles, see [Roles](#roles) or run  `xsrv show-defaults`.
Copy any variable to your `host_vars` file and edit its value there, to override the default value.

**After any changes to the playbook, inventory or configuration variables**, re-apply the playbook:

```bash
xsrv deploy [playbook] [host]
```

## Command-line usage

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
fetch-backups   fetch backups from a host to the playbook backups dir
upgrade         ugrade xsrv script and roles to latest versions
show-defaults   show all available role variables and their default values

The following environment variables are supported
TAGS=tag1,tag2  limit deploy/check to a list of ansible tags (eg. TAGS=common,monitoring xsrv deploy)
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
```


## Maintenance

- Self-hosting places your services and data under your own responsibility (availability, integrity, confidentiality...).
- Always have a plan in place if your server crashes, gets compromised or damaged.
- Respond to alerts sent by the monitoring system.
- There is no High Availability mechanism configured by default.


### Backups

Always keep 3 copies of valuable data (the working data, a local backup - preferably on another drive, and an off-site backup).

The [backup](roles/backup) role performs automatic daily/weekly/monthly backups of your data, to a local directory `/var/backups/rsnapshot` on the server.

To download a copy of latest daily backups from a host, to the `backups/` directory on the controller, run:

```bash
xsrv backup-fetch
```

See each role's documentation for information on how to restore backups.

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


### Using as ansible collection in your playbooks

```bash
# install the collection
ansible-galaxy collection install nodiscc.xsrv

# add roles from the collection to your playbook
nano playbook.yml
```

```yaml
- hosts: all
  collections:
   - nodiscc.xsrv

- hosts: my.example.org
  roles:
   - common
   - monitoring
   - apache
   - ...
```

See [Using collections](https://docs.ansible.com/ansible/latest/user_guide/collections_using.html)


## Contributing/Issues/Work in progress

- [Planned features/work in progress](docs/TODO.md)
- [Issue tracker](https://stdout.root.sx/gitea/xsrv/xsrv/issues)
- [Gitlab issue tracker](https://gitlab.com/nodiscc/xsrv/issues)

Branches/merge requests status:

![](https://gitlab.com/nodiscc/xsrv/badges/master/pipeline.svg?key_width=100&key_text=master)
![](https://gitlab.com/nodiscc/xsrv/badges/gitlab/pipeline.svg?key_width=100&key_text=gitlab)
![](https://gitlab.com/nodiscc/xsrv/badges/gitlab-runner/pipeline.svg?key_width=100&key_text=gitlab-runner)
![](https://gitlab.com/nodiscc/xsrv/badges/graylog/pipeline.svg?key_width=100&key_text=graylog)
![](https://gitlab.com/nodiscc/xsrv/badges/icecast/pipeline.svg?key_width=100&key_text=icecast)
![](https://gitlab.com/nodiscc/xsrv/badges/pulseaudio/pipeline.svg?key_width=100&key_text=pulseaudio)
![](https://gitlab.com/nodiscc/xsrv/badges/rsyslog-auditd/pipeline.svg?key_width=100&key_text=rsyslog-auditd)
![](https://gitlab.com/nodiscc/xsrv/badges/warn-before-upgrade/pipeline.svg?key_width=100&key_text=warn-before-upgrade)
![](https://gitlab.com/nodiscc/xsrv/badges/docker/pipeline.svg?key_width=100&key_text=docker)


## License

[GNU GPLv3](LICENSE)


## Changelog

[CHANGELOG.md](CHANGELOG.md)


## See also

- [awesome-selfhosted](https://github.com/awesome-selfhosted/awesome-selfhosted)
- https://stdout.root.sx/gitea/xsrv/xsrv (upstream)
- https://github.com/nodiscc/xsrv (mirror)
- https://gitlab.com/nodiscc/xsrv (mirror)