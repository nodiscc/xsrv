```
  ╻ ╻┏━┓┏━┓╻ ╻
░░╺╋╸┗━┓┣┳┛┃┏┛
  ╹ ╹┗━┛╹┗╸┗┛ 
```

[![](https://gitlab.com/nodiscc/xsrv/badges/master/pipeline.svg)](https://gitlab.com/nodiscc/xsrv/commits/master)
[![CII Best Practices](https://bestpractices.coreinfrastructure.org/projects/3647/badge)](https://bestpractices.coreinfrastructure.org/projects/3647)

Install and manage self-hosted network services and applications on your own server(s):
 - collection of [ansible](https://en.wikipedia.org/wiki/Ansible_(software)) [roles](#roles) for various services/applications
 - premade default [playbook to setup a single server](#initial-deployment) for personal use or small/medium teams
 - simple [command-line tool](#usage) for easy installation, common maintenance and configuration changes


## Roles

- [common](roles/common) - base system components (SSH, upgrades, users, hostname, networking, kernel, time/date)
- [backup](roles/backup) - incremental backup service (local and remote backups)
- [monitoring](roles/monitoring) - monitoring, alerting and log agregation system (netdata, rsyslog, other tools	)
- [lamp](roles/lamp) - Apache web server, PHP interpreter and MariaDB (MySQL) database server
- [nextcloud](roles/nextcloud) - File hosting/sharing/synchronization/groupware/"private cloud" service
- [tt-rss](roles/tt-rss) - Tiny Tiny RSS web feed reader
- [gitea](roles/gitea) - Lightweight self-hosted Git service/software forge
- _WIP_ [docker](roles/docker) - Docker container platform
- _WIP_ [gitlab](roles/gitlab) - Self-hosted software forge, project management, CI/CD tool suite
- _WIP_ [graylog](roles/graylog) - Log management and analysis software
- _WIP_ [icecast](roles/icecast) - Streaming media server
- _WIP_ [mumble-server](roles/mumble) - Low-latency voice-over-IP (VoIP) server
- _WIP_ [pulseaudio](roles/pulseaudio) - Network sound server
- _WIP_ [openldap](roles/openldap) - LDAP directory service and management tools
- _WIP_ [samba](roles/samba) - Cross-platform file and printer sharing service (SMB/CIFS)
- _WIP_ [shaarli](roles/shaarli) - personal, minimalist, super-fast bookmarking service
- _WIP_ [transmission](roles/transmission) - Bittorrent client/web interface/seedbox service
- _WIP_ [rocketchat](roles/rocketchat) - Realtime web chat/communication service

<!-- TODO demo screencast -->

[![](https://i.imgur.com/E74kJx5.png)](roles/lamp/)
[![](https://screenshots.debian.net/screenshots/000/015/229/thumb.png)](roles/monitoring)
[![](https://i.imgur.com/PPVIb6V.png)](roles/nextcloud)
[![](https://i.imgur.com/UoKs3x1.png)](roles/tt-rss)
[![](https://i.imgur.com/Rks90zV.png)](roles/gitea)

------------

**Table of contents**

<!-- MarkdownTOC -->

- [Requirements](#requirements)
  - [Prepare the server](#prepare-the-server)
  - [Prepare the controller](#prepare-the-controller)
- [Usage](#usage)
  - [Initial deployment](#initial-deployment)
- [Changing configuration](#changing-configuration)
- [Maintenance](#maintenance)
  - [Backups](#backups)
  - [Upgrades](#upgrades)
  - [Uninstalling roles](#uninstalling-roles)
  - [Reverting changes](#reverting-changes)
  - [Use as ansible collection in your playbooks](#use-as-ansible-collection-in-your-playbooks)
- [Contributing/Issues/Work in progress](#contributingissueswork-in-progress)
- [License](#license)
- [Changelog](#changelog)
- [See also](#see-also)

<!-- /MarkdownTOC -->

------------

## Requirements

- One or more target Linux servers (_hosts_).
- A remote administration machine (_controller_)

### Prepare the server

See [server preparation](docs/server-preparation.md)

### Prepare the controller

The controller machine can be any workstation, dedicated server, container... where an operating system, python, git and ([ansible](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html)) are available.

```bash
# install requirements (example for debian-based systems)
sudo apt update && sudo apt install git bash python3-pip openssl

# clone the repository
sudo git clone -b release https://gitlab.com/nodiscc/xsrv /opt/xsrv # latest release
sudo git clone -b 1.0 https://gitlab.com/nodiscc/xsrv /opt/xsrv # OR specific release
sudo git clone -b master https://gitlab.com/nodiscc/xsrv /opt/xsrv # OR development version
```

A command line tool `xsrv` is provided to help performing common tasks (basic wrapper around ansible, virtualenv, rsync and SSH commands, roles upgrade machanism).

``` bash
# (optional) install the command line tool to your $PATH
sudo cp /opt/xsrv/xsrv /usr/local/bin/
```

You can also use roles directly in existing/custom ansible playbooks and use `ansible-*` [command-line tools](https://docs.ansible.com/ansible/latest/user_guide/command_line_tools.html) directly. In that case add `/opt/xsrv/roles` to your ansible [roles path](https://docs.ansible.com/ansible/latest/reference_appendices/config.html).


## Usage

```
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
help            show this message
fetch-backups   fetch backups from a host to the playbook backups dir
upgrade         ugrade xsrv script and roles to latest versions
show-defaults   show all available role variables and their default values

The following environment variables are supported
TAGS=tag1,tag2  limit deployment to a set of ansible tags (eg. TAGS=monitoring xsrv deploy)
```

### Initial deployment

The default `xsrv` playbook installs/manages a basic set of roles on a single personal server:

```bash

# create a base directory for your playbooks/environments
mkdir ~/playbooks/
# put this directory under version control/git if needed. make sure no sensitive
# config values/secrets are commited as plaintext! see ansible-vault below

# create a new playbook
xsrv init-playbook
```

```bash
TODO ASCIINEMA
```
You can use the default playbook as-is, or [edit roles and configuration](#changing-configuration) before initial deployment. When the configuration suits you, deploy changes to the host:

```bash
xsrv deploy
```

Once complete, your services are ready to use. A summary will be displayed:

```
TODO
```


## Changing configuration

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

To list all available variables for all roles, see [Roles](#roles) or run  `cat /opt/xsrv/roles/*/defaults/main.yml`.
Copy any variable to your `host_vars` file and edit its value there, to override the default value.

**After any changes to the playbook, inventory or configuration variables**, re-apply the playbook:

```bash
cd ~/playbooks/xsrv && ~/.local/bin/ansible-playbook playbook.yml
```


## Maintenance

Self-hosting places your services and data under your own responsibility (availability, integrity, confidentiality...). Always have a plan in place if your server crashes, gets compromised or damaged. There is no High Availability mechanism configured by default.



### Backups


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

For production systems, it is strongly recommended to run the playbook and evaluate changes against a testing/staging environment first.
Using git to manage your playbooks directory makes this significanlty easier/flexible.
Ensure all sensitive variables are vaulted (`xyz_password: {{ vault_xyz_password }}` in plaintext host vars file, `vault_xyz_password: $3CR3T` in ansible-vault).
Setup **Continuous Deployment** and monitoring to automate delivery and testing. See the example [`.gitlab-ci.yml`](playbooks/xsrv/.gitlab-ci.yml) to get started.


### Uninstalling roles

Uninstalling roles is not supported at this time: components must be removed manually, or a new server must be deployed and data restored from backups. Most roles provide variables to disable their services/functionality.


### Reverting changes

 - restore a VM snapshot from before the change (will cause loss of all data modified after the snapshot!)
 - or, restore data from the last known good backups (see each role's documentation for restoration instructions)
 - `git checkout` the configuration as it was before the change
 - run the playbook `xsrv deploy`

Refer to **[ansible documentation](https://docs.ansible.com/)** for more information.

<!-- 
### Use as ansible collection in your playbooks

TODO

-->

## Contributing/Issues/Work in progress

- [Planned features/work in progress](docs/TODO.md)
- [Issue tracker](https://stdout.root.sx/gitea/xsrv/xsrv/issues)
- [Gitlab issue tracker](https://gitlab.com/nodiscc/xsrv/issues)

Branches/merge requests status:

![](https://gitlab.com/nodiscc/xsrv/badges/ansible-collection/pipeline.svg?key_width=100&key_text=ansible-collection)
![](https://gitlab.com/nodiscc/xsrv/badges/master/pipeline.svg?key_width=100&key_text=master)
![](https://gitlab.com/nodiscc/xsrv/badges/ansible-vault/pipeline.svg?key_width=100&key_text=ansible-vault)
![](https://gitlab.com/nodiscc/xsrv/badges/docker/pipeline.svg?key_width=100&key_text=docker)
![](https://gitlab.com/nodiscc/xsrv/badges/gitlab/pipeline.svg?key_width=100&key_text=gitlab)
![](https://gitlab.com/nodiscc/xsrv/badges/gitlab-runner/pipeline.svg?key_width=100&key_text=gitlab-runner)
![](https://gitlab.com/nodiscc/xsrv/badges/graylog/pipeline.svg?key_width=100&key_text=graylog)
![](https://gitlab.com/nodiscc/xsrv/badges/icecast/pipeline.svg?key_width=100&key_text=icecast)
![](https://gitlab.com/nodiscc/xsrv/badges/make-release/pipeline.svg?key_width=100&key_text=make-release)
![](https://gitlab.com/nodiscc/xsrv/badges/mumble-server/pipeline.svg?key_width=100&key_text=mumble-server)
![](https://gitlab.com/nodiscc/xsrv/badges/pulseaudio/pipeline.svg?key_width=100&key_text=pulseaudio)
![](https://gitlab.com/nodiscc/xsrv/badges/rsyslog-auditd/pipeline.svg?key_width=100&key_text=rsyslog-auditd)
![](https://gitlab.com/nodiscc/xsrv/badges/shaarli/pipeline.svg?key_width=100&key_text=shaarli)
![](https://gitlab.com/nodiscc/xsrv/badges/transmission/pipeline.svg?key_width=100&key_text=transmission)
![](https://gitlab.com/nodiscc/xsrv/badges/warn-before-upgrade/pipeline.svg?key_width=100&key_text=warn-before-upgrade)


## License

[GNU GPLv3](LICENSE)


## Changelog

[CHANGELOG.md](CHANGELOG.md)


## See also

- [awesome-selfhosted](https://github.com/awesome-selfhosted/awesome-selfhosted)
- https://stdout.root.sx/gitea/xsrv/xsrv (upstream)
- https://github.com/nodiscc/xsrv (mirror)
- https://gitlab.com/nodiscc/xsrv (mirror)