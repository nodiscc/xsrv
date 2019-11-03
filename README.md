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

<!-- TODO demo screencast -->

**Table of contents**

<!-- MarkdownTOC -->

- [Installation](#installation)
  - [Preparing the server](#preparing-the-server)
  - [Preparing the ansible controller](#preparing-the-ansible-controller)
  - [Initial configuration/deployment](#initial-configurationdeployment)
- [Usage](#usage)
- [Configuration](#configuration)
- [Maintenance](#maintenance)
  - [Backups](#backups)
  - [Updates](#updates)
  - [Testing/reverting updates](#testingreverting-updates)
- [License](#license)

<!-- /MarkdownTOC -->

------------


## Installation

You will need a server (_host_), and a remote _controller_ machine from where you will deploy/administrate the server.


### Preparing the server

* [Hardware requirements](doc/hardware.md)
* [Network setup](doc/network.md)
* [Operating system setup](operating-system.md)


### Preparing the ansible controller

The _controller_ machine will be used for remote administration and deployment. It can be any Linux/other machine where ansible and git can be installed (desktop/laptop/server/VM...). It must be able to resolve the server's hostname (using DNS, [hosts file](https://en.wikipedia.org/wiki/Hosts_(file))), and have IP and SSH access to the server (default port `tcp/22`).

- [Ansible installation](doc/ansible-install.md)


### Initial configuration/deployment

```bash
# Clone the playbook
git clone -b 1.0 https://gitlab.com/nodiscc/xsrv

# Enter the playbook directory. All ansible commands must be run from this directory
cd xsrv

# copy the example inventory file
cp examples/inventory.example.yml inventory.yml

# copy the example playbook file
cp examples/playbook.example.yml playbook.yml

# copy the example host configuration variables file
# the filename must match your actual server hostname (FQDN)
cp examples/my.example.org.yml host_vars/myserver.example.org.yml
```

- Edit `inventory.yml` and replace `my.example.org` with your actual server hostname (FQDN):
- Edit `playbook.yml`, replace `my.example.org` with your actual server FQDN, enable (uncomment) any roles you want to install
- Edit `host_vars/myserver.example.org`, and set the required variables (labeled `CHANGEME`)

```bash
# Download roles
ansible-galaxy install -f -r requirements.yml

# Deploy the playbook to the server
ansible-playbook playbook.yml
```

After the deployment completes, your services are ready to use.


## Usage

Read [roles](#roles) documentation for tips on how to use your services.


## Configuration

- **Add more roles:** to add more roles to your server, uncomment them in [`inventory.yml`](inventory.yml).
- **Configuration:** The default configuration will work out of the box. If you need to change any details, put any configuration variable and its new value in your host configuration file in `host_vars/`. To list available role variables and their defaults, read `defaults/main.yml` in each [role](#roles): `
find ./ -wholename "*defaults/main.yml" | xargs cat | less`

**After any changes to configuration/roles**, apply changes to the host:

```bash
source ~/ansible-venv/bin/activate # required if ansible is installed in a virtualenv
ansible-galaxy install -f -r requirements.yml
ansible-playbook playbook.yml
```

Read [getting started with ansible](doc/getting-started-with-ansible.md) for details on configuration and creation of playbooks and roles.

**Uninstalling roles** is not supported at this time: components must be removed manually, or a new server must be deployed and data restored from backups.

**Tracking configuration in git:** Default [.gitignore](.gitignore) patterns are here to ensure that you do not push your configuration, public keys and secrets to a public Git service. If you have a private git server, you can comment out ignore patterns in [.gitignore](.gitignore) to start tracking your configuration changes in git. Check that the git remote is *actually* set to your private git server. Secrets and sensitive information should still be stored encrypted in the repository, using [ansible-vault](doc/getting-started-with-ansible.md#ansible-vault) or another method.



## Maintenance

Self-hosting places your services and data under your own responsibility (uptime, backups, security...). Always have a plan in place if your server crashes, gets compromised or damaged. There is no High Availability mechanism configured by default.


### Backups

See the [backup role](https://gitlab.com/nodiscc/ansible-xsrv-backup#documentation)


### Updates

Security upgrades for Debian packages are applied [automatically/daily](https://gitlab.com/nodiscc/ansible-xsrv-common). To upgrade roles to their latest versions (bugfixes, new features, up-to-date versions of all third-party/web applications...):

- Download latest backups from the server and/or do a snapshot of the VM.
- Read the [release notes](CHANGELOG.md). Update configuration variables if needed.
- Update the playbook to the latest release: `git remote update && git checkout $latest_release`
- Update roles: `ansible-galaxy -f -r requirements.yml`
- Run the playbook:  `ansible-playbook playbook.yml`


### Testing/reverting updates

- Restore previous configuration variables (tracking inventory/playbook/host_vars in a private git repository make this easier). Roll back roles to their previous versions (`git checkout $previous_version && ansible-galaxy -f -r requirements.yml`).
- Run the playbook:  `ansible-playbook playbook.yml`
- Restore the previous snapshot of the VM and/or restore data from the backups

For professional/production systems, running the playbook and evaluating changes against a [testing environment](doc/getting-started-with-ansible.md#using-multiple-environments) first is recommended.


## License

[GNU GPLv3](LICENSE)
