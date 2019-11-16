```
  ╻ ╻┏━┓┏━┓╻ ╻
░░╺╋╸┗━┓┣┳┛┃┏┛
  ╹ ╹┗━┛╹┗╸┗┛ 
```

Run your own network services, on a server you control. Self-hosted communication, collaboration systems, file storage, transfer, sharing and synchronization, web publishing, automation, development, multimedia, IT infrastructure, and more.

This [ansible](https://en.wikipedia.org/wiki/Ansible_(software)) playbook lets you quickly and reliably install and manage various network services and applications on a personal server, or more.

## Roles

The following components (_roles_) are available:

- [common](https://gitlab.com/nodiscc/ansible-xsrv-common) - base server components (SSH, automatic updates, users, hostname, networking, kernel, time/date...)
- [backup](https://gitlab.com/nodiscc/ansible-xsrv-backup) - incremental backup service (local and remote backups)
- [monitoring](https://gitlab.com/nodiscc/ansible-xsrv-monitoring) - lightweight server monitoring system (netdata and additional tools)
- [lamp](https://gitlab.com/nodiscc/ansible-xsrv-lamp) - Apache web server, PHP interpreter and MariaDB (MySQL) database server
- [nextcloud](https://gitlab.com/nodiscc/ansible-xsrv-lamp) - File hosting/sharing/synchronization/groupware/"private cloud" service.

<!-- TODO demo screencast -->

**Table of contents**

<!-- MarkdownTOC -->

- [Installation](#installation)
  - [Preparing the server](#preparing-the-server)
  - [Initial configuration/deployment](#initial-configurationdeployment)
- [Usage](#usage)
- [Configuration](#configuration)
- [Maintenance](#maintenance)
  - [Backups](#backups)
  - [Updates](#updates)
  - [Other maintenance](#other-maintenance)
- [License](#license)

<!-- /MarkdownTOC -->

------------


## Installation

You will need a server (_host_), and a remote _controller_ machine from where you will deploy/administrate the server.


### Preparing the server

* [Hardware requirements](doc/hardware.md)
* [Network setup](doc/network.md)
* [Operating system setup](doc/operating-system.md)


### Initial configuration/deployment

```bash
# Clone the playbook
git clone -b 1.0 https://gitlab.com/nodiscc/xsrv

# Enter the playbook directory. All ansible commands must be run from this directory
cd xsrv

# Install ansible
./xsrv install-ansible

# initialize the playbook and set required confiuration variables
./xsrv init

# If needed, change the list of enabled roles and/or host configuration variables
./xsrv config-playbook
./xsrv config-host-vars

# Run host deployment
ansible-playbook playbook.yml
```

After the deployment completes, your services are ready to use.


## Usage

Read [roles](#roles) documentation for tips on how to use your services.


## Configuration

- **Add more roles:** to add more roles to your server, uncomment them in `inventory.yml`: `./xsrv config-playbook`
- **Configuration:** The default configuration will work out of the box.
  - To show defaults for all configuration variables, review each role](#roles)'s `default/main.yml`: `./xsrv show-defaults`
  - To review/change configuration details for your host, edit the host's configuration variables in `host_vars/`: `./xsrv config-host-vars`
  - To override any of the default variables, copy them from role defaults to your host's variables and edit them there.

**After any changes to configuration/roles**, apply changes to the host: `./xsrv deploy`


## Maintenance

Self-hosting places your services and data under your own responsibility (uptime, backups, security...). Always have a plan in place if your server crashes, gets compromised or damaged. There is no High Availability mechanism configured by default.


### Backups

Backups can be configured in the `##### BACKUPS #####` section of your host configuration variables.

To download a copy of the latest backups from the host, to the controller (`backups/` under the playbook directory), run:

```bash
./xsrv backup-fetch
```

### Updates

Security upgrades for Debian packages are applied [automatically/daily](https://gitlab.com/nodiscc/ansible-xsrv-common). To upgrade roles to their latest versions (bugfixes, new features, up-to-date versions of all third-party/web applications...):

- Download latest backups from the server and/or do a snapshot of the VM.
- Read the [release notes](CHANGELOG.md). Update configuration variables if needed.
- Update the playbook to the latest release: `git remote update && git checkout $latest_release`
- Update roles: `ansible-galaxy -f -r requirements.yml`
- Run the playbook:  `ansible-playbook playbook.yml`


### Other maintenance

**Tracking configuration in git:** By default your specific playbook/inventory/host_vars configuration is excluded from git to prevent accidentally pushing you configuration details to a public git repot. See [.gitignore](.gitignore) and disable relevant sections to start tracking your configuration in git.

**Uninstalling roles** is not supported at this time: components must be removed manually, or a new server must be deployed and data restored from backups.

**Testing/reverting updates:**

- Restore previous configuration variables
- Roll back roles to their previous versions (`git checkout $previous_version && ansible-galaxy -f -r requirements.yml`).
- Run the playbook:  `ansible-playbook playbook.yml`
- Restore data from the last known good backups.
- For professional/production systems, running the playbook and evaluating changes against a testing environment first is recommended.


## License

[GNU GPLv3](LICENSE)
