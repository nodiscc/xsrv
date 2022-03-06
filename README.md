# xsrv

```
  ╻ ╻┏━┓┏━┓╻ ╻
░░╺╋╸┗━┓┣┳┛┃┏┛
  ╹ ╹┗━┛╹┗╸┗┛ 
```

[![](https://gitlab.com/nodiscc/xsrv/badges/master/pipeline.svg)](https://gitlab.com/nodiscc/xsrv/-/pipelines)
[![](https://bestpractices.coreinfrastructure.org/projects/3647/badge)](https://bestpractices.coreinfrastructure.org/projects/3647)
[![](https://img.shields.io/badge/latest%20release-1.5.0-blue)](https://gitlab.com/nodiscc/xsrv/-/releases)
[![](https://img.shields.io/badge/docs-readthedocs-%232980B9)](https://xsrv.readthedocs.io)

**Install, manage and run self-hosted network services and applications on your own server(s).**

This project provides:

- [ansible](https://en.wikipedia.org/wiki/Ansible_%28software%29) [roles](#roles) to install/configure various network services, applications and management tools (sharing, communication, collaboration systems, file storage, multimedia, office/organization, development, automation, infrastructure...)
- an optional [command-line tool](docs/usage.md) for common operations, configuration, deployment and maintenance of your servers
- a template to [get started with a single server](docs/installation.md) in a few minutes


## Roles
<!--BEGIN ROLES LIST-->
- [apache](roles/apache) - Apache web server + PHP-FPM interpreter
- [backup](roles/backup) - Remote/local backup service (rsnapshot)
- [common](roles/common) - Base setup for Debian servers
- [dnsmasq](roles/dnsmasq) - Lightweight DNS server
- [docker](roles/docker) - Open source application containerization technology
- [gitea](roles/gitea) - Self-hosted Git service/software forge
- [gotty](roles/gotty) - Share your terminal as a web application
- [graylog](roles/graylog) - Log capture, storage, real-time search and analysis tool
- [homepage](roles/homepage) - Simple webserver homepage/dashboard
- [jellyfin](roles/jellyfin) - Media solution that puts you in control of your media
- [monitoring](roles/monitoring) - Monitoring, alerting, audit and logging system
- [monitoring_netdata](roles/monitoring_netdata) - Lightweight real-time monitoring and alerting system
- [monitoring_rsyslog](roles/monitoring_rsyslog) - Log aggregation, processing and forwarding system
- [monitoring_utils](roles/monitoring_utils) - Various monitoring and audit utilities
- [mumble](roles/mumble) - Low-latency VoIP/voice chat server
- [nextcloud](roles/nextcloud) - file hosting/sharing/synchronization and collaboration platform
- [openldap](roles/openldap) - LDAP directory server and web management tools
- [postgresql](roles/postgresql) - PostgreSQL database engine
- [proxmox](roles/proxmox) - Proxmox VE hypervisor configuration
- [rocketchat](roles/rocketchat) - Instant messaging & communication platform
- [rss_bridge](roles/rss_bridge) - The RSS feed for websites missing it
- [samba](roles/samba) - Cross-platform file sharing server
- [shaarli](roles/shaarli) - Bookmarking & link sharing web application
- [transmission](roles/transmission) - Transmission Bittorrent client/web interface
- [tt_rss](roles/tt_rss) - Tiny Tiny RSS web-based news feed reader
- [valheim_server](roles/valheim_server) - Valheim multiplayer server
<!--END ROLES LIST-->

## Screenshots

[![](https://i.imgur.com/pG1xnig.png)](roles/monitoring_netdata)
[![](https://i.imgur.com/LNaAH2L.png)](roles/nextcloud)
[![](https://i.imgur.com/5TXg6vm.png)](roles/tt_rss)
[![](https://i.imgur.com/Jlmj0iE.png)](roles/shaarli)
[![](https://i.imgur.com/8cAGkf2.png)](roles/gitea)
[![](https://i.imgur.com/Imb0dqO.png)](roles/transmission)
[![](https://i.imgur.com/6Im61B0.png)](roles/mumble)
[![](https://i.imgur.com/REzcZVh.png)](roles/openldap)
[![](https://i.imgur.com/Mib9YkX.png)](roles/rocketchat)
[![](https://i.imgur.com/5KDvL9Z.png)](roles/homepage)
[![](https://i.imgur.com/H3PIWrt.png)](roles/jellyfin)
[![](https://i.imgur.com/wa3pkyJ.png)](roles/graylog)
[![](https://i.imgur.com/NytdOIJ.png)](roles/rss_bridge)

## Source code

- [Gitlab](https://gitlab.com/nodiscc/xsrv)
- [Github](https://github.com/nodiscc/xsrv)


## License

- [GNU GPLv3](https://gitlab.com/nodiscc/xsrv/-/blob/master/LICENSE) unless noted otherwise in individual files/directories
- Documentation is under the [Creative Commons Attribution-ShareAlike 4.0](https://creativecommons.org/licenses/by-sa/4.0/) license


## Documentation

- [Installation](docs/installation.md)
- [Server preparation](docs/installation/server-preparation.md)
- [Controller preparation](docs/installation/controller-preparation.md)
- [First project](docs/installation/first-project.md)
- [Usage](docs/usage.md)
- [List of all configuration variables](docs/configuration-variables.md)
- [Maintenance](docs/maintenance.md)
- [Advanced usage](docs/advanced.md)
- [Contributing](docs/contributing.md)
- [Appendices](docs/appendices.md)
- [Changelog](https://gitlab.com/nodiscc/xsrv/-/blob/master/CHANGELOG.md)



