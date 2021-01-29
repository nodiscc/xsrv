```
  ╻ ╻┏━┓┏━┓╻ ╻
░░╺╋╸┗━┓┣┳┛┃┏┛
  ╹ ╹┗━┛╹┗╸┗┛ 
```

[![](https://gitlab.com/nodiscc/xsrv/badges/master/pipeline.svg)](https://gitlab.com/nodiscc/xsrv/-/pipelines)
[![](https://bestpractices.coreinfrastructure.org/projects/3647/badge)](https://bestpractices.coreinfrastructure.org/projects/3647)

**Install and manage self-hosted services/applications on your own server(s).**

`xsrv` provides:

- a collection of [ansible](https://en.wikipedia.org/wiki/Ansible_%28software%29) [roles](#roles) to install and configure various network services, web applications, system administration and infrastructure tools
- a [command-line tool](https://xsrv.readthedocs.io/en/latest/usage.html#command-line-usage) for easy configuration, deployment and maintenance
- a base [playbook to setup a single server](https://xsrv.readthedocs.io/en/latest/installation/first-deployment.html) for personal use or small/medium teams in a few minutes


## Roles

- [common](roles/common) - base system components (SSH, upgrades, users, hostname, network, kernel, time...)
- [backup](roles/backup) - incremental backup service (local and remote backups)
- [monitoring](roles/monitoring) - monitoring, alerting and log agregation system (netdata, rsyslog, other tools)
- [apache](roles/apache) - Apache web server and PHP-FPM interpreter
- [homepage](role/homepage) - simple web server homepage
- [postgresql](roles/postgresql) - PostgreSQL database server
- [mariadb](roles/mariadb) - MariaDB (MySQL) database server
- [nextcloud](roles/nextcloud) - File hosting/sharing/synchronization/groupware/"private cloud"
- [tt_rss](roles/tt_rss) - Tiny Tiny RSS web feed reader
- [samba](roles/samba) - Cross-platform file and printer sharing service (SMB/CIFS)
- [shaarli](roles/shaarli) - personal, minimalist, super-fast bookmarking service
- [gitea](roles/gitea) - Lightweight self-hosted Git service/software forge
- [transmission](roles/transmission) - Bittorrent client/web interface/seedbox service
- [mumble](roles/mumble) - Low-latency voice-over-IP (VoIP) server
- [openldap](roles/openldap) - LDAP directory server and web administration tools
- [docker](roles/docker) - Docker container platform
- [rocketchat](roles/rocketchat) - Realtime web chat/communication platform
- [jellyfin](roles/jellyfin) - Media System that puts you in control of managing and streaming your media

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
sudo git clone https://gitlab.com/nodiscc/xsrv /opt/xsrv
sudo cp /opt/xsrv/xsrv /usr/local/bin

# initialize the playbook, select the target server and components to install
xsrv init-playbook

# deploy your configuration
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
