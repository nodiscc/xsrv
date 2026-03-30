# xsrv

```
  ╻ ╻┏━┓┏━┓╻ ╻
░░╺╋╸┗━┓┣┳┛┃┏┛
  ╹ ╹┗━┛╹┗╸┗┛ 
```

[![](https://github.com/nodiscc/xsrv/badges/master/pipeline.svg)](https://github.com/nodiscc/xsrv/-/pipelines)
[![](https://bestpractices.coreinfrastructure.org/projects/3647/badge)](https://bestpractices.coreinfrastructure.org/projects/3647)
[![](https://img.shields.io/badge/latest%20release-1.27.0-blue)](https://github.com/nodiscc/xsrv/releases)
[![](https://img.shields.io/badge/docs-readthedocs-%232980B9)](https://xsrv.readthedocs.io)

**Install, manage and run self-hosted network services and applications on your own server(s).**

This project provides:

- [ansible](https://en.wikipedia.org/wiki/Ansible_%28software%29) [roles](#roles) for automated installation/configuration of various network services, applications and management tools (sharing, communication, collaboration systems, file storage, multimedia, office/organization, development, automation, infrastructure...)
- an optional [command-line tool](usage.md) for common operations, configuration, deployment and maintenance of your servers
- a template to [get started with a single server](installation.md) in a few minutes


## Roles
<!--BEGIN ROLES LIST-->
- [apache](https://github.com/nodiscc/xsrv/tree/master/roles/apache) - web server/reverse proxy + PHP-FPM interpreter
- [backup](https://github.com/nodiscc/xsrv/tree/master/roles/backup) - remote/local backup service (rsnapshot)
- [common](https://github.com/nodiscc/xsrv/tree/master/roles/common) - base setup for Debian-based servers
- [dnsmasq](https://github.com/nodiscc/xsrv/tree/master/roles/dnsmasq) - lightweight DNS server
- [gitea](https://github.com/nodiscc/xsrv/tree/master/roles/gitea) - git version control service/software forge
- [gitea_act_runner](https://github.com/nodiscc/xsrv/tree/master/roles/gitea_act_runner) - CI/CD runner for Gitea Actions
- [homepage](https://github.com/nodiscc/xsrv/tree/master/roles/homepage) - simple webserver homepage/dashboard
- [jellyfin](https://github.com/nodiscc/xsrv/tree/master/roles/jellyfin) - media server
- [jitsi](https://github.com/nodiscc/xsrv/tree/master/roles/jitsi) - video conferencing solution
- [kiwix](https://github.com/nodiscc/xsrv/tree/master/roles/kiwix) - mirror wikipedia or other wikis locally
- [libvirt](https://github.com/nodiscc/xsrv/tree/master/roles/libvirt) - virtualization toolkit
- [mail_dovecot](https://github.com/nodiscc/xsrv/tree/master/roles/mail_dovecot) - IMAP mailbox server
- [matrix](https://github.com/nodiscc/xsrv/tree/master/roles/matrix) - secure instant messaging service
- [monitoring.exporters](https://github.com/nodiscc/xsrv/tree/master/roles/monitoring/exporters) - monitoring agents/metrics exporters
- [monitoring.goaccess](https://github.com/nodiscc/xsrv/tree/master/roles/monitoring/goaccess) - real-time web log analyzer/interactive viewer
- [monitoring.grafana](https://github.com/nodiscc/xsrv/tree/master/roles/monitoring/grafana) - monitoring metrics visualization and analytics
- [monitoring.rsyslog](https://github.com/nodiscc/xsrv/tree/master/roles/monitoring/rsyslog) - log aggregation, processing and forwarding system
- [monitoring.utils](https://github.com/nodiscc/xsrv/tree/master/roles/monitoring/utils) - basic monitoring utilities
- [monitoring.victoriametrics](https://github.com/nodiscc/xsrv/tree/master/roles/monitoring/victoriametrics) - monitoring metrics scraper and time-series database
- [moodist](https://github.com/nodiscc/xsrv/tree/master/roles/moodist) - Ambient sound mixer
- [mumble](https://github.com/nodiscc/xsrv/tree/master/roles/mumble) - low-latency VoIP/voice chat server
- [nextcloud](https://github.com/nodiscc/xsrv/tree/master/roles/nextcloud) - file hosting/sharing/synchronization and collaboration platform
- [nmap](https://github.com/nodiscc/xsrv/tree/master/roles/nmap) - automated network scanning for ansible-based projects
- [openldap](https://github.com/nodiscc/xsrv/tree/master/roles/openldap) - LDAP directory server and web management tools
- [owncast](https://github.com/nodiscc/xsrv/tree/master/roles/owncast) - live video streaming and chat server
- [podman](https://github.com/nodiscc/xsrv/tree/master/roles/podman) - OCI container engine and management tools
- [postgresql](https://github.com/nodiscc/xsrv/tree/master/roles/postgresql) - database engine
- [readme_gen](https://github.com/nodiscc/xsrv/tree/master/roles/readme_gen) - automatic README.md generator for ansible-based projects
- [samba](https://github.com/nodiscc/xsrv/tree/master/roles/samba) - cross-platform file sharing server
- [searxng](https://github.com/nodiscc/xsrv/tree/master/roles/searxng) - metasearch engine
- [shaarli](https://github.com/nodiscc/xsrv/tree/master/roles/shaarli) - bookmarking & link sharing web application
- [stirlingpdf](https://github.com/nodiscc/xsrv/tree/master/roles/stirlingpdf) - PDF manipulation tools
- [transmission](https://github.com/nodiscc/xsrv/tree/master/roles/transmission) - bittorrent client/web interface
- [tt_rss](https://github.com/nodiscc/xsrv/tree/master/roles/tt_rss) - web-based news feed reader
- [wireguard](https://github.com/nodiscc/xsrv/tree/master/roles/wireguard) - fast and modern VPN server
<!--END ROLES LIST-->

## Screenshots

[![](https://github.com/nodiscc/toolbox/raw/master/DOC/SCREENSHOTS/LNaAH2L.png)](https://github.com/nodiscc/xsrv/tree/master/roles/nextcloud)
[![](https://github.com/nodiscc/toolbox/raw/master/DOC/SCREENSHOTS/5TXg6vm.png)](https://github.com/nodiscc/xsrv/tree/master/roles/tt_rss)
[![](https://github.com/nodiscc/toolbox/raw/master/DOC/SCREENSHOTS/Jlmj0iE.png)](https://github.com/nodiscc/xsrv/tree/master/roles/shaarli)
[![](https://github.com/nodiscc/toolbox/raw/master/DOC/SCREENSHOTS/8cAGkf2.png)](https://github.com/nodiscc/xsrv/tree/master/roles/gitea)
[![](https://github.com/nodiscc/toolbox/raw/master/DOC/SCREENSHOTS/Imb0dqO.png)](https://github.com/nodiscc/xsrv/tree/master/roles/transmission)
[![](https://github.com/nodiscc/toolbox/raw/master/DOC/SCREENSHOTS/6Im61B0.png)](https://github.com/nodiscc/xsrv/tree/master/roles/mumble)
[![](https://github.com/nodiscc/toolbox/raw/master/DOC/SCREENSHOTS/REzcZVh.png)](https://github.com/nodiscc/xsrv/tree/master/roles/openldap)
[![](https://github.com/nodiscc/toolbox/raw/master/DOC/SCREENSHOTS/udEAnKA.png)](https://github.com/nodiscc/xsrv/tree/master/roles/matrix)
[![](https://github.com/nodiscc/toolbox/raw/master/DOC/SCREENSHOTS/Vvdj3Zu.png)](https://github.com/nodiscc/xsrv/tree/master/roles/homepage)
[![](https://github.com/nodiscc/toolbox/raw/master/DOC/SCREENSHOTS/H3PIWrt.png)](https://github.com/nodiscc/xsrv/tree/master/roles/jellyfin)
[![](https://github.com/nodiscc/toolbox/raw/master/DOC/SCREENSHOTS/g0jUMXE.jpg)](https://github.com/nodiscc/xsrv/tree/master/roles/jitsi)
[![](https://github.com/nodiscc/toolbox/raw/master/DOC/SCREENSHOTS/v3lHJGx.png)](https://github.com/nodiscc/xsrv/tree/master/roles/readme_gen)
[![](https://github.com/nodiscc/toolbox/raw/master/DOC/SCREENSHOTS/XYmHNqT.png)](https://github.com/nodiscc/xsrv/tree/master/roles/libvirt)
[![](https://github.com/nodiscc/toolbox/raw/master/DOC/SCREENSHOTS/goaccess-bright-thumb.png)](https://github.com/nodiscc/xsrv/tree/master/roles/monitoring/goaccess)
[![](https://github.com/nodiscc/toolbox/raw/master/DOC/SCREENSHOTS/grafana-thumb.png)](https://github.com/nodiscc/xsrv/tree/master/roles/monitoring/grafana)
[![](https://github.com/nodiscc/toolbox/raw/master/DOC/SCREENSHOTS/owncast-thumb.png)](https://github.com/nodiscc/xsrv/tree/master/roles/owncast)
[![](https://github.com/nodiscc/toolbox/raw/master/DOC/SCREENSHOTS/searxng-thumb.png)](https://github.com/nodiscc/xsrv/tree/master/roles/searxng)
[![](https://github.com/nodiscc/toolbox/raw/master/DOC/SCREENSHOTS/nmap-thumb.png)](https://github.com/nodiscc/xsrv/tree/master/roles/nmap)
[![](https://github.com/nodiscc/toolbox/raw/master/DOC/SCREENSHOTS/stirlingpdf-thumb.png)](https://github.com/nodiscc/xsrv/tree/master/roles/stirlingpdf)
[![](https://github.com/nodiscc/toolbox/raw/master/DOC/SCREENSHOTS/moodist-thumb.png)](https://github.com/nodiscc/xsrv/tree/master/roles/moodist)
[![](https://github.com/nodiscc/toolbox/raw/master/DOC/SCREENSHOTS/kiwix2_thumb.png)](https://github.com/nodiscc/xsrv/tree/master/roles/kiwix)


## Source code

- [Gitlab](https://github.com/nodiscc/xsrv)
- [Github](https://github.com/nodiscc/xsrv)


## License

- [GNU GPLv3](https://github.com/nodiscc/xsrv/blob/master/LICENSE) unless noted otherwise in individual files/directories
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
- [Changelog](https://github.com/nodiscc/xsrv/blob/master/CHANGELOG.md)



