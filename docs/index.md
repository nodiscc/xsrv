# xsrv

```
  ╻ ╻┏━┓┏━┓╻ ╻
░░╺╋╸┗━┓┣┳┛┃┏┛
  ╹ ╹┗━┛╹┗╸┗┛ 
```

[![](https://gitlab.com/nodiscc/xsrv/badges/master/pipeline.svg)](https://gitlab.com/nodiscc/xsrv/-/pipelines)
[![](https://bestpractices.coreinfrastructure.org/projects/3647/badge)](https://bestpractices.coreinfrastructure.org/projects/3647)
[![](https://img.shields.io/badge/latest%20release-1.21.0-blue)](https://gitlab.com/nodiscc/xsrv/-/releases)
[![](https://img.shields.io/badge/docs-readthedocs-%232980B9)](https://xsrv.readthedocs.io)

**Install, manage and run self-hosted network services and applications on your own server(s).**

This project provides:

- [ansible](https://en.wikipedia.org/wiki/Ansible_%28software%29) [roles](#roles) for automated installation/configuration of various network services, applications and management tools (sharing, communication, collaboration systems, file storage, multimedia, office/organization, development, automation, infrastructure...)
- an optional [command-line tool](usage.md) for common operations, configuration, deployment and maintenance of your servers
- a template to [get started with a single server](installation.md) in a few minutes


## Roles
<!--BEGIN ROLES LIST-->
- [apache](https://gitlab.com/nodiscc/xsrv/-/tree/master/roles/apache) - Apache web server/reverse proxy + PHP-FPM interpreter
- [backup](https://gitlab.com/nodiscc/xsrv/-/tree/master/roles/backup) - Remote/local backup service (rsnapshot)
- [common](https://gitlab.com/nodiscc/xsrv/-/tree/master/roles/common) - Base setup for Debian servers
- [dnsmasq](https://gitlab.com/nodiscc/xsrv/-/tree/master/roles/dnsmasq) - Lightweight DNS server
- [gitea](https://gitlab.com/nodiscc/xsrv/-/tree/master/roles/gitea) - Self-hosted Git service/software forge
- [gitea_act_runner](https://gitlab.com/nodiscc/xsrv/-/tree/master/roles/gitea_act_runner) - CI/CD runner for Gitea Actions
- [gotty](https://gitlab.com/nodiscc/xsrv/-/tree/master/roles/gotty) - Share your terminal as a web application
- [graylog](https://gitlab.com/nodiscc/xsrv/-/tree/master/roles/graylog) - Log capture, storage, real-time search and analysis tool
- [homepage](https://gitlab.com/nodiscc/xsrv/-/tree/master/roles/homepage) - Simple webserver homepage/dashboard
- [jellyfin](https://gitlab.com/nodiscc/xsrv/-/tree/master/roles/jellyfin) - Media solution that puts you in control of your media
- [jitsi](https://gitlab.com/nodiscc/xsrv/-/tree/master/roles/jitsi) - Video conferencing solution
- [libvirt](https://gitlab.com/nodiscc/xsrv/-/tree/master/roles/libvirt) - libvirt virtualization toolkit
- [mail_dovecot](https://gitlab.com/nodiscc/xsrv/-/tree/master/roles/mail_dovecot) - IMAP mailbox server
- [matrix](https://gitlab.com/nodiscc/xsrv/-/tree/master/roles/matrix) - Real-time secure communication server and web client
- [monitoring](https://gitlab.com/nodiscc/xsrv/-/tree/master/roles/monitoring) - Monitoring, alerting, audit and logging system
- [monitoring_goaccess](https://gitlab.com/nodiscc/xsrv/-/tree/master/roles/monitoring_goaccess) - real-time web log analyzer/interactive viewer
- [monitoring_netdata](https://gitlab.com/nodiscc/xsrv/-/tree/master/roles/monitoring_netdata) - Lightweight real-time monitoring and alerting system
- [monitoring_rsyslog](https://gitlab.com/nodiscc/xsrv/-/tree/master/roles/monitoring_rsyslog) - Log aggregation, processing and forwarding system
- [monitoring_utils](https://gitlab.com/nodiscc/xsrv/-/tree/master/roles/monitoring_utils) - Various monitoring and audit utilities
- [mumble](https://gitlab.com/nodiscc/xsrv/-/tree/master/roles/mumble) - Low-latency VoIP/voice chat server
- [nextcloud](https://gitlab.com/nodiscc/xsrv/-/tree/master/roles/nextcloud) - file hosting/sharing/synchronization and collaboration platform
- [nmap](https://gitlab.com/nodiscc/xsrv/-/tree/master/roles/nmap) - run nmap network scanner against hosts in the inventory
- [openldap](https://gitlab.com/nodiscc/xsrv/-/tree/master/roles/openldap) - LDAP directory server and web management tools
- [owncast](https://gitlab.com/nodiscc/xsrv/-/tree/master/roles/owncast) - Decentralized, single user live video streaming and chat server
- [podman](https://gitlab.com/nodiscc/xsrv/-/tree/master/roles/podman) - OCI container engine and management tools
- [postgresql](https://gitlab.com/nodiscc/xsrv/-/tree/master/roles/postgresql) - PostgreSQL database engine
- [readme_gen](https://gitlab.com/nodiscc/xsrv/-/tree/master/roles/readme_gen) - add an inventory of hosts and services to the project's README.md
- [samba](https://gitlab.com/nodiscc/xsrv/-/tree/master/roles/samba) - Cross-platform file sharing server
- [shaarli](https://gitlab.com/nodiscc/xsrv/-/tree/master/roles/shaarli) - Bookmarking & link sharing web application
- [transmission](https://gitlab.com/nodiscc/xsrv/-/tree/master/roles/transmission) - Transmission Bittorrent client/web interface
- [tt_rss](https://gitlab.com/nodiscc/xsrv/-/tree/master/roles/tt_rss) - Tiny Tiny RSS web-based news feed reader
- [wireguard](https://gitlab.com/nodiscc/xsrv/-/tree/master/roles/wireguard) - fast and modern VPN server
<!--END ROLES LIST-->

## Screenshots

[![](https://gitlab.com/nodiscc/toolbox/-/raw/master/DOC/SCREENSHOTS/netdata-dashboard-thumb.png)](https://gitlab.com/nodiscc/xsrv/-/tree/master/roles/monitoring_netdata)
[![](https://gitlab.com/nodiscc/toolbox/-/raw/master/DOC/SCREENSHOTS/LNaAH2L.png)](https://gitlab.com/nodiscc/xsrv/-/tree/master/roles/nextcloud)
[![](https://gitlab.com/nodiscc/toolbox/-/raw/master/DOC/SCREENSHOTS/5TXg6vm.png)](https://gitlab.com/nodiscc/xsrv/-/tree/master/roles/tt_rss)
[![](https://gitlab.com/nodiscc/toolbox/-/raw/master/DOC/SCREENSHOTS/Jlmj0iE.png)](https://gitlab.com/nodiscc/xsrv/-/tree/master/roles/shaarli)
[![](https://gitlab.com/nodiscc/toolbox/-/raw/master/DOC/SCREENSHOTS/8cAGkf2.png)](https://gitlab.com/nodiscc/xsrv/-/tree/master/roles/gitea)
[![](https://gitlab.com/nodiscc/toolbox/-/raw/master/DOC/SCREENSHOTS/Imb0dqO.png)](https://gitlab.com/nodiscc/xsrv/-/tree/master/roles/transmission)
[![](https://gitlab.com/nodiscc/toolbox/-/raw/master/DOC/SCREENSHOTS/6Im61B0.png)](https://gitlab.com/nodiscc/xsrv/-/tree/master/roles/mumble)
[![](https://gitlab.com/nodiscc/toolbox/-/raw/master/DOC/SCREENSHOTS/REzcZVh.png)](https://gitlab.com/nodiscc/xsrv/-/tree/master/roles/openldap)
[![](https://gitlab.com/nodiscc/toolbox/-/raw/master/DOC/SCREENSHOTS/udEAnKA.png)](https://gitlab.com/nodiscc/xsrv/-/tree/master/roles/matrix)
[![](https://gitlab.com/nodiscc/toolbox/-/raw/master/DOC/SCREENSHOTS/Vvdj3Zu.png)](https://gitlab.com/nodiscc/xsrv/-/tree/master/roles/homepage)
[![](https://gitlab.com/nodiscc/toolbox/-/raw/master/DOC/SCREENSHOTS/H3PIWrt.png)](https://gitlab.com/nodiscc/xsrv/-/tree/master/roles/jellyfin)
[![](https://gitlab.com/nodiscc/toolbox/-/raw/master/DOC/SCREENSHOTS/wa3pkyJ.png)](https://gitlab.com/nodiscc/xsrv/-/tree/master/roles/graylog)
[![](https://gitlab.com/nodiscc/toolbox/-/raw/master/DOC/SCREENSHOTS/g0jUMXE.jpg)](https://gitlab.com/nodiscc/xsrv/-/tree/master/roles/jitsi)
[![](https://gitlab.com/nodiscc/toolbox/-/raw/master/DOC/SCREENSHOTS/v3lHJGx.png)](https://gitlab.com/nodiscc/xsrv/-/tree/master/roles/readme_gen)
[![](https://gitlab.com/nodiscc/toolbox/-/raw/master/DOC/SCREENSHOTS/XYmHNqT.png)](https://gitlab.com/nodiscc/xsrv/-/tree/master/roles/libvirt)
[![](https://gitlab.com/nodiscc/toolbox/-/raw/master/DOC/SCREENSHOTS/goaccess-bright-thumb.png)](https://gitlab.com/nodiscc/xsrv/-/tree/master/roles/monitoring_goaccess)
[![](https://gitlab.com/nodiscc/toolbox/-/raw/master/DOC/SCREENSHOTS/owncast-thumb.png)](https://gitlab.com/nodiscc/xsrv/-/tree/master/roles/owncast)
[![](https://gitlab.com/nodiscc/toolbox/-/raw/master/DOC/SCREENSHOTS/nmap-thumb.png)](https://gitlab.com/nodiscc/xsrv/-/tree/master/roles/nmap)


## Source code

- [Gitlab](https://gitlab.com/nodiscc/xsrv)
- [Github](https://github.com/nodiscc/xsrv)


## License

- [GNU GPLv3](https://gitlab.com/nodiscc/xsrv/-/blob/master/LICENSE) unless noted otherwise in individual files/directories
- Documentation is under the [Creative Commons Attribution-ShareAlike 4.0](https://creativecommons.org/licenses/by-sa/4.0/) license


## Documentation

- [Installation](installation.md)
- [Server preparation](installation/server-preparation.md)
- [Controller preparation](installation/controller-preparation.md)
- [First project](installation/first-project.md)
- [Usage](usage.md)
- [List of all configuration variables](configuration-variables.md)
- [List of all tags](tags.md)
- [Maintenance](maintenance.md)
- [Contributing](contributing.md)
- [Appendices](appendices.md)
- [Changelog](https://gitlab.com/nodiscc/xsrv/-/blob/master/CHANGELOG.md)



