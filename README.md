```
  ╻ ╻┏━┓┏━┓╻ ╻
░░╺╋╸┗━┓┣┳┛┃┏┛
  ╹ ╹┗━┛╹┗╸┗┛ 
```

[![](https://gitlab.com/nodiscc/xsrv/badges/master/pipeline.svg)](https://gitlab.com/nodiscc/xsrv/-/pipelines)
[![](https://bestpractices.coreinfrastructure.org/projects/3647/badge)](https://bestpractices.coreinfrastructure.org/projects/3647)

**Install and manage self-hosted services/applications on your own server(s).**

- a collection of [ansible](https://en.wikipedia.org/wiki/Ansible_%28software%29) [roles](#roles) to install and configure various network services, web applications, system administration and infrastructure tools
- a [command-line tool](https://xsrv.readthedocs.io/en/latest/usage.html#command-line-usage) for easy configuration, deployment and maintenance
- a [playbook to setup a single server](https://xsrv.readthedocs.io/en/latest/installation/first-deployment.html) in a few minutes


## Roles

**System components/infrastucture/middleware**

- [common](roles/common) - base system components
- [backup](roles/backup) - incremental backup service
- [monitoring](monitoring) - monitoring, alerting and logging system
- [apache](roles/apache) - web server and PHP interpreter
- [postgresql](roles/postgresql) or [mariadb](roles/mariadb) database server
- [openldap](roles/openldap) - LDAP directory server
- [docker](roles/docker) - Docker container platform

**End-user web applications/services**

- [nextcloud](roles/nextcloud) - file hosting/sharing/synchronization/groupware/"private cloud" service
- [tt_rss](roles/tt_rss) - RSS feed reader
- [samba](roles/samba) - cross-platform file and printer sharing service (SMB/CIFS)
- [shaarli](role/shaarli) - personal, minimalist, super-fast bookmarking service
- [gitea](roles/gitea) - lightweight self-hosted Git service/software forge
- [transmission](roles/transmission) - bittorrent peer-to-peer client web interface (seedbox) service
- [mumble](roles/mumble) - low-latency voice-over-IP (VoIP) server
- [rocketchat](roles/rocketchat) - realtime web chat/communication platform
- [jellyfin](roles/jellyfin) - media System that puts you in control of managing and streaming your media
- [homepage](roles/homepage) - simple homepage/dashhoard for your services

[![](https://screenshots.debian.net/screenshots/000/015/229/thumb.png)](roles/monitoring)
[![](https://i.imgur.com/PPVIb6V.png)](roles/nextcloud)
[![](https://i.imgur.com/UoKs3x1.png)](roles/tt_rss)
[![](https://i.imgur.com/8wEBRSG.png)](roles/shaarli)
[![](https://i.imgur.com/Rks90zV.png)](roles/gitea)
[![](https://i.imgur.com/blWO4LL.png)](roles/transmission)
[![](https://i.imgur.com/jYSU9zC.png)](roles/mumble)
[![](https://screenshots.debian.net/screenshots/000/006/946/thumb.png)](roles/openldap)
[![](https://i.imgur.com/OL7RZXb.png)](roles/rocketchat)
[![](https://i.imgur.com/3ZwPVQNs.png)](roles/homepage)
[![](https://jellyfin.org/images/screenshots/movie_thumb.png)](roles/jellyfin)


## Quick start

```bash
# install the program
git clone https://gitlab.com/nodiscc/xsrv
sudo cp xsrv/xsrv /usr/local/bin/

# initialize the playbook, select the target server and components to install
xsrv init-playbook

# deploy your first server
xsrv deploy
```

[![](https://asciinema.org/a/kGt6mVg3GxFlDPXwagiwg4Laq.svg)](https://asciinema.org/a/kGt6mVg3GxFlDPXwagiwg4Laq)

Use the [`xsrv`](https://xsrv.readthedocs.io/en/latest/usage.html#command-line-usage) command-line tool to manage your servers, or include any of the [roles](#roles) in your own `ansible` playbooks.


## Documentation

- **[Documentation](https://xsrv.readthedocs.io)**
- [Installation](https://xsrv.readthedocs.io/en/latest/installation.html)
- [Server preparation](https://xsrv.readthedocs.io/en/latest/installation/server-preparation.html)
- [Controller preparation](https://xsrv.readthedocs.io/en/latest/installation/controller-preparation.html)
- [First deployment](https://xsrv.readthedocs.io/en/latest/installation/first-deployment.gtml)
- [Usage](https://xsrv.readthedocs.io/en/latest/usage.html)
- [Maintenance](https://xsrv.readthedocs.io/en/latest/maintenance.html)
- [Advanced usage](https://xsrv.readthedocs.io/en/latest/advanced.html)
- [Contributing](https://xsrv.readthedocs.io/en/latest/contributing.html)
- [License](https://gitlab.com/nodiscc/xsrv/-/blob/master/LICENSE)
- [Changelog](https://gitlab.com/nodiscc/xsrv/-/blob/master/CHANGELOG.md)
