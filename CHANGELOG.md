# Change Log

All notable changes to this project will be documented in this file.  
The format is based on [Keep a Changelog](http://keepachangelog.com/).


-------------------------------


#### [v1.0](https://gitlab.com/nodiscc/xsrv/-/releases#1.0) - UNRELEASED

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
- sshd: explicitely deny AllowTcpForwarding, AllowAgentForwarding, GatewayPorts and X11Forwarding for the sftponly group
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
- rsyslog: make agregation of apache access logs to syslog optional, disable by default
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
- explicitely define file permissions for all file copy/templating tasks
- add checks/assertions for all mandatory variables
- remove .gitignore, clean files generated by tests using 'make clean'
- improve/clarify logging, program output and help messages
- generate HTML documentation with sphinx+recommonmark, host on https://xsrv.readthedocs.io
- various fixes, cleanup, formatting
- update roles metadata
- upgrade ansible to latest stable version (https://github.com/ansible/ansible/blob/stable-2.10/changelogs/CHANGELOG-v2.10.rst)
