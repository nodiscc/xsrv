```
  ╻ ╻┏━┓┏━┓╻ ╻
░░╺╋╸┗━┓┣┳┛┃┏┛
  ╹ ╹┗━┛╹┗╸┗┛ 
```

Run your own network services, on a server you control. Self-hosted communication, collaboration systems, file storage, transfer, sharing and synchronization, automation, development, multimedia, IT infrastructure, and more.

This ansible playbook lets you quickly and reliably install and manage various network services and applications on a personal server, or more.

## Roles

The following components (_roles_) are available:

- [common](https://gitlab.com/nodiscc/ansible-xsrv-common) - base server components (SSH, automatic updates, users, hostname, networking, kernel, time/date...)

<!-- TODO demo video -->


------------

<!-- MarkdownTOC -->

- [Installation](#installation)
  - [Preparing the server](#preparing-the-server)
  - [Preparing the ansible controller](#preparing-the-ansible-controller)
  - [Initial configuration/deployment](#initial-configurationdeployment)
- [Configuration](#configuration)
- [Maintenance](#maintenance)
  - [Backups](#backups)
  - [Updates](#updates)
  - [License](#license)

<!-- /MarkdownTOC -->


## Installation

You will need a server (_host_) to configure, and a remote _controller_ machine from where you will deploy/administrate the server.


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

After the deployment completes, your services are ready to use. Read each [role](#roles)'s documentation for tips on how to use your services.


## Configuration

- **Add more roles:** to add more [roles](#roles) to your server, uncomment them in [`inventory.yml`](inventory.yml).
- **Configuration:** The default configuration will work out of the box. If you need to change any details, put any configuration variable and its new value in your host configuration file (). To list available role variables and their defaults, read `defaults/main.yml` in each [role](#roles): `
find ./ -wholename "*defaults/main.yml" | xargs cat | less`

**After any changes to configuration/roles**, apply changes to the host:

```bash
source ~/ansible-venv/bin/activate # required if ansible is installed in a virtualenv
ansible-galaxy install -f -r requirements.yml
ansible-playbook playbook.yml
```

At this time, uninstalling roles is not supported - components must be removed manually, or a new server must be deployed and data restored from backups.

Read [getting started with ansible](doc/getting-started-with-ansible.md) for details on configuring and building ansible playbooks and roles.


## Maintenance

Self-hosting places your services and data under your own responsibility (uptime, backups, security...). Always have a plan in place if your server crashes, gets compromised or damaged. There is no High Availability mechanism configured by default.

### Backups

See the [backup role](https://gitlab.com/nodiscc/ansible-xsrv-backup#documentation)


### Updates

Security upgrades for Debian packages are applied automatically, daily. To upgrade software installed from other sources (web applications):

- Download latest backups from the server and/or do a snapshot of the VM.
- Read the [release notes](CHANGELOG.md). Update your configuration if needed.
- Update the playbook to the latest release: `git remote update && git checkout $version`
- Update roles: `ansible-galaxy -f -r requirements.yml`
- Run server deployment:  `ansible-playbook playbook.yml`


### License

[GNU GPLv3](LICENSE)
