# xsrv

[![](https://gitlab.com/nodiscc/xsrv/badges/master/pipeline.svg)](https://gitlab.com/nodiscc/xsrv/-/pipelines)
[![](https://bestpractices.coreinfrastructure.org/projects/3647/badge)](https://bestpractices.coreinfrastructure.org/projects/3647)

**Install and manage self-hosted services/applications on your own server(s).**

`xsrv` provides:

- a collection of [ansible](https://en.wikipedia.org/wiki/Ansible_%28software%29) [roles](#roles) to install and configure various network services, web applications, system administration and infrastructure tools
- a [command-line tool](https://xsrv.readthedocs.io/en/latest/usage.html#command-line-usage) for easy configuration, deployment and maintenance
- a [playbook to setup a single server](https://xsrv.readthedocs.io/en/latest/installation/first-deployment.html) in a few minutes


## Roles

- [common](https://gitlab.com/nodiscc/xsrv/-/tree/master/roles/common) - base system components
- [backup](https://gitlab.com/nodiscc/xsrv/-/tree/master/roles/backup) - incremental backup service (local/remote backups)
- [monitoring](https://gitlab.com/nodiscc/xsrv/-/tree/master/roles/monitoring) - monitoring, alerting and logging system (netdata/rsyslog/other)
- [apache](https://gitlab.com/nodiscc/xsrv/-/tree/master/roles/apache) - web server and PHP interpreter
- [homepage](https://gitlab.com/nodiscc/xsrv/-/tree/master/roles/homepage) - simple homepage/dashhoard for your services
- [postgresql](https://gitlab.com/nodiscc/xsrv/-/tree/master/roles/postgresql) or [mariadb](https://gitlab.com/nodiscc/xsrv/-/tree/master/roles/mariadb) (MySQL) database server
- [nextcloud](https://gitlab.com/nodiscc/xsrv/-/tree/master/roles/nextcloud) - file hosting/sharing/synchronization/groupware/"private cloud" service
- [tt_rss](https://gitlab.com/nodiscc/xsrv/-/tree/master/roles/tt_rss) - RSS feed reader
- [samba](https://gitlab.com/nodiscc/xsrv/-/tree/master/roles/samba) - cross-platform file and printer sharing service (SMB/CIFS)
- [shaarli](https://gitlab.com/nodiscc/xsrv/-/tree/master/roles/shaarli) - personal, minimalist, super-fast bookmarking service
- [gitea](https://gitlab.com/nodiscc/xsrv/-/tree/master/roles/gitea) - lightweight self-hosted Git service/software forge
- [transmission](https://gitlab.com/nodiscc/xsrv/-/tree/master/roles/transmission) - bittorrent peer-to-peer client web interface (seedbox) service
- [mumble](https://gitlab.com/nodiscc/xsrv/-/tree/master/roles/mumble) - low-latency voice-over-IP (VoIP) server
- [openldap](https://gitlab.com/nodiscc/xsrv/-/tree/master/roles/openldap) - LDAP directory server and web administration tools
- [docker](https://gitlab.com/nodiscc/xsrv/-/tree/master/roles/docker) - Docker container platform
- [rocketchat](https://gitlab.com/nodiscc/xsrv/-/tree/master/roles/rocketchat) - realtime web chat/communication platform
- [jellyfin](roles/jellyfin) - media System that puts you in control of managing and streaming your media

<!-- TODO link to roles on gitlab -->
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

- [Installation](installation.md)
- [Server preparation](installation/server-preparation.md)
- [Controller preparation](installation/controller-preparation.md)
- [First deployment](installation/first-deployment.md)
- [Usage](usage.md)
- [Maintenance](maintenance.md)
- [Advanced usage](advanced.md)
- [Contributing](contributing.md)
