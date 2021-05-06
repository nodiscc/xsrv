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
- a [command-line tool](usage.md) based on [ansible](https://en.wikipedia.org/wiki/Ansible_%28software%29) for easy/fast deployment, configuration and maintenance
- a basic playbook to [setup a single server](installation/first-deployment.md) in a few minutes


## Roles

**System components/infrastucture/middleware**

- [common](https://gitlab.com/nodiscc/xsrv/-/tree/master/roles/common) - common system components
- [backup](https://gitlab.com/nodiscc/xsrv/-/tree/master/roles/backup) - incremental backup service
- [monitoring](https://gitlab.com/nodiscc/xsrv/-/tree/master/roles/monitoring) - monitoring, alerting and logging system
- [apache](https://gitlab.com/nodiscc/xsrv/-/tree/master/roles/apache) - web server and PHP interpreter
- [postgresql](https://gitlab.com/nodiscc/xsrv/-/tree/master/roles/postgresql) or [mariadb](https://gitlab.com/nodiscc/xsrv/-/tree/master/roles/mariadb) database server
- [openldap](https://gitlab.com/nodiscc/xsrv/-/tree/master/roles/openldap) - LDAP directory server
- [docker](https://gitlab.com/nodiscc/xsrv/-/tree/master/roles/docker) - Docker container platform
- [graylog](https://gitlab.com/nodiscc/xsrv/-/tree/master/roles/graylog) - log management, capture and analysis platform

**End-user applications/services**

- [nextcloud](https://gitlab.com/nodiscc/xsrv/-/tree/master/roles/nextcloud) - file hosting/sharing/synchronization/groupware/"private cloud" service
- [tt_rss](https://gitlab.com/nodiscc/xsrv/-/tree/master/roles/tt_rss) - RSS feed reader
- [samba](https://gitlab.com/nodiscc/xsrv/-/tree/master/roles/samba) - cross-platform file and printer sharing service (SMB/CIFS)
- [shaarli](https://gitlab.com/nodiscc/xsrv/-/tree/master/roles/shaarli) - personal, minimalist, super-fast bookmarking service
- [gitea](https://gitlab.com/nodiscc/xsrv/-/tree/master/roles/gitea) - lightweight self-hosted Git service/software forge
- [transmission](https://gitlab.com/nodiscc/xsrv/-/tree/master/roles/transmission) - bittorrent peer-to-peer client web interface (seedbox) service
- [mumble](https://gitlab.com/nodiscc/xsrv/-/tree/master/roles/mumble) - low-latency voice-over-IP (VoIP) server
- [rocketchat](https://gitlab.com/nodiscc/xsrv/-/tree/master/roles/rocketchat) - realtime web chat/communication platform
- [jellyfin](https://gitlab.com/nodiscc/xsrv/-/tree/master/roles/jellyfin) - media System that puts you in control of managing and streaming your media
- [homepage](https://gitlab.com/nodiscc/xsrv/-/tree/master/roles/homepage) - simple homepage/dashhoard for your services


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

Or include any of the roles in your own ansible playbooks. See [Using as ansible collection](usage.md#using-as-ansible-collection).


## Screenshots

[![](https://i.imgur.com/v9BQYpN.png)](https://gitlab.com/nodiscc/xsrv/-/tree/master/roles/monitoring)
[![](https://i.imgur.com/PPVIb6V.png)](https://gitlab.com/nodiscc/xsrv/-/tree/master/roles/nextcloud)
[![](https://i.imgur.com/UoKs3x1.png)](https://gitlab.com/nodiscc/xsrv/-/tree/master/roles/tt_rss)
[![](https://i.imgur.com/gsoh2Mj.png)](https://gitlab.com/nodiscc/xsrv/-/tree/master/roles/shaarli)
[![](https://i.imgur.com/Rks90zV.png)](https://gitlab.com/nodiscc/xsrv/-/tree/master/roles/gitea)
[![](https://i.imgur.com/7nJ6cMN.png)](https://gitlab.com/nodiscc/xsrv/-/tree/master/roles/transmission)
[![](https://i.imgur.com/lHgDbDC.png)](https://gitlab.com/nodiscc/xsrv/-/tree/master/roles/mumble)
[![](https://i.imgur.com/PRE7fvn.png)](https://gitlab.com/nodiscc/xsrv/-/tree/master/roles/openldap)
[![](https://i.imgur.com/WUdwbAX.png)](https://gitlab.com/nodiscc/xsrv/-/tree/master/roles/rocketchat)
[![](https://i.imgur.com/KDJZuFO.png)](https://gitlab.com/nodiscc/xsrv/-/tree/master/roles/homepage)
[![](https://i.imgur.com/Fg8uRjL.png)](https://gitlab.com/nodiscc/xsrv/-/tree/master/roles/jellyfin)
[![](https://i.imgur.com/6Zu7YKym.png)](https://gitlab.com/nodiscc/xsrv/-/tree/master/roles/graylog)


## Source code

- [Gitlab](https://gitlab.com/nodiscc/xsrv)
- [Github](https://github.com/nodiscc/xsrv)


## License

- [GNU GPLv3](https://gitlab.com/nodiscc/xsrv/-/blob/master/LICENSE) unless noted otherwise in individual files/directories
- Documentation is under the [Creative Commons Attribution-ShareAlike 4.0](https://creativecommons.org/licenses/by-sa/4.0/) license


## Documentation

- **[Documentation](https://xsrv.readthedocs.io)**
- [Installation](installation.md)
- [Server preparation](installation/server-preparation.md)
- [Controller preparation](installation/controller-preparation.md)
- [First deployment](installation/first-deployment.md)
- [Usage](usage.md)
- [List of all configuration variables](configuration-variables.md)
- [Maintenance](maintenance.md)
- [Advanced usage](advanced.md)
- [Contributing](contributing.md)
- [Changelog](https://gitlab.com/nodiscc/xsrv/-/blob/master/CHANGELOG.md)
