# Change Log

All notable changes to this project will be documented in this file.  
The format is based on [Keep a Changelog](http://keepachangelog.com/).


-------------------------------


#### [v0.15](https://gitlab.com/nodiscc/xsrv/-/releases#0.15) - 2020-02-08


**Changed**

* defaults: playbook: disable all role by default except common, backup, monitoring. Users should manually enable any additional roles for their own needs
* defaults: firewall: only allow access to services from LAN (except SSH)
* defaults: lamp: add a reverseproxy directive for gitea
* move rsyslog configuration tasks from common role to monitoring role
* lamp: move all logs to single access.log, error.log files, use combined log format
* monitoring: rsyslog: log *all* messages to /var/log/rsyslog
* xsrv: upgrade ansible to 2.9.3, rename show-defaults command to help-defaults
* doc: update help and documentation
* tests: improve tests coverage

**Added**

* add Gitea self-hosted Git service/software forge role
* lamp/apache: allow defining custom reverse proxies in configuration
* add update_todo makefile target (build a list of TODOs from gitea issues)
* monitoring: let rsyslog monitor gitea and netdata logs
* common: ssh: make tcp forwarding restrictions configurable, default to no forwarding allowed

**Removed**

* monitoring: remove obsolete rsyslog 'discard' rule

**Fixed**

* tt-rss: fix backups output directory, do not overwrite database with blank schema when db is already initialized, fix missing become directive, fix permissions on ansible facts files
* monitoring: fix idempotence of SSL certificate generation tasks, remove obselete rsyslog 'discard' rule
* fix ansible-lint, yamllint and shellcheck warnings
* nextcloud: fix rsnapshot output directory
* fix ansible-galaxy roles metadata
* add missing licenses

-------------------------------


#### [v0.14](https://gitlab.com/nodiscc/xsrv/-/releases#0.13) - 2020-01-20

**Added**

- new feature: [Tiny Tiny RSS feed reader](https://gitlab.com/nodiscc/ansible-xsrv-tt-rss)
- monitoring: upgrade netdata to [1.19.0](https://github.com/netdata/netdata/releases/tag/v1.19.0)
- backup: (optional) auto-backup tt-rss database if tt-rss role is installed
- nextcloud: add Notes app

**Changed**

- monitoring: decrease frequency of apache status checks to 10 seconds (decrease log spam)
- update documentation
- backup: decrease rsnapshot verbosity/log level to 'verbose'
- nextcloud: update calendar app to 2.0.0, set a random database password by default, disable recommendations app
- lamp: use NCSA combined log format
- xsrv: update ansible to 2.8.8, work on the first host from the playbook - don't error on multiple hosts

**Fixed**

- nextcloud: fix content-security-policy header when nextcloud is not installed in the default location
- nextcloud: backup: only backup the nextcloud database not all mysql databases, fix fail2ban jail configuration file permissions


-------------------------------


#### [v0.13](https://gitlab.com/nodiscc/xsrv/-/releases#0.13) - 2020-01-14

<!--
**Changed**
**Added**
**Removed**
**Fixed**
**Security**
**Deprecated**
-->

This is a rewrite of https://github.com/nodiscc/srv01 with better separation of components, documentation, testing, simplified configuration, instalaltion and usage. An archive of the old repository is attached.