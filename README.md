```
  ╻ ╻┏━┓┏━┓╻ ╻
░░╺╋╸┗━┓┣┳┛┃┏┛
  ╹ ╹┗━┛╹┗╸┗┛ 
```

Build and manage your private servers and infrastructure.

[![](https://gitlab.com/nodiscc/xsrv/badges/master/pipeline.svg)](https://gitlab.com/nodiscc/xsrv/commits/master)
[![CII Best Practices](https://bestpractices.coreinfrastructure.org/projects/3647/badge)](https://bestpractices.coreinfrastructure.org/projects/3647)

An [ansible](https://en.wikipedia.org/wiki/Ansible_(software)) collection and simple [command-line wrapper](#usage-and-maintenance) that let you easily and reliably manage your self-hosted servers, network services and applications. The following roles are available:

- [common](roles/common) - base server components (SSH, upgrades, users, hostname, networking, kernel, time/date)
- [backup](roles/backup) - incremental backup service (local and remote backups)
- [monitoring](roles/monitoring) - lightweight monitoring, alerting and log aggregation system (netdata, rsyslog, other tools	)
- [lamp](roles/lamp) - Apache web server, PHP interpreter and MariaDB (MySQL) database server
- [nextcloud](roles/nextcloud) - File hosting/sharing/synchronization/groupware/"private cloud" service
- [tt-rss](roles/tt-rss) - Tiny Tiny RSS web feed reader
- [gitea](roles/gitea) - Gitea self-hosted Git service/software forge

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
- [Deploy a single server](#deploy-a-single-server)
- [Usage](#usage)
- [Maintenance](#maintenance)
  - [Backups](#backups)
  - [Upgrades](#upgrades)
- [Managing multiple hosts/environments](#managing-multiple-hostsenvironments)
- [Contributing/Issues/Work in progress](#contributingissueswork-in-progress)
- [License](#license)
- [Changelog](#changelog)
- [Mirrors](#mirrors)

<!-- /MarkdownTOC -->

------------

## Requirements

xsrv/ansible runs from a _controller_ computer and configures your servers remotely through [SSH](https://en.wikipedia.org/wiki/Secure_Shell).

- One or more remote servers (_hosts_)
- A _controller_ machine to run xsrv


### Prepare the server

See [server preparation](docs/server-preparation.md)

### Prepare the controller

The controller can be any machine where git, bash, python and ansible are available (laptop/desktop PC, dedicated automation server/container...)

```bash
# install requirements (example for debian-based systems)
sudo apt update && sudo apt install git bash python3-pip python3-venv

# clone the repository
git clone -b release https://gitlab.com/nodiscc/xsrv # latest release
git clone -b 1.0 https://gitlab.com/nodiscc/xsrv # OR specific release
git clone -b master https://gitlab.com/nodiscc/xsrv # OR development version
```


## Deploy a single server

```bash
# enter the directory - all commands must be run from this directory
cd xsrv

# initialize an environment/playbook, create configuration files for the host
./xsrv init-host
# you will be asked for basic configuration settings, and a list of roles to enable
```

<!-- TODO asciinema -->

Edit additional configuration if needed:

- To **edit the list of enabled roles (playbook)**: `./xsrv edit-playbook`
- To **change host configuration variables** (_host vars_): `./xsrv edit-host my.example.org`
- To **change (secret) host configuration variables** (_vaulted_ host vars): `./xsrv edit-host my.example.org`
- To **list all available variables** in roles: `./xsrv help-defaults`. Copy any variable to your _host vars_ and change it there to override the default value.

Deploy changes to the server:

```bash
./xsrv deploy
```

If you need to later change host roles or configuration, repeat the previous steps at will (`./xsrv edit-playbook; ./xsrv edit-host my.example.org; ./xsrv deploy`). Only requested changes will be applied.


## Usage

The command-line utility `xsrv` provides quick access to common deployment, configuration, maintenance and diagnostic tasks:

```bash
USAGE: ./xsrv COMMAND
AVAILABLE COMMANDS:
init-env            install the ansible environment (virtualenv)
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
upgrade             upgrade the ansible collection to the latest version
ansible-playbook    run a raw ansible-playbook command
help-defaults       show roles configuration defaults
help                show this message
deploy my.exmp.org  deploy/configure a list of hosts (for multi-machine playbooks, comma-separated)
```

## Maintenance

Self-hosting places your services and data under your own responsibility (confidentiality, availability, integrity...). Always have a plan in place if your server crashes, gets compromised or damaged. There is no High Availability mechanism configured by default.


### Backups

Your configuration and secrets are stored in the `environments/default/` directory.

All user data is backed up daily/weekly/monthly to a local directory on the server (if the [backup](roles/backup) role is enabled). To download a copy of latest daily backups from a host, to the environment `backups/` directory), run:

```bash
./xsrv backup-fetch $hostname
```

See each role's documentation for information on how to restore backups.

Keep **off-line, off-site backups** of your environment/playbooks directory and user data.


### Upgrades

Security upgrades for Debian packages are applied [automatically/daily](roles/common). To upgrade roles to their latest versions (bugfixes, new features, up-to-date versions of all unpackaged applications...):

- Read the [release notes](https://gitlab.com/nodiscc/xsrv/-/releases)
- Download latest backups from the server (`./xsrv backup-fetch`) and/or do a snapshot of the VM
- Update the playbook to the latest release: `./xsrv upgrade`
- Adjust configuration if needed `./xsrv edit-playbook; ./xsrv edit-host; ./xsrv edit-vault`
- Run checks and watch out for unwanted changes `./xsrv check`
- Deploy the playbook `./xsrv deploy`


## Managing multiple hosts/environments 

To **add new hosts to your environment:**

- Run `./xsrv add-host $environment` (the default environment is named `default`).
- Edit hosts configuration and roles with `./xsrv edit-*` commands
- Deploy with `./xsrv check && ./xsrv deploy`. See [usage](#usage).

**Tracking configuration in git:** The default `environments/` directory containing your configuration is [ignored](environments/.gitignore) by git by default. Store the configuration in a separate directory and symlink it to  `environments/` - you can then tack this directory in git. Ensure sensitive values are vaulted (`./xsrv edit-vault`) before pacing them under version control.

For professional/production systems, run the playbook and evaluate changes against a **testing/staging environment** first. For example:

```bash
./xsrv add-env test
# ./xsrv add-env qa # add as many intermediate environments you want...
./xsrv add-env staging
./xsrv add-env production
./xsrv add-host test # add a new host test.example.org
./xsrv add-host staging # add a new host staging.example.org
./xsrv add-host production # add a new host prod.example.org
 ```

Setup **Continuous Deployment** and monitoring to automate delivery and testing. See the example [`.gitlab-ci.yml`](playbooks/example/.gitlab-ci.yml) to get started.

**Uninstalling roles** is not supported at this time: components must be removed manually, or a new server must be deployed and data restored from backups (most roles provide a way to disable their services/functionality though).

**Reverting changes:**
 - `git checkout` the configuration as it was before the change
 - run the playbook `./xsrv deploy`
 - restore data from the last known good backups (see each role's documentation for restoration instructions)
 - or restore a VM snapshot from before the change

Refer to **[ansible documentation](https://docs.ansible.com/)** for more information.


## Contributing/Issues/Work in progress

- [Planned features/work in progress](TODO.md)
- [Gitlab issue tracker](https://gitlab.com/nodiscc/xsrv/issues)
- See also [awesome-selfhosted](https://github.com/awesome-selfhosted/awesome-selfhosted)

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


## Mirrors

 - https://stdout.root.sx/gitea/xsrv/xsrv (upstream)
 - https://github.com/nodiscc/xsrv
 - https://gitlab.com/nodiscc/xsrv