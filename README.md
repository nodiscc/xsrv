# xsrv

```
  ╻ ╻┏━┓┏━┓╻ ╻
░░╺╋╸┗━┓┣┳┛┃┏┛
  ╹ ╹┗━┛╹┗╸┗┛ 
```

[![](https://gitlab.com/nodiscc/xsrv/badges/master/pipeline.svg)](https://gitlab.com/nodiscc/xsrv/-/pipelines)
[![](https://bestpractices.coreinfrastructure.org/projects/3647/badge)](https://bestpractices.coreinfrastructure.org/projects/3647)
[![](https://img.shields.io/badge/latest%20release-1.3.1-blue)](https://gitlab.com/nodiscc/xsrv/-/releases)
[![](https://img.shields.io/badge/docs-readthedocs-%232980B9)](https://xsrv.readthedocs.io)

**Install, manage and run self-hosted network services and applications on your own server(s)** (sharing, communication, collaboration systems, file storage, multimedia, office/organization, development, automation, IT infrastructure and more).

 `xsrv` provides:
- [roles](#roles) to install/configure various network services, web applications, system and infrastructure management tools
- a [command-line tool](https://xsrv.readthedocs.io/en/latest/usage.html) for common operations, easy/fast deployment, configuration and maintenance
- a template to [get started with a single server](https://xsrv.readthedocs.io/en/latest/installation/first-deployment.html) in a few minutes


## Roles

- [common](roles/common) - base system setup and hardening
- [backup](roles/backup) - incremental backup service
- [monitoring](roles/monitoring) - monitoring, alerting and logging system
- [apache](roles/apache) - web server and PHP interpreter
- [postgresql](roles/postgresql) or [mariadb](roles/mariadb) database server
- [openldap](roles/openldap) - LDAP directory server
- [docker](roles/docker) - Docker container platform
- [graylog](roles/graylog) - log management, capture and analysis platform
- [nextcloud](roles/nextcloud) - file hosting/sharing/synchronization/groupware/"private cloud" service
- [tt_rss](roles/tt_rss) - RSS feed reader
- [samba](roles/samba) - cross-platform file and printer sharing service (SMB/CIFS)
- [shaarli](roles/shaarli) - personal, minimalist, super-fast bookmarking service
- [gitea](roles/gitea) - lightweight self-hosted Git service/software forge
- [transmission](roles/transmission) - bittorrent peer-to-peer client web interface (seedbox) service
- [mumble](roles/mumble) - low-latency voice-over-IP (VoIP) server
- [rocketchat](roles/rocketchat) - realtime web chat/communication platform
- [jellyfin](roles/jellyfin) - media System that puts you in control of managing and streaming your media
- [homepage](roles/homepage) - simple homepage/dashboard for your services
- [gotty](roles/gotty) - access a server terminal as a web application
- [proxmox](roles/proxmox) - basic setup for Proxmox VE hypervisors


## Quick start

[Prepare the remote server](https://xsrv.readthedocs.io/en/latest/installation/server-preparation.html), then, on the controller:

```bash
# install requirements (example for debian-based systems)
sudo apt update && sudo apt install git bash python3-venv python3-pip ssh pwgen
# clone the repository
git clone https://gitlab.com/nodiscc/xsrv
# (optional) install the command line tool to your $PATH
sudo cp xsrv/xsrv /usr/local/bin/
# authorize your SSH key on the remote user account
ssh-copy-id deploy@my.CHANGEME.org
# initialize the playbook, provide basic settings and roles to enable
xsrv init-playbook
# deploy your first server
xsrv deploy
```

[![](https://asciinema.org/a/kGt6mVg3GxFlDPXwagiwg4Laq.svg)](https://asciinema.org/a/kGt6mVg3GxFlDPXwagiwg4Laq)


```bash
# change the configuration, add hosts or roles...
xsrv edit-inventory
xsrv edit-playbook
xsrv edit-host
xsrv edit-vault
```

See the full [usage documentation](https://xsrv.readthedocs.io/en/latest/usage.html).

`xsrv` uses [ansible](https://en.wikipedia.org/wiki/Ansible_%28software%29), a [configuration management](https://en.wikipedia.org/wiki/Software_configuration_management) system for reproducible and automated deployments, configuration and change management. You can use the provided command-line tool to manage your setup, or [include the roles in your own ansible playbooks](https://xsrv.readthedocs.io/en/latest/usage.html#using-as-ansible-collection).


## Screenshots

[![](https://i.imgur.com/v9BQYpN.png)](roles/monitoring)
[![](https://i.imgur.com/PPVIb6V.png)](roles/nextcloud)
[![](https://i.imgur.com/UoKs3x1.png)](roles/tt_rss)

[![](https://i.imgur.com/gsoh2Mj.png)](roles/shaarli)
[![](https://i.imgur.com/Rks90zV.png)](roles/gitea)
[![](https://i.imgur.com/7nJ6cMN.png)](roles/transmission)

[![](https://i.imgur.com/lHgDbDC.png)](roles/mumble)
[![](https://i.imgur.com/PRE7fvn.png)](roles/openldap)
[![](https://i.imgur.com/WUdwbAX.png)](roles/rocketchat)

[![](https://i.imgur.com/OWOH8LI.png)](roles/homepage)
[![](https://i.imgur.com/Fg8uRjL.png)](roles/jellyfin)
[![](https://i.imgur.com/eGCL45L.jpg)](roles/graylog)

## Source code

- [Gitlab](https://gitlab.com/nodiscc/xsrv)
- [Github](https://github.com/nodiscc/xsrv)


## License

- [GNU GPLv3](https://gitlab.com/nodiscc/xsrv/-/blob/master/LICENSE) unless noted otherwise in individual files/directories
- Documentation is under the [Creative Commons Attribution-ShareAlike 4.0](https://creativecommons.org/licenses/by-sa/4.0/) license


## Documentation

- [Installation](https://xsrv.readthedocs.io/en/latest/installation.html)
- [Server preparation](https://xsrv.readthedocs.io/en/latest/installation/server-preparation.html)
- [Controller preparation](https://xsrv.readthedocs.io/en/latest/installation/controller-preparation.html)
- [First deployment](https://xsrv.readthedocs.io/en/latest/installation/first-deployment.html)
- [Usage](https://xsrv.readthedocs.io/en/latest/usage.html)
- [List of all configuration variables](https://xsrv.readthedocs.io/en/latest/configuration-variables.html)
- [Maintenance](https://xsrv.readthedocs.io/en/latest/maintenance.html)
- [Advanced usage](https://xsrv.readthedocs.io/en/latest/advanced.html)
- [Contributing](https://xsrv.readthedocs.io/en/latest/contributing.html)
- [Changelog](https://gitlab.com/nodiscc/xsrv/-/blob/master/CHANGELOG.md)
