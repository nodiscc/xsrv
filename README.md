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

Check each role's documentation for info on how to use the installed service.

<!-- TODO demo screencast -->

**Table of contents**

<!-- MarkdownTOC -->

- [Installation](#installation)
  - [Preparing the server](#preparing-the-server)
  - [Initial configuration/deployment](#initial-configurationdeployment)
- [Configuration](#configuration)
- [Usage and maintenance](#usage-and-maintenance)
  - [Backups](#backups)
  - [Updates](#updates)
  - [Other](#other)
- [License](#license)
- [Mirrors](#mirrors)

<!-- /MarkdownTOC -->

------------


## Installation

You will need a server (_host_) to run your services, and a _controller_ machine to remotely deploy and administrate the server.


### Preparing the server

See **[Server preparation](server-preparation.md)**


### Initial configuration/deployment

From the _controller_:

```bash
# clone the playbook
git clone -b 1.0 https://gitlab.com/nodiscc/xsrv

# enter the playbook directory - all commands must be run from this directory
cd xsrv

# install ansible
./xsrv install-ansible
# set required configuration variables
./xsrv init

# If needed, enable/disable roles, edit configuration variables
./xsrv config-playbook
./xsrv config-host

# Run deployment/configuration
./xsrv deploy
```

After the deployment completes, your services are ready to use.



## Configuration

**Enabling more roles:**

```bash
# To add more roles to your server, uncomment them in inventory.yml
./xsrv config-playbook
```

**Host configuration:** The default configuration should work out of the box for a single server.

```bash
# To show or edit your host's configuration variables, edit host_vars/my.example.org.yml
./xsrv config-host

# By default, host variables only override some default values provided by roles.
# To show role defaults for all variables, review each role's default/main.yml
# Copy any setting from these defaults to your host variables file, and edit its value.
./xsrv help-defaults

```

**After any changes to configuration/roles**, apply changes: 

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

By default all valuable data from installed roles is backed up automatically to a local directory on the server (see the [backup](https://gitlab.com/nodiscc/ansible-xsrv-backup) role). To download a copy of the latest backups from the host, to the controller (`backups/` directory), run:

```bash
./xsrv backup-fetch
```

See each role's documentation for information on how to restore backups.


### Updates

Security upgrades for Debian packages are applied [automatically/daily](https://gitlab.com/nodiscc/ansible-xsrv-common). To upgrade roles to their latest versions (bugfixes, new features, up-to-date versions of all third-party/web applications...):

- Read the [release notes](https://gitlab.com/nodiscc/xsrv/-/releases), adjust your configuration variables if needed `./xsrv config-host`.
- Download latest backups from the server and/or do a snapshot of the VM.
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


## License

[GNU GPLv3](LICENSE)


## Mirrors

 - https://github.com/nodiscc/xsrv
 - https://gitlab.com/nodiscc/xsrv
 - https://stdout.root.sx/gitea/xsrv/xsrv