
# Change Log

All notable changes to this project will be documented in this file.
The format is based on [Keep a Changelog](http://keepachangelog.com/).

#### [v1.10.0](https://gitlab.com/nodiscc/xsrv/-/releases#1.10.0) - UNRELEASED

**Upgrade procedure:**
- `xsrv upgrade` to upgrade roles/ansible environments to the latest release
- **common:** if the variable `os_security_kernel_enable_core_dump` was changed from its default value in your hosts/groups configuration, rename it to `kernel_enable_core_dump`
- **openldap: self-sevice-password:** If you changed the value of [`self_service_password_allowed_hosts`](https://gitlab.com/nodiscc/xsrv/-/blob/master/roles/openldap/defaults/main.yml) in your host/groups configuration (`xsrv edit-host/edit-groups`), update it to the YAML list format, instead of a list of addresses separated by spaces:

```yaml
# old format
self_service_password_allowed_hosts: "10.0.0.0/8 192.168.0.0/16 172.16.0.0/12"
# new format
self_service_password_allowed_hosts:
  - 10.0.0.0/8
  - 192.168.0.0/16
  - 172.16.0.0/12
```

**Added:**
- add [jitsi](https://gitlab.com/nodiscc/xsrv/-/tree/master/roles/jitsi) role - video conferencing solution
- add [`xsrv open`](https://xsrv.readthedocs.io/en/latest/usage.html#provision-hosts) command (open the project directory in the default file manager)
- apache: automatically load new Let's Encrypt certificates every minute, manually reloading the server is no longer needed
- nextcloud: allow configuration of nextcloud log level, default app on login ([`nextcloud_loglevel`/`nextcloud_defaultapp`](https://gitlab.com/nodiscc/xsrv/-/blob/master/roles/nextcloud/defaults/main.yml))
- common: kernel: hardening: allow hiding processes from other users ([`kernel_proc_hidepid: no/yes`](https://gitlab.com/nodiscc/xsrv/-/blob/master/roles/common/defaults/main.yml))
- shaarli: add ability to install the python API client ([`shaarli_setup_python_client: no/yes`](https://gitlab.com/nodiscc/xsrv/-/blob/master/roles/shaarli/defaults/main.yml)) and export all shaarli data to a JSON file every hour
- wireguard: add ability to enable/disable the wireguard server service ([`wireguard_enable_service: yes/no`](https://gitlab.com/nodiscc/xsrv/-/blob/master/roles/wireguard/defaults/main.yml))
- monitoring/netdata: allow disabling notifications for ping check alarms ([`netdata_fping_alarms_silent: yes/no`](https://gitlab.com/nodiscc/xsrv/-/blob/master/roles/monitoring_netdata/defaults/main.yml))
- apache/monitoring: netdata: monitor state of the php-fpm service and alert in case of failure
- apache: start/stop the php7.4-fpm service alongside the apache service depending on `apache_enable_service: yes/no`
- shaarli: add required packages for LDAP authentication
- monitoring_netdata: add `utils-autorestart` tag (reboot hosts if required after a kernel update, will only run if the `utils-autorestart` tag is explicitly called)
- samba: add `utils-samba-listusers` tag (list samba users)

**Removed:**
- tt_rss: remove installation of custom plugins/themes

**Changed:**
- nextcloud: no longer disable accessibility app by default
- nextcloud: disable the web updater
- nextcloud: disable link to https://nextcloud.com/signup/ on public pages
- nextcloud: backup: add `config.php` to the list of files to backup (may contain the encryption secret if encryption was enabled by the admin)
- openldap: self-service-password: use a YAML list to define [`self_service_password_allowed_hosts`](https://gitlab.com/nodiscc/xsrv/-/blob/master/roles/openldap/defaults/main.yml), instead of a string with addresses separated by spaces
- common: kernel: rename variable `os_security_kernel_enable_core_dump` -> [`kernel_enable_core_dump`](https://gitlab.com/nodiscc/xsrv/-/blob/master/roles/common/defaults/main.yml)
- common: kernel/sysctl: ensure ipv4/ipv6 configuration is applied to all new/future interfaces as well
- common: kernel/sysctl: don't disable USB storage, audio input/output, USB MIDI, bluetooth and camera modules by default
- common: kernel/sysctl: don't disable audio input/output module by default
- common: kernel/sysctl: don't disable bluetooth modules by default
- common: kernel/sysctl: don't disable camera modules by default
- common: kernel/sysctl: don't disable `vfat` `squashfs` filesystems module by default
- common: dns: check that valid IP addresses are specified in [`dns_nameservers`](https://gitlab.com/nodiscc/xsrv/-/blob/master/roles/common/defaults/main.yml)
- common: kernel/sysctl: load all sysctl variables, not just those in `custom.conf`
- wireguard: firewalld: setup firewall to allow blocking/allowing traffic from VPN clients to services on the host, independently
- nextcloud: update to [v24.0.6](https://nextcloud.com/blog/maintenance-releases-24-0-6-and-23-0-10-are-out-plus-5th-beta-of-our-upcoming-release/)
- gitea: update to [v1.17.3](https://github.com/go-gitea/gitea/releases/tag/v1.17.3)
- openldap: update self-service-password to [v1.5.2](https://github.com/ltb-project/self-service-password/releases/tag/v1.5.2)
- graylog: update mongodb to v4.4
- rocketchat: upgrade to [v3.18.7](https://raw.githubusercontent.com/RocketChat/Rocket.Chat/develop/HISTORY.md)
- cleanup: replace deprecated `apt_key/apt_repository` modules, install all APT keys in `/usr/share/keyrings/`
- general cleanup and maintenance
- update documentation
- update/improve test tooling

**Fixed:**
- shaarli: fix shaarli unable to save thumbnails to disk
- shaarli: fix broken link (HTTP 403) to documentation
- jellyfin: fix jellyfin unable to upgrade on machines migrated from Debian 10 -> 11
- common: kernel/sysctl: don't disable `vfat` module required by EFI boot
- graylog: fix installation of elasticsearch packages
- monitoring/netdata: fix individual alarms for failed systemd services
- common: firewalld: add all addresses from `192.168.0.0/16` to the `internal` zone by default, not just `192.168.0.0/24`

**Security:**
- jellyfin: only allow connections from LAN (RFC1918) IP addresses by default ([`jellyfin_allowed_hosts`](https://gitlab.com/nodiscc/xsrv/-/blob/master/roles/jellyfin/defaults/main.yml))


[Full changes since v1.9.0](https://gitlab.com/nodiscc/xsrv/-/compare/1.9.0...1.10.0)

-------------------------------

#### [v1.9.0](https://gitlab.com/nodiscc/xsrv/-/releases#1.9.0) - 2022-09-18

**Upgrade procedure:**
- `xsrv self-upgrade` to upgrade the xsrv script
- `xsrv upgrade` to upgrade roles/ansible environments to the latest release
- **gitea:** if you rely on custom git hooks for your projects, set `gitea_enable_git_hooks: yes` in the host configuration/vars file (`xsrv edit-host`)
- `xsrv deploy` to apply changes

**Added:**
- xsrv: add [`xsrv init-vm-template`](https://xsrv.readthedocs.io/en/latest/usage.html#provision-hosts) command (create a libvirt Debian VM template, unattended using a preconfiguration file)
- add [wireguard](https://gitlab.com/nodiscc/xsrv/-/tree/master/roles/wireguard) role - fast and modern VPN server
- nextcloud: enable [group folders](https://apps.nextcloud.com/apps/groupfolders) app by default
- common: allow setting up [apt-listbugs](https://packages.debian.org/bullseye/apt-listbugs) to prevent installation of packages with known serious bugs ([`apt_listbugs: yes/no`](https://gitlab.com/nodiscc/xsrv/-/blob/master/roles/common/defaults/main.yml))
- common: allow specifying a list of packages to install/remove ([`packages_install/remove`](https://gitlab.com/nodiscc/xsrv/-/blob/master/roles/common/defaults/main.yml))
- gitea: allow enabling/disabling git hooks and webhooks features globally ([`gitea_enable_git_hooks/webhooks`](https://gitlab.com/nodiscc/xsrv/-/blob/master/roles/gitea/defaults/main.yml))
- gitea: allow configuring the list of hosts that can be called from webhooks ([`gitea_webhook_allowed_hosts`](https://gitlab.com/nodiscc/xsrv/-/blob/master/roles/gitea/defaults/main.yml))
- gitea: allow configuring the SSH port exposed in the clone URL ([`gitea_ssh_url_port`](https://gitlab.com/nodiscc/xsrv/-/blob/master/roles/gitea/defaults/main.yml))

**Removed:**
- common: remove `setup_cli_utils` and `setup_haveged` variables. Use [`packages_install/remove`](https://gitlab.com/nodiscc/xsrv/-/blob/master/roles/common/defaults/main.yml) instead.

**Changed:**
- gitea: disable git hooks by default
- gitea: upgrade to v1.17.2 [[1]](https://github.com/go-gitea/gitea/releases/tag/v1.16.9) [[2]](https://github.com/go-gitea/gitea/releases/tag/v1.17.0) [[3]](https://github.com/go-gitea/gitea/releases/tag/v1.17.1) [[4]](https://github.com/go-gitea/gitea/releases/tag/v1.17.2)
- openldap: update self-service-password to v1.5.1 [[1]](https://github.com/ltb-project/self-service-password/releases/tag/v1.5.0) [[2]](https://github.com/ltb-project/self-service-password/releases/tag/v1.5.1)
- nextcloud: upgrade to v24.0.5 [[1]](https://nextcloud.com/blog/maintenance-releases-24-0-3-23-0-7-and-22-2-10-are-out-update/) [[2]](https://nextcloud.com/changelog/#latest24)
- postgresql: update pgmetrics to [v1.13.1](https://github.com/rapidloop/pgmetrics/releases/tag/v1.13.1)
- shaarli: hardening: run shaarli under a dedicated `shaarli` user account (don't use the default shared `www-data` user)
- xsrv: upgrade ansible to [v6.4.0](https://github.com/ansible-community/ansible-build-data/blob/main/6/CHANGELOG-v6.rst)
- nextcloud/netdata: mitigate frequent httpckeck alarms on the nextcloud web service response time (`httpcheck_web_service_unreachable`), increase the timeout of the check to 3s
- common: sysctl: automatically reboot the host after 60 seconds in case of kernel panic
- common: hardening: ensure `/var/log/wtmp` is not world-readable
- common: login/ssh: hardening: kill user processes when an interactive user logs out (except for root). Lock idle login sessions after 15 minutes of inactivity.
- common: ssh: hardening: replace the server's default 2048 bits RSA keypair with 4096 bits keypair
- common: sudo: hardening: configure sudo to run processes in a pseudo-terminal
- common: users/pam: hardening: increase the number of rounds for hashing group passwords
- common: sysctl: hardening: only allow root/users with CAP_SYS_PTRACE to use ptrace
- common: sysctl: hardening: disable more kernel modules by default (bluetooth, audio I/O, USB storage, USB MIDI, UVC/V4L2/CPIA2 video devices, thunderbolt, floppy, PC speaker beep)
- common: sysctl: hardening: restrict loading TTY line disciplines to the CAP_SYS_MODULE capability
- common: sysctl: hardening: protect against unintentional writes to an attacker-controlled FIFO
- common: sysctl: hardening: prevent even the root user from reading kernel memory maps
- common: sysctl: hardening: enable BPF JIT hardening
- common: sysctl: hardening: disable ICMP redirect support for IPv6
- all roles: require `ansible-core>=2.12/ansible>=6.0.0`
- common: improve check mode support before first deployment
- tools/tests: improve/simplify test tools

**Fixed:**
- common: users: fix errors during creation fo `sftponly` user accounts when no groups are defined in the user definition

[Full changes since v1.8.1](https://gitlab.com/nodiscc/xsrv/-/compare/1.8.1...1.9.0)

-------------------------------

#### [v1.8.1](https://gitlab.com/nodiscc/xsrv/-/releases#1.8.0) - 2022-07-10

**Upgrade procedure:**
- `xsrv upgrade` to upgrade roles/ansible environments to the latest release
- `xsrv deploy` to apply changes

**Fixed:**
- backup/rsnapshot: fix rsnapshot installation, always install from Debian repositories

[Full changes since v1.8.0](https://gitlab.com/nodiscc/xsrv/-/compare/1.8.0...1.8.1)

-------------------------------

#### [v1.8.0](https://gitlab.com/nodiscc/xsrv/-/releases#1.8.0) - 2022-07-04

**Upgrade procedure:**
- `xsrv self-upgrade` to upgrade the xsrv script
- `xsrv upgrade` to upgrade roles/ansible environments to the latest release
- **gitea/gotty/graylog/homepage/jellyfin/nextcloud/openldap/rocketchat/rss_bridge/shaarli/transmission/tt_rss:** ensure the `apache` role or equivalent is explicitly deployed to the host *before* deploying any of these roles.
- **jellyfin/samba:** if both jellyfin and samba roles are deployed on the same host, ensure `samba` is deployed before `jellyfin` ([`xsrv edit-playbook`](https://xsrv.readthedocs.io/en/latest/usage.html#xsrv-edit-playbook))
- **valheim_server:** if you are using the [`valheim_server`](https://gitlab.com/nodiscc/xsrv/-/tree/1.7.0/roles/valheim_server) role, update `requirements.yml` (`xsrv edit-requirements`) and `playbook.yml` ([`xsrv edit-playbook`](https://xsrv.readthedocs.io/en/latest/usage.html#xsrv-edit-playbook)) to use the archived [`nodiscc.toolbox.valheim_server`](https://gitlab.com/nodiscc/toolbox/-/tree/master/ARCHIVE/ANSIBLE-COLLECTION) role instead.
- `xsrv deploy` to apply changes

**Added:**
- add [`mail_dovecot`](https://gitlab.com/nodiscc/xsrv/-/tree/master/roles/mail_dovecot) role - IMAP mailbox server
- monitoring: netdata: allow streaming charts data/alarms to/from other netdata nodes ([`netdata_streaming_*`](https://gitlab.com/nodiscc/xsrv/-/blob/master/roles/monitoring_netdata/defaults/main.yml))
- monitoring: netdata: enable monitoring of hard drives SMART status
- xsrv: add [`xsrv ssh`](https://xsrv.readthedocs.io/en/latest/usage.html#command-line-usage) subcommand (alias for `shell`)
- openldap: allow secure LDAP communication over SSL/TLS on port 636/tcp (use a self-signed certificate)
- common: allow disabling PAM/user accounts configuration tasks ([`setup_users: yes/no`](https://gitlab.com/nodiscc/xsrv/-/blob/master/roles/common/defaults/main.yml))
- common: allow blacklisting unused/potentially insecure kernel modules ([`kernel_modules_blacklist`](https://gitlab.com/nodiscc/xsrv/-/blob/master/roles/common/defaults/main.yml)), disable unused network/firewire modules by default
- common: automatically remove (purge) configuration files of removed packages, nightly, enabled by default ([`apt_purge_nightly: yes/no`](https://gitlab.com/nodiscc/xsrv/-/blob/master/roles/common/defaults/main.yml))
- common: attempt to automatically repair (fsck) failed filesystems on boot
- docker: allow enabling automatic firewall/iptables rules setup by Docker ([`docker_iptables: no/yes`](https://gitlab.com/nodiscc/xsrv/-/blob/master/roles/docker/defaults/main.yml))
- docker: install requirements for logging in to private docker registries
- openldap: self-service-password/ldap-account-manager: make LDAP server URI configurable ([`*_ldap_url`](https://gitlab.com/nodiscc/xsrv/-/blob/master/roles/openldap/defaults/main.yml))
- openldap: ldap-account-manager: allow specifying a trusted LDAPS server certificate ([`ldap_account_manager_ldaps_cert`](https://gitlab.com/nodiscc/xsrv/-/blob/master/roles/openldap/defaults/main.yml))
- samba: make events logged by full_audit configurable ([`samba_log_full_audit_success_events`](https://gitlab.com/nodiscc/xsrv/-/blob/master/roles/samba/defaults/main.yml))
- shaarli: add an option to configure thumbnail generation mode ([`shaarli_thumbnails_mode`](https://gitlab.com/nodiscc/xsrv/-/blob/master/roles/shaarli/defaults/main.yml)) and default number of links per page (`shaarli_links_per_page`, default 30)
- postgresql: download pgmetrics report to the controller when running `TAGS=utils-pgmetrics`
- all roles: checks: add an info message pointing to roles documentation when one or more variables are not correctly defined
- xsrv: [`xsrv help-tags`](https://xsrv.readthedocs.io/en/latest/usage.html#command-line-usage) will now parse tag descriptions from custom roles in `roles/` in addition to collections
- monitoring: utils: add `iputils-ping` package (ping utility)

**Removed:**
- common: firewalld/mail/msmtp: drop compatibilty with Debian 10
- valheim_server: remove role, [archive](https://gitlab.com/nodiscc/toolbox/-/tree/master/ARCHIVE/ANSIBLE-COLLECTION) it to separate repository (installs non-free components)

**Changed:**
- netdata: needrestart: don't send e-mail notifications for needrestart alarms
- netdata: debsecan: refresh debsecan reports every 6 hours instead of every hour
- netdata: disable metrics gathering for `/dev` and `/dev/shm` virtual filesystems
- all roles: checks all variables values *before* failing, when one or more variables are not correctly defined
- tt_rss: don't send feed update errors by mail, log them to syslog
- xsrv: always use the first host/group in alphabetical order when no host/group is specified
- xsrv: upgrade ansible to [v5.10.0](https://github.com/ansible-community/ansible-build-data/blob/main/5/CHANGELOG-v5.rst)
- apache/proxmox: only setup fail2ban when it is marked as managed by ansible through ansible local facts
- common: ssh: increase the frequency of "client alive" messages to 1 every 5 minutes
- common: ssh/users: don't allow login for users without an existing home directory
- apache: rsyslog: prefix apache access logs with `apache-access:` in syslog when [`apache_access_log_to_syslog: yes`](https://gitlab.com/nodiscc/xsrv/-/blob/master/roles/apache/defaults/main.yml)
- homepage: improve homepage styling/layout, link directly to `ssh://` and `sftp://` URIs
- homepage: reword default [`homepage_message`](https://gitlab.com/nodiscc/xsrv/-/blob/master/roles/homepage/defaults/main.yml)
- shaarli: default to generating thumbnails only for common media hosts
- transmission: firewall: always allow bittorrent peer traffic from the public zone
- monitoring_utils: lynis: review and whitelist unapplicable "suggestion" level report items ([`lynis_skip_tests`](https://gitlab.com/nodiscc/xsrv/-/blob/master/roles/monitoring_utils/defaults/main.yml))
- nextcloud: upgrade to v24.0.1 [[1]](https://nextcloud.com/blog/nextcloud-hub-24-is-here/) [[2]](https://nextcloud.com/blog/maintenance-releases-24-0-1-23-0-5-and-22-2-8-are-out-update/) [[3]](https://nextcloud.com/changelog/#latest23)
- gitea: upgrade to v1.16.8 [[1]](https://github.com/go-gitea/gitea/releases/tag/v1.16.6) [[2]](https://github.com/go-gitea/gitea/releases/tag/v1.16.7) [[3]](https://github.com/go-gitea/gitea/releases/tag/v1.16.8)
- openldap: ldap-account-manager: upgrade to [v7.9.1](https://www.ldap-account-manager.org/lamcms/node/446)
- rss_bridge: upgrade to [v2022-06-14](https://github.com/RSS-Bridge/rss-bridge/releases/tag/2022-06-14)
- postgresql: update pgmetrics to [v1.13.0](https://github.com/rapidloop/pgmetrics/releases/tag/v1.13.0)
- gitea/gotty/graylog/homepage/jellyfin/nextcloud/openldap/rocketchat/rss_bridge/shaarli/transmission/tt_rss: remove hard dependency on apache role
- cleanup: proxmox: use a single file to configure proxmox APT repositories
- cleanup: apache: ensure no leftover mod-php installations are present
- cleanup: common: users: move PAM configuration to the main `limits.conf` configuration file
- cleanup/tools: improve `check` mode support, standardize task names, remove unused template files, make usage of ansible_facts consistent in all roles, clarify xsrv script, reorder functions by purpose/component, automate documentation generation, improve tests/release procedure, automate initial check mode/deployment/idempotence tests
- update documentation

**Fixed:**
- xsrv: `init-project`: fix inventory not correctly initialized
- xsrv: fix `xsrv shell/fetch-backups` when a non-default `XSRV_PROJECTS_DIR` is specified by the user
- common: ssh: fix confusion between `AcceptEnv` and `PermitUserEnvironment` settings
- all roles: monitoring/netdata: fix systemd services health checks not loaded by netdata
- apache: monitoring/rsyslog: fix rsyslog config installation when running with only `--tags=monitoring`
- graylog: fix elasticsearch/graylog unable to start caused by too strict permissions on configuration files
- openldap: ldap-account-manager: fix access to tree view
- homepage: fix homepage generation when the mumble role was deployed from a different play
- jellyfin/samba: fix jellyfin [samba share](https://gitlab.com/nodiscc/xsrv/-/blob/master/roles/jellyfin/defaults/main.yml) creation when samba role is not part of the same play
- samba: fix [`samba_passdb_backend: ldapsam`](https://gitlab.com/nodiscc/xsrv/-/blob/master/roles/samba/defaults/main.yml#L39) mode when openldap role is not part of the same play
- xsrv: [`fetch-backups`](https://xsrv.readthedocs.io/en/latest/usage.html#command-line-usage): use the first host in alphabetical order, when no host is specified
- monitoring: rsyslog: add correctness checks for `syslog_retention_days` variable
- monitoring: netdata/needrestart: fix `needrestart_autorestart_services` value not taken into account when true
- shaarli/transmission: fix `*_https_mode` variable checks
- doc: fix broken links

**Security:**
- proxmox: fail2ban: fix detection of failed login attempts

[Full changes since v1.7.0](https://gitlab.com/nodiscc/xsrv/-/compare/1.7.0...1.8.0)

-------------------------------

#### [v1.7.0](https://gitlab.com/nodiscc/xsrv/-/releases#1.7.0) - 2022-04-22

**Upgrade procedure:**
- `xsrv self-upgrade` to upgrade the xsrv script
- `xsrv upgrade` to upgrade roles/ansible environments to the latest release
- this upgrade will cause Nextcloud instances to go down for a few minutes, depending on the number of files in their data directory

**Added:**
- xsrv: add [`init-vm`](https://xsrv.readthedocs.io/en/latest/usage.html#command-line-usage) command (initialize a ready-to-deploy libvirt VM from a template)
- xsrv: add [`edit-group-vault`](https://xsrv.readthedocs.io/en/latest/usage.html#command-line-usage) command (edit encrypted group variables file)
- common: make cron jobs log level configurable ([`cron_log_level`](https://gitlab.com/nodiscc/xsrv/-/blob/master/roles/common/defaults/main.yml))
- common: apt: clean downloaded package archives every 7 days by default ([`apt_clean_days`](https://gitlab.com/nodiscc/xsrv/-/blob/master/roles/common/defaults/main.yml))
- netdata: allow configuring the [fping](https://learn.netdata.cloud/docs/agent/collectors/fping.plugin) plugin (ping hosts/measure loss/latency) ([`netdata_fping_*`](https://gitlab.com/nodiscc/xsrv/-/blob/master/roles/monitoring_netdata/defaults/main.yml))
- netdata: make netdata filechecks configurable ([`netdata_file_checks`](https://gitlab.com/nodiscc/xsrv/-/blob/master/roles/monitoring_netdata/defaults/main.yml))
- transmission/gotty/jellyfin/docker: monitoring/netdata: raise alarms when corresponding systemd services are in the failed state (and the `monitoring_netdata` role is deployed)
- homepage: add rss-bridge to the homepage when the rss_bridge role is deployed on the host
- add ansible [tags](https://xsrv.readthedocs.io/en/latest/usage.html#command-line-usage): `netdata-modules`, `netdata-needrestart`, `netdata-debsecan`, `netdata-logcount`, `netdata-config`

**Changed:**
- common: sysctl/security: disable potentially exploitable unprivileged BPF and user namespaces
- gitea: limit systemd service automatic restart attempts to 4 in 10 seconds
- gitea: update to v1.16.5 [[1]](https://github.com/go-gitea/gitea/releases/tag/v1.16.1) [[2]](https://github.com/go-gitea/gitea/releases/tag/v1.16.2) [[3]](https://github.com/go-gitea/gitea/releases/tag/v1.16.3) [[4]](https://github.com/go-gitea/gitea/releases/tag/v1.16.4) [[5]](https://github.com/go-gitea/gitea/releases/tag/v1.16.5)
- gotty: attempt to restart the systemd service every 2 seconds in case of failure, for a maximum of 4 times in 10 seconds
- netdata: disable more internal monitoring charts (plugin execution time, webserver threads CPU)
- netdata: re-add default netdata alarms for the `systemdunits` module
- nextcloud: update to v23.0.3 [[1]](https://nextcloud.com/blog/update-now-23-0-2-22-2-5-and-21-0-9/) [[2]](https://nextcloud.com/blog/nextcloud-23-0-3-and-22-2-6-are-out-bringing-a-series-of-bug-fixes-and-improvements/)
- nextcloud: run nextcloud PHP processes under a dedicated `nextcloud` user, if an older installation owned by `www-data` is found, it will be migrated to the new user automatically
- openldap: update LDAP Account Manager to [v8.0.1](https://github.com/LDAPAccountManager/lam/releases)
- rocketchat: update to [v3.18.4](https://github.com/RocketChat/Rocket.Chat/releases)
- apache/fail2ban/nextcloud: remove obsolete workaround for nextcloud [desktop client issue](https://github.com/nextcloud/server/issues/15688)
- xsrv: store group_vars files under `group_vars/$group_name/` (allows multiple vars files per group). If a `group_vars/$group_name.yml` file is found, it will be moved to the subdirectory automatically.
- xsrv: update ansible to [v5.5.0](https://github.com/ansible-community/ansible-build-data/blob/main/5/CHANGELOG-v5.rst)
- cleanup: make netdata assembled configuration more readable (add blank line delimiters)
- cleanup: standardize file names
- all roles: check that variables are correctly defined before running roles
- tests: ansible-lint: ignore `fqcn-bultins,truthy,braces,line-length` rules
- tests: remove broken jinja2 syntax test
- tests: remove obsolete `ansible-playbook --syntax-check` and `yamllint` tests, replaced by ansible-lint
- tests: automate tests for `init-vm`, `xsrv check`, `xsrv deploy`
- doc: update documentation, default playbook README, Gitlab CI example


**Fixed:**
- all roles: ensure `check` mode doesn't fail when running it before before first deployment
- common: ssh/users: fix SFTP-only user accounts creation (set permissions _after_ creating user accounts)
- all roles: firewall: fix 'reload firewall/fail2ban/apache' handlers failures when called from other roles
- openldap: fix ldap-ccount-manager installation on Debian 11 (php package name changes)
- graylog: fix graylog service not starting/incorrect permissions on configuration files
- graylog/mumble: monitoring/netdata: fix healthcheck/alarm not returning correct status when systemd services are in the failed state
- netdata: fix location for needrestart module configuration file
- netdata: fix/standardize indentation in configuration files produced by `to_nice_yaml`
- homepage: fix homepage templating when the homepage role is not part of the same play as related roles
- shaarli: explicitly use php 7.4 packages, fix possible installation problems on Debian 11
- tests: fix and speed up `ansible-lint` tests, fix ansible-lint warnings

[Full changes since v1.6.0](https://gitlab.com/nodiscc/xsrv/-/compare/1.6.0...1.7.0)

-------------------------------

#### [v1.6.0](https://gitlab.com/nodiscc/xsrv/-/releases#1.6.0) - 2022-03-17

**Upgrade procedure:**
- `xsrv self-upgrade` to upgrade the xsrv script
- `xsrv upgrade` to upgrade roles in your playbook to the latest release

**Added:**
- add [rss_bridge](https://gitlab.com/nodiscc/xsrv/-/tree/master/roles/rss_bridge) role - the RSS feed for websites missing it
- monitoring_utils: install [debsums](https://packages.debian.org/sid/debsums) utility for the verification of packages with known good database (by default, run weekly)
- common: cron: allow disabling cron setup (`setup_cron: yes/no`)
- monitoring_netdata: allow configuring netdata notification downtime periods (start/end)
- tests: automate basic testing of the xsrv command-line tool (`xsrv init-project xsrv-test my.example.org`)

**Changed:**
- common: cron: include the FDQN in subject when sending mail
- common: cron: log beginning and end of cron jobs
- all roles: replace netdata process checks/alarms with more accurate systemd unit checks, raise alarms/notifications when a service is in the failed state
- cleanup: standardize task names
- xsrv: init-project: allow adding a first host directly using `xsrv init-project [project] [host]`

**Fixed:**
- fix `check` mode support for self-signed certificate generation tasks/netdata configuration
- apt: fix automatic upgrades for packages installed from Debian Backports
- xsrv: fix error on new project creation/`init-playbook` - missing playbook directory
- xsrv: fix support for `XSRV_PROJECTS_DIR` environment variable

[Full changes since v1.5.0](https://gitlab.com/nodiscc/xsrv/-/compare/1.5.0...1.6.0)

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
- xsrv: add [`xsrv help-tags`](https://xsrv.readthedocs.io/en/latest/usage.html#command-line-usage) subcommand (show the list of ansible tags in the play and their descriptions)
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
- common/graylog: apt: enable automatic upgrades for graylog/mongodb/elasticsearch packages by default ([`apt_unattended_upgrades_origins_patterns`](https://gitlab.com/nodiscc/xsrv/-/blob/master/roles/common/defaults/main.yml#L48))
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

[Full changes since v1.4.0](https://gitlab.com/nodiscc/xsrv/-/compare/1.4.0...1.5.0)

-------------------------

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
- tools: improve automatic documentation generation
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

[Full changes since v1.3.1](https://gitlab.com/nodiscc/xsrv/-/compare/1.3.1...1.4.0)

------------------------

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

[Full changes since v1.3.0](https://gitlab.com/nodiscc/xsrv/-/compare/1.3.0...1.3.1)

----------------------------

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
- monitoring/rsyslog: add ability forward logs to a remote syslog/graylog server over TCP/SSL/TLS (add [`rsyslog_enable_forwarding`, `rsyslog_forward_to_hostname` and `rsyslog_forward_to_port`]([`apt_unattended_upgrades_origins_patterns`](https://gitlab.com/nodiscc/xsrv/-/blob/master/roles/monitorign_rsyslog/defaults/main.yml)) variables)
- jellyfin/common/apt: enable automatic upgrades for jellyfin by default ([`apt_unattended_upgrades_origins_patterns`](https://gitlab.com/nodiscc/xsrv/-/blob/master/roles/common/defaults/main.yml#L48))
- monitoring: support all [httpcheck](https://github.com/netdata/go.d.plugin/blob/master/config/go.d/httpcheck.conf) parameters in [`netdata_http_checks`](https://gitlab.com/nodiscc/xsrv/-/blob/master/roles/monitoring_netdata/defaults/main.yml)
- monitoring/netdata: add [`netdata_x509_checks`](https://gitlab.com/nodiscc/xsrv/-/blob/master/roles/monitoring_netdata/defaults/main.yml) (list of x509 certificate checks, supports all [x509check](https://github.com/netdata/go.d.plugin/blob/master/config/go.d/x509check.conf) parameters)
- rocketchat: allow disabling rocketchat/mongodb services (`rocketchat_enable_service: yes/no`)
- xsrv: add [`xsrv edit-group`](https://xsrv.readthedocs.io/en/latest/usage.html#command-line-usage) subcommand (edit group variables - default group: `all`)
- xsrv: add [`xsrv ls`](https://xsrv.readthedocs.io/en/latest/usage.html#command-line-usage) subcommand (list files in the playbooks directory - accepts a path)
- xsrv: add [`xsrv edit-requirements`](https://xsrv.readthedocs.io/en/latest/usage.html#command-line-usage) subcommand (edit ansible collections/requirements)
- xsrv: add [`xsrv edit-cfg`](https://xsrv.readthedocs.io/en/latest/usage.html#command-line-usage) subcommand (edit ansible configuration/`ansible.cfg`)
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

[Full changes since v1.2.2](https://gitlab.com/nodiscc/xsrv/-/compare/1.2.2...1.3.0)

-------------------------------

#### [v1.2.2](https://gitlab.com/nodiscc/xsrv/-/releases#1.2.2) - 2021-04-01

Upgrade procedure: `xsrv upgrade` to upgrade roles in your playbook to the latest release

**Fixed:**
 - samba: fix nscd default log level, update samba default log level

[Full changes since v1.2.1](https://gitlab.com/nodiscc/xsrv/-/compare/1.2.1...1.2.2)

---------------------------

#### [v1.2.1](https://gitlab.com/nodiscc/xsrv/-/releases#1.2.1) - 2021-04-01

Upgrade procedure: `xsrv upgrade` to upgrade roles in your playbook to the latest release

**Fixed:**
 - tt_rss: fix initial tt-rss schema installation (file has moved)

samba: fix nscd default log level, update samba default log level

[Full changes since v1.2.0](https://gitlab.com/nodiscc/xsrv/-/compare/1.2.0...1.2.1)

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

[Full changes since v1.1.0](https://gitlab.com/nodiscc/xsrv/-/compare/1.1.0...1.2.0)

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

[Full changes since v1.0.0](https://gitlab.com/nodiscc/xsrv/-/compare/1.0.0...1.1.0)

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
- delegate HTTP basic auth to apache, pass credentials to the backend transmission service (proxy-chain-auth)
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
