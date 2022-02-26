# Change Log

All notable changes to this project will be documented in this file.
The format is based on [Keep a Changelog](http://keepachangelog.com/).

-------------------------------

#### [v1.5.0](https://gitlab.com/nodiscc/xsrv/-/releases#1.5.0) - 2022-02-25

**Upgrade procedure:**
- `xsrv self-upgrade` to upgrade the xsrv script
- `xsrv upgrade` to upgrade roles in your playbook to the latest release
- `TAGS=utils-debian10to11 xsrv deploy` to upgrade your host's distribution from Debian 10 "Buster" to [Debian 11 "Bullseye"](https://www.debian.org/News/2021/20210814.html). Debian 10 compatibility will not be maintained after this release.
- **common/firewall:** remove `firehol_*` variables from your configuration. Roles from the `xsrv` collection will automatically insert their own rules, if firewalld is deployed. If you had custom firewall rules in place/not related to xsrv roles, please port them to the new [`firewalld` configuration](https://gitlab.com/nodiscc/xsrv/-/blob/master/roles/common/defaults/main.yml#L74))
- **common/hosts:** if the `hosts:` variable (hosts file entries) is used in your `host/group_vars`, rename it to  `host_file_entries`. If `setup_hosts` is used in your `host/group_vars`, rename it to `setup_hosts_file`.
- **mariadb:** if you had the `nodiscc.xsrv.mariadb` role enabled, migrate to PostgreSQL, or use the [archived `nodiscc.toolbox.mariadb` role](https://gitlab.com/nodiscc/toolbox/-/tree/master/ARCHIVE/ANSIBLE-COLLECTION).
- **gitea/nextcloud/tt_rss:** if any of these roles is listed in your playbook, ensure `nodiscc.xsrv.postgresql` is explicitly deployed before it.
- **jellyfin/proxmox/docker:** remove `jellyfin_auto_upgrade`, `proxmox_auto_upgrade` or `docker_auto_upgrade` variables from your configuration, if you changed the defaults. These settings are now controlled by the [`apt_unattended_upgrades_origins_patterns`](https://gitlab.com/nodiscc/xsrv/-/blob/master/roles/common/defaults/main.yml#L48) list, automatic upgrades are enabled by default for these components.
- **jellyfin/samba:** if you have both the `samba` and `jellyfin` roles enabled on a host, and want to keep using the jellyfin samba share for media storage, explicitly set `jellyfin_samba_share: yes` in the host's configuration variables.
- **monitoring:** remove `setup_monitoring_cli_utils: yes/no` and `setup_rsyslog: yes/no` variables from your configuration, if you changed the defaults. If you don't want monitoring utilities or rsyslog set up, enable individual `monitoring_netdata/rsyslog/utils` roles, instead of the global `monitoring` role.
- (optional) `xsrv check` to simulate changes.
- `xsrv deploy` to apply changes.

**Added:**
- add [dnsmasq](https://gitlab.com/nodiscc/xsrv/-/tree/master/roles/dnsmasq) lightweight DNS server role
- common: add [firewalld](https://firewalld.org/) firewall management tool
- common: apt: allow configuration of allowed origins for unattended-upgrades
- common: packages: add `at` task scheduler
- monitoring: netdata: allow disabling specific plugins (`netdata_disabled_plugins`), disable `ebpf` plugin by default
- monitoring: lynis: enable lynis installation and daily reports by default
- common: ssh: fix lynis warning FILE-7524 (ensure `/root/.ssh` is mode 0700)
- common: mail/msmtp: allow disabling SMTP authentication/LOGIN (`msmtp_auth_enabled`), allow disabling SMTP server TLS certificate verification completely (`msmtp_tls_certcheck: yes/no`)
- common: mail/msmtp: allow disabling TLS (`msmtp_tls_enabled`)
- monitoring: netdata: automate testing netdata mail notifications (`TAGS=utils-netdata-test-notifications xsrv deploy`)
- monitoring: netdata: monitor systemd units state (timers/services/sockets)
- docker: add a nightly cleanup of unused docker images/containers/networks/build cache, allow disabling it through `docker_prune_nighlty: no`
- xsrv: add `xsrv help-tags` subcommand (show the list of ansible tags in the play and their descriptions)
- install ansible local fact files for each deployed role/component

**Removed:**
- common: remove [firehol](https://firehol.org/) firewall management tool, remove `firehol_*` configuration variables
- common: firewall: remove ability to filter outgoing traffic, will be re-added later
- drop compatibility with Debian 9
- monitoring: remove `setup_monitoring_cli_utils: yes/no` and `setup_rsyslog: yes/no` variables
- common: fail2ban: remove `fail2ban_destemail` variable, always send mail to root
- mariadb: remove role, [archive](https://gitlab.com/nodiscc/toolbox/-/tree/master/ARCHIVE/ANSIBLE-COLLECTION) it to separate repository
- remove ansible tags `certificates lamp valheim valheim-server`

**Changed:**
- make all roles compatible with Debian 11
- common/firewall/all roles: let roles manage their own firewall rules if the `nodiscc.xsrv.firewalld` role is deployed
- all roles: refactor/performance: only flush handlers once, unless required otherwise, refactor service start/stop/enable/disable tasks
- common: fail2ban: ban offenders on all ports
- jellyfin: the jellyfin samba share automatic setup is now disabled by default (`jellyfin_samba_share_enabled: no`)
- apache/tt_rss/shaarli/nextcloud: make roles compatible with Debian 11 (PHP 7.4))
- jellyfin/proxmox/docker: remove `jellyfin_auto_upgrade`, `proxmox_auto_upgrade`, `docker_auto_upgrade` variables, add these origins to the default list of `apt_unattended_upgrades_origins_patterns`
- monitoring: split role to smaller `monitoring_rsyslog`/`monitoring_netdata`/`monitoring_utils` roles, make the `monitoring` role an alias for these 3 roles
- common: apt: explicitly install aptitude
- common: apt: remove unused packages after automatic upgrades
- common: apt: automatically remove unused dependency packages on every install/upgrade/remove operation
- common: fail2ban: increase maximum IP/attempts count retention to 1 year
- common: ssh: decrease SFTP logs verbosity to INFO by default
- common/graylog: apt: enable automatic upgrades for graylog/mongodb/elasticsearch packages by default
- gitea: upgrade to v1.16.0 [[1]](https://github.com/go-gitea/gitea/releases/tag/v1.15.8), [[2]](https://github.com/go-gitea/gitea/releases/tag/v1.15.9), [[3]](https://github.com/go-gitea/gitea/releases/tag/v1.15.10), [[4]](https://github.com/go-gitea/gitea/releases/tag/v1.15.11), [[5]](https://github.com/go-gitea/gitea/releases/tag/v1.16.0)
- xsrv: upgrade ansible to [5.2.0](https://github.com/ansible-community/ansible-build-data/blob/main/5/CHANGELOG-v5.rst)
- gitea: cleanup/maintenance: update config file comments/ordering to reduce diff with upstream example file
- apache: relax permissions on apache virtualhost config files (make them world-readable)
- nextcloud: upgrade to [23.0.1](https://nextcloud.com/changelog/#latest23) [[1]](https://nextcloud.com/blog/nextcloud-hub-2-brings-major-overhaul-introducing-nextcloud-office-p2p-backup-and-more/)
- nextcloud: add [Nextcloud Bookmarks](https://apps.nextcloud.com/apps/bookmarks) to the default list of apps (default disabled)
- xsrv/tools/doc: don't install python3-cryptography from pip, install from OS packages
- gitea/nextcloud/tt_rss: remove hard dependency on postgresql role
- openldap: remove hard dependency on common role
- transmission: log/show diff on configuration file changes
- netdata/docker: move `netdata_min/max_running_docker_containers` configuration variables to the `docker` role
- netdata: no longer install `python3-mysqldb`/mysql support packages
- mumble: force superuser password change task to *never* return "changed" (instead of always)
- doc: update documentation, document all ansible tags, refactor command-line usage doc
- refactoring: move fail2ban/samba/rsyslog/netdata/... tasks to separate task files inside each role
- tags: add `ssl` tag to all ssl-related tasks, add `rsnapshot-ssh-key` tag to all ssh-key-related tasks
- cleanup: remove unused tasks/improve deployment times

**Fixed:**
- fix integration between roles when roles are part of different plays: use ansible local facts installed by other roles to detect installed components, instead of checking the list of roles in the current play
- proxmox: fix missing ansible fact file template
- proxmox: fix APT configuration on Debian 10/11
- fix `check` mode compatibility issues, fix ansible-lint warnings
- common: ssh: fix creation of SFTP-only accounts (`bad ownership or modes for chroot directory`)
- common: ssh: ssh: fix root ssh logins when `ssh_permit_root_login: without-password/prohibit-password/forced-commands-only`
- monitoring: netdata: fix chart values incorrectly increased by 1 in debsecan module
- backup: fix mode/idempotence for `/root/.ssh` directory creation
- graylog: fix configuration file templating always returning changed in check mode
- default playbook/xsrv: fix invalid `"%%ANSIBLE_HOST%%"` value set by `xsrv init-host`
- common: hosts: fix warning: Found variable using reserved name: hosts


#### [v1.4.0](https://gitlab.com/nodiscc/xsrv/-/releases#1.4.0) - 2021-12-17

**Upgrade procedure:**
- `xsrv self-upgrade` to upgrade the xsrv script
- `xsrv upgrade` to upgrade roles in your playbook to the latest release
- `xsrv deploy` to apply changes
- (optional) `TAGS=debian10to11 xsrv deploy` to upgrade your host's distribution from Debian 10 "Buster" to [Debian 11 "Bullseye"](https://www.debian.org/News/2021/20210814.html)
- (optional) remove custom `netdata_modtime_checks` from your configuration, if any (the [modtime](https://github.com/nodiscc/netdata-modtime) module was removed, use the [filecheck](https://learn.netdata.cloud/docs/agent/collectors/go.d.plugin/modules/filecheck) module instead)


**Added:**
- add [proxmox](roles/proxmox) role (basic Proxmox VE hypervisor setup)
- add [valheim_server](roles/valheim_server) role (Valheim multiplayer game server)
- gitea: make number of issues per page configurable (`gitea_issue_paging_num` , increase to 20 by default)
- shaarli: make `hide_timestamp,header_link,debug,formatter` [settings](https://shaarli.readthedocs.io/en/master/Shaarli-configuration/) configurable
- monitoring: add [lynis](https://cisofy.com/lynis/) security audit tool (optional, default disabled), schedule a daily report
- monitoring/postgresql: allow netdata to monitor postgresql server
- docker: allow enabling unattended upgrades of docker engine packages (`docker_auto_upgrade: yes/no`)
- common: apt: allow enabling `contrib` and `non-free` software sections (`apt_enable_nonfree`)
- common: allow disabling hostname setup (`setup_hostname: yes/no`)
- common, monitoring: make roles compatible with Debian 11 "Bullseye"
- homepage: add link to graylog instance (when graylog role is enabled)
- monitoring: allow configuration of syslog retention duration, default to 186 days instead of 7
- monitoring: allow defining a number of maximum expected running docker containers (`netdata_max_running_docker_containers`)
- monitoring: add [logwatch](https://packages.debian.org/bullseye/logwatch) log analyzer, disable scheduled execution
- monitoring: install requirements for postgresql monitoring
- postgresql: add ability to enable/disable the service and enforce started/stopped/enabled/disabled state
- backup: make rsnapshot verbosity configurable
- backup: download rsnapshot's/root SSH public key to the controller (public_keys/ directory)
- common: allow configuring the list of users allowed to use `crontab` (`linux_users_crontab_allow`)
- common: add an procedure for Debian 10 -> 11 upgrades
- common: add ability to add/remove entries from the hosts (`/etc/hosts`) file

**Changed:**
- nextcloud: upgrade to [22.2.3](https://nextcloud.com/changelog/#latest22)
- nextcloud: silence cron/background tasks output to prevent mail notification spam
- nextcloud: allow installation of [ONLYOFFICE](https://nextcloud.com/onlyoffice/) realtime collaborative document edition tools
- gitea: upgrade to [1.15.7](https://github.com/go-gitea/gitea/releases)
- gitea update fail2ban [login failure detection](https://docs.gitea.io/en-us/fail2ban-setup/) for gitea v1.15+
- common: sysctl: disable IP source routing for IPv6 (was already disabled for IPv4)
- common: msmtp: check that configuration variables have correct values/types when `msmtp_setup: yes`
- monitoring: increate netdata charts retention duration to ~7 days
- monitoring: allow disabling needrestart/logcount/debsecan modules installation
- monitoring: decrease alarm sensitivity for logcount module (warning on 10 alarms/min, critical on 100 errors/min)
- monitoring: disable lynis checks AUTH-9283 and FIRE-4512 by default (false positives)
- monitoring: only enable "number of running docker container" checks when the nodiscc.xsrv.docker role is enabled
- monitoring: update configuration for netdata > 1.30
- backup, monitoring: replace custom [modtime](https://github.com/nodiscc/netdata-modtime) module with built-in netdata [filecheck](https://learn.netdata.cloud/docs/agent/collectors/go.d.plugin/modules/filecheck) module
- xsrv: rename top-level directory concept (playbook -> project)
- xsrv: logs: don't ask for sudo password if syslog is readable without it
- xsrv: switch to ansible "distribution" versioning, upgrade to [4.9.0](https://github.com/ansible-community/ansible-build-data/blob/main/4/CHANGELOG-v4.rst) ([ansible-core](https://github.com/ansible/ansible) 2.11.6), update playbook for compatibility
- xsrv: store virtualenv inside the project directory, improve startup time
- homepage: update theme (use light theme), use web safe fonts
- apache: make role compatible with Debian 11 "Bullseye"
- backup: make dependency on monitoring role optional
- backup: ensure only `root` can read the rsnapshot configuration file
- backup: re-schedule monthly backups at 04:01 on the first day of the month
- all roles/monitoring: apply role-specific netdata/rsyslog configuration immediately after installing it
- default playbook: .gitignore data/ and cache/ directories
- doc: update/refactor documentation and roles metadata
- tools: improve automatic doc generation
- refactor: refactor integration between roles (use ansible_local facts, fix intergation when roles are not part of the same play)

**Removed:**
- nextcloud: disable [deck](https://apps.nextcloud.com/apps/deck) app by default

**Fixed:**
- homepage: really update page title from `homepage_title` variable
- jellyfin: use `samba_shares_path` variable to determine samba shares path
- nextcloud: fix upgrade procedure order (upgrade incompatible apps)
- nextcloud: fix `check` mode on upgrades
- graylog: respect `elasticsearch_timeout_start_sec` value
- monitoring: netdata: enable gzip compression on web server responses, fix empty dashboard
- monitoring: fix netdata modtime module installation, remove obsolete tasks file
- monitoring: rsyslog: ensure that requirements for self-signed certificates generation are installed
- monitoring: ensure requirements for self-signed certificate generation are installed
- monitoring: also allow access to netdata.conf from `netdata_allow_connections_from` addresses
- monitoring: fix APT package manager logs aggregation to syslog
- tt_rss: fix permission denied errors when updating feeds
- homepage: fix grid responsiveness on mobile devices
- transmission: don't attempt to reload the service when it is disabled in host configuration
- don't ignore expected errors when not running in check mode

**Security:**
- nextcloud: fail2ban: fix log file location/login failures not detected by fail2ban
- common: automatically apply security updates for packages installed from Debian Backports


#### [v1.3.1](https://gitlab.com/nodiscc/xsrv/-/releases#1.3.1) - 2021-06-24

**Upgrade procedure:**
- `xsrv upgrade` to upgrade roles in your playbook to the latest release
- `xsrv deploy` to apply changes

**Fixed:**
- common: msmtp: fix msmtp unable to read /etc/aliases (`/etc/aliases: line 1: invalid address`)
- common: msmtp: fix unreadable /etc/msmtprc configuration for un privileged users
- nextcloud/apache/php: fix path to PHP APCU configuration file (really fix `cannot allocate memory` errors on nextcloud upgrades)
- tt_rss: fix/automate initial database population and schema upgrades, update documentation

**Added:**
- common: msmtp: allow disabling STARTTLS (`msmtp_starttls: yes/no`)
- backup: rsnapshot: don't update timestamp file after weekly/monthly backups (monitoring only measures time since the last successful **daily** backup)

**Changed:**
- nextcloud: upgrade to 20.0.10
- update documentation (virt-manager/add basic VM provisioning procedure)



#### [v1.3.0](https://gitlab.com/nodiscc/xsrv/-/releases#1.3.0) - 2021-06-08

**Upgrade procedure:**
- `xsrv self-upgrade` to upgrade the xsrv script to the latest release
- `xsrv upgrade` to upgrade roles in your playbook to the latest release
- if you had defined custom `netdata_http_checks`, port them to the new [`netdata_http_checks`/`netdata_x509_checks`](https://gitlab.com/nodiscc/xsrv/-/blob/master/roles/monitoring/defaults/main.yml#L64) syntax
- (optional/cleanup) `xsrv edit-vault`: remove all `vault_` prefixes from encrypted host variables; `xsrv edit-host`: remove all variables that are just `variable_name: {{ vault_variable_name }}` references
- (optional/cleanup) remove previous hardcoded/default `netdata_modtime_checks` and `netdata_process_checks` from your host variables
- (optional) `xsrv check` to simulate and review changes
- `xsrv deploy` to apply changes

**Removed:**
- default playbook: remove hardcoded `netdata_modtime_checks` and `netdata_process_checks` (roles will automatically configure relevant checks)
- default playbook/all roles: remove `variable_name: {{ vault_variable_name }}` indirections/references
- monitoring/netdata: remove ability to configure netdata modules git clone URLs (`netdata_*_git_url` variables), always clone from upstream
- monitoring/netdata: remove support for `check_x509` parameter in `netdata_httpchecks`
- monitoring/rsyslog: remove hardcoded, service-specific configuration

**Added:**
- add [graylog](https://gitlab.com/nodiscc/xsrv/-/tree/master/roles/graylog) log analyzer role
- add [gotty](https://gitlab.com/nodiscc/xsrv/-/tree/master/roles/gotty) role
- monitoring/rsyslog: add ability forward logs to a remote syslog/graylog server over TCP/SSL/TLS (add `rsyslog_enable_forwarding`, `rsyslog_forward_to_hostname` and `rsyslog_forward_to_port` variables)
- jellyfin/common/apt: add automatic upgrades for jellyfin, enable by default
- monitoring: support all [httpcheck](https://github.com/netdata/go.d.plugin/blob/master/config/go.d/httpcheck.conf) parameters in `netdata_http_checks`
- monitoring/netdata: add `netdata_x509_checks` (list of x509 certificate checks, supports all [x509check](https://github.com/netdata/go.d.plugin/blob/master/config/go.d/x509check.conf) parameters)
- rocketchat: allow disabling rocketchat/mongodb services (`rocketchat_enable_service: yes/no`)
- xsrv: add `xsrv edit-group` subcommand (edit group variables - default group: `all`)
- xsrv: add `xsrv ls` subcommand (list files in the playbooks directory - accepts a path)
- xsrv: add `edit-requirements` subcommand (edit ansible collections/requirements)
- xsrv: add `edit-cfg` subcommand (edit ansible configuration/`ansible.cfg`)
- xsrv: add syntax highlighting to default text editor/pager (nano - requires manual installation of yaml syntax highlighting file), improve display
- homepage: add favicon
- common: msmtp: make outgoing mail port configurable (`msmtp_port`, default `587`)

**Changed:**
- gitea: enable API by default (`gitea_enable_api`)
- gitea: upgrade gitea to 1.14.2
- openldap: upgrade ldap-account-manager to 7.5
- nextcloud: upgrade nextcloud to 21.0.2
- rocketchat: update rocket.chat to 3.15.0
- homepage: switch to a responsive grid layout
- monitoring: decrease logcount warning alarm sensitivity, warn when error rate >= 10/min
- monitoring/all roles: let roles install their own syslog aggregation settings, if the `nodiscc.xsrv.monitoring` role is enabled.
- monitoring/needrestart: by default, automatically restart services that require it after a security update (`needrestart_autorestart_services: yes`)
- monitoring/netdata/default playbook: let roles install their own HTTP/x509/modtime/port checks under `/etc/netdata/{python,go}.d/$module_name.conf.d/*.conf`, if the `nodiscc.xsrv.monitoring` role is enabled
- apache/common/mail: forward all local mail from `www-data` to `root` - allows `root` to receive webserver cron jobs output
- apache/monitoring: disable aggregation of access logs to syslog by default, add variable allowing to enable it (`apache_access_log_to_syslog`)
- common: cron: ensure only root can access cron job files and directories (CIS 5.1.2 - 5.1.7)
- common: ssh: lower maximum concurrent unauthenticated connections to 60
- common/mail: don't overwrite `/etc/aliases`, ensure `root` mail is forwarded to the configured user (set to `ansible_user` by default)
- docker: speed up role execution - dont't force APT cache update when not necessary
- transmission: disable automatic backups of the downloads directory by default, add `transmission_backup_downloads: yes/no` variable allowing to enable it
- rocketchat/monitoring: disable HTTP check when rocketchat service is explicitly disabled in the configuration
- mumble/checks: ensure that `mumble_welcome_text` is set
- transmission/jellyfin: allow jellyfin to read/write transmission downloads directory
- tools: add Pull Request template, speed up Gitlab CI test suite (prebuild an image with required tools)
- update ansible tags
- update roles metadata, remove coupling/dependencies between roles unless strictly required, make `nodiscc.xsrv.common` role mostly optional
- xsrv: cleanup/reorder/DRY/refactoring, make `self-upgrade` safer
- doc: update documentation/formatting, fix manual backup command, fix ssh-copy-id instructions


**Fixed:**
- jellyfin: fix automatic samba share creation
- common: fix `linux_users` creation when no `authorized_ssh_keys`/`sudo_nopasswd_commands` are defined
- common: users: allow creation of `linux_users` without a password (login to these user accounts will be denied, SSH login with authorized keys are still possible if the user is in the `ssh` group)
- samba: fix error on LDAP domain creation
- nextcloud: fix condition for dependency on postgresql role
- nextcloud: fix `allowed memory size exhausted` during nextcloud upgrades
- openldap: fix condition for dependency on apache role
- rsyslog: fix automatic aggregation fo fail2ban logs to syslog
- rocketchat: fix automatic backups when the service is disabled
- samba/rsnapshot/gitea: fix role when runing in 'check' mode, fix idempotence
- tools: fix release procedure/ansible-galaxy collection publication
- xsrv: fix wrong inventory formatting after running `xsrv init-host`
- remove unused/duplicate/leftover task files
- fix typos

**Security:**
- common: fail2ban: fix bantime for ssh jail (~49 days)

-------------------------------

#### [v1.2.2](https://gitlab.com/nodiscc/xsrv/-/releases#1.2.2) - 2021-04-01

Upgrade procedure: `xsrv upgrade` to upgrade roles in your playbook to the latest release

**Fixed:**
 - samba: fix nscd default log level, update samba default log level


#### [v1.2.1](https://gitlab.com/nodiscc/xsrv/-/releases#1.2.1) - 2021-04-01

Upgrade procedure: `xsrv upgrade` to upgrade roles in your playbook to the latest release

**Fixed:**
 - tt_rss: fix initial tt-rss schema installation (file has moved)

samba: fix nscd default log level, update samba default log level


-------------------------------

#### [v1.2.0](https://gitlab.com/nodiscc/xsrv/-/releases#1.2.0) - 2021-03-27

**Added:**
- homepage: add configurable message/paragraph to homepage (homepage_message)
- add ability to configure multiple aliases/valid domain names for the homepage virtualhost (homepage_vhost_aliases: [])
- nextcloud: improve performance (auto-add missing primary keys/indices in database, convert columns to bigint)

**Removed:**
- openldap: remove `self_service_password_keyphrase` variable (unused since tokens/SMS/question based password resets are disabled)
- common: ssh: cleanup/remove unused `MatchGroup rsyncasroot` directive

**Changed:**
- common: sysctl: enable logging of martian packets
- common: sysctl: ensure sysctl settings also apply to all network interfaces added in the future
- common: ssh: set loglevel to VERBOSE by default
- samba: increase log level, enable detailed authentication success/failure logs, clarify log prefix
- update documentation

**Fixed:**
- rocketchat: fix role idempotence (ownership of data directories)

**Security:**
- rocketchat: fix port 3001 exposed on 0.0.0.0 instead of localhost-only/firewall bypass
- gitea: update to v1.13.6


-------------------------------

#### [v1.1.0](https://gitlab.com/nodiscc/xsrv/-/releases#1.1.0) - 2021-03-14

**Added:**
- xsrv: add self-upgrade command
- monitoring: add [netdata-debsecan](https://gitlab.com/nodiscc/netdata-debsecan) module
- common: ensure NTP service is started
- common: make timezone configurable (default to not touching the timezone)
- openldap: add [Self Service Password](https://ltb-project.org/documentation/self-service-password) password reset tool (fixes #401)
  - requires manual configuration of `self_service_password_fqdn` and `vault_self_service_password_keyphrase`
  - auto-configure apache and `selfsigned` or `letsencrypt` certificates + php-fpm.
  - by default only allow access from LAN/private addresses in `self_service_password_allowed_hosts`
  - when samba role is enabled, use the LDAP admin DN to access the directory (required to be able to change `sambaNtPassword` attribute)
  - make various settings configurable, add correctness checks for all variables
- openldap: make log level configurable
- homepage: add jellyfin/self-service-password links (when relevant roles/variables are enabled)
- jellyfin: add LDAP authentication documentation
- jellyfin: add fail2ban configuration/bruteforce prevention on jellyfin login attempts
- jellyfin/backup: add automatic backups (only backup db/metadata/configuration by default, allow enabling media directory backups with `jellyfin_enable_media_backups`)
- jellyfin: create subdirectories for each library type under the default media directory/jellyfin samba share
- samba/backup: allow disabling automatic backups of samba shares (`samba_enable_backups`)
- shaarli/monitoring: aggregate data/log.txt to syslog using the imfile module

**Changed:**
- update documentation (upgrade procedure, example playbook, mirrors, TOC, links, ansible-collection installation, list of all variables, ansible.cfg, sysctl settings...)
- openldap: upgrade ldap-account-manager to v7.4 (https://www.ldap-account-manager.org/lamcms/changelog)
- openldap: prevent LDAP lookups for local user accounts
- openldap: decrease log verbosity
- gitea: upgrade to 1.13.3 - https://github.com/go-gitea/gitea/releases
- nextcloud: upgrade to 20.0.8 - https://nextcloud.com/changelog/

**Fixed:**
- xsrv: fix show-defaults command (by default display all role defaults for the default playbook)
- homepage: fix mumble and ldap-account-manager links
- samba: fix duplicate execution of the openldap role when samba uses LDAP passdb backend
- rocketchat: fix variable checks not being run before applying the role
- rocketchat: fix permissions/ownership of mongodb/rocketchat data directories
- tt_rss: fix error 'Please set SELF_URL_PATH to the correct value detected for your server'
- samba/jellyfin: fix automatic jellyfin samba share creation, fix permissions on jellyfin samba share
- monitoring: fix ansible --check mode when netdata is not installed yet
- shaarli: set apache directoryindex to index.php, prevent error messages in logs at every page access

**Tools/maintenance:**
- Makefile: add a make changelog target (print commits since last tag)
- Makefile: automate release procedure `make release`
- tt-rss: cleanup/grouping
- roles/*/defaults/main.yml: add header for all defaults files
- upgrade ansible to 2.10.7 - https://pypi.org/project/ansible/#history
- move TODOs to issues


-------------------------------


#### [v1.0.0](https://gitlab.com/nodiscc/xsrv/-/releases#1.0.0) - 2021-02-12

This is a major rewrite of https://github.com/nodiscc/srv01. To upgrade/migrate from previous releases, you must redeploy services to a new instance, and restore user data from backups/exports.

This releases improves usability, portability, standards compliance, separation of concerns, performance, documentation, security, simplifies installation and usage, and adds new features to all roles/components. A summary of changes is included below. See [README.md](README.md) for more information.

**xsrv command-line tool**
- improve/simplify command-line usage, see `xsrv help`
- refactor main script/simplify/cleanup
- use pwgen (optional) to generate random passwords during host creation
- make installation to $PATH and use of sudo optional
- use ansible-galaxy collections for role upgrades method


**example playbook: refactor:**
- add examples for playbook, inventory, group_vars and host_vars (cleartext and vaulted) files
- disable all but essential roles by default. Additional roles should be enabled manually by the admin
- firewall: by default, allow incoming traffic for netdata dashboard from LAN (monitoring role is enabled by default)
- firewall: by default, allow incoming SSH from anywhere (key-based authentication is enabled so this is reasonably secure)
- firewall: by default, allow HTTP/HTTPS access from anywhere (required for let's encrypt http-01 challenge, and apache role is enabled by default)
- firewall: change the default policy for the 'global' firehol_network definition to RETURN (changes nothing in the default configuration, makes adding other network definitions easier)
- doc: add firewall examples for all services (only from LAN by default)
- doc: add example .gitlab-ci.yml
- ansible/all roles: use ansible-vault as default storage for sensitive values
- ansible: use .ansible-vault-password as vault password file
- ansible: speed up ansible SSH operations using controlmaster and pipelining SSH options
- host_vars: add a netdata check for successful daily backups
- host_vars: add netdata process checks for ssh, fail2ban, ntp, httpd, sql
- host_vars: auto-restart services by default when needrestart detects a restart is required
- remove unused directories, cleanup


**common: refactor role:**
- import from https://gitlab.com/nodiscc/ansible-xsrv-common
- unattended-upgrades: allow automatic upgrades from stable-updates repository
- unattended-upgrades: install apt-listchanges (mail with a summary of changes will be sent to the server admin)
- add ansible_user_allow_sudo_rsync_nopasswd option (allow ansible user to run sudo rsync without password)
- msmtp: require manual configuration of msmtp host/username/password (if msmtp installation is enabled)
- dns: add ability to configure multiple DNS nameservers in /etc/resolv.conf
- packages: enable haveged installation by default
- packages: don't install pwgen/secure-delete/autojump by default, add man package
- sshd: remove deprecated UsePrivilegeSeparation option
- sshd: make ssh server log level, PasswordAuthentication, AllowTcpForwarding and PermitRootLogin options configurable
- sshd: fix accepted environment variables LANG,LC_* accepted from the client
- sshd: explicitly deny AllowTcpForwarding, AllowAgentForwarding, GatewayPorts and X11Forwarding for the sftponly group
- sshd: add curve25519-sha256@libssh.org KexAlgorithm
- firewall: add an option to generate firewall rules compatible with docker swarm routing/port forwarding
- firewall: allow outgoing mail submission/port 587 by default
- firewall: make firewall config file only readable by root
- firewall: use an alias/variable to define LAN IP networks, templatize
- firewall/fail2ban: prevent firehol from overwriting fail2Ban rules, remove interaction/integration between services, split firewall/fail2ban configuration tasks, add ability to disable both
- fail2ban: make more settings configurable (destination e-mail, default findtime/maxretry/bantime)
- users: simplify management, remove *remotebackup* options/special remotebackup user/tasks
- users: linux_users is now compatible with ansible users module syntax, with added ssh_authorized_keys and sudo_nopasswd_commands parameters
- users: fix user password generation (use random salt, make task idempotent by setting update_password: on_create by default)
- users: ensure ansible user home is not world-readable


**monitoring: refactor role:**
- import from https://gitlab.com/nodiscc/ansible-xsrv-monitoring
- netdata: add ssl/x509 expiration checks, make http check timeout value optional, default to 1s)
- netdata: allow installation from deb packages/packagecloud APT repository, make it the default
- netdata: decrease frequency of apache status checks to 10 seconds (decrease log spam)
- netdata: disable access logs and debug logs by default (performance), add netdata_disable_*_log variables to configure it
- netdata: disable cloud/SaaS features by default, add netdata_cloud_enabled variable to configure it
- netdata: disable web server gzip compression since we only use ssl
- netdata: install and configure https://gitlab.com/nodiscc/netdata-logcountmodule, disable notifications by default
- netdata: install and configure https://gitlab.com/nodiscc/netdata-modtime module
- netdata: make dbengine disk space size and memory page cache size configurable
- netdata: monitor mysql server if mariadb role is enabled (add netdata mysql user)
- netdata: add default configuration for health notifications
- netdata: upgrade to latest stable release
- rsyslog: aggregate all log messages to `/var/log/syslog` by default
- rsyslog: monitor samba, gitea, mumble-server, openldap, nextcloud, unattended-upgrades and rsnapshot log files with imfile module (when corresponding roles are enabled)
- rsyslog: make aggregation of apache access logs to syslog optional, disable by default
- rsyslog: disable aggregation of netdata logs to syslog by default (very noisy, many false-positive ERROR messages)
- rsyslog: discard apache access logs caused by netdata apche monitoring
- needrestart: don't auto-restart services by default
- extend list of command-line monitoring tools (lsof/strace)
- various fixes, reorder, cleanup, update documentation, fix role/certificate generation idempotence, make more components optional


**backup role**
- import from https://gitlab.com/nodiscc/ansible-xsrv-backup
- auto-load rsnapshot configuration from /etc/rsnapshot.d/*.conf, remove hardcoded xsrv* roles integration
- check rsnapshot configuration after copying files
- restrict access to backups directory to root only
- redirect cron job stdout to /dev/null, only send errors by mail
- write rsnapshot last success time to file (allows monitoring the time since last successful backup)
- store ssh public key to ansible facts (this will allow generating a human readable document/dashboard with hosts information)

**lamp role: refactor:**
- import from https://gitlab.com/nodiscc/ansible-xsrv-lamp
- split lamp role to separate apache and mariadb roles


**apache role:**
- import/refactor/split role from https://gitlab.com/nodiscc/ansible-xsrv-lamp
- use apache mod-md for Let's Encrypt certificate generation, remove certbot and associated ansible tasks
- switch to php-fpm interpreter, remove mod_php
- switch to mpm_event, disable mpm_worker
- switch to HTTP2
- remove ability to create custom virtualhosts
- remove automatic homepage generation feature (will be split to separate role)
- enforce fail2ban bans on HTTP basic auth failures
- set the default log format to `vhost_combined` (all vhosts to a single file)
- rename cert_mode variable to https_mode
- don't enable mod-deflate by default
- add variable apache_allow_robots (allow/disabllow robots globally, default no)
- add hard dependency on common role
- update doc, cleanup, formatting, add screenshot
- require manual configuration of the letsencrypt admin email address
- disable X-Frame-Options header as Content-Security-Policy frame-ancestors replaces/obsoletes it
- disable setting a default Content-Security-Policy, each application is responsible for setting an appropriate CSP
- mark HTTP->HTTPS redirects as permanent (HTTP code 301)
- exclude /server-status from automatic HTTP -> HTTPS redirects
- ensure the default/fallback vhost is always the first in load order, raise HTTP error 403 and autoindex:error when accessing the default vhost


**nextcloud: refactor role:**
- import from https://gitlab.com/nodiscc/ansible-xsrv-nextcloud
- determine appropriate setup procedure depending on whether nextcloud is already installed or not, installed version and current role version (installation/upgrades are now idempotent)
- add support for let's encrypt certificates (use mod_md when nextcloud_rss_https_mode: letsencrypt. else generate self-signed certificates)
- use ansible local fact file to store nextcloud installed version
- ensure correct/restrictive permissions are set
- support postgresql as database engine, make it the default
- move apache configuration steps to separate file, add full automatic virtualhost configuration for nextcloud
- reorder setup procedure (setup apache last)
- enable additional php modules https://docs.nextcloud.com/server/16/admin_manual/installation/source_installation.html#apache-web-server-configuration
- reload apache instead of restarting when possible
- make basic settings configurable through ansible (FQDN, install directory, full URL, share_folder...)
- require manual configuration of nextcloud FQDN
- enforce fail2ban bans on nextcloud login failures
- upgrade nextcloud to latest stable version (https://nextcloud.com/changelog)
- upgrade all nextcloud apps to latest compatible versions
- make installed/enabled applications configurable
- enable APCu memcache
- gallery app replaced with photos app
- optional integration with backup role, delegate database backups to the respective database role (mariadb/postgresql)
- add deck, notes, admin_audit and maps apps
- add php-fpm configuration
- run background jobs via cron every 5 minutes

**Migrating Nextcloud data to Postgresql from a MySQL-based installation:**

```bash
# migration is manual
# files: login nextcloud desktop client to your account on the old server, wait for complete file synchronization (eg. to ~/Nextcloud)
#        deploy the new server, create equivalent accounts
#        from nextcloud desktop, login a new/secondary account to the new server, synchronize to another directory (eg. ~/Nextcloud2)
#        from desktop, move files from ~/Nextcloud to ~/Nextcloud2
# calendar/tasks: from the old server's https://old.EXAMPLE.org/nextcloud/index.php/apps/calendar/, export calendars as ICS from the "..." menu
#                 from the new server's https://cloud.EXAMPLE.org/index.php/apps/calendar/, import ICS file from the "Import" menu
# contacts: from the old server's https://old.EXAMPLE.org/nextcloud/index.php/apps/contacts/, export contacts as VCF from the "..." menu
#           from the new server's https://cloud.EXAMPLE.org/index.php/apps/contacts/, import VCF file from the "Import" menu > Local file
# update all desktop/mobile clients to use the new URL/account (DAVx5, thunderbird...)
```

**tt-rss: refactor role:**
- import from https://gitlab.com/nodiscc/ansible-xsrv-tt-rss
- add support for postgresql databases, make it the default (config variable tt_rss_db_type)
- add support for postgresql backups/dumps
- make backup role fully optional, check rsnapshot configuration after copying config file
- delegate database backups to the respective database role (mariadb/postgresql)
- add support for let's encrypt certificates (use mod_md when tt_rss_https_mode: letsencrypt)
- make log destination configurable, default to blank/PHP/webserver logs
- update config.php template (remove deprecated feed_crypt_key setting)
- require manual configuration of admin username and tt-rss FQDN/URL
- standardize component installation order (backups/fail2ban/database first)
- simplify ansible_local.tt_rss.db_imported, always set to true
- do not use a temporary file to store admin user credentials, run mysql command directly from tasks
- add support for letsencrypt certificates/virtualhost configuration (mod_md). add tt_rss_https_mode: selfsigned/letsencrypt, move tasks to separate files
- mark plugins/themes setup tasks as unmaintained, move to separate yml files
- simplify file permissions setup/make idempotent
- update documentation
- simplify domain name/install directory/full URL templating
- rename role to `tt_rss`
- add php-fpm configuration
- various fixes, cleanup, reordering

**Migrating tt-rss data to Postgresql from a MySQL-based installation:**

```bash

# on the original machine
# OPML import/export (including filters and some settings). Must be done before data_migration plugin if you want to keep feed categories
sudo mkdir /var/www/tt-rss/export
sudo chown -R www-data:www-data /var/www/tt-rss/export/
sudo -u www-data php /var/www/tt-rss/update.php --opml-export "MYUSERNAME /var/www/tt-rss/export/export-2020-08-07.opml" # export feeds OPML
# migrate all articles from mysql to postgresql
git clone https://git.tt-rss.org/fox/ttrss-data-migration
sudo chown -R root:www-data ttrss-data-migration/
sudo mv ttrss-data-migration/ /var/www/tt-rss/plugins.local/data_migration
sudo nano /var/www/tt-rss/config.php # enable data_migration in the PLUGINS array
sudo -u www-data php /var/www/tt-rss/update.php --data_user MYUSERNAME --data_export /var/www/tt-rss/export/export-2020-08-07.zip # export articles to database-agnostic format

# on a client
xsrv deploy # deploy tt-rss role
rsync -avP my.original.machine.org:/var/www/tt-rss/export/export-2020-08-07.zip ./ # download zip export
rsync -avP export-2020-08-07.zip my.new.machine.org: # upload zip export
rsync -avP my.original.machine.org:/var/www/tt-rss/export/export-2020-08-07.opml ./ # download opml export
# login to the new tt-rss instance from a browser, go to Preferences > Feeds, import OPML file

# on the target machine
git clone https://git.tt-rss.org/fox/ttrss-data-migration
sudo chown -R root:www-data ttrss-data-migration/
sudo mv ttrss-data-migration/ /var/www/rss.example.org/plugins.local/data_migration
sudo nano /var/www/rss.example.org/config.php # enable data_migration in the PLUGINS array
sudo mkdir /var/www/rss.example.org/export
sudo mv export-2020-08-07.zip /var/www/rss.example.org/export
sudo chown -R root:www-data /var/www/rss.example.org/export
sudo chmod -R g+rX /var/www/rss.example.org/export/
sudo -u www-data php /var/www/rss.example.org/update.php --data_user MYUSERNAME --data_import /var/www/rss.example.org/export/export-2020-08-07.zip # it can take a while
sudo rm -r /var/www/rss.example.org/export/ # cleanup

```

**gitea:**
- add gitea self-hosted software forge role (https://gitea.io/en-us/)
- import from https://gitlab.com/nodiscc/ansible-xsrv-gitea
- make backup role fully optional, check rsnapshot configuration after copying config file
- delegate database backups to the respective database role (mariadb/postgresql)
- make common settings configurable through ansible variables
- simplify domain name/location/root URL templating
- require manual configuration of gitea instance FQDN/URL, JWT secrets and internal token
- LFS JWT secret must not contain /+= characters
- only configure a subset of gitea settings in the configuration file, let gitea use defaut values for other settings
- disable displaying gitea version in footer
- upgrade gitea to latest stable version (https://github.com/go-gitea/gitea/releases)
- download binary from github.com instea of gitea.io
- download uncompressed binary to avoid handling xz decompression
- update configuration file template
- add support for self-signed and let's encrypt certificates through gitea_https_mode variable
- update documentation

**Migrating gitea data to Postgresql from a MySQL-based installation**

```bash
# To save some backup/restoration time and if you don't care about keeping system notices,
# Access https://$OLD_DOMAIN/gitea/admin/notices and 'Delete all notices'
# on the original machine, do a backup, and upgrade gitea to the target version
# if source and target versions do not match you will have to correct the database
# dump by hand to match the expected schema...

# download the binary from github
wget https://github.com/go-gitea/gitea/releases/download/v1.12.4/gitea-1.12.4-linux-amd64
# stop gitea
sudo systemctl stop gitea
# replace the gitea binary with the new version
sudo mv gitea-1.12.4-linux-amd64 /usr/local/bin/gitea
sudo chmod a+x /usr/local/bin/gitea
# run migrations
sudo -u gitea gitea -c /etc/gitea/app.ini convert
sudo -u gitea gitea -c /etc/gitea/app.ini migrate

# the dump command must be run from gitea's home directory
sudo su
export TMPDIR=/var/backups/gitea/
cd /var/backups/gitea/
# remove any old dumps
rm -rf gitea-dump*zip
# backup gitea data + database as postgresql dump
sudo -u gitea gitea dump -d postgres --tempdir /var/backups/gitea/ -c /etc/gitea/app.ini
# ensure your normal user account can read the backup file
chown $MY_USER /var/backups/gitea/gitea-dump-*.zip
```

```bash
# on the ansible controller
# download the backup file
rsync -avP $OLD_MACHINE:/var/backups/gitea/gitea-dump-*.zip ./
# upload the zip to the new machine
rsync -avP gitea-dump-*.zip $NEW_MACHINE:
# make sure gitea is deployed to the new machine
TAGS=gitea xsrv deploy
```

```bash
# on the new machine
# stop gitea
sudo systemctl stop gitea

# unarchive the backup zip to gitea's directory
sudo mkdir /var/lib/gitea/dump
sudo unzip gitea-dump-*.zip -d /var/lib/gitea/dump/
sudo chown -R gitea:gitea /var/lib/gitea/dump

# make the database dump in a directory readable by postgresql user
sudo mv /var/lib/gitea/dump/gitea-db.sql /var/lib/postgresql/
sudo chown postgres /var/lib/postgresql/gitea-db.sql

# edit the db dump to skip index creations when they already exist
sudo sed -i 's/CREATE INDEX/CREATE INDEX IF NOT EXISTS/g' /var/lib/postgresql/gitea-db.sql
sudo sed -i 's/CREATE UNIQUE INDEX/CREATE UNIQUE INDEX IF NOT EXISTS/g' /var/lib/postgresql/gitea-db.sql

# delete the gitea admin user created by ansible
# since it will conflict with the admin user from the database dump
sudo -u gitea psql --command="delete from public.user where name = '$gitea_admin_username';"
# must return DELETE 1

# restore the database dump
sudo -u postgres psql --echo-all --set ON_ERROR_STOP=on gitea < /var/lib/postgresql/gitea-db.sql

# fix sequence values
# https://github.com/go-gitea/gitea/issues/740
# https://github.com/go-gitea/gitea/issues/12511
# get a list of tables
sudo -u gitea psql -c '\dt' | cut -d " " -f 4
echo $tables # check that the list is correct
for table in $tables; do sudo -u gitea psql --echo-all -c "SELECT setval('${table}_id_seq', COALESCE((SELECT MAX(id) FROM \"$table\"), 0) + 1, false);"; done

# extract repositories zip file
sudo -u gitea bash -c ' \
  cd /var/lib/gitea/dump && \
  unzip gitea-repo.zip && \
  mv repos/* /var/lib/gitea/repos/'
sudo chown -R gitea:gitea /var/lib/gitea/repos/

# remove the backup zip, psql dump, and temporary extraction directory
sudo rm -r gitea-dump-*.zip /var/lib/postgresql/gitea-db.sql /var/lib/gitea/dump

# regenerate hooks
sudo -u gitea gitea admin regenerate hooks -c /etc/gitea/app.ini

# start gitea and watch logs until it has finished starting up
sudo systemctl start gitea
sudo lnav /var/log/syslog
```

```bash
# on the controller
# log in to the new instance with your old admin account
# go to https://$NEW_DOMAIN/user/settings/ ->
#   change username and e-mail address to match values provided by ansible (gitea_admin_username/e-mail)
# go to https://$NEW_DOMAIN/user/settings/account
#   change password to match value provided by ansible (gitea_admin_password)

# re-apply the playbook and check that it finishes without error
TAGS=gitea xsrv deploy

# Check that all gitea funtionality works
```


**shaarli: refactor role:**
- detect installed version from ansible fact file and appropriate install/upgrade procedure depending on installed version
- add apache configuration for shaarli, including Content-Security Policy and SSL/TLS certificate management with mod_md
- allow generation of sel-signed certificates
- make shaarli fqdn and installation directory configurable
- harden file permissions
- add rsnapshot configuration for shaarli backups
- auto-configure shaarli from ansible variables (name/user/password/timezone) + compute hash during installation
- by default, don't overwrite shaarli config when it already exists (rely on configuration from the web interface) (idempotence)
- require manual generation of shaarli password salt (40 character string)
- add documentation, add backup restoration procedure
- add role to example playbook (disabled by default)
- add php-fpm configuration
- upgrade shaarli to latest stable release (https://github.com/shaarli/Shaarli/releases)

**Migrating Shaarli data to a new installation**

```bash
# deploy shaarli
make deploy
# access https://old.CHANGEME.org/links/?do=export and export ALL links as HTML (without prepending instance URL to notes)
# access the new instance at https://links.CHANGEME.org/?do=import and import your HTML file
# you can also resynchronize thumbnails a https://links.CHANGEME.org/?do=thumbs_update
```

**transmission: refactor role:**
- install and configure transmission (most settings are left to their defaults)
- add ansible variables for username/password, service status, download directory, FQDN
- only let transmission web interface listen on 127.0.0.1
- settings.json is updates by the daemon on exit with current/user-defined settings, hence the role is not always idempotent
- configure an apache virtualhost for transmission
- add transmission_https_mode variable to configure SSL certificate generation (selfsigned/letsencrypt)
- add checks for required variables
- delegate HTTP basic auth to apache, pass credentials to the backend tranmission service (proxy-chain-auth)
- add rsnapshot configuration (backup transmission downloads and torrents cache)


**mumble: refactor role:**
- setup mumble-server (murmur)
- make server password, superuser password, allowping, max users, max bandwidth per client, server port and welcome text and service state configurable through ansible variables
- update documentation, add screenshot
- add rsnapshot configuration for automatic backups of mumble server data
- add fail2ban configuration for failed mumble logins


**postgresql role:**
- add basic postgresql role
- add optional integration with the backup role (automatic database backups)


**samba role:**
 - add samba file sharing server role (standalone mode)
 - make log level configurable
 - add support for internal (tdbsam) and LDAP user/group/password backends
 - make shares configurable through samba_shares variable
 - make tdbsam users configurable through samba_users variable
 - add rsnapshot backup configuration for samba
 - make shares available/browseable state configurable (default to yes)

 - update documentation

**docker role:**
 - add docker role (install and configure Docker container platform)
 - add ability to configure a docker swarm orchestrator (default to initialize a new swarm)

**homepage role:**
 - add a role to generate a basic webserver homepage listing URLs/commands to access deployed services
 - automatic apache virtualhost configuration and let's encrypt/self-signed certificate generation

**rocketchat role:**
 - add a role to deploy the rocket.chat instant messaging/communication software
 - deploy rocket.chat as a stack of docker swarm services
 - add apache cofiguration to proxy traffic from the host's apache instance, add let's encrypt/self-signed certificate generation tasks

**openldap role:**
 - add a role to install openldap server and optionally ldap-account-manager
 - preconfigure base DN, users and groups OUs,
 - add rsnapshot backup configuration
 - add apache configuration/host for ldap-account-managaer, add let's encrypt/self-signed certificate generation tasks
 - make ldap-account-manager configuration read-only (must be configured through ansible)
 - only allow access to ldap-account-manager from private IP addresses by default
 - add optional support for Samba domain/users/groups

**jellyfin role:**
- add a role to install the jellyfin media server
- require manual configuration of admin username/password and initial media directory
- create a default media directory in /var/lib/jellyfin/media + symlink from home directory to media directory

**tools, documentation, misc:**
- refactor and update documentation (clarify/cleanup/update/reorder/reword/simplify/deduplicate/move), add screenshots, add full setup guide
- manage all components from a single git repository
- publish roles and default playbook as ansible collection (https://galaxy.ansible.com/nodiscc/xsrv - use make publish_collection to build)
- add automated tests (ansible-lint, yamllint, shellcheck) for all roles, add ansible-playbook --syntax-check test
- add a test suite, add automatic tests with Gitlab CI (https://gitlab.com/nodiscc/xsrv/-/pipelines)
- remove pip install requirements (performed by xsrv script)
- change release/branching model to 'release" (latest stable release), 'X.Y.Z' (semantic versioning), 'master' (development version)
- automate TODO.md updates and version headers updates
- fully working ansible-playbook --check mode
- add checks for all mandatory variables
- explicitly define file permissions for all file copy/templating tasks
- add checks/assertions for all mandatory variables
- remove .gitignore, clean files generated by tests using 'make clean'
- improve/clarify logging, program output and help messages
- generate HTML documentation with sphinx+recommonmark, host on https://xsrv.readthedocs.io
- various fixes, cleanup, formatting
- update roles metadata
- upgrade ansible to latest stable version (https://github.com/ansible/ansible/blob/stable-2.10/changelogs/CHANGELOG-v2.10.rst)
