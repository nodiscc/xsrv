```
  ╻ ╻┏━┓┏━┓╻ ╻
░░╺╋╸┗━┓┣┳┛┃┏┛
  ╹ ╹┗━┛╹┗╸┗┛ 
```

Run your own network services, on a server you control.

This [ansible](https://en.wikipedia.org/wiki/Ansible_(software)) playbook lets you quickly and reliably install and manage various network services and applications on your own servers. A simple [command-line wrapper](#usage-and-maintenance) is provided for initial deployment and occasional maintenance tasks.

[![](https://gitlab.com/nodiscc/xsrv/badges/master/pipeline.svg)](https://gitlab.com/nodiscc/xsrv/commits/master)
[![CII Best Practices](https://bestpractices.coreinfrastructure.org/projects/3647/badge)](https://bestpractices.coreinfrastructure.org/projects/3647)

## Roles

The following components (_roles_) are available:

- [common](https://gitlab.com/nodiscc/ansible-xsrv-common) - base server components (SSH, automatic updates, users, hostname, networking, kernel, time/date, logging...)
- [backup](https://gitlab.com/nodiscc/ansible-xsrv-backup) - incremental backup service (local and remote backups)
- [monitoring](https://gitlab.com/nodiscc/ansible-xsrv-monitoring) - lightweight server monitoring system (netdata and additional tools)
- [lamp](https://gitlab.com/nodiscc/ansible-xsrv-lamp) - Apache web server, PHP interpreter and MariaDB (MySQL) database server
- [nextcloud](https://gitlab.com/nodiscc/ansible-xsrv-nextcloud) - File hosting/sharing/synchronization/groupware/"private cloud" service.
- [tt-rss](https://gitlab.com/nodiscc/ansible-xsrv-tt-rss) - Tiny Tiny RSS web feed reader
- [gitea](https://gitlab.com/nodiscc/ansible-xsrv-gitea) - Gitea self-hosted Git service/software forge

<!-- TODO demo screencast -->

[![](https://i.imgur.com/E74kJx5.png)](https://gitlab.com/nodiscc/ansible-xsrv-lamp)
[![](https://screenshots.debian.net/screenshots/000/015/229/thumb.png)](https://gitlab.com/nodiscc/ansible-xsrv-monitoring)
[![](https://i.imgur.com/PPVIb6V.png)](https://gitlab.com/nodiscc/ansible-xsrv-nextcloud)
[![](https://i.imgur.com/UoKs3x1.png)](https://gitlab.com/nodiscc/ansible-xsrv-tt-rss)
[![](https://i.imgur.com/Rks90zV.png)](https://gitlab.com/nodiscc/ansible-xsrv-gitea)



**Table of contents**

<!-- MarkdownTOC -->

- [Installation](#installation)
  - [Preparing the server](#preparing-the-server)
  - [Preparing the controller](#preparing-the-controller)
- [Configuration](#configuration)
- [Deployment](#deployment)
- [Usage and maintenance](#usage-and-maintenance)
  - [Backups](#backups)
  - [Upgrades](#upgrades)
  - [Other](#other)
- [Issues](#issues)
- [License](#license)
- [Changelog](#changelog)
- [Similar projects](#similar-projects)
- [Mirrors](#mirrors)

<!-- /MarkdownTOC -->

------------


## Installation

You will need a server (_host_) to run your services, and a _controller_ machine to remotely deploy and administrate the server.


### Preparing the server

See **[Server preparation](server-preparation.md)**


### Preparing the controller

From the _controller_:

```bash
# install requirements (example for debian-based systems)
sudo apt update && sudo apt install git bash python3-pip python3-venv

# clone the playbook
git clone -b stable https://gitlab.com/nodiscc/xsrv # stable version (releases)
git clone -b master https://gitlab.com/nodiscc/xsrv # OR development version

# enter the playbook directory - all commands must be run from this directory
cd xsrv

# install ansible
./xsrv install-ansible
# set required configuration variables
./xsrv init
```


## Configuration

**Enabling/disabling roles:** Activate only required roles by uncommenting them in the playbook

```bash
./xsrv config-playbook
```

**Host variables:** The default configuration should work out of the box for a single server. To change passwords and/or advanced configuration details, edit the _host variables_ file:

```bash
./xsrv config-host
```

**Show default configuration values:** Only a subset of configuration variables are present in the host variables file by default. To show all available variables, and their default values:

```bash
./xsrv help-defaults
```

Simply copy default variables that need to be changed, to your host configuration file, and edit them there.


## Deployment

After any changes to configuration files, changes must be applied by running

```bash
./xsrv deploy
```


## Usage and maintenance

The command-line utility `xsrv` provides easy access to common maintenance/diagnostic tasks:

```bash
$ ./xsrv help
USAGE: ./xsrv COMMAND
AVAILABLE COMMANDS:
install-ansible     install ansible in a virtualenv
init                initialize the playbook from example files
deploy              run deployment/configuration
config-host         edit host configuration
config-playbook     edit the list of roles (playbook)
config-inventory    edit the list of hosts (inventory)
check               simulate deployment/report items that would be changed
shell               open a SSH shell on the host
logs                view system logs on the host
netstat             view network connections on the host
disk-usage          analyse disk usage on the host
backup-force        force a backup on the host
backup-fetch        fetch latest daily backups from the host
web                 open the hosts main homepage in a web browser
upgrade             upgrade playbook and roles to latest stable versions (read the release notes)
upgrade-dev         upgrade playbook and roles to latest development versions
ansible-playbook    run a raw ansible-playbook command
help-defaults       show roles configuration defaults
help                show this message
```

### Backups

Self-hosting places your services and data under your own responsibility (uptime, backups, security...). Always have a plan in place if your server crashes, gets compromised or damaged. There is no High Availability mechanism configured by default.

By default all user data is backed up automatically to a local directory on the server (see the [backup](https://gitlab.com/nodiscc/ansible-xsrv-backup) role). To download a copy of the latest backups from the host, to the controller (`backups/` directory), run:

```bash
./xsrv backup-fetch
```

You can then do an off-line, off-site backup of the `xsrv` directory.

See each role's documentation for information on how to restore backups.


### Upgrades

Security upgrades for Debian packages are applied [automatically/daily](https://gitlab.com/nodiscc/ansible-xsrv-common). To upgrade roles to their latest versions (bugfixes, new features, up-to-date versions of all third-party/web applications...):

- Read the [release notes](https://gitlab.com/nodiscc/xsrv/-/releases)
- Adjust your configuration variables if needed `./xsrv config-host`
- Download latest backups from the server (`./xsrv backup-fetch`) and/or do a snapshot of the VM
- Update the playbook to the latest release: `./xsrv upgrade`
- Run checks and watch out for unwanted changes `./xsrv check`
- Deploy the playbook `./xsrv deploy`


### Other

**Tracking configuration in git:** The playbook, inventory and host configuration files are ignored by git to prevent accidentally pushing sensitive configuration details to a public git repository. Edit [.gitignore](.gitignore) to start tracking your configuration in a private git repository. It is recommended to [encrypt your secrets](secrets/README.md) before storing them in git.

**Uninstalling roles** is not supported at this time: components must be removed manually, or a new server must be deployed and data restored from backups.

**Testing/reverting updates:** The easiest way is probably to restore a snapshot from just before the upgrade.

- Restore previous configuration variables
- Roll back roles to their previous versions (`git checkout $previous_version && ansible-galaxy -f -r requirements.yml`).
- Run the playbook:  `ansible-playbook playbook.yml`
- Restore data from the last known good backups (see each role's documentation for restore instructions)
- For professional/production systems, running the playbook and evaluating changes against a testing environment first is recommended.


## Issues

- https://gitlab.com/nodiscc/xsrv
- https://stdout.root.sx/gitea/xsrv/xsrv/issues or [TODO.md](TODO.md)

## License

[GNU GPLv3](LICENSE)


## Changelog

[CHANGELOG.md](CHANGELOG.md)

## Similar projects

- https://github.com/progmaticltd/homebox
- https://github.com/sovereign/sovereign

## Mirrors

 - https://github.com/nodiscc/xsrv
 - https://gitlab.com/nodiscc/xsrv
 - https://stdout.root.sx/gitea/xsrv/xsrv