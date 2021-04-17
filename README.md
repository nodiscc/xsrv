```
  ╻ ╻┏━┓┏━┓╻ ╻
░░╺╋╸┗━┓┣┳┛┃┏┛
  ╹ ╹┗━┛╹┗╸┗┛ 
```

[![](https://gitlab.com/nodiscc/xsrv/badges/master/pipeline.svg)](https://gitlab.com/nodiscc/xsrv/-/pipelines)
[![](https://bestpractices.coreinfrastructure.org/projects/3647/badge)](https://bestpractices.coreinfrastructure.org/projects/3647)
[![](https://img.shields.io/badge/latest%20release-1.2.2-blue)](https://gitlab.com/nodiscc/xsrv/-/releases)


**Install and manage self-hosted services/applications, on your own server(s).**

`xsrv` provides:

- a comprehensive set of web applications/network services, system/infrastructure tools ([roles](#roles))
- a [command-line tool](https://xsrv.readthedocs.io/en/latest/usage.html) for easy configuration, deployment and maintenance
- a basic playbook to [setup a single server](https://xsrv.readthedocs.io/en/latest/installation/first-deployment.html) in a few minutes


## Roles

**System components/infrastucture/middleware**

- [common](roles/common) - common system components
- [backup](roles/backup) - incremental backup service
- [monitoring](roles/monitoring) - monitoring, alerting and logging system
- [apache](roles/apache) - web server and PHP interpreter
- [postgresql](roles/postgresql) or [mariadb](roles/mariadb) database server
- [openldap](roles/openldap) - LDAP directory server
- [docker](roles/docker) - Docker container platform

**End-user applications/services**

- [nextcloud](roles/nextcloud) - file hosting/sharing/synchronization/groupware/"private cloud" service
- [tt_rss](roles/tt_rss) - RSS feed reader
- [samba](roles/samba) - cross-platform file and printer sharing service (SMB/CIFS)
- [shaarli](roles/shaarli) - personal, minimalist, super-fast bookmarking service
- [gitea](roles/gitea) - lightweight self-hosted Git service/software forge
- [transmission](roles/transmission) - bittorrent peer-to-peer client web interface (seedbox) service
- [mumble](roles/mumble) - low-latency voice-over-IP (VoIP) server
- [rocketchat](roles/rocketchat) - realtime web chat/communication platform
- [jellyfin](roles/jellyfin) - media System that puts you in control of managing and streaming your media
- [homepage](roles/homepage) - simple homepage/dashhoard for your services


## Quick start

```bash
# clone the repository
git clone https://gitlab.com/nodiscc/xsrv

# (optional) install the program to your $PATH
sudo cp xsrv/xsrv /usr/local/bin/

# initialize the playbook, provide basic settings and roles to enable
xsrv init-playbook

# deploy your first server
xsrv deploy
```

[![](https://asciinema.org/a/kGt6mVg3GxFlDPXwagiwg4Laq.svg)](https://asciinema.org/a/kGt6mVg3GxFlDPXwagiwg4Laq)

`xsrv` is a wrapper around the [ansible](https://en.wikipedia.org/wiki/Ansible_%28software%29) suite of tools. Use the [`xsrv`](https://xsrv.readthedocs.io/en/latest/usage.html#command-line-usage) command-line tool to manage your servers, or include any of the roles in your own ansible playbooks. See [Using as ansible collection](https://xsrv.readthedocs.io/en/latest/usage.html#using-as-ansible-collection).


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
[![](https://i.imgur.com/KDJZuFO.png)](roles/homepage)
[![](https://i.imgur.com/Fg8uRjL.png)](roles/jellyfin)

## Source code

- [Gitlab](https://gitlab.com/nodiscc/xsrv)
- [Github](https://github.com/nodiscc/xsrv)


## License

This project and the components it manages are [Free and Open-Source Software](https://en.wikipedia.org/wiki/Free_software)

Ansible components are licensed under the [GNU GPLv3](https://gitlab.com/nodiscc/xsrv/-/blob/master/LICENSE) unless noted otherwise.

The project's documentation is under the [Creative Commons Attribution-ShareAlike 4.0](https://creativecommons.org/licenses/by-sa/4.0/) license.


## Documentation

- **[Documentation](https://xsrv.readthedocs.io)**
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
