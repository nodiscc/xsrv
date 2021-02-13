# All configuration variables

This is a list of all available configuration variables, and their default values. Copy any of these variables to `xsrv edit-host` (`host_vars` file), and edit its value there, then run `xsrv deploy` to apply changes.

```yaml
##### APACHE WEB SERVER #####

# yes/no: listen on port 80 (unencrypted HTTP)
# (all unencrypted requests will be redirected to HTTPS)
apache_listen_http: yes

# yes/no: ask search engines/bots that respect the X-Robots-Tag header not to crawl this webserver's sites
apache_allow_robots: no

# yes/no: start/stop the apache webserver, enable/disable it on boot
apache_enable_service: yes

# yes/no: enable mod_evasive for basic DoS protection
# This can interfere with legitimate traffic, so be wary if you decide to enable it
apache_enable_mod_evasive: no

# (optional) e-mail address to register a letsencrypt.org account
apache_letsencrypt_email: "{{ vault_apache_letsencrypt_email }}"


##### PHP-FPM INTERPRETER #####

# yes/no: enable/disable the default php-fpm pool (www)
# It is recommended to create separate pools for each application. Disabling the default pool saves some resources
# The default (www) pool is enabled by default as starting php-fpm without any pool defined will cause the service to fail
php_fpm_enable_default_pool: yes
##### RSNAPSHOT BACKUP SERVICE #####

# Backups storage directory (with traing slash!)
rsnapshot_backup_dir: "/var/backups/rsnapshot"

# Number of backup generations to keep
# for daily, weekly and monthly backups
rsnapshot_retain_daily: 6
rsnapshot_retain_weekly: 6
rsnapshot_retain_monthly: 6

# Commands to run before starting backups (database dumps, application exports...)
# Return codes different from 0 will cause the backup process to abort with an error
# These commands run as the 'rsnapshot' user locally.
# Use 'ssh user@host /path/to/script' to run scripts on remote hosts.
# - For local scripts, 'rsnapshot' user must have appropriate permissions to run the script
# - For remote backups, 'rsnapshot' user's SSH key must be authorized on the remote host, the remote user must have appropriate permissions to run the script
# Example:
# rsnapshot_backup_execs:
#   - 'ssh rsnapshot@srv01.example.org /opt/xsrv/nextcloud-mysql-dump.sh'
#   - 'ssh rsnapshot@srv02.example.org /opt/xsrv/ttrss-mysql-dump.sh'
#   - 'ssh rsnapshot@srv03.example.org /opt/xsrv/openldap-dump.sh'
#   - /opt/xsrv/nextcloud-mysql-dump.sh
rsnapshot_backup_execs: []

# Local files/directories to backup
# The 'rsnapshot' user must have read access to these directories
# Example:
# rsnapshot_local_backups:
#   - '/var/backup/mysql/nextcloud/'
#   - '/var/backups/mysql/ttrss/'
#   - '/var/backups/openldap/'
#   - '/var/lib/transmission-daemon/'
#   - '/var/www/my.example.org/links/data/'
#   - '/var/www/my.example.org/public/'
#   - '/etc/letsencrypt/'
#   - '/etc/ssl/private/'
rsnapshot_local_backups: []

# Remote files/directories to fetch. Parameters:
#    user: SSH username to connect with (must have read access to backup paths)
#    host: host address
#    path: file/directory path to backup
# Example:
# rsnapshot_remote_backups:
#   - { user: 'rsnapshot', host: 'srv01.example.org', path: '/var/backup/mysql/nextcloud/' }
#   - { user: 'rsnapshot', host: 'srv01.example.org', path: '/var/backups/mysql/ttrss/' }
#   - { user: 'rsnapshot', host: 'srv02.example.org', path: '/var/backups/openldap/' }
#   - { user: 'rsnapshot', host: 'srv03.example.org', path: '/var/www/my.example.org/links/data/' }
#   - { user: 'rsnapshot', host: 'srv04.example.org', path: '/var/www/my.example.org/public/' }
#   - { user: 'rsnapshot', host: 'srv04.example.org', path: '/etc/letsencrypt/' }
#   - { user: 'rsnapshot', host: 'srv04.example.org', path: '/etc/ssl/private/' }
rsnapshot_remote_backups: []

# File name patterns to exclude from backups, globally
# Example:
# rsnapshot_excludes:
#   - '/var/nextcloud/data/updater-*/'
#   - '/var/nextcloud/data/appdata_*/'
#   - '/var/nextcloud/data/*/cache/'
#   - '/var/nextcloud/data/*/thumbnails/'
#   - '/var/nextcloud/data/*/files_trashbin/'
rsnapshot_excludes: []


##### COMMON/GENERAL SYSTEM SETTINGS #####

##### DNS RESOLVER #####

# update DNS nameserver settings (resolv.conf) (yes/no)
setup_dns: no

# list of DNS nameservers IP addresses
# Example:
# dns_nameservers:
#   - "1.1.1.1"
#   - "1.0.0.1"
dns_nameservers: []

##### SYSCTL (NETWORKING/MEMORY) #####

# update sysctl settings (yes/no)
setup_sysctl: yes

# Enable/disable packet forwarding between network interfaces (routing) (yes/no)
sysctl_allow_forwarding: no

# answer ICMP pings (yes/no)
sysctl_answer_ping: no

# "swappiness" setting. 100: swap/reclaim RAM aggressively. 0: do not swap unless necessary
sysctl_vm_swappiness: '10'

# "VFS cache pressure" setting. 100+ : prefer caching memory pages over disk cache
sysctl_vm_vfs_cache_pressure: '150'

# yes/no: enable/disable creation of core dumps on kernel crashes
# These are usually not needed and may contain sensitive information
os_security_kernel_enable_core_dump: no


##### PACKAGE MANAGEMENT #####

# yes/no: setup APT sources (security, backports) and automatic security upgrades
setup_apt: yes


##### SSH SERVER #####

# setup/harden SSH server (yes/no)
setup_ssh: yes

# List of public SSH key files to authorize on the server for the ansible user
# Example: ['public_keys/john.pub', 'public_keys/jane.pub']
ssh_authorized_keys: []

# a list of public keys that are never accepted by the ssh server
ssh_server_revoked_keys: []

# sshd and SFTP server log levels, respecively (QUIET, FATAL, ERROR, INFO, VERBOSE, DEBUG, DEBUG1, DEBUG2, DEBUG3)
ssh_log_level: "INFO"
ssh_sftp_loglevel: "ERROR"

# types of SSH TCP forwarding to allow (no, local, remote, all - QUOTED)
# remote/all is required to use the host as a jumpbox
ssh_allow_tcp_forwarding: "no"

# enable/disable root SSH logins (yes, no - QUOTED)
ssh_permit_root_login: "no"

# enable/disable SSH password authentication (yes, no - QUOTED)
ssh_password_authentication: "no"


##### FIREWALL #####

# setup firewall (yes/no)
setup_firewall: yes

# alias for LAN addresses (CIDR notation,comma-separated values)
firehol_alias_lan: "10.0.0.0/8,192.168.0.0/16,172.16.0.0/12"

# Firewall rules
# By default a single global network chain is defined (traffic on any interface, from any source)
# Restrict traffic to individual source/destination IPs in earch rule's src/dst value
# Or create additional network definitions for more complex setups.
firehol_networks:
  - name: "global" # a name for this rule set
    src: "any" # traffic to/from any IP address
    interface: "any" # traffic to/from any network interface
    policy: "RETURN" # policy to apply for traffic that matches no rules match (one of DROP/RETURN/ACCEPT/REJECT)
    allow_input: # incoming traffic to allow (name: service name, src: source IP address/subnet)
      - { name: "ssh", src: "any" } # ssh from anywhere
      # - { name: "netdata", src: "{{ firehol_alias_lan }}" } # monitoring dashboard
      # - { name: "http", src: "{{ firehol_alias_lan }}" } # web server
      # - { name: "https", src: "{{ firehol_alias_lan }}" } # web server
      # - { name: "mumble", src: "{{ firehol_alias_lan }}" } # mumble voip server
      # - { name: "ping", src: "{{ firehol_alias_lan }}" } # incoming ICMP pings
      # - { name: "samba", src: "{{ firehol_alias_lan }}" } # samba file sharing
      # - { name: "pulseaudio", src: "{{ firehol_alias_lan }}" } # pulseaudio sound server
      # - { name: "mdns", src: "any" } # avahi/zeroconf/MDNS/DNS-SD/uPnP, requires src: any
      # - { name: "multicast", src: "any" } # avahi/zeroconf/MDNS/DNS-SD/uPnP, requires src=any
      # - { name: "sshcustom", src: "any" } # SSH server on custom port
      # - { name: "transmission", src: "any", } # incoming bittorrent peer connections
      # - { name: "rtc", src: "any", } # jitsi meet audio/video conferencing
      # - { name: "ldap", src: "{{ firehol_alias_lan }}", } # LDAP (plain/insecure) from LAN
      # - { name: "ldaps", src: "{{ firehol_alias_lan }}", } # LDAP (SSL/secure) from LAN
    allow_output: # outgoing traffic to allow (name: service name, dst: destination IP address/subnet)
      - { name: "dns", dst: "any" } # DNS queries to anywhere
      - { name: "ntp", dst: "any" } # time/date synchronization
      - { name: "dhcp", dst: "{{ firehol_alias_lan }}" } # DHCP requests on LAN
      - { name: "http", dst: "any" } # outgoing HTTP requests
      - { name: "https", dst: "any" } # outgoing HTTPS requests
      - { name: "ping", dst: "any" } # outgoing ICMP pings
      - { name: "submission", dst: "any" } # outgoing mail/port 587
      # - { name: "imaps", dst: "any" } # nextcloud mail
      # - { name: "imaps585", dst: "any" } # nextcloud mail
      # - { name: "imap", dst: "any" } # nextcloud mail
      # - { name: "smtps", dst: "any" } # nextcloud mail
      # - { name: "smtp", dst: "any" } # nextcloud mail
      # - { name: "ssh", dst: "any" } # ssh/git access to anywhere
      # - { name: "all", dst: "any" } # allow ALL outgoing connections


# Router definitions - traffic forwarding between network interfaces
# Example:
# firehol_routers:
#   - name: "docker" # arbitrary name for the router, example for docker
#     allow_route_to: # forward these services from any interface, to the interface specified
#       - { name: "http", to_interface: "docker_gwbridge" }
#       - { name: "https", to_interface: "docker_gwbridge" }
#       - { name: "git", to_interface: "docker_gwbridge" }
#     allow_route_from: # forward these services to any interface, from the interface specified
#       - { name: "any", from_interface: "docker_gwbridge" }
#       - { name: "any", from_interface: "docker0" }
firehol_routers: []

# if docker role is enabled, add relevant firewall/router rules (yes/no):
# - allow traffic from host to containers
# - allow traffic between containers
# - allow all outgoing swarm traffic
# - insert SNAT rules for outgoing swarm traffic
firehol_docker_swarm_compat: yes


# custom services definitions, in addition to https://firehol.org/services/
firehol_custom_services:
  - { name: "sshcustom", ports: "tcp/722" } # SSH server on custom port
  - { name: "mumble", ports: "tcp/64738 udp/64738" } # mumble voip server
  - { name: "netdata", ports: "tcp/19999" } # netdata monitoring dashboard/API
  - { name: "mdns", ports: "udp/5353" } # avahi/zeroconf/MDNS/DNS-SD
  - { name: "pulseaudio", ports: "tcp/4713" } # pulseaudio sound server
  - { name: "transmission", ports: "tcp/52943 udp/52943" } # incoming bittorrent/transmission peer connections
  - { name: "iscsi", ports: "tcp/3260" } # iSCSI initiator
  - { name: "dropboxlan", ports: "udp/17500" } # Dropbox LAN sync
  - { name: "imaps585", ports: "tcp/585" } # IMAPS on port 585


##### FAIL2BAN #####

# setup fail2ban bruteforce detection/prevention system (yes/no)
setup_fail2ban: yes

# list of IPs to never ban - 127.0.0.1 is always ignored
fail2ban_ignoreip:
  - '10.0.0.0/8'
  - '192.168.0.0/16'
  - '172.16.0.0/12'

# fail2ban default ban duration (in seconds or time abbreviation format)
fail2ban_default_bantime: "1year"
# fail2ban: default interval (in seconds or time abbreviation format) before counting failures towards a ban
fail2ban_default_findtime: "10min"
# fail2ban default number of failures that have to occur in the last findtime to ban the IP
fail2ban_default_maxretry: 5
# destination email address used for some actions
fail2ban_destemail: "root@localhost"


##### USERS #####

# Additional user accounts to create.
# Supports these user (https://docs.ansible.com/ansible/latest/modules/user_module.html) module parameters:
#   name, password, comment, create_home, home, groups, append, generate_ssh_key, update_password
# Additional supported parameters:
#   ssh_authorized_keys: list of public key files to authorize on this account
#   sudo_nopasswd_commands: list of commands the user should be able to run with sudo without password
# Example:
# linux_users:
#    - name: "remotebackup"
#      password: "{{ vault_linux_users_remotebackup_password }}"
#      groups: [ "ssh", "sudo" ]
#      comment: "limited user account for remote backups"
#      ssh_authorized_keys: []
#      sudo_nopasswd_commands: ['/usr/bin/rsync']
linux_users: []

# allow ansible connecting user to run 'sudo rsync' without password (yes/no)
# Required to use the ansible synchronize module, and download files generated by the backup role
ansible_user_allow_sudo_rsync_nopasswd: yes

##### OUTGOING MAIL #####

# install outgoing system mail client/local MTA (yes/no)
# The system will not be able to send status/monitoring e-mails unless this is enabled
setup_msmtp: no

# If msmtp is enabled, the following values must be set
# System mail relay (SMTP server) to use, and authentication username/password
msmtp_host: "{{ vault_msmtp_host }}"
msmtp_username: "{{ vault_msmtp_username }}"
msmtp_password: "{{ vault_msmtp_password }}"
# Mail address to send all local mail to
msmtp_admin_email: "{{ vault_msmtp_admin_email }}"

# (optional) TLS certificate fingerprint of the SMTP server - use this to accept a self-signed certificate
# Get the server's certificate fingerprint with openssl s_client -connect $smtp_host:587 -starttls smtp < /dev/null 2>/dev/null |openssl x509 -fingerprint -noout
# msmtp_host_fingerprint: '11:22:33:44:55:66:77:88:99:00:13:37:AA:BB:CC:DD:EE:FF:AD:C2'

##### PACKAGES #####

# install a basic set of interactive command-line diagnostic/file manipulation/shell utilities (yes/no)
# see tasks/50utilities.yml for the full list
setup_cli_utils: yes

# install haveged entropy generator (yes/no)
# good to have on virtual machines where system is frequently running out of entropy
setup_haveged: yes
##### DOCKER CONTAINER PLATFORM #####

# Docker release channel (stable/edge)
docker_apt_release_channel: stable
docker_apt_arch: amd64

# A list of users who will be added to the docker group
docker_users: []

# yes/no: start/stop docker service, enable/disable it on boot
docker_enable_service: yes

# the log driver for the docker daemon (none/local/json-file/syslog/journaled/gelf/fluentd/awslogs/splunk/etwlogs/gcplogs/logentries)
docker_log_driver: "syslog"

# docker swarm settings (accepts all parameters from https://docs.ansible.com/ansible/latest/collections/community/general/docker_swarm_module.html)
docker_swarm:
  state: "present"
##### GITEA SELF-HOSTED GIT SERVICE #####

# fully qualified domain name of the gitea instance
gitea_fqdn: "git.CHANGEME.org"

# username/password/e-mail address for the gitea admin user
gitea_admin_username: "{{ vault_gitea_admin_username }}"
gitea_admin_password: "{{ vault_gitea_admin_password }}"
gitea_admin_email: "{{ vault_gitea_admin_email }}"

# gitea database settings
gitea_db_type: "postgres" # postgres/mysql
gitea_db_name: "gitea"
gitea_db_user: "gitea"
gitea_db_host: "/run/postgresql/" # /run/postgresql/ for a local postgresql database/peer authentication
gitea_db_password: "{{ vault_gitea_db_password }}" # leave empty for local postgresql database/peer authentication
gitea_db_port: 5432 # usually 5432 for PostgreSQL, 3306 for MySQL

# gitea version to install - https://github.com/go-gitea/gitea/releases.atom; remove leading v
gitea_version: '1.13.1'
# 106 character token used for internal API calls authentication
gitea_internal_token: " {{ vault_gitea_internal_token }}"
# 64 character global secret key
gitea_secret_key: "{{ vault_gitea_secret_key }}"
# 43 character OAuth2 JWT secret
gitea_oauth2_jwt_secret: "{{ vault_gitea_oauth2_jwt_secret }}"
# 43 character LFS JWT secret
gitea_lfs_jwt_secret: "{{ vault_gitea_lfs_jwt_secret }}"
# home directory for the gitea user
gitea_user_home: /var/lib/gitea
# gitea base URL under the domain name (eg change. it to /gitea to serve from https://git.CHANGEME.org/gitea)
gitea_base_url: "/"
# start/stop the gitea service, enable/disable it on boot (yes/no)
gitea_enable_service: yes

# HTTPS and SSL/TLS certificate mode for the gitea webserver virtualhost
#   letsencrypt: acquire a certificate from letsencrypt.org
#   selfsigned: generate a self-signed certificate (will generate warning in bowsers and clients)
gitea_https_mode: selfsigned


### Gitea settings ###

# Default visibility setting when creating a new repository (last/private/public)
gitea_default_private: "private"
# force every new repository to be private (true/false - QUOTED)
gitea_force_private: "false"
# User must sign in to view anything (true/false - QUOTED)
gitea_require_signin: "true"
# Disallow registration, only allow admins to create accounts (true/false - QUOTED)
gitea_disable_registration: "true"
# Whether a new user needs to confirm their email when registering (true/false - QUOTED)
gitea_register_email_confirm: "true"
# Whether the email of the user should be shown in the Explore Users page (true/false - QUOTED)
gitea_show_user_email: "false"
# disable all third-party/external services/CDNs (true/false - QUOTED)
gitea_offline_mode: "true"
# disable third-party gravatar service (true/false - QUOTED)
gitea_disable_gravatar: "true"
# global limit of repositories per user, applied at creation time. -1 means no limit
gitea_user_repo_limit: -1
# enable/disable gitea REST API (true/false - QUOTED)
gitea_enable_api: "false"
# max number of items in API responses
gitea_api_max_results: 1000
# The minimum password length for new Users
gitea_min_password_length: 10
# comma-separated list of charactacter classes required in passwords (lower,upper,digit,spec or off)
gitea_password_complexity: "lower,upper,digit,spec"
# Allow new users to create organizations by default (true/false - QUOTED)
gitea_default_allow_create_organization: "false"

# enable outgoing mail (yes/no)
gitea_mailer_enabled: no
# Mail settings below are required if gitea mailer is enabled
# 'From:' address used in mails sent by gitea
# gitea_mail_from: "gitea-noreply@{{ gitea_fqdn }}"
# SMTP host, username and password for outgoing mail from gitea
# gitea_mail_host: "{{ vault_gitea_mail_host }}"
# gitea_mail_user: "{{ vault_gitea_mail_user }}"
# gitea_mail_password: "{{ vault_gitea_mail_password }}"
##### HOMEPAGE #####

# Fully Qualified Domain Name for the homepage
homepage_fqdn: "www.CHANGEME.org"

# main title of the homepage
homepage_title: "{{ homepage_fqdn }}"

# HTTPS and SSL/TLS certificate mode for the homepage webserver virtualhost
#   letsencrypt: acquire a certificate from letsencrypt.org
#   selfsigned: generate a self-signed certificate (will generate warning in bowsers and clients)
homepage_https_mode: selfsigned
##### JELLYFIN MEDIA SERVER #####

# fully qualified domain name of the jellyfin instance
# jellyfin_fqdn: "media.CHANGEME.org"

# HTTPS and SSL/TLS certificate mode for the jellyfin webserver virtualhost
#   letsencrypt: acquire a certificate from letsencrypt.org
#   selfsigned: generate a self-signed certificate (will generate warning in bowsers and clients)
jellyfin_https_mode: selfsigned

# yes/no: start/stop the jellyfin webserver, enable/disable it on boot
jellyfin_enable_service: yes

# if the samba role is enabled, enable a jellyfin samba share (upload media files there)
jellyfin_samba_share_enabled: yes
# lists of users allowed to read/write to the jellyfin samba share (use @groupname for groups)
jellyfin_samba_share_allow_write_users: []
jellyfin_samba_share_allow_read_users: []
##### MARIADB DATABASE SERVER #####

# root password for the mariadb database service
mariadb_root_password: "{{ vault_mariadb_root_password }}"

# hostname for the mariadb database service
mariadb_hostname: "{{ inventory_hostname }}"

# yes/no: start/stop the mysql service, enable/disable it on boot
mariadb_enable_service: yes
##### MONITORING #####

##### LOGGING (RSYSLOG) #####

# setup rsyslog (aggregate application/service logs to /var/log/syslog, discard useless messages)
setup_rsyslog: yes

# agregate netdata logs to main syslog (default disabled, noisy) (yes/no)
rsyslog_monitor_netdata: no

# aggregate apache access logs to main syslog (default disabled) (yes/no)
rsyslog_monitor_apache_accesslog: no


##### NETDATA MONITORING SYSTEM #####

# default interval between netdata updates (in seconds)
# each plugin/module can override this setting (but only to set a longer interval)
netdata_update_every: 2

# (MiB) amount of memory dedicated to caching metric values
netdata_dbengine_page_cache_size: 32
# (MiB) amount of disk space dedicated to storing Netdata metric values/metadata
netdata_dbengine_disk_space: 256

# space-separated list of IP addresses authorized to access netdata
netdata_allow_connections_from: '10.* 192.168.* 172.16.* 172.17.* 172.18.* 172.19.* 172.20.* 172.21.* 172.22.* 172.23.* 172.24.* 172.25.* 172.26.* 172.27.* 172.28.* 172.29.* 172.30.* 172.31.*'

# enable netdata cloud/SaaS features (yes/no)
netdata_cloud_enabled: no

# enable netdata self-monitoring charts (yes/no)
netdata_self_monitoring_enabled: no

# enable/disable netdata debug/error/access logs (yes/no)
netdata_disable_debug_log: yes
netdata_disable_error_log: no
netdata_disable_access_log: yes


### NETDATA CHECKS ###

# Netdata process checks
#   name: process group name to check (apps_groups.conf)
#   min_count: minimum expected number of processes
#   interval: time interval (seconds) between checks
# Example:
# netdata_process_checks:
#   - { name: ssh, min_count: 1, interval: 20} # SSH server
#   - { name: time, min_count: 1, interval: 20} # NTP daemon
#   - { name: fail2ban, min_count: 1, interval: 20} # bruteforce prevention/IPS
#   - { name: httpd, min_count: 1, interval: 20} # web server
#   - { name: sql, min_count: 1, interval: 20} # SQL database engine
#   - { name: gitea, min_count: 1, interval: 20} # gitea self-hosted software forge
#   - { name: gitlab_runner, min_count: 1, interval: 20} # gitlab CI job runner
#   - { name: ezstream, min_count: 1, interval: 20} # icecast/ezstream media streaming server
#   - { name: murmurd, min_count: 1, interval: 20} # mumble VoIP server
#   - { name: pulseaudio, min_count: 1, interval: 20} # pulseaudio network sound server
#   - { name: auth, min_count: 1, interval: 20} # openldap server
netdata_process_checks: []

# Netdata HTTP/SSL checks
#   name: readable name of the check
#   url: URL to check for successful HTTP response
#   timeout: (seconds, default 1) maximum allowed time to return the content
#   interval: (seconds) interval between HTTP checks
#   check_x509: (yes/no, default yes for https:// URLs): check x509/SSL certificate time to expiration
# Example:
# netdata_http_checks:
#   - name: example.com
#     url: https://website.com
#   - name: example.net
#     url: http://example.net:8000
#     timeout: 5
#     interval: 60
#   - name: broken-ssl-website
#     url: https://www.self-signed.dev
#     check_x509: no
netdata_http_checks: []

# Netdata x509/SSL checks
# (seconds) global interval between x509 certificate checks
netdata_x509_checks_interval: "60"
# (seconds) global SSL connection timeout value for x509 checks
netdata_x509_checks_timeout: "60"
# (days) raise an alarm when a SSL certificate expires in less than this value
netdata_x509_checks_days_until_expiration_warning: "14"
netdata_x509_checks_days_until_expiration_critical: "7"

# Netdata TCP port checks
#   name: readable name of the check
#   host: hostname or IP address to contact
#   ports: list of TCP port numbers to check
#   interval: time interval (seconds) between checks
# Example:
# netdata_port_checks:
#   - name: ldap-available
#     host: 192.168.10.10
#     ports: [389, 636]
#     interval: 10
netdata_port_checks: []

# Netdata Docker container checks
# expected number of running docker containers
netdata_min_running_docker_containers: 0

# netdata installation method (packagecloud/binary)
#   packagecloud: install signed deb package from packagecloud APT repository (recommended)
#   binary: install netdata from .run install script
netdata_install_method: 'packagecloud'

# Netdata release to install in 'binary' installation mode - https://github.com/netdata/netdata/releases/
netdata_version: "v1.24.0"


### NETDATA EXTRA MODULES ###

# automatically restart services that require it after an upgrade (yes/no)
needrestart_autorestart_services: no

# (minutes) interval between updates of log message counts in the logcount module
netdata_logcount_update_interval: 1
# maximum acceptable ERROR message in logs over the last period before raising a WARNING or CRITICAL alert
netdata_logcount_error_threshold_warn: 0
netdata_logcount_error_threshold_crit: 10
# maximum acceptable WARNING message in logs over the last period before raising a WARNING alert
netdata_logcount_warning_threshold_warn: 0
# user to send logcount notifications to (eg. sysadmin, silent...)
netdata_logcount_notification_to: "silent"

# files to watch with netdata-modtime. each item takes the following parameters;
#   name: a unique name for the job/chart
#   path: path of the file to monitor
#   age_warning: raise a warning alert when time since last modification exceeds this value (seconds)
#   age_critical: raise a critical alert when time since last modification exceeds this value (seconds)
# Example:
# netdata_modtime_checks:
#   - name: rsnapshot_last_success
#     path: /var/log/rsnapshot_last_success
#     age_warning: 88200
#     age_critical: 90000
netdata_modtime_checks: []

# git repository URL for netdata-needrestart
netdata_needrestart_git_url: https://gitlab.com/nodiscc/netdata-needrestart
# git repository URL for netdata-logcount
netdata_logcount_git_url: https://gitlab.com/nodiscc/netdata-logcount
# git repository URL for netdata-modtime
netdata_modtime_git_url: https://gitlab.com/nodiscc/netdata-modtime


##### CLI MONITORING UTILITIES #####

# install ncdu, nethogs, htop, lnav (yes/no)
setup_monitoring_cli_utils: yes
##### MUMBLE VOIP SERVER #####

# password to join the Mumble server (NO SPACES)
mumble_password: "{{ vault_mumble_password }}"
# administrator password for the mumble server (login as 'superuser' - NO SPACES)
mumble_superuser_password: "{{ vault_mumble_superuser_password }}"

# exposes current/maximum user count and max bandwidth per client to unauthenticated users (ture/false - QUOTED)
mumble_allowping: 'false'

# Welcome message sent to clients when they connect
mumble_welcome_text: "<br />Welcome to this server running <b>Murmur</b>.<br />Enjoy your stay!<br />"

# Port to bind TCP and UDP sockets to
mumble_port: 64738

# Maximum bandwidth (in bits per second) clients are allowed to send speech at.
mumble_client_max_bandwidth: 72000

# Maximum number of concurrent clients allowed.
mumble_max_users: 100

# yes/no: start/stop the mumble VoIP server, enable/disable it on boot
mumble_enable_service: yes
##### NEXTCLOUD #####

# Nextcloud admin username/password
nextcloud_user: "{{ vault_nextcloud_user }}"
nextcloud_password: "{{ vault_nextcloud_password }}"

# Fully Qualified Domain Name for the nextcloud instance
# nextcloud_fqdn: "cloud.CHANGEME.org"
# Nextcloud installation directory (must be under a valid documentroot)
nextcloud_install_dir: "/var/www/{{ nextcloud_fqdn }}"
# full public URL of your tt-rss installation (update this if you changed the install location to a subdirectory)
nextcloud_full_url: "https://{{ nextcloud_fqdn }}/"

# mode for SSL/TLS certificates for the nextcloud webserver virtualhost (letsencrypt/selfsigned)
#   letsencrypt: acquire a certificate from letsencrypt.org
#   selfsigned: generate a self-signed certificate (will generate warning in browsers and clients)
nextcloud_https_mode: selfsigned

# nextcloud data storage directory
nextcloud_data_dir: "/var/nextcloud/data"

# nextcloud adminstrator e-mail address
nextcloud_admin_email: "{{ vault_nextcloud_admin_email }}"

# nextcloud database type (mysql/pgsql)
nextcloud_db_type: "pgsql"
# nextcloud database host
# use /var/run/postgresql and unset the password to use postgresql local peer authentication
nextcloud_db_host: "localhost"
# nextcloud database name
nextcloud_db_name: "nextcloud"
# nextcloud database user
nextcloud_db_user: "nextcloud"
# nextcloud database password
nextcloud_db_password: "{{ vault_nextcloud_db_password }}"

# nextcloud version to install
nextcloud_version: "20.0.6"

# base folder for shared files from other users
nextcloud_share_folder: '/SHARED/'
# workaround for old nextcloud-desktop clients which don't support TLSv1.3
nextcloud_allow_tls12: true

# Nextcloud applications to enable or disable
#   state: enable/disable
#   app: nextcloud app name
nextcloud_apps:
  - { state: "disable", app: "encryption" }
  - { state: "disable", app: "files_antivirus" }
  - { state: "disable", app: "files_versions" }
  - { state: "disable", app: "news" }
  - { state: "disable", app: "user_external" }
  - { state: "disable", app: "recommendations" }
  - { state: "enable", app: "activity" }
  - { state: "enable", app: "calendar" }
  - { state: "enable", app: "comments" }
  - { state: "enable", app: "contacts" }
  - { state: "enable", app: "dav" }
  - { state: "enable", app: "federatedfilesharing" }
  - { state: "enable", app: "federation" }
  - { state: "enable", app: "files" }
  - { state: "enable", app: "files_external" }
  - { state: "enable", app: "files_pdfviewer" }
  - { state: "enable", app: "files_sharing" }
  - { state: "enable", app: "files_trashbin" }
  - { state: "enable", app: "files_videoplayer" }
  - { state: "enable", app: "firstrunwizard" }
  - { state: "enable", app: "photos" }
  - { state: "enable", app: "music" }
  - { state: "enable", app: "maps" }
  - { state: "enable", app: "notifications" }
  - { state: "enable", app: "systemtags" }
  - { state: "enable", app: "tasks" }
  - { state: "enable", app: "updatenotification" }
  - { state: "enable", app: "user_ldap" }
  - { state: "enable", app: "notes" }
  - { state: "enable", app: "deck" }
  - { state: "enable", app: "admin_audit" }
#  - { state: "enable", app: "documents" } #TODO requires download
#  - { state: "enable", app: "templateeditor" } #TODO requires download

# nextcloud php-fpm pool settings (performance/resource usage)
# php-fpm: Maximum amount of memory a script may consume (K, M, G)
nextcloud_php_memory_limit: '512M'
# php_fpm: Maximum execution time of each script (seconds)
nextcloud_php_max_execution_time: 30
# php-fpm: Maximum amount of time each script may spend parsing request data (seconds)
nextcloud_php_max_input_time: 60
# php-fpm: Maximum size of POST data that PHP will accept (K, M, G)
nextcloud_php_post_max_size: '4G'
# php-fpm: Maximum allowed size for uploaded files (K, M, G)
nextcloud_php_upload_max_filesize: '4G'
# php-fpm: maximum number of child processes
nextcloud_php_pm_max_children: 30
# php-fpm: number of child processes created on startup.
nextcloud_php_pm_start_servers: 3
# php-fpm: desired minimum number of idle server processes
nextcloud_php_pm_min_spare_servers: 2
# php-fpm: desired maximum number of idle server processes
nextcloud_php_pm_max_max_spare_servers: 4
##### OPENLDAP DIRECTORY SERVICE #####

# FQDN at which the LDAP server can be reached
openldap_fqdn: "ldap.CHANGEME.org"
# LDAP domain
openldap_domain: "CHANGEME.org"
# LDAP organization
openldap_organization: "CHANGEME"
# LDAP base DN
openldap_base_dn: "dc=CHANGEME,dc=org"
# admin username/password for OpenLDAP server
# the admin DN will be of the form cn=admin,dc=CHANGEME,dc=org
openldap_admin_password: "{{ vault_openldap_admin_password }}"

# Unprivilegied "bind" LDAP account username/password
# This account will be allowed to to browse the directory/resolve UIDs and GIDs)
openldap_bind_username: "bind"
openldap_bind_password: "{{ vault_openldap_bind_password }}"


##### LDAP ACCOUNT MANAGER #####

# setup LDAP Account Manager web management interface (yes/no)
openldap_setup_lam: yes

# domain name (FQDN) for ldap-account-manager
ldap_account_manager_fqdn: "{{ openldap_fqdn }}"

# comma-separated list of IP addresses allowed to access ldap-account-manager (wildcards allowed)
# for security reasons only private/RFC1918 addresses are allowed by default
ldap_account_manager_allowed_hosts: "10.*,192.168.*,172.16.*,172.17.*,172.18.*,172.19.*,172.20.*,172.21.*,172.22.*,172.23.*,172.24.*,172.25.*,172.26.*,172.27.*,172.28.*,172.29.*,172.30.*,172.31.*"

# installation directory for ldap-account-manager
ldap_account_manager_install_dir: "/var/www/{{ ldap_account_manager_fqdn }}"
# ldap account manager version
ldap_account_manager_version: "7.3"
# ldap-account-manager installation method (tar.bz2, apt...)
# currently only tar.bz2 is supported (ldap-account-manager not available in debian 10 repositories)
ldap_account_manager_install_method: "tar.bz2"
# ldap-account-manager session timeout in minutes
ldap_account_manager_session_timeout: 10

# HTTPS and SSL/TLS certificate mode for the ldap-account-manager webserver virtualhost
#   letsencrypt: acquire a certificate from letsencrypt.org
#   selfsigned: generate a self-signed certificate (will generate warning in browsers and clients)
ldap_account_manager_https_mode: "selfsigned"

# php-fpm: Maximum amount of memory a script may consume (K, M, G)
ldap_account_manager_php_memory_limit: '128M'
# php_fpm: Maximum execution time of each script (seconds)
ldap_account_manager_php_max_execution_time: 30
# php-fpm: Maximum amount of time each script may spend parsing request data (seconds)
ldap_account_manager_php_max_input_time: 60
# php-fpm: Maximum size of POST data that PHP will accept (K, M, G)
ldap_account_manager_php_post_max_size: '8M'
# php-fpm: Maximum allowed size for uploaded files (K, M, G)
ldap_account_manager_php_upload_max_filesize: '2M'
##### ROCKETCHAT COMMUNICATION PLATFORM #####

rocketchat_docker_version: "3.7.1"
rocketchat_fqdn: "chat.CHANGEME.org"
# mode for SSL/TLS certificates for the rocketchat webserver virtualhost (letsencrypt/selfsigned)
#   letsencrypt: acquire a certificate from letsencrypt.org
#   selfsigned: generate a self-signed certificate (will generate warning in browsers and clients)
rocketchat_https_mode: selfsigned
##### SAMBA FILE SHARING SERVER #####

# List of samba shares. Each item has the following attributes:
#   name: (required): unique name for the share
#   allow_read_users (default none): list of users/groups allowed to read the share (use @groupname for groups)
#   allow_write_users (default none): list of users/groups allowed to write to the share (use @groupname for groups)
#   comment (default none): text  that is seen next to a share in share listings on clients
#   available: (yes/no, default yes): set to no to disable the share
#   browseable: (yes/no, default yes): set to no to hide the share from network share listings on clients (it can still be accessed)
#   state: (directory/absent, default 'directory') : set to 'absent' to delete the share. All data will be removed!
# Example:
# samba_shares:
#   - name: mycompany
#     comment: "File share for the whole company"
#     allow_read_users:
#       - alice
#       - bob
#       - martin
#       - eve
#   - name: bob-personal
#     comment: "Bob's file share (hidden from share listing)"
#     browseable: no
#     allow_write_users:
#       - bob
#   - name: accounting
#     comment: "Share for the accounting department"
#     allow_write_users:
#       - @accounting
#     allow_read_users:
#       - alice # give alice read-only access
#   - name: a_share_that_will_be_removed
#     state: absent
samba_shares: []

# Server name and description
samba_netbios_name: "{{ ansible_hostname }}"
samba_server_string: "{{ ansible_hostname }} file server"

# Max size of log files (in KiB)
samba_max_log_size_kb: 10000

# Samba log level
samba_log_level: 0

# base path for samba share directories
samba_shares_path: /var/lib/samba/shares/

# list of hosts allowed to connect to samba services
samba_hosts_allow:
  - '192.168.0.0/16'
  - '172.31.0.0/12'
  - '10.0.0.0/8'

# list of hosts allowed to access the $IPC share anonymously
# windows clients require access to $IPC to be able to access any other share,
# so it is recommended to keep the same value as samba_hosts_allow
samba_hosts_allow_ipc: "{{ samba_hosts_allow }}"

# user/group storage backend for samba accounts (tdbsam/ldapsam)
#   tdbsam: use local UNIX user accounts and samba's internal TDB database
#   ldapsam: use a LDAP server to store users and groups
samba_passdb_backend: "tdbsam"

# List of samba_users (only for samba_passdb_backend: "tdbsam")
# Each item has the following attributes:
#   username: the username. Do not use a username already in use by a system service or interactive user!
#   password: password for this user. It is best to store this value in ansible-vault
#   TODO: state: present/absent. Set to 'absent' to delete the account
# Example:
# samba_users:
#   - username: alice
#     password: "{{ vault_samba_user_password_alice }}"
#   - username: bob
#     password: "{{ vault_samba_user_password_bob }}"
samba_users: []

# 0-999: nscd debug log level
samba_nscd_debug_level: 0
# (seconds): time after which user/group/passwords are invalidated in nscd cache
samba_nscd_cache_time_to_live: 60
##### SHAARLI BOOKMARKING SERVICE #####

# Fully Qualified Domain Name for the shaarli instance
# shaarli_fqdn: "links.CHANGEME.org"

# Shaarli login and password
shaarli_username: "{{ vault_shaarli_username }}"
shaarli_password: "{{ vault_shaarli_password }}"
# 40 character random salt used to hash shaarli password
shaarli_password_salt: "{{ vault_shaarli_password_salt }}"
# 12 character REST API secret
shaarli_api_secret: "{{ vault_shaarli_api_secret }}"
# shaarli timezone (see https://www.php.net/manual/en/timezones.php)
shaarli_timezone: "Europe/Amsterdam"
# overwrite shaarli configuration if it already exists (yes/no - yes will overwrite any changes made from Shaarli tools menu)
shaarli_overwrite_config: no

# Mode for SSL/TLS certificates for the shaarli webserver virtualhost
#   letsencrypt: acquire a certificate from letsencrypt.org
#   selfsigned: generate a self-signed certificate (will generate warning in browsers and clients)
shaarli_https_mode: selfsigned

# Shaarli installation directory
shaarli_install_dir: "/var/www/{{ shaarli_fqdn }}"
# Shaarli version to install - https://github.com/shaarli/Shaarli/releases.atom
shaarli_version: 'v0.12.1'

# php-fpm: Maximum amount of memory a script may consume (K, M, G)
shaarli_php_memory_limit: '128M'
# php_fpm: Maximum execution time of each script (seconds)
shaarli_php_max_execution_time: 30
# php-fpm: Maximum amount of time each script may spend parsing request data (seconds)
shaarli_php_max_input_time: 60
# php-fpm: Maximum size of POST data that PHP will accept (K, M, G)
shaarli_php_post_max_size: '8M'
# php-fpm: Maximum allowed size for uploaded files (K, M, G)
shaarli_php_upload_max_filesize: '2M'
##### TRANSMISSION BITTORRENT CLIENT #####

# fully qualified domain name for the transmission web interface
# transmission_fqdn: torrent.CHANGEME.org

# username/password for remote control web interface
transmission_username: '{{ vault_transmission_username }}'
transmission_password: "{{ vault_transmission_password }}"

# Torrents download directory for
transmission_download_dir: '/var/lib/transmission-daemon/downloads'

# HTTPS and SSL/TLS certificate mode for the transmission webserver virtualhost
#   letsencrypt: acquire a certificate from letsencrypt.org
#   selfsigned: generate a self-signed certificate (will generate warning in browsers and clients)
transmission_https_mode: selfsigned

# yes/no: start/stop the transmission bitorrent client, enable/disable it on boot
transmission_enable_service: yes
##### TT-RSS FEED READER #####

# domain name (FQDN) for the tt-rss instance
# tt_rss_fqdn: "rss.CHANGEME.org"

# tt-rss installation directory (must be under a valid documentroot)
tt_rss_install_dir: "/var/www/{{ tt_rss_fqdn }}"
# full public URL of your tt-rss installation (update this if you changed the install location to a subdirectory)
tt_rss_full_url: "https://{{ tt_rss_fqdn }}/"

# HTTPS and SSL/TLS certificate mode for the tt-rss webserver virtualhost
#   letsencrypt: acquire a certificate from letsencrypt.org
#   selfsigned: generate a self-signed certificate (will generate warning in browsers and clients)
tt_rss_https_mode: selfsigned

# tt-rss main user/admin username/password
tt_rss_user: "{{ vault_tt_rss_user }}"
tt_rss_password: "{{ vault_tt_rss_password }}"
# random 250 characters string used to salt the password
tt_rss_password_salt: "{{ vault_tt_rss_password_salt }}"

# tt-rss database settings
tt_rss_db_name: "ttrss"
tt_rss_db_user: "ttrss"
tt_rss_db_password: "{{ vault_tt_rss_db_password }}"

# tt-rss version (git revision)
tt_rss_version: "master"
# Allow users to register themselves (true/false - QUOTED)
tt_rss_allow_registration: "false"
# Maximum number of users allowed to register accounts
tt_rss_account_limit: 10
# install additional tt-rss themes (yes/no - UNMAINTAINED)
tt_rss_install_themes: no
# install additional tt-rss plugins (yes/no - unmaintained)
tt_rss_install_plugins: no
# Error log destination. setting this to blank uses PHP logging/webserver error log (sql, syslog, '')
tt_rss_log_destination: ''

# php-fpm: Maximum amount of memory a script may consume (K, M, G)
tt_rss_php_memory_limit: '128M'
# php_fpm: Maximum execution time of each script (seconds)
tt_rss_php_max_execution_time: 30
# php-fpm: Maximum amount of time each script may spend parsing request data (seconds)
tt_rss_php_max_input_time: 60
# php-fpm: Maximum size of POST data that PHP will accept (K, M, G)
tt_rss_php_post_max_size: '8M'
# php-fpm: Maximum allowed size for uploaded files (K, M, G)
tt_rss_php_upload_max_filesize: '2M'
```