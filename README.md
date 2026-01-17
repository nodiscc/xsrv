# xsrv

```
  ╻ ╻┏━┓┏━┓╻ ╻
░░╺╋╸┗━┓┣┳┛┃┏┛
  ╹ ╹┗━┛╹┗╸┗┛ 
```

[![](https://gitlab.com/nodiscc/xsrv/badges/master/pipeline.svg)](https://gitlab.com/nodiscc/xsrv/-/pipelines)
[![](https://bestpractices.coreinfrastructure.org/projects/3647/badge)](https://bestpractices.coreinfrastructure.org/projects/3647)
[![](https://img.shields.io/badge/latest%20release-1.27.0-blue)](https://gitlab.com/nodiscc/xsrv/-/releases)
[![](https://img.shields.io/badge/docs-readthedocs-%232980B9)](https://xsrv.readthedocs.io)

**Install, manage and run self-hosted network services and applications on your own server(s).**

This project provides:

- [ansible](https://en.wikipedia.org/wiki/Ansible_%28software%29) [roles](#roles) for automated installation/configuration of various network services, applications and management tools (sharing, communication, collaboration systems, file storage, multimedia, office/organization, development, automation, infrastructure...)
- an optional [command-line tool](docs/usage.md) for common operations, configuration, deployment and maintenance of your servers
- a template to [get started with a single server](docs/installation.md) in a few minutes


## Roles
<!--BEGIN ROLES LIST-->
- [apache](roles/apache) - web server/reverse proxy + PHP-FPM interpreter
- [backup](roles/backup) - remote/local backup service (rsnapshot)
- [common](roles/common) - base setup for Debian-based servers
- [dnsmasq](roles/dnsmasq) - lightweight DNS server
- [gitea](roles/gitea) - git version control service/software forge
- [gitea_act_runner](roles/gitea_act_runner) - CI/CD runner for Gitea Actions
- [gotty](roles/gotty) - web-based terminal emulator
- [graylog](roles/graylog) - log aggregation, storage, real-time search and analysis tool
- [homepage](roles/homepage) - simple webserver homepage/dashboard
- [jellyfin](roles/jellyfin) - media server
- [jitsi](roles/jitsi) - video conferencing solution
- [kiwix](roles/kiwix) - mirror wikipedia or other wikis locally
- [libvirt](roles/libvirt) - virtualization toolkit
- [mail_dovecot](roles/mail_dovecot) - IMAP mailbox server
- [matrix](roles/matrix) - secure instant messaging service
- [monitoring.exporters](roles/monitoring/exporters) - monitoring agents/metrics exporters
- [monitoring.goaccess](roles/monitoring/goaccess) - real-time web log analyzer/interactive viewer
- [monitoring.grafana](roles/monitoring/grafana) - metrics visualization and analytics application
- [monitoring.rsyslog](roles/monitoring/rsyslog) - log aggregation, processing and forwarding system
- [monitoring.utils](roles/monitoring/utils) - basic monitoring utilities
- [monitoring.victoriametrics](roles/monitoring/victoriametrics) - monitoring metrics scraper and time-series database
- [moodist](roles/moodist) - Ambient sound mixer
- [mumble](roles/mumble) - low-latency VoIP/voice chat server
- [nextcloud](roles/nextcloud) - file hosting/sharing/synchronization and collaboration platform
- [nmap](roles/nmap) - automated network scanning for ansible-based projects
- [ollama](roles/ollama) - Large Language Model (LLM) runner and web interface
- [openldap](roles/openldap) - LDAP directory server and web management tools
- [owncast](roles/owncast) - live video streaming and chat server
- [podman](roles/podman) - OCI container engine and management tools
- [postgresql](roles/postgresql) - database engine
- [readme_gen](roles/readme_gen) - automatic README.md generator for ansible-based projects
- [samba](roles/samba) - cross-platform file sharing server
- [searxng](roles/searxng) - metasearch engine
- [shaarli](roles/shaarli) - bookmarking & link sharing web application
- [stirlingpdf](roles/stirlingpdf) - PDF manipulation tools
- [transmission](roles/transmission) - bittorrent client/web interface
- [tt_rss](roles/tt_rss) - web-based news feed reader
- [wireguard](roles/wireguard) - fast and modern VPN server
<!--END ROLES LIST-->

## Screenshots

[![](https://gitlab.com/nodiscc/toolbox/-/raw/master/DOC/SCREENSHOTS/LNaAH2L.png)](roles/nextcloud)
[![](https://gitlab.com/nodiscc/toolbox/-/raw/master/DOC/SCREENSHOTS/5TXg6vm.png)](roles/tt_rss)
[![](https://gitlab.com/nodiscc/toolbox/-/raw/master/DOC/SCREENSHOTS/Jlmj0iE.png)](roles/shaarli)
[![](https://gitlab.com/nodiscc/toolbox/-/raw/master/DOC/SCREENSHOTS/8cAGkf2.png)](roles/gitea)
[![](https://gitlab.com/nodiscc/toolbox/-/raw/master/DOC/SCREENSHOTS/Imb0dqO.png)](roles/transmission)
[![](https://gitlab.com/nodiscc/toolbox/-/raw/master/DOC/SCREENSHOTS/6Im61B0.png)](roles/mumble)
[![](https://gitlab.com/nodiscc/toolbox/-/raw/master/DOC/SCREENSHOTS/REzcZVh.png)](roles/openldap)
[![](https://gitlab.com/nodiscc/toolbox/-/raw/master/DOC/SCREENSHOTS/udEAnKA.png)](roles/matrix)
[![](https://gitlab.com/nodiscc/toolbox/-/raw/master/DOC/SCREENSHOTS/Vvdj3Zu.png)](roles/homepage)
[![](https://gitlab.com/nodiscc/toolbox/-/raw/master/DOC/SCREENSHOTS/H3PIWrt.png)](roles/jellyfin)
[![](https://gitlab.com/nodiscc/toolbox/-/raw/master/DOC/SCREENSHOTS/wa3pkyJ.png)](roles/graylog)
[![](https://gitlab.com/nodiscc/toolbox/-/raw/master/DOC/SCREENSHOTS/g0jUMXE.jpg)](roles/jitsi)
[![](https://gitlab.com/nodiscc/toolbox/-/raw/master/DOC/SCREENSHOTS/v3lHJGx.png)](roles/readme_gen)
[![](https://gitlab.com/nodiscc/toolbox/-/raw/master/DOC/SCREENSHOTS/XYmHNqT.png)](roles/libvirt)
[![](https://gitlab.com/nodiscc/toolbox/-/raw/master/DOC/SCREENSHOTS/goaccess-bright-thumb.png)](roles/monitoring/goaccess)
[![](https://gitlab.com/nodiscc/toolbox/-/raw/master/DOC/SCREENSHOTS/owncast-thumb.png)](roles/owncast)
[![](https://gitlab.com/nodiscc/toolbox/-/raw/master/DOC/SCREENSHOTS/searxng-thumb.png)](roles/searxng)
[![](https://gitlab.com/nodiscc/toolbox/-/raw/master/DOC/SCREENSHOTS/nmap-thumb.png)](roles/nmap)
[![](https://gitlab.com/nodiscc/toolbox/-/raw/master/DOC/SCREENSHOTS/stirlingpdf-thumb.png)](roles/stirlingpdf)
[![](https://gitlab.com/nodiscc/toolbox/-/raw/master/DOC/SCREENSHOTS/moodist-thumb.png)](roles/moodist)
[![](https://gitlab.com/nodiscc/toolbox/-/raw/master/DOC/SCREENSHOTS/kiwix2_thumb.png)](roles/kiwix)
[![](https://gitlab.com/nodiscc/toolbox/-/raw/master/DOC/SCREENSHOTS/ollama-ui-thumb.png)](roles/ollama)


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
- [List of all tags](docs/tags.md)
- [Maintenance](docs/maintenance.md)
- [Contributing](docs/contributing.md)
- [Appendices](docs/appendices.md)
- [Changelog](https://gitlab.com/nodiscc/xsrv/-/blob/master/CHANGELOG.md)



