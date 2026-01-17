# All configuration variables

This is a list of all available configuration variables, and their default values.
Copy any of these variables to `xsrv edit-host` (`host_vars` file) or `xsrv edit-vault`, and edit its value there.
Then run `xsrv deploy` to apply changes. See [Manage configuration](usage.md#manage-configuration)

<!--BEGIN ROLES LIST-->
## apache

[roles/apache/defaults/main.yml](https://gitlab.com/nodiscc/xsrv/-/blob/master/roles/apache/defaults/main.yml)

```yaml
##### APACHE WEB SERVER #####
# listen on port 80 (unencrypted HTTP) (yes/no)
apache_listen_http: yes
# ask search engines/bots that respect the X-Robots-Tag header not to crawl this webserver's sites (yes/no)
apache_allow_robots: no
# start/stop the apache webserver, enable/disable it on boot (yes/no)
apache_enable_service: yes
# e-mail address to register a letsencrypt.org account
apache_letsencrypt_email: "CHANGEME"
# enable HTTP Strict-Transport-Security for websites using letsencrypt.org certificates (yes/no)
# enabling HSTS will force clients/browsers to only connect over to these sites over HTTPS with valid certificates for 6 months, don't set this to yes if you intend to use self-signed certificates in the future
apache_letsencrypt_enable_hsts: no
# custom apache reverse proxies (https://en.wikipedia.org/wiki/Reverse_proxy)
# Example:
# apache_reverseproxies:
#   - servername: site1.example.org # required, FQDN of the virtualhost
#     upstream: "https://localhost:3545" # (required) the server to proxy requests to
#     https_mode: selfsigned # (optional, selfsigned/letsencrypt, default selfsigned) mode for the auto-generated SSL certificate
#     redirect_https: yes # (optional, yes/no, default yes) redirect HTTP requests to HTTPS
#     extra_directives: # (optional) list of additional config directives https://httpd.apache.org/docs/current/mod/directives.html
#       - "SSLProtocol all -SSLv3 -TLSv1 -TLSv1.1" # allow less-secure TLS1.2 for legacy clients
#   - servername: site2.example.org
#     upstream: https://10.0.0.36:3646
apache_reverseproxies: []
# aggregate apache access logs to syslog (if nodiscc.xsrv.monitoring.rsyslog role is deployed) (yes/no)
apache_access_log_to_syslog: no
# firewall zones for the apache service (if nodiscc.xsrv.common/firewalld role is deployed)
# 'zone:' is one of firewalld zones, set 'state:' to 'disabled' to remove the rule (the default is state: enabled)
# apache access must be allowed from the 'public' zone to use Let's Encrypt certificates
apache_firewalld_zones:
  - zone: public
    state: enabled
  - zone: internal
    state: enabled

##### PHP-FPM INTERPRETER #####
# yes/no: enable/disable the default php-fpm pool (www)
# starting php-fpm without any pool defined will cause the service to fail
php_fpm_enable_default_pool: yes
```


## backup

[roles/backup/defaults/main.yml](https://gitlab.com/nodiscc/xsrv/-/blob/master/roles/backup/defaults/main.yml)

```yaml
##### RSNAPSHOT BACKUP SERVICE #####
# backups storage directory (without trailing slash!)
rsnapshot_backup_dir: "/var/backups/rsnapshot"
# number of daily, weekly and monthly backup generations to keep (set to 0 to disable a specific backup interval)
rsnapshot_retain_daily: 6
rsnapshot_retain_weekly: 6
rsnapshot_retain_monthly: 6
# enable/disable automatic/scheduled backups (yes/no)
rsnapshot_enable_cron: yes
# automatically create the backup storage directory (yes/no)
# if the backup directory should be created by another process, such as USB drive automounter, you may want to set this to no
rsnapshot_create_root: yes
# rsnapshot verbosity level (1-5)
rsnapshot_verbose_level: 3
# commands to run before starting backups (database dumps, application exports...)
# return codes different from 0 will cause the backup process to abort with an error
# these commands run as the 'rsnapshot' user locally.
# use 'ssh user@host /path/to/script' to run scripts on remote hosts.
# - For local scripts, 'rsnapshot' user must have appropriate permissions to run the script
# - For remote backups, 'rsnapshot' user's SSH key must be authorized on the remote host, the remote user must have appropriate permissions to run the script
# Example:
# rsnapshot_backup_execs:
#   - 'ssh -oStrictHostKeyChecking=no rsnapshot@srv01.example.org /opt/xsrv/nextcloud-mysql-dump.sh'
#   - 'ssh -oStrictHostKeyChecking=no rsnapshot@srv02.example.org /opt/xsrv/ttrss-mysql-dump.sh'
#   - 'ssh -oStrictHostKeyChecking=no rsnapshot@srv03.example.org /opt/xsrv/openldap-dump.sh'
#   - /opt/xsrv/nextcloud-mysql-dump.sh
rsnapshot_backup_execs: []
# local files/directories to backup
# the 'rsnapshot' user must have read access to these directories
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
# remote files/directories to fetch. Parameters:
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
# file name patterns to exclude from backups, globally
# Example:
# rsnapshot_excludes:
#   - '/var/nextcloud/data/updater-*/'
#   - '/var/nextcloud/data/appdata_*/'
#   - '/var/nextcloud/data/*/cache/'
#   - '/var/nextcloud/data/*/thumbnails/'
#   - '/var/nextcloud/data/*/files_trashbin/'
rsnapshot_excludes: []
```


## common

[roles/common/defaults/main.yml](https://gitlab.com/nodiscc/xsrv/-/blob/master/roles/common/defaults/main.yml)

```yaml
##### COMMON/GENERAL SYSTEM SETTINGS #####
##### HOSTNAME #####
# yes/no: update hostname using ansible inventory name
setup_hostname: yes

##### DNS RESOLVER #####
# update DNS nameserver settings (resolv.conf) (yes/no)
setup_dns: no
# list of DNS nameservers IP addresses
# Example:
# dns_nameservers:
#   - "1.1.1.1"
#   - "1.0.0.1"
dns_nameservers: []

##### HOSTS FILE #####
# update hosts file (yes/no)
setup_hosts_file: yes
# list of hosts to add/remove from the hosts file
# Example:
# hosts_file_entries:
#   - ip_address: "10.0.0.1"
#     hostname: "srv01.example.org"
#     state: present # optional, absent/present, default present
#   - ip_address: "10.0.0.2"
#     hostname: "srv02.example.org mail.example.org"
#   - ip_address: "1.2.3.4"
#     state: absent
hosts_file_entries: []

##### SYSCTL/KERNEL CONFIGURATION #####
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
# value of sysctl control kernel.yama.ptrace_scope, see documentation in etc_sysctl.d_custom.conf.j2
sysctl_kernel_yama_ptrace_scope: 2
# yes/no: enable/disable creation of core dumps on kernel crashes
# These are usually not needed and may contain sensitive information
kernel_enable_core_dump: no
# no/yes: configure /proc mountpoint to hide processes from other users
# setting this to yes will likely break monitoring/process diagnostic tools (ps, htop, prometheus...)
kernel_proc_hidepid: no
# list of kernel modules to prevent from being loaded
kernel_modules_blacklist:
  - dccp # CIS 3.4.1 Ensure DCCP is disabled
  - sctp # CIS 3.4.2 Ensure SCTP is disabled
  - rds # CIS 3.4.3 Ensure RDS is disabled
  - tipc # 3.4.4 Ensure TIPC is disabled
  - firewire-ohci # disable IEEE 1394 (FireWire) Support
  - firewire-core # disable IEEE 1394 (FireWire) Support
  - cpia2 # CPiA2 cameras
  - floppy # floppy drives
  - n_hdlc # HDLC line discipline
  - pcspkr # PC speaker/beep
  - thunderbolt # thunderbolt devices
  - cramfs # CIS 1.1.1.5 mounting of squashfs filesystems is disabled
  - freevxfs # CIS 1.1.1.1 mounting of freevxfs filesystems is disabled
  - hfs # CIS 1.1.1.3 mounting of hfs filesystems is disabled
  - hfsplus # CIS 1.1.1.4 mounting of hfsplus filesystems is disabled
  - jffs2 # CIS 1.1.1.2 mounting of jffs2 filesystems is disabled
  - udf # CIS 1.1.1.6 mounting of udf filesystems is disabled
  # - soundcore # audio input/output
  # - usb-midi # USB MIDI
  # - usb-storage # CIS 1.1.10 disable USB storage - prevents usage of USB mass storage
  # - bluetooth # bluetooth support, STIG V-38682
  # - bnep # bluetooth support, STIG V-38682
  # - btusb # bluetooth support, STIG V-38682
  # - net-pf-31 # bluetooth support, STIG V-38682
  # - uvcvideo # UVC video devices
  # - v4l2_common # V4L2 video devices
  # - vfat # 1.1.1.7 mounting of FAT filesystems is limited - prevents EFI boot
  # - squashfs # CIS 1.1.1.5 mounting of squashfs filesystems is disabled

### PACKAGE MANAGEMENT ###
# yes/no: setup APT sources (security, backports) and automatic security upgrades
setup_apt: yes
# yes/no: enable contrib non-free and non-free-firmware software sections in debian APT repositories
apt_enable_nonfree: no
# clean downloaded package archives (apt clean) every n-days (0=disable)
apt_clean_days: 7
# yes/no: automatically remove (purge) configuration files of removed packages, nightly
apt_purge_nightly: yes
# automatic upgrades: allow unattended upgrades from the following sources (see 50unattended-upgrades.j2)
# these settings have no effect if corresponding repositories are not enabled/configured
apt_unattended_upgrades_origins_patterns:
  - "origin=Debian,codename=${distro_codename},label=Debian" # Debian stable
  - "origin=Debian,codename=${distro_codename}-updates" # Debian stable point release
  - "origin=Debian,codename=${distro_codename}-proposed-updates" # Debian stable proposed updates
  - "origin=Debian,codename=${distro_codename}-security,label=Debian-Security" # Debian security
  - "origin=Debian Backports,codename=${distro_codename}-backports,label=Debian Backports" # Debian backports
  - "origin=Jellyfin,site=repo.jellyfin.org" # nodiscc.xsrv.jellyfin
  - "o=Freight,a=stable,site=packages.graylog2.org" # nodiscc.xsrv.graylog
  - "o=mongodb,a=jammy,site=repo.mongodb.org" # nodiscc.xsrv.graylog
  - "o=elastic,a=stable,site=artifacts.elastic.co" # nodiscc.xsrv.graylog
  - "o=Prosody,a=stable,site=packages.prosody.im" # nodiscc.xsrv.jitsi
  - "o=jitsi.org,a=stable,site=download.jitsi.org,label=Jitsi Debian packages repository" # nodiscc.xsrv.jitsi
  - "o=matrix.org,site=packages.matrix.org" # nodiscc.xsrv.matrix
  - "o=Proxmox,site=download.proxmox.com" # nodiscc.toolbox.proxmox
  - "o=Docker,site=download.docker.com" # nodiscc.toolbox.docker

# yes/no: setup apt-listbugs
apt_listbugs: no
# what to do when apt-listbugs finds a bug in a package about to be installed (force-no (default), force-yes/force-default)
# force-no: abort the installation/upgrade as soon as bugs are found, unless bugs are listed in apt_listbugs_ignore_list
# force-yes/force-default: accept to continue with the installation/upgrade even when bugs are found
apt_listbugs_action: "force-no"
# Debian bug numbers/packages to ignore for apt-listbugs (don't let these bugs block package installation)
apt_listbugs_ignore_list:
  - 909750 # https://bugs.debian.org/909750 - reason: FHS violation, not critical
  - 933001 # https://bugs.debian.org/933001 - reason: plymouth is not installed
  - 933749 # https://bugs.debian.org/933749 - reason: disk space not a problem on most hosts
  - 935042 # https://bugs.debian.org/935042 - reason: skip-upgrade-test=yes set in monitoring role
  - 967010 # https://bugs.debian.org/967010 - reason: not reproducible
  - 935182 # https://bugs.debian.org/935182 - reason: only affects files on samba shares in specific setups
  - 928963 # https://bugs.debian.org/928963 - reason: only affects sparc64, powerpc64, and s390x architectures
  - 967010 # https://bugs.debian.org/967010 - reason: not reproducible
  - 918012 # https://bugs.debian.org/918012 - reason: only affects debian 9
  - 969072 # https://bugs.debian.org/969072 - reason: only happens during groff build, not when running the command
  - 987570 # https://bugs.debian.org/987570 - reason: packaging bug, no impact
  - 922981 # https://bugs.debian.org/922981 - reason: impact limited to new certificates, patch pending upload
  - 929685 # https://bugs.debian.org/929685 - packaging bug, no impact
  - 991449 # https://bugs.debian.org/991449 - not using bsd-mailx
  - 994510 # https://bugs.debian.org/994510 - only affects i386 architecture
  - 1000826 # https://bugs.debian.org/1000826 - only affects python 3.10
  - 1003150 # https://bugs.debian.org/1003150 - distutils already installed
  - 1000796 # https://bugs.debian.org/1000796 - no impact on common use cases
  - 993716 # https://bugs.debian.org/993716 - IPv6 is disabled
  - 945001 # https://bugs.debian.org/945001 - only affects hosts with multiple OS in grub
  - 948318 # https://bugs.debian.org/948318 - old lbc6 versions are automatically removed
  - 998516 # https://bugs.debian.org/998516 - only affects bridged interfaces, workaround in bug report
  - 990026 # https://bugs.debian.org/990026 - MAILTO not used in cron jobs
  - 1004111 # https://bugs.debian.org/1004111 - unconfirmed, unattended-upgrades failure will trigger an error report by mail
  - 1003012 # https://bugs.debian.org/1003012 - fixed in point release
  - 995387 # https://bugs.debian.org/994971 - only affects #994971/nvidia-driver not in use
  - 992045 # https://bugs.debian.org/992045 - fixed in debian-security, local only, high RAM usage noticeable by monitoring
  - 968368 # https://bugs.debian.org/968368 - option bond-master not in use
  - 990428 # https://bugs.debian.org/990428 - option bond-slaves not in use
  - 984574 # https://bugs.debian.org/984574 - fixed in point release, workaround in bug report
  - 998008 # https://bugs.debian.org/998008 - NIS not in use
  - 993578 # https://bugs.debian.org/993578 - fixed in point release, gpgconf --check-programs not used
  - 990318 # https://bugs.debian.org/990318 - no impact, incomplete removal of python2
  - 995115 # https://bugs.debian.org/995115 - unconfirmed, workaround is to comment out DPkg::Pre-Install-Pkgs in /etc/apt/apt.conf.d/10apt-listbugs
  - 991936 # https://bugs.debian.org/991936 - fixed in point release, no workaround available
  - 1016102 # https://bugs.debian.org/1016102 - edge case
  - 1001276 # https://bugs.debian.org/1001276 - kFreeBSD only
  - 975931 # https://bugs.debian.org/975931 - armhf only
  - 1008005 # https://bugs.debian.org/1008005 - no impact when installation of recommended packages is disabled
  - 1002047 # https://bugs.debian.org/1002047 - no impact when base option is present in configuration file
  - 895823 # https://bugs.debian.org/895823 - only happens after purging dovecot
  - 1009872 # https://bugs.debian.org/1009872 - only happens when /etc/ssl/certs/ssl-cert-snakeoil* were deleted manually
  - 1019564 # https://bugs.debian.org/1019564 - unreproducible
  - 1019855 # https://bugs.debian.org/1019855 - only affects 4th gen Intel Core CPUs
  - 1023812 # https://bugs.debian.org/1019855 - packaging bug without impact
  - 916596 # https://bugs.debian.org/916596 - not reproducible on a fresh debian installation
  - 1028638 # https://bugs.debian.org/1028638 - unreproducible
  - 1031336 # https://bugs.debian.org/1031336 - only affects debian sid
  - 1029342 # https://bugs.debian.org/1029342 - packaging bug without impact
  - 983393 # https://bugs.debian.org/983393 - ignored in bullseye, fixed in unstable
  - 1035483 # https://bugs.debian.org/1035483 - minor bug leading to false positive/debsums incorrectly detecting missing file
  - 993714 # https://bugs.debian.org/993714 - minor bug leading to false positive/debsums incorrectly detecting missing file
  - 1037258 # https://bugs.debian.org/1037258 - unreproducible
  - 1038422 # https://bugs.debian.org/1038422 - unreproducible
  - 1033167 # https://bugs.debian.org/1033167 - packaging bug, no impact
  - 1014503 # https://bugs.debian.org/1014503 - fixed, patch pending upload
  - 1035820 # https://bugs.debian.org/1035820 - packaging bug, no impact
  - 1036641 # https://bugs.debian.org/1036641 - packaging bug, no impact
  - 1039668 # https://bugs.debian.org/1039668 - no impact unless chromium-browser is installed
  - 1037478 # https://bugs.debian.org/1037478 - unreproducible
  - 1038603 # https://bugs.debian.org/1038603 - unreproducible, specific to some GCC-based build processes
  - 1030129 # https://bugs.debian.org/1030129 - unreproducible
  - 1041547 # https://bugs.debian.org/1041547 - no impact unless madin deliberately sets an empty root password
  - 1023748 # https://bugs.debian.org/1023748 - only affects java 20, debian 12 has java 17
  - 1039472 # https://bugs.debian.org/1039472 - fixed, patch pending upload
  - 1043415 # https://bugs.debian.org/1043415 - not applicable to upstream/packagecloud packages
  - 1051003 # https://bugs.debian.org/1051003 - only affects pam_shield
  - 1030284 # https://bugs.debian.org/1030284 - only affects arm64 architecture
  - 1057715 # https://bugs.debian.org/1057715 - only affects i386 architecture
  - 1061776 # https://bugs.debian.org/1061776 - only affects ssh jail on systems without rsyslog
  - 1037437 # https://bugs.debian.org/1037437 - only affects ssh jail on systems without rsyslog
  - 770171 # https://bugs.debian.org/770171 - only affects ssh jail on systems without rsyslog
  - 862348 # https://bugs.debian.org/862348 - only affects ssh jail on systems without rsyslog
  - 1058777 # https://bugs.debian.org/1058777 - licensing problem, fix available
  - 1051392 # https://bugs.debian.org/1051392 - only affects 32-bit architectures
  - 1114729 # https://bugs.debian.org/1114729 - only during dist-upgrade

### DATE/TIME ###
# yes/no: setup ntp time service
setup_datetime: yes
# timezone name (if commented out, timezone will not be changed)
# timezone: "Etc/UTC"

##### SSH SERVER #####
# setup/harden SSH server (yes/no)
setup_ssh: yes
# List of public SSH key files to authorize on the server for the ansible user
# Example: ['data/public_keys/john.pub', 'data/public_keys/jane.pub']
# Removing a key here does not remove it on the server!
ssh_authorized_keys: []
# sshd and SFTP server log levels, respectively (QUIET, FATAL, ERROR, INFO, VERBOSE, DEBUG, DEBUG1, DEBUG2, DEBUG3)
ssh_log_level: "VERBOSE"
ssh_sftp_loglevel: "INFO"
# allow clients to set locale/language-related environment variables (yes/no)
ssh_accept_locale_env: no
# types of SSH TCP forwarding to allow (no, local, remote, all - QUOTED)
# remote/all is required to use the host as a jumpbox
ssh_allow_tcp_forwarding: "no"
# enable/disable root SSH logins (yes/no/prohibit-password/forced-commands-only - QUOTED)
ssh_permit_root_login: "no"
# enable/disable SSH password authentication (yes, no - QUOTED)
ssh_password_authentication: "no"

##### FIREWALL #####

# setup firewall (yes/no)
setup_firewall: yes
# log rejected/dropped packets (all/unicast/broadcast/multicast/off)
firewalld_log_denied: all
# firewalld zones
# Example:
# firewalld_zone_sources:
#   - zone: internal # add 192.168.0.0/16 and 10.0.0.0/8 to the internal zone
#     sources: # list of IP addresses or networks (CIDR)
#       - 192.168.0.0/16
#       - 10.0.0.0/8
#     state: enabled # optional, enabled/disabled, default enabled
#     permanent: yes # optional, yes/no, default yes
#     immediate: yes # optional, yes/no, default yes
#   - zone: internal # remove 172.16.0.0/12 from the internal zone
#     sources:
#       - 172.16.0.0/12
#     state: disabled
#   - zone: drop # drop all traffic coming from these addresses
#     sources:
#       - 10.11.12.13/24
#       - 15.8.4.6
#   - zone: ldap-clients # custom zone, incoming traffic from specific hosts
#     sources:
#       - 192.168.1.2
#       - 192.168.1.3
#   - zone: delete-this-zone
#     delete: yes # set delete: yes to completely delete the zone
firewalld_zone_sources:
  - zone: internal # add all RFC1918 addresses to the internal zone
    sources:
      - 192.168.0.0/16
      - 172.16.0.0/12
      - 10.0.0.0/8
# services to allow in firewalld zones
# Example:
# firewalld_zone_services:
#   - zone: public # firewall zone to configure
#     services: # list of services to add/remove from the zone
#       - ssh
#     state: disabled # optional, enabled/disabled, default enabled, set to disabled to remove a rule
#     permanent: yes # optional, yes/no, default yes
#     immediate: yes # optional, yes/no, default yes
#   - zone: internal
#     services:
#       - dns # allow DNS from the internal zone
#   - zone: ldap-clients # allow traffic for a specific service from a zone
#     services:
#       - ldap
#       - ldaps
firewalld_zone_services:
  - zone: public
    services:
      - ssh # allow SSH from anywhere
  - zone: internal
    services:
      - ssh # allow SSH from internal zone
  - zone: public
    services:
      - dhcpv6-client # remove dhcpv6-client rule from the default public zone
    state: disabled
# list of IP addresses/networks to block globally
# Example:
# firewalld_blocklist:
#   - 1.2.3.4
#   - 5.6.7.8/24
#   - 9.10.11.12/16
firewalld_blocklist: []

# additional firewalld configuration - https://docs.ansible.com/ansible/latest/collections/ansible/posix/firewalld_module.html
firewalld: []

### FAIL2BAN ###
# setup fail2ban bruteforce detection/prevention system (yes/no)
setup_fail2ban: yes
# list of IPs to never ban - 127.0.0.1 is always whitelisted
fail2ban_ignoreip:
  - '10.0.0.0/8'
  - '192.168.0.0/16'
  - '172.16.0.0/12'
# fail2ban default ban duration (in seconds or time abbreviation format)
fail2ban_default_bantime: "1year"
# fail2ban: default interval (in seconds or time abbreviation format) before counting failures towards a ban
fail2ban_default_findtime: "10min"
# fail2ban default number of failures that have to occur in the last findtime to ban the IP
fail2ban_default_maxretry: 3

### LINUX USERS ###
# setup user accounts/PAM configuration (yes/no)
setup_users: yes
# Additional user accounts to create.
# Supports these parameters from the user (https://docs.ansible.com/ansible/latest/modules/user_module.html) module:
#   name, password, comment, create_home, home, groups, append, generate_ssh_key, update_password
# In addition these optional parameters are supported:
#   ssh_authorized_keys: list of public key files to authorize on this account
#   sudo_nopasswd_commands: list of commands the user should be able to run with sudo without password
# Example:
# linux_users:
#   - name: "remotebackup"
#     groups: [ "ssh-access", "sudo" ]
#     comment: "limited user account for remote backups"
#     ssh_authorized_keys: ['data/public_keys/root@backup.EXAMPLE.org.pub']
#     home: "/home/remotebackup"
#     sudo_nopasswd_commands: ['/usr/bin/rsync']
#   - name: "my-sftp-account"
#     home: "/var/lib/sftp/my-sftp-account"
#     comment: "SFTP-only account"
#     ssh_authorized_keys: [ "data/public_keys/gitlab-runner@my.EXAMPLE.org.pub", "data/public_keys/client1@EXAMPLE.org.pub" ]
#     groups: [ 'ssh-access', 'sftponly' ]
#   - name: "{{ ansible_user }}"
#     groups: adm
#     append: yes
#     comment: "ansible user/allowed to read system logs"
#   - name: bob
#     groups: ['ssh-access', 'sudo']
#     password: "{{ bob_ssh_password }}"
#     comment: "SSH account for bob, root access via sudo"
linux_users: []
# allow ansible connecting user to run 'sudo rsync' without password (yes/no)
# Required to use the ansible synchronize module, and download files generated by the backup role
ansible_user_allow_sudo_rsync_nopasswd: yes
# kill user processes when an interactive user logs out (yes/no)
systemd_logind_kill_user_processes: yes
# do not kill processes on logout for these users
systemd_logind_kill_exclude_users: ['root']
# time after which idle interactive login sessions are automatically closed (minutes, set to 0 to disable)
systemd_logind_lock_after_idle_min: 0
# terminate interactive bash processes after this number of seconds if no input is received (set to 0 to disable)
bash_timeout: 900


### CRON TASK SCHEDULER ###
# (yes/no): setup cron permission restrictions/logging options
setup_cron: yes
# list of users allowed to use crontab for task scheduling
linux_users_crontab_allow: ['root']
# cron jobs log level (cumulative, https://manpages.debian.org/bookworm/cron/cron.8.en.html#OPTIONS)
cron_log_level: 7

### OUTGOING MAIL ###
# (yes/no) install outgoing system mail (msmtp)
setup_msmtp: no
# following msmtp_* variables are required is setup_msmtp: yes
# mail relay (SMTP server) address/port/username/password
msmtp_host: "smtp.CHANGEME.org"
msmtp_port: 587
msmtp_username: "CHANGEME"
msmtp_password: "CHANGEME"
# mail address to send administrator email to (multiple recipients can be added, separated by ', ')
msmtp_admin_email: "CHANGEME"
# (auto/admin@CHANGEME.org) sender address for outgoing mail
msmtp_from: 'auto'
# enable SMTP authentication (LOGIN) (yes/no)
msmtp_auth_enabled: yes
# yes/no: enable STARTTLS connection to the SMTP server
msmtp_tls_enabled: yes
# yes/no: enforce checking for valid server TLS certificates
msmtp_tls_certcheck: yes
# yes/no: use STARTTLS
msmtp_starttls: yes
# (optional) TLS certificate fingerprint of the SMTP server. use this to accept a self-signed certificate. get the server's certificate fingerprint with openssl s_client -connect $smtp_host:587 -starttls smtp < /dev/null 2>/dev/null |openssl x509 -fingerprint -noout
# msmtp_host_fingerprint: '11:22:33:44:55:66:77:88:99:00:13:37:AA:BB:CC:DD:EE:FF:AD:C2'
# the user to forward all local root mail to, if msmtp setup is disabled
mail_root_alias: "{{ ansible_user }}"


### PACKAGES ###
# additional packages to install (list)
packages_install:
  - atool # single tool to manipulate all archives/compressed file formats
  - less # a pager like 'more'
  - tree # show filesystems as a tree
  - rsync # fast/powerful file transfer utility
  - locate # maintain and query an index of a directory tree
  - man # view manual pages
  - at # task scheduler - required for ansible at module/one-shot job scheduling
  - bash-completion # completion for the bash shell

# packages to remove (list)
packages_remove:
  - snapd
  # - rpcbind # not an NFS server
  # - nfs-common # not an NFS server
  # - exim4-base # use a smarthost/msmtp
```


## dnsmasq

[roles/dnsmasq/defaults/main.yml](https://gitlab.com/nodiscc/xsrv/-/blob/master/roles/dnsmasq/defaults/main.yml)

```yaml
##### DNSMASQ DNS SERVER #####
# list of recursive DNS servers to forward DNS requests to (IP addresses)
# either your own/private recursive DNS resolver, your ISP/hosting provider's resolver, or a public DNS server (https://en.wikipedia.org/wiki/Public_recursive_name_server)
# 2 entries are recommended in case the primary one fails
# Example:
# dnsmasq_upstream_servers:
#   - 1.1.1.1 # https://en.wikipedia.org/wiki/1.1.1.1
#   - 1.0.0.1 # https://en.wikipedia.org/wiki/1.1.1.1
#   - 8.8.8.8 # https://en.wikipedia.org/wiki/Google_Public_DNS
#   - 8.8.4.4 # https://en.wikipedia.org/wiki/Google_Public_DNS
#   - 185.222.222.222 # https://dns.sb/guide/
#   - 45.11.45.11 # https://dns.sb/guide/
dnsmasq_upstream_servers:
  - CHANGEME
  - CHANGEME
# List of DNS A records (name, ip)
# Example:
# dnsmasq_records:
#   - name: my.example.org # the record name
#     ip: 1.2.3.4 # IP address to return for this name
dnsmasq_records: []
# firewall zones for the DNS service (zone, state), if nodiscc.xsrv.common/firewalld role is deployed
# 'zone:' is one of firewalld zones, set 'state:' to 'disabled' to remove the rule (the default is state: enabled)
dnsmasq_firewalld_zones:
  - zone: internal
    state: enabled
# start/stop the dnsmasq service, enable/disable it on boot (yes/no)
dnsmasq_enable_service: yes
# list of network interfaces dnsmasq should listen on
# leave the list empty [] to listen on all interfaces
# Example:
# dnsmasq_listen_interfaces:
#   - eth0
#   - eth1
dnsmasq_listen_interfaces: []
# list of IP addresses dnsmasq should listen on
# leave the list empty [] to listen on all addresses
# Example:
# dnsmasq_listen_addresses:
#   - 127.0.0.1
dnsmasq_listen_addresses: []
# use DNSSEC to validate answers to DNS queries (yes/no)
# if enabled, dig @127.0.1.1 dnssec-failed.org should return SERVFAIL
dnsmasq_dnssec: yes
# log DNS queries prcessed by dnsmasq (VERY verbose) (no/yes)
dnsmasq_log_queries: no
# URL of a DNS blocklist to download and load into dnsmasq
# Examples:
#   https://raw.githubusercontent.com/hagezi/dns-blocklists/main/dnsmasq/pro.txt (dnsmasq format)
#   https://raw.githubusercontent.com/hagezi/dns-blocklists/main/hosts/pro.txt (hosts format)
#   https://raw.githubusercontent.com/StevenBlack/hosts/master/hosts (hosts format)
#   see also https://github.com/hagezi/dns-blocklists/, https://github.com/StevenBlack/hosts, https://firebog.net/
dnsmasq_blocklist_url: "https://raw.githubusercontent.com/hagezi/dns-blocklists/main/dnsmasq/pro.txt" # dnsmasq format
# blocklist mode (hosts/dnsmasq/disabled)
# hosts: parse the blocklist as standard linux hosts file (the file must be formatted as a valid hosts file)
# dnsmasq: parse the blocklist as dnsmasq configuration file (the file must be formatted as a valid dnsmasq configuration file)
# disabled: don't download or parse any blocklist
dnsmasq_blocklist_mode: disabled
# list of domain names to remove from the blocklist before loading it (aka. excepyions or whitelist)
# Example:
# dnsmasq_blocklist_whitelist
#   - example.org
#   - requiredforwork.example.com
dnsmasq_blocklist_whitelist: []
```


## gitea_act_runner

[roles/gitea_act_runner/defaults/main.yml](https://gitlab.com/nodiscc/xsrv/-/blob/master/roles/gitea_act_runner/defaults/main.yml)

```yaml
##### GITEA ACTIONS RUNNER #####
# FQDN of the gitea instance to register the runner on
gitea_act_runner_gitea_instance_fqdn: "{{ gitea_fqdn | default('git.CHANGEME.org') }}"
# inventory hostname of the gitea host to register the runner on (if different from the runner host)
# gitea_act_runner_gitea_instance_hostname: "CHANGEME"
# how many tasks the runner can execute concurrently at the same time (integer)
gitea_act_runner_capacity: 1
# container engine to use (docker/podman)
gitea_act_runner_container_engine: "podman"
# network to which the containers managed by act-runner will connect (host/bridge/custom)
# set to an empty string to have act-runner create a network automatically. "host" is required when using gitea_act_runner_container_engine: podman, and the gitea instance is on the same host as the runner
gitea_actions_runner_container_network: "host"
# list of labels to use when registering the runner (https://docs.gitea.com/usage/actions/design)
# If the list of labels is changed, the runner must be unregistered (delete /var/lib/act-runner/.runner) and the role must be redeployed
# Add "host:host" to this list to allow running workflows directly on the host, without containerization (and specify "runs-on: host" in your workflow yml file)
# If host-based workflows are allowed, you probably want to install the nodejs package on the host so that nodejs-based actions can run
# Example:
# gitea_act_runner_labels:
#   - 'host:host'
#   - "debian-bookworm-backports:docker://debian:bookworm-backports"
gitea_act_runner_labels:
  - "debian-latest:docker://node:21-bookworm"
  - "ubuntu-latest:docker://node:21-bookworm"
  - "ubuntu-22.04:docker://node:16-bullseye"
  - "ubuntu-20.04:docker://node:16-bullseye"
  - "ubuntu-18.04:docker://node:16-buster"
# prune act-runner's podman downloaded images/stopped containers nightly at 03:30 to save disk space (no/yes)
gitea_act_runner_daily_podman_prune: no
# act-runner version (https://gitea.com/gitea/act_runner/releases, remove leading v)
gitea_act_runner_version: "0.2.12"
# start/stop the gitea actions runner service, enable/disable it on boot (yes/no)
gitea_act_runner_enable_service: yes
```


## gitea

[roles/gitea/defaults/main.yml](https://gitlab.com/nodiscc/xsrv/-/blob/master/roles/gitea/defaults/main.yml)

```yaml
##### GITEA SELF-HOSTED GIT SERVICE #####
# fully qualified domain name of the gitea instance
gitea_fqdn: "git.CHANGEME.org"
# username/password/e-mail address for the gitea admin user
gitea_admin_username: "CHANGEME"
gitea_admin_password: "CHANGEME"
gitea_admin_email: "CHANGEME"
# 106 character token used for internal API calls authentication
gitea_internal_token: "CHANGEME"
# 64 character global secret key
gitea_secret_key: "CHANGEME"
# 43 character OAuth2 JWT secret
gitea_oauth2_jwt_secret: "CHANGEME"
# 43 character LFS JWT secret
gitea_lfs_jwt_secret: "CHANGEME"
# home directory for the gitea user
gitea_user_home: /var/lib/gitea
# gitea base URL under the domain name (eg change. it to /gitea to serve from https://git.CHANGEME.org/gitea)
gitea_base_url: "/"
# start/stop the gitea service, enable/disable it on boot (yes/no) (redirect users to maintenance page if disabled)
gitea_enable_service: yes
# gitea database settings
gitea_db_type: "postgres" # postgres/mysql
gitea_db_name: "gitea"
gitea_db_user: "gitea"
gitea_db_host: "/run/postgresql/" # /run/postgresql/ for a local postgresql database/peer authentication
gitea_db_password: "" # leave empty for local postgresql database/peer authentication
gitea_db_port: 5432 # usually 5432 for PostgreSQL, 3306 for MySQL
# gitea version to install - https://github.com/go-gitea/gitea/releases.atom; remove leading v
gitea_version: "1.24.7"
# HTTPS and SSL/TLS certificate mode for the gitea webserver virtualhost
#   letsencrypt: acquire a certificate from letsencrypt.org
#   selfsigned: generate a self-signed certificate
gitea_https_mode: selfsigned
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
# number of issues that are displayed on one page
gitea_issue_paging_num: 20
# enable/disable gitea REST API (true/false - QUOTED)
gitea_enable_api: "true"
# max number of items in API responses
gitea_api_max_results: 1000
# enable the built-in Gitea Actions CI/CD system (yes/no)
gitea_enable_actions: no
# The minimum password length for new Users
gitea_min_password_length: 10
# comma-separated list of charactacter classes required in passwords (lower,upper,digit,spec or off)
gitea_password_complexity: "lower,upper,digit,spec"
# Allow new users to create organizations by default (true/false - QUOTED)
gitea_default_allow_create_organization: "false"
# yes/no: allow users with git hook privileges to create custom git hooks
# Custom git hooks can be used to perform arbitrary code execution on the host operating system, access and modify files owned by gitea, the database and gain administrator privileges, and access/perform arbitrary actions other resources available to the gitea user on the operating system. Use with caution.
gitea_enable_git_hooks: no
# yes/no: enable/disable the webhooks feature
gitea_enable_webhooks: yes
# list of hosts that can be called from webhooks
# accepts: my.example.org (hostname), *.example.org (wildcards), 192.168.1.0/24 (IP network), loopback (localhost), private (LAN/intranet), external (public hosts on internet), * (all hosts)
gitea_webhook_allowed_hosts:
  - "external"
# port to expose in the clone URL
gitea_ssh_url_port: 22
# enable indexing/searching of repository contents (can consume a lot of system resources)
gitea_repo_indexer_enabled: no
# list of filenames (glob patterns) to exclude from the index. Example:
# gitea_repo_indexer_exclude:
#   - 'resources/bin/**'
#   - '.npm/**'
gitea_repo_indexer_exclude: []
# enable outgoing mail (yes/no)
gitea_mailer_enabled: no
# mail settings below are required if gitea_mailer_enabled: yes
# Mail server protocol (smtp/smtps/smtp+starttls/smtp+unix/sendmail/dummy)
gitea_mail_protocol: "smtp+starttls"
# SMTP mail server address
gitea_mail_host: "{{ msmtp_host | default('smtp.CHANGEME.org') }}"
# SMTP mail server port (e.g. 25/465/587)
gitea_mail_port: "{{ msmtp_port | default('CHANGEME') }}"
# 'From' address used in mails sent by gitea
gitea_mail_from: "{{ msmtp_admin_email | default('gitea-noreply@CHANGEME.org') }}"
# username and password for SMTP authentication
gitea_mail_user: "{{ msmtp_username | default('CHANGEME') }}"
gitea_mail_password: "{{ msmtp_password | default('CHANGEME') }}"
# list of IP addresses allowed to access the gitea web interface (IP or IP/netmask format)
# set to empty list [] to allow access from any IP address
gitea_allowed_hosts: []
```


## gotty

[roles/gotty/defaults/main.yml](https://gitlab.com/nodiscc/xsrv/-/blob/master/roles/gotty/defaults/main.yml)

```yaml
##### GOTTY WEB TERMINAL #####
# fully qualified domain name of the gotty instance
gotty_fqdn: "tty.CHANGEME.org"
# username/password for gotty HTTP basic authentication
gotty_auth_username: "CHANGEME"
gotty_auth_password: "CHANGEME"
# linux username to run the gotty process as
gotty_run_username: "CHANGEME"
# command to run as soon as a client connects
gotty_run_command: "bash"
# (yes/no) allow users to write to the terminal
gotty_permit_write: no
# HTTPS and SSL/TLS certificate mode for the gotty webserver virtualhost
#   letsencrypt: acquire a certificate from letsencrypt.org
#   selfsigned: generate a self-signed certificate
gotty_https_mode: selfsigned
# start/stop the gotty service, enable/disable it on boot (yes/no)
gotty_enable_service: yes
# (seconds) time to wait before killing chil processes after client is disconnected
gotty_close_timeout: 60
# (yes/no) enable reconnection
gotty_reconnect: no
# (seconds) time to reconnect
gotty_reconnect_time: 10
# (seconds) timeout seconds for waiting a client
gotty_input_timeout: 0
# IP address to listen on
gotty_listen_address: "0.0.0.0"
# gotty release/version number (https://github.com/sorenisanerd/gotty/releases, without leading v)
gotty_version: "1.6.0"
# list of IP addresses allowed to access gotty (IP or IP/netmask format)
# set to empty list [] to allow access from any IP address
gotty_allowed_hosts: []
```


## graylog

[roles/graylog/defaults/main.yml](https://gitlab.com/nodiscc/xsrv/-/blob/master/roles/graylog/defaults/main.yml)

```yaml
##### GRAYLOG LOG AGGREGATION/ANALYSIS PLATFORM #####
# fully qualified domain name of the graylog instance
graylog_fqdn: "logs.CHANGEME.org"
# graylog admin username/password, and secret key for hashing passwords
graylog_root_username: "CHANGEME"
graylog_root_password: "CHANGEME20"
graylog_secret_key: "CHANGEME96"
# password for the mongodb admin user
mongodb_admin_password: "CHANGEME20"
# password for the mongodb graylog user
graylog_mongodb_password: "CHANGEME20"
# timezone of the graylog admin user, from https://www.joda.org/joda-time/timezones.html
graylog_root_timezone: "UTC"
# start and end validity dates for TLS certificates for syslog inputs (YYYYMMDDHHMMSSZ)
graylog_cert_not_before: "20240219000000Z"
graylog_cert_not_after: "20340219000000Z"
# HTTPS and SSL/TLS certificate mode for the graylog webserver virtualhost
#   letsencrypt: acquire a certificate from letsencrypt.org
#   selfsigned: generate a self-signed certificate
graylog_https_mode: selfsigned
# start/stop the graylog/elasticsearch/mongodb services, enable/disable them on boot (yes/no) (redirect users to maintenance page if disabled)
graylog_enable_service: yes
# (512m/1g...) JVM memory heap size for graylog
graylog_heap_size: "1g"
# (auto/512m/1g...) JVM memory heap size for elasticsearch
elasticsearch_heap_size: "auto"
# (auto/seconds) timeout for elasticsearch systemd service startup
# set a longer value if the elasticsearch systemd service fails to start/times out
elasticsearch_timeout_start_sec: auto
# list of IP addresses allowed to access the graylog web interface (IP or IP/netmask format)
# set to empty list [] to allow access from any IP address
graylog_allowed_hosts: []
# firewall zones for graylog TCP inputs, if nodiscc.xsrv.common/firewalld role is deployed
# 'zone:' is one of firewalld zones, set 'state:' to 'disabled' to remove the rule (the default is state: enabled)
graylog_tcp_firewalld_zones:
  - zone: internal
    state: enabled
```


## homepage

[roles/homepage/defaults/main.yml](https://gitlab.com/nodiscc/xsrv/-/blob/master/roles/homepage/defaults/main.yml)

```yaml
##### HOMEPAGE #####
# Fully Qualified Domain Name for the homepage
homepage_fqdn: "www.CHANGEME.org"
# main title of the homepage
homepage_title: "{{ homepage_fqdn }}"
# freeform message/paragraph displayed on the homepage (HTML allowed)
homepage_message: "<i>Welcome to this server managed by <a href='https://xsrv.readthedocs.io'>xsrv</a></i>"
# custom links to add to the homepage, in addition to auto-generated links (list)
# Example:
# homepage_custom_links:
#   - url: https://myapp.EXAMPLE.org # URL to link to
#     title: "My App" # title of the link
#     description: "A custom application" # (optional, default empty) description of the link
#     icon: sftp # (optional, default globe) icon file for the link, one of https://gitlab.com/nodiscc/xsrv/-/tree/master/roles/homepage/files/res without .png extension
#     compact: no # (optional, yes/no, default no) make this link/tile half as wide, and hide description (pick a short title or it will overflow)
#   - url: https://anotherapp.EXAMPLE.org
#     title: "Another App"
homepage_custom_links: []
# HTTPS and SSL/TLS certificate mode for the homepage webserver virtualhost
#   letsencrypt: acquire a certificate from letsencrypt.org
#   selfsigned: generate a self-signed certificate
homepage_https_mode: selfsigned
# list of additional aliases/domain names for the homepage, in addition to homepage_fqdn. example:
# homepage_vhost_aliases:
#   - www.CHANGEME.org
#   - CHANGEME.org
#   - 192.168.8.0
homepage_vhost_aliases: []
# list of IP addresses allowed to access the homepage (IP or IP/netmask format)
# set to empty list [] to allow access from any IP address
homepage_allowed_hosts: []
# enable/disable the homepage virtualhost (yes/no) (redirect users to maintenance page if disabled)
homepage_enable_service: yes
```


## jellyfin

[roles/jellyfin/defaults/main.yml](https://gitlab.com/nodiscc/xsrv/-/blob/master/roles/jellyfin/defaults/main.yml)

```yaml
##### JELLYFIN MEDIA SERVER #####
# fully qualified domain name of the jellyfin instance
jellyfin_fqdn: "media.CHANGEME.org"
# list of linux users to add to the jellyfin group (may read/write files inside the media directory)
jellyfin_users:
  - "{{ ansible_user }}"
# HTTPS and SSL/TLS certificate mode for the jellyfin webserver virtualhost
#   letsencrypt: acquire a certificate from letsencrypt.org
#   selfsigned: generate a self-signed certificate
jellyfin_https_mode: selfsigned
# start/stop the jellyfin webserver, enable/disable it on boot, redirect users to maintenance page if disabled (yes/no)
jellyfin_enable_service: yes
# yes/no: enable automatic backups of the default jellyfin media directory (when the nodiscc.xsrv.backup role is managed by ansible)
# disabled by default - this can consume a lot of space on the backup storage, please configure backups manually or set this to yes if you really want to backup all media
# backups of the jellyfin samba share are controlled by a different variable (samba_enable_backups)
# database/metadata/configuration is always backed up automatically when the backup role is enabled
jellyfin_enable_media_backups: no
# install and configure opensubtitles plugin (yes/no)
jellyfin_setup_opensubtitles_plugin: no
# opensubtitles plugin username/password/API key (from https://opensubtitles.com/ account page)
jellyfin_opensubtitles_plugin_username: "CHANGEME"
jellyfin_opensubtitles_plugin_password: "CHANGEME"
jellyfin_opensubtitles_plugin_apikey: "CHANGEME"
# enable a jellyfin samba share (upload media files there)
# requires the nodiscc.xsrv.samba role to be deployed before jellyfin
jellyfin_samba_share_enabled: no
# lists of users allowed to read/write to the jellyfin samba share (use @groupname for groups)
jellyfin_samba_share_allow_write_users: []
jellyfin_samba_share_allow_read_users: []
# list of IP addresses allowed to access jellyfin (IP or IP/netmask format)
# for security reasons only private/RFC1918 addresses are allowed by default
# set to empty list [] to allow access from any IP address
jellyfin_allowed_hosts:
  - '192.168.0.0/16'
  - '172.16.0.0/12'
  - '10.0.0.0/8'
```


## jitsi

[roles/jitsi/defaults/main.yml](https://gitlab.com/nodiscc/xsrv/-/blob/master/roles/jitsi/defaults/main.yml)

```yaml
##### JITSI MEET VIDEO CONFERENCE PLATFORM #####
# fully qualified domain name of the jitsi meet instance
jitsi_fqdn: "conference.CHANGEME.org"
# random secret shared between the TURN and XMPP server
jitsi_turn_secret: "CHANGEME"
# random secret shared between jitsi/jicofo and the XMPP server
jitsi_prosody_password: "CHANGEME"
# random secret shared between jitsi/videobridge and the XMPP server
jitsi_jvb_prosody_password: "CHANGEME"
# only allow registered users to create rooms (yes/no)
# if yes, whenever a new room is about to be created, Jitsi Meet will prompt for a user name and password. After the room is created, guests will be able to join without authentication.
jitsi_secure_domain: yes
# registered users (allowed to create rooms when jitsi_secure_domain: yes)
#   name: the account name
#   password: the account password
#   state: absent/present (default present), set to absent to delete the account
# Example:
# jitsi_users:
#   - name: CHANGEME
#     password: CHANGEME
#   - name: remove-this-account
#     state: absent
jitsi_users: []
# enable/disable the recent rooms list on the welcome page (yes/no)
jitsi_enable_recent_list: no
# HTTPS and SSL/TLS certificate mode for the jitsi webserver virtualhost
#   letsencrypt: acquire a certificate from letsencrypt.org
#   selfsigned: generate a self-signed certificate
jitsi_https_mode: selfsigned
# start/stop the jitsi service, enable/disable it on boot (yes/no) (redirect users to maintenance page if disabled)
jitsi_enable_service: yes
# list of IP addresses allowed to access the jitsi web interface (IP or IP/netmask format)
# set to empty list [] to allow access from any IP address
jitsi_allowed_hosts: []
# firewall zones for the jitsi server, if nodiscc.xsrv.common/firewalld role is deployed
# 'zone:' is one of firewalld zones, set 'state:' to 'disabled' to remove the rule (the default is state: enabled)
jitsi_firewalld_zones:
  - zone: public
    state: enabled
  - zone: internal
    state: enabled
```


## kiwix

[roles/kiwix/defaults/main.yml](https://gitlab.com/nodiscc/xsrv/-/blob/master/roles/kiwix/defaults/main.yml)

```yaml
##### KIWIX WIKI SERVER #####
# fully qualified domain name of the kiwix server instance
kiwix_fqdn: kiwix.CHANGEME.org
# list of kiwix zim file URLs to to download and serve
# See https://library.kiwix.org/# for a list of all available wikis
# Examples:
# kiwix_zim_urls:
# - https://download.kiwix.org/zim/wikipedia/wikipedia_en_all_maxi_2024-01.zim # 109GB, full english wikipedia
# - https://download.kiwix.org/zim/wikipedia/wikipedia_en_all_nopic_2024-06.zim # english wikipedia without pictures
# - https://download.kiwix.org/zim/wikipedia/wikipedia_fr_all_maxi_2024-05.zim # 37GB, full french wikipedia
# - https://download.kiwix.org/zim/other/ekopedia_fr_all_maxi_2021-03.zim # 17MB, french wikipedia without pictures
# - https://download.kiwix.org/zim/other/rationalwiki_en_all_maxi_2021-03.zim #116MB, rationalwiki.org
kiwix_zim_urls:
  - https://download.kiwix.org/zim/other/rationalwiki_en_all_maxi_2021-03.zim # 116MB
  - https://download.kiwix.org/zim/other/ekopedia_fr_all_maxi_2021-03.zim # 17MB
# yes/no: enable/disable kiwix server service, start it at boot
kiwix_enable_service: yes
# list of IP addresses allowed to access the kiwix web interface (IP or IP/netmask format)
# set to empty list [] to allow access from any IP address
kiwix_allowed_hosts: []
# HTTPS and SSL/TLS certificate mode for the kiwix webserver virtualhost
#   letsencrypt: acquire a certificate from letsencrypt.org
#   selfsigned: generate a self-signed certificate
kiwix_https_mode: selfsigned
# include kiwix data files in backups (when the nodiscc.xsrv.backup role is managed by ansible) (yes/no)
kiwix_backup_data: no
```


## libvirt

[roles/libvirt/defaults/main.yml](https://gitlab.com/nodiscc/xsrv/-/blob/master/roles/libvirt/defaults/main.yml)

```yaml
##### LIBVIRT VIRTUALIZATION TOOLKIT #####
# list of libvirt networks
# https://docs.ansible.com/ansible/latest/collections/community/libvirt/virt_net_module.html
# https://libvirt.org/formatnetwork.html
# Example:
# libvirt_networks:
#  - name: default
#    mac_address: "52:54:00:4f:b1:01"
#    forward_dev: "eth0" # optional
#    bridge_name: "virbr2"
#    ip_address: "10.0.100.1"
#    netmask: "255.255.255.0"
#    dhcp_start: "10.0.100.128" # optional
#    dhcp_end: "10.0.100.254" # optional
#    autostart: yes # optional, yes/no, default yes
#    state: present # optional, active/inactive/present/absent, default active
libvirt_networks: []

# list of libvirt storage pools
# https://libvirt.org/formatstorage.html
# https://docs.ansible.com/ansible/latest/collections/community/libvirt/virt_pool_module.html
# Example:
# libvirt_storage_pools:
#  - name: pool0
#    path: /var/lib/libvirt/pools/pool0
#    mode: "0750" # optional, QUOTED, default 0750
#    owner_uid: "1003" # optional, QUOTED, default 0 (root)
#    group_gid: "64055" # optional, QUOTED, default 64055 (libvirt-qemu)
#    autostart: yes # optional, default yes
#    state: inactive # optional, active/inactive/present/absent/undefined/deleted, default active
#  - name: delete-this-pool
#    state: undefined
#  - name: delete-this-pool-and-its-contents
#    state: deleted
libvirt_storage_pools: []

# List of libvirt VMs to create/start/stop/shutdown/delete
# 'state: absent' deletes the VM BUT NOT THEIR DISKS/STORAGE VOLUMES (a.k.a. virsh undefine --delete-all-storage)
# 'state: destroyed' stops the VM without proper shutdown
# xml_file must point to a file containing a libvirt VM XML definition (https://libvirt.org/formatdomain.html). You can use xsrv init-vm --dump option to display XML during VM creation.
# Example:
# libvirt_vms:
#  - name: vm01.CHANGEME.org # name of the VM/guest
#    state: present # present/running/destroyed/shutdown/absent, default present
#    autostart: yes # optional, default yes
#    xml_file: "{{ playbook_dir }}/data/libvirt/vm01.CHANGEME.org.xml" # path to XML file containing the VM definition, required when state: present/running/destroyed/shutdown
#  - name: remove.this.vm
#    state: absent
libvirt_vms: []

# number of VMs to shutdown in parallel when the hypervisor is being shut down
libvirt_parallel_shutdown_number: 3

# DNAT/port forwarding to libvirt VMs
# Example:
# libvirt_port_forwards:
#   - vm_name: vm01.EXAMPLE.org # VM name (rules will be applied/removed when this VM starts/shuts down)
#     vm_ip: 10.2.0.225 # forward connections to the VM on this IP address
#     vm_bridge: virbr2 # forward connections to the VM through this bridge
#     host_interface: eth0 # forward connections arriving on this interface on the libvirt host
#     dnat: # list of port forwarding/translation (DNAT) rules
#       - host_port: 25 # forward (DNAT) connections arriving on this port on the libvirt host
#         vm_port: 25 # forward connections to this port on the VM
#         protocol: tcp # (optional, tcp/udp, default tcp) forward connections using this protocol
#       - host_port: 19225# redirect port 19225 on the host to port 19999 on the VM
#         vm_port: 19999
#       - host_port: 2456-2458 # port range, separated by -
#         vm_port: 2456-2458
#         protocol: udp
#   - vm_name: vm02.EXAMPLE.org
#     vm_ip: 10.3.0.226
#     vm_bridge: virbr3
#     host_interface: eth0
#     dnat:
#       - host_port: 22226
#         vm_port: 22
#       - host_port: 19226
#         vm_port: 19999
libvirt_port_forwards: []

# list of systemd units that should be started before libvirtd starts (for example mount units)
# Example:
# libvirt_service_after:
#  - mnt-KVMSTORAGE1.mount
#  - mnt-KVMSTORAGE2.mount
libvirt_service_after: []

# list of users who will be added to the libvirt/libvirt-qemu/kvm groups (can manage libvirt VMS without sudo)
# Note: setting the default connection URI only works for login shells (e.g. SSH/console), so you may need to add `export LIBVIRT_DEFAULT_URI='qemu:///system'` to your `~/.bashrc` if your terminal emulator uses non-login shells
# Example:
# libvirt_users:
#   - "{{ ansible_user }}"
#   - libvirt-admin
#   - anotheruser
libvirt_users:
  - "{{ ansible_user }}"
```


## mail_dovecot

[roles/mail_dovecot/defaults/main.yml](https://gitlab.com/nodiscc/xsrv/-/blob/master/roles/mail_dovecot/defaults/main.yml)

```yaml
##### DOVECOT MAIL SERVER (IMAP/MDA) #####
# domain name used to access the IMAP server
dovecot_fqdn: "imap.CHANGEME.org"
# URI of the LDAP server to use for authentication (use ldap:// or ldaps://)
dovecot_ldap_uri: "ldap://ldap.CHANGEME.org"
# LDAP base DN used to search for user accounts
dovecot_ldap_base: "ou=users,dc=CHANGEME,dc=org"
# DN of the unprivileged/"bind" LDAP user used to lookup user accounts in the directory
dovecot_ldap_bind_dn: "cn=bind,ou=system,dc=CHANGEME,dc=org"
# password for the "bind" LDAP user
dovecot_ldap_bind_password: "CHANGEME"
# LDAP user filter, the default value allows logins to the IMAP server by username OR e-mail address
dovecot_ldap_user_filter: "(&(objectClass=inetOrgPerson)(|(uid=%u)(mail=%u)))"
# mappign between LDAP attributes and IMAP user/password
dovecot_ldap_pass_attrs: "mail=user,userPassword=password"
# log authentication debugging messages (yes/no)
dovecot_auth_debug: no
# allow unencrypted IMAP on port 143/tcp (yes/no)
dovecot_listen_imap: no
# require SSL (yes/no)
dovecot_ssl_required: yes
# disable plaintext authentication when SSL is not used (yes/no)
dovecot_disable_plaintext_auth: yes
# start/stop the dovecot service, enable/disable it on boot (yes/no)
dovecot_enable_service: yes
# firewall zones for the IMAPS service, if nodiscc.xsrv.common/firewalld role is deployed
# 'zone:' is one of firewalld zones, set 'state:' to 'disabled' to remove the rule (the default is state: enabled)
dovecot_firewalld_zones:
  - zone: internal
    state: enabled
  - zone: public
    state: enabled
```


## matrix

[roles/matrix/defaults/main.yml](https://gitlab.com/nodiscc/xsrv/-/blob/master/roles/matrix/defaults/main.yml)

```yaml
##### MATRIX REAL-TIME COMMUNICATION SERVER #####
# fully qualified domain name of the matrix-synapse server instance
matrix_synapse_fqdn: matrix.CHANGEME.org
# username/password for the matrix admin user
matrix_synapse_admin_user: "CHANGEME"
matrix_synapse_admin_password: "CHANGEME25"
# postgresql database password for synapse
matrix_synapse_db_password: "CHANGEME20"
# random secret used to register new users
matrix_synapse_registration_shared_secret: "CHANGEME25"
# random secret used to sign access tokens
matrix_synapse_macaroon_secret_key: "CHANGEME25"
# yes/no: whether room invites to users on this server should be blocked (except those sent by local server admins).
matrix_synapse_block_non_admin_invites: no
# yes/no: whether to enable URL previews
matrix_synapse_enable_url_previews: yes
# start/stop the matrix-synapse service, enable/disable it on boot (yes/no) (redirect users to maintenance page if disabled)
matrix_synapse_enable_service: yes
# yes/no: aggregate (verbose) synapse logs to syslog
matrix_synapse_homeserver_logs_to_syslog: no
# HTTPS and SSL/TLS certificate mode for the matrix-synapse webserver virtualhost
#   letsencrypt: acquire a certificate from letsencrypt.org
#   selfsigned: generate a self-signed certificate
matrix_synapse_https_mode: selfsigned
# firewall zones for the matrix server, if nodiscc.xsrv.common/firewalld role is deployed
# 'zone:' is one of firewalld zones, set 'state:' to 'disabled' to remove the rule (the default is state: enabled)
matrix_firewalld_zones:
  - zone: internal
    state: enabled
  - zone: public
    state: disabled

##### LDAP AUTHENTICATION #####
# enable/disable LDAP authentication (yes/no)
matrix_synapse_ldap: no
# if LDAP authentication is enabled, the following options must be set
# LDAP server URI
matrix_synapse_ldap_uri: "ldaps://{{ openldap_fqdn | default('ldap.CHANGEME.org') }}:636"
# use STARTTLS to connect to the LADP server
matrix_synapse_ldap_starttls: yes
# base DN to look for users in the LDAP directory
matrix_synapse_base_dn: "ou=users,dc=CHANGEME,dc=org"
# LDAP attributes corresponding to the `uid, mail, name` matrix properties
matrix_synapse_ldap_uid_attr: "cn"
matrix_synapse_ldap_mail_attr: "mail"
matrix_synapse_ldap_name_attr: "givenName"
# bind username and password to authenticate to the LDAP server
matrix_synapse_ldap_bind_dn: "cn=bind,ou=system,dc=CHANGEME,dc=org"
matrix_synapse_ldap_bind_password: "{{ openldap_bind_password | default('CHANGEME') }}"
# login filter used to lookup valid users in the LDAP directory
matrix_synapse_ldap_filter: "(objectClass=posixAccount)"
# verify validity of SSL/TLS certificates presented by the LDAP server
matrix_synapse_ldap_validate_certs: yes

##### SYNAPSE-ADMIN #####
# enable/disable the synapse-admin virtualhost (redirect users to maintenance page if disabled)
matrix_synapse_admin_enable_service: yes
# synapse-admin version (https://github.com/Awesome-Technologies/synapse-admin/releases)
matrix_synapse_admin_version: "0.11.0"
# list of IP addresses allowed to access synapse-admin and synapse admin API endpoints (IP or IP/netmask format)
# set to empty list [] to allow access from any IP address
matrix_synapse_admin_allowed_hosts: []

##### ELEMENT #####
# fully qualified domain name of the element application instance
matrix_element_fqdn: "chat.CHANGEME.org"
# mode for element video rooms (jitsi/element_call)
matrix_element_video_rooms_mode: "element_call"
# when matrix_element_video_rooms_mode = 'jitsi', domain of the Jitsi instance to use for video calls
# you can set this to your own Jitsi domain if you are hosting one, but this will NOT work with Jitsi instances set up as "secure domain"/authenticated
matrix_element_jitsi_preferred_domain: "meet.element.io"
# when matrix_element_video_rooms_mode = 'element_call', domain of the Element Call instance to use for video calls
matrix_element_call_domain: "call.element.io"
# matrix element web client version (https://github.com/vector-im/element-web/releases)
matrix_element_version: "1.12.2"
# element installation directory
element_install_dir: "/var/www/{{ matrix_element_fqdn }}"
# HTTPS and SSL/TLS certificate mode for the matrix-element webserver virtualhost
#   letsencrypt: acquire a certificate from letsencrypt.org
#   selfsigned: generate a self-signed certificate
matrix_element_https_mode: selfsigned
# enable/disable the element virtualhost (redirect users to maintenance page if disabled)
matrix_element_enable_service: yes
# list of IP addresses allowed to access element (IP or IP/netmask format)
# set to empty list [] to allow access from any IP address
matrix_element_allowed_hosts: []
```


## moodist

[roles/moodist/defaults/main.yml](https://gitlab.com/nodiscc/xsrv/-/blob/master/roles/moodist/defaults/main.yml)

```yaml
# Fully Qualified Domain Name for the moodist instance
moodist_fqdn: "moodist.CHANGEME.org"
# the moodist OCI image to pull
moodist_image: "ghcr.io/remvze/moodist:latest"
# HTTPS and SSL/TLS certificate mode for the moodist webserver virtualhost
#   letsencrypt: acquire a certificate from letsencrypt.org
#   selfsigned: generate a self-signed certificate
moodist_https_mode: "selfsigned"
# start/stop the moodist service, enable/disable it on boot (yes/no) (redirect users to maintenance page if disabled)
moodist_enable_service: yes
```


## mumble

[roles/mumble/defaults/main.yml](https://gitlab.com/nodiscc/xsrv/-/blob/master/roles/mumble/defaults/main.yml)

```yaml
##### MUMBLE VOIP SERVER #####
# password to join the Mumble server (NO SPACES)
mumble_password: "CHANGEME"
# administrator password for the mumble server (login as 'superuser' - NO SPACES)
mumble_superuser_password: "CHANGEME"
# exposes current/maximum user count and max bandwidth per client to unauthenticated users (true/false - QUOTED)
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
# firewall zones for the mumble service, if nodiscc.xsrv.common/firewalld role is deployed
# 'zone:' is one of firewalld zones, set 'state:' to 'disabled' to remove the rule (the default is state: enabled)
mumble_firewalld_zones:
  - zone: public
    state: enabled
  - zone: internal
    state: enabled
```


## nextcloud

[roles/nextcloud/defaults/main.yml](https://gitlab.com/nodiscc/xsrv/-/blob/master/roles/nextcloud/defaults/main.yml)

```yaml
##### NEXTCLOUD #####
# Nextcloud admin username/password
nextcloud_user: "CHANGEME"
nextcloud_password: "CHANGEME"
# nextcloud administrator e-mail address
nextcloud_admin_email: "CHANGEME@CHANGEME.org"
# Fully Qualified Domain Name for the nextcloud instance
nextcloud_fqdn: "cloud.CHANGEME.org"
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
nextcloud_db_password: "CHANGEME"
# mode for SSL/TLS certificates for the nextcloud webserver virtualhost (letsencrypt/selfsigned)
#   letsencrypt: acquire a certificate from letsencrypt.org
#   selfsigned: generate a self-signed certificate (will generate warning in browsers and clients)
nextcloud_https_mode: selfsigned
# nextcloud data storage directory
nextcloud_data_dir: "/var/nextcloud/data"
# Nextcloud installation directory (must be under a valid documentroot)
nextcloud_install_dir: "/var/www/{{ nextcloud_fqdn }}"
# full public URL of your nextcloud installation (update this if you changed the install location to a subdirectory)
nextcloud_full_url: "https://{{ nextcloud_fqdn }}/"
# nextcloud version to install
nextcloud_version: "30.0.17"
# base folder for shared files from other users
nextcloud_share_folder: '/SHARED/'
# default app to open on login. You can use comma-separated list of app names, so if the first  app is not enabled for a user then Nextcloud will try the second one, and so on.
nextcloud_defaultapp: 'dashboard,files'
# Loglevel to start logging at (integer 1-4, 0=Debug, 1=Info, 2=Warning, 3=Error, 4=Fatal)
nextcloud_loglevel: 1
# workaround for old nextcloud-desktop clients which don't support TLSv1.3
nextcloud_allow_tls12: true
# automatically check the filesystem/data directory for changes made outside Nextcloud (no/yes)
nextcloud_filesystem_check_changes: no
# Nextcloud applications to enable or disable
#   state: enable/disable
#   app: nextcloud app name
nextcloud_apps:
  - { state: "disable", app: "encryption" } # https://nextcloud.com/encryption/
  - { state: "disable", app: "files_antivirus" } # https://apps.nextcloud.com/apps/files_antivirus
  - { state: "disable", app: "files_versions" } # https://docs.nextcloud.com/server/latest/user_manual/en/files/version_control.html
  - { state: "disable", app: "news" } # https://apps.nextcloud.com/apps/news
  - { state: "disable", app: "user_external" } # https://apps.nextcloud.com/apps/user_external
  - { state: "disable", app: "recommendations" } # https://github.com/nextcloud/recommendations/
  - { state: "enable", app: "activity" } # https://docs.nextcloud.com/server/latest/admin_manual/configuration_server/activity_configuration.html
  - { state: "enable", app: "calendar" } # https://apps.nextcloud.com/apps/calendar
  - { state: "enable", app: "comments" } # comments on files
  - { state: "enable", app: "contacts" } # https://apps.nextcloud.com/apps/contacts
  - { state: "enable", app: "dav" } # https://docs.nextcloud.com/server/20/user_manual/en/files/access_webdav.html
  - { state: "enable", app: "federatedfilesharing" } # https://docs.nextcloud.com/server/latest/admin_manual/configuration_files/federated_cloud_sharing_configuration.html
  - { state: "enable", app: "federation" } # https://docs.nextcloud.com/server/latest/admin_manual/configuration_files/federated_cloud_sharing_configuration.html
  - { state: "enable", app: "files" } # https://nextcloud.com/files/
  - { state: "enable", app: "files_external" } # https://docs.nextcloud.com/server/latest/admin_manual/configuration_files/external_storage_configuration_gui.html
  - { state: "enable", app: "files_pdfviewer" } # https://apps.nextcloud.com/apps/files_pdfviewer
  - { state: "enable", app: "files_sharing" } # https://docs.nextcloud.com/server/stable/user_manual/en/files/sharing.html
  - { state: "enable", app: "files_trashbin" } # https://docs.nextcloud.com/server/latest/admin_manual/configuration_files/trashbin_configuration.html
  - { state: "enable", app: "viewer" } # https://github.com/nextcloud/viewer
  - { state: "enable", app: "firstrunwizard" } # https://github.com/nextcloud/firstrunwizard
  - { state: "enable", app: "groupfolders" } # https://apps.nextcloud.com/apps/groupfolders
  - { state: "enable", app: "photos" } # https://github.com/nextcloud/photos
  - { state: "disable", app: "music" } # https://apps.nextcloud.com/apps/music
  - { state: "enable", app: "maps" } # https://apps.nextcloud.com/apps/maps
  - { state: "enable", app: "notifications" } # https://github.com/nextcloud/notifications
  - { state: "enable", app: "systemtags" } # https://docs.nextcloud.com/server/latest/user_manual/en/files/access_webgui.html#tagging-files
  - { state: "disable", app: "files_automatedtagging" } # https://apps.nextcloud.com/apps/files_automatedtagging
  - { state: "enable", app: "tasks" } # https://apps.nextcloud.com/apps/tasks
  - { state: "enable", app: "updatenotification" } # https://docs.nextcloud.com/server/latest/admin_manual/maintenance/update.html
  - { state: "enable", app: "user_ldap" } # https://docs.nextcloud.com/server/latest/admin_manual/configuration_user/user_auth_ldap.html
  - { state: "enable", app: "notes" } # https://apps.nextcloud.com/apps/notes
  - { state: "disable", app: "deck" } # https://apps.nextcloud.com/apps/deck
  - { state: "enable", app: "admin_audit" } # https://portal.nextcloud.com/article/7/using-the-audit-log-44.html
  - { state: "disable", app: "documentserver_community" } # https://apps.nextcloud.com/apps/documentserver_community
  - { state: "disable", app: "onlyoffice" } # https://apps.nextcloud.com/apps/onlyoffice
  - { state: "disable", app: "bookmarks" } # https://apps.nextcloud.com/apps/bookmarks
  - { state: "disable", app: "cookbook" } # https://apps.nextcloud.com/apps/cookbook
  - { state: "disable", app: "keeweb" } # https://apps.nextcloud.com/apps/keeweb
  - { state: "disable", app: "passman" } # https://apps.nextcloud.com/apps/passman
  - { state: "disable", app: "passwords" } # https://apps.nextcloud.com/apps/passwords
  - { state: "enable", app: "polls" } # https://apps.nextcloud.com/apps/polls
  - { state: "enable", app: "forms" } # https://apps.nextcloud.com/apps/forms
  - { state: "disable", app: "apporder" } # https://apps.nextcloud.com/apps/apporder
  - { state: "disable", app: "keeporsweep" } # https://apps.nextcloud.com/apps/keeporsweep
  - { state: "disable", app: "jitsi" } # https://apps.nextcloud.com/apps/jitsi
  - { state: "disable", app: "tables" } # https://apps.nextcloud.com/apps/tables
  - { state: "disable", app: "survey_client" } # https://github.com/nextcloud/survey_client
  - { state: "disable", app: "integration_whiteboard" } # https://apps.nextcloud.com/apps/integration_whiteboard
# mode for outgoing mail (disabled/smtp/smtp+ssl/sendmail)
nextcloud_smtp_mode: disabled
# outgoing mail settings below are required if nextcloud_smtp_mode: smtp/smtp+ssl
# 'From' address used in mails sent by nextcloud
nextcloud_smtp_from: "{{ msmtp_admin_email | default('nextcloud-noreply@CHANGEME.org') }}"
# SMTP mail server address
nextcloud_smtp_host: "{{ msmtp_host | default('smtp.CHANGEME.org') }}"
# SMTP mail server port (e.g. 25/465/587)
nextcloud_smtp_port: "{{ msmtp_port | default('CHANGEME') }}"
# username and password for SMTP authentication
nextcloud_smtp_user: "{{ msmtp_username | default('CHANGEME') }}"
nextcloud_smtp_password: "{{ msmtp_password | default('CHANGEME') }}"
# list of IP addresses allowed to access nextcloud (IP or IP/netmask format)
# set to empty list [] to allow access from any IP address
nextcloud_allowed_hosts: []
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
# enable/disable the nextcloud php-fpm pool (redirect users to maintenance page if disabled)
nextcloud_enable_service: yes
```


## nmap

[roles/nmap/defaults/main.yml](https://gitlab.com/nodiscc/xsrv/-/blob/master/roles/nmap/defaults/main.yml)

```yaml
##### NMAP NETWORK SCANNER #####
# the set of hosts to scan
# Example: nmap_limit: ['host1.CHANGEME.org', 'host2.CHANGEME.org']
nmap_limit: "{{ groups['all'] }}"
```


## ollama

[roles/ollama/defaults/main.yml](https://gitlab.com/nodiscc/xsrv/-/blob/master/roles/ollama/defaults/main.yml)

```yaml
##### OLLAMA LARGE LANGUAGE MODEL (LLM) RUNNER #####
# list of models to pull by default, see https://github.com/ollama/ollama?tab=readme-ov-file#model-library
# you can still pull/run any model by running ollama pull/run MODEL_NAME manually
ollama_models:
  - gemma3:4b
  # - gemma3:12b
  # - llama2-uncensored:7b
  # - llama3.1:8b
  # - mistral:7b
  # - phi3:3.8b
  # - qwen2.5:7b
# username/password for access to the ollama web interface/API
ollama_username: "CHANGEME"
ollama_password: "CHANGEME"
# ollama version (https://github.com/ollama/ollama/releases.atom)
ollama_version: "v0.12.6"
# enable automatic backups of downloaded models (if the nodiscc.xsrv.backup role is deployed) (no/yes)
ollama_backup_models: no
# enable/disable installation of ollama-ui (yes/no)
ollama_ui: no
# HTTPS and SSL/TLS certificate mode for the ollama-ui webserver virtualhost
#   letsencrypt: acquire a certificate from letsencrypt.org
#   selfsigned: generate a self-signed certificate
ollama_ui_https_mode: selfsigned
# start/stop the ollama service and web UI, enable/disable it on boot (yes/no) (redirect users to maintenance page if disabled)
ollama_enable_service: yes
# fully qualified domain name of the ollama-ui web interface
ollama_ui_fqdn: "llm.CHANGEME.org"
# list of IP addresses allowed to access the ollama web interface (IP or IP/netmask format)
# set to empty list [] to allow access from any IP address
ollama_ui_allowed_hosts: []
```


## openldap

[roles/openldap/defaults/main.yml](https://gitlab.com/nodiscc/xsrv/-/blob/master/roles/openldap/defaults/main.yml)

```yaml
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
openldap_admin_password: "CHANGEME"
# Unprivilegied "bind" LDAP account username/password
# This account will be allowed to to browse the directory/resolve UIDs and GIDs)
openldap_bind_username: "bind"
openldap_bind_password: "CHANGEME"
# yes/no: start/stop the LDAP server, enable/disable it on boot
openldap_enable_service: yes
# log level for the openldap server (integer) - https://openldap.org/doc/admin24/slapdconf2.html
openldap_log_level: 512
# firewall zones for the LDAP service, if nodiscc.xsrv.common/firewalld role is deployed
# 'zone:' is one of firewalld zones, set 'state:' to 'disabled' to remove the rule (the default is state: enabled)
openldap_firewalld_zones:
  - zone: internal
    state: enabled

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
# LDAP Account Manager version (https://github.com/LDAPAccountManager/lam/releases)
ldap_account_manager_version: "9.2"
# ldap-account-manager installation method (tar.bz2, apt...)
# currently only tar.bz2 is supported (ldap-account-manager not available in debian 10 repositories)
ldap_account_manager_install_method: "tar.bz2"
# ldap-account-manager session timeout in minutes
ldap_account_manager_session_timeout: 10
# LDAP server URI for ldap-account-manager (e.g. ldap://localhost:389 or ldaps://localhost:636)
ldap_account_manager_ldap_url: "ldap://{{ openldap_fqdn }}:389"
# path to trusted server certificate if using ldaps:// connection (e.g. "certificates/{{ openldap_fqdn }}.openldap.crt" - leave empty to disable)
ldap_account_manager_ldaps_cert: ""
# HTTPS/SSL/TLS certificate mode for the ldap-account-manager webserver virtualhost
#   letsencrypt: acquire a certificate from letsencrypt.org
#   selfsigned: generate a self-signed certificate (will generate warning in browsers and clients)
ldap_account_manager_https_mode: "selfsigned"
# enable/disable the ldap-account-manager php-fpm pool (redirect users to maintenance page if disabled)
ldap_account_manager_enable_service: yes
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


##### LDAP SELF SERVICE PASSWORD #####
# setup Self Service Password password change tool (yes/no)
openldap_setup_ssp: no
# domain name (FQDN) for Self Service Password
self_service_password_fqdn: "ssp.CHANGEME.org"
# list of IP addresses/networks allowed to access self service password (CIDR notation)
# for security reasons only private/RFC1918 addresses are allowed by default
# set to empty list [] to allow access from any IP address
self_service_password_allowed_hosts:
  - 10.0.0.0/8
  - 192.168.0.0/16
  - 172.16.0.0/12
# yes/no: enable self service password debug log messages
self_service_password_debug: no
# installation directory for Self Service Password
self_service_password_install_dir: "/var/www/{{ self_service_password_fqdn }}"
# LDAP Self-Service Password version (https://github.com/ltb-project/self-service-password/releases)
self_service_password_version: "1.7.3"
# LDAP server URI for Self Service Password (e.g. ldap://localhost:389 or ldap://ldap.CHANGEME.org:686)
self_service_password_ldap_url: "ldap://{{ openldap_fqdn }}:389"
# HTTPS/SSL/TLS certificate mode for the Self Service Password webserver virtualhost
#   letsencrypt: acquire a certificate from letsencrypt.org
#   selfsigned: generate a self-signed certificate (will generate warning in browsers and clients)
self_service_password_https_mode: "selfsigned"
# enable/disable the self-service-password php-fpm pool (redirect users to maintenance page if disabled)
self_service_password_enable_service: yes
# php-fpm: Maximum amount of memory a script may consume (K, M, G)
self_service_password_php_memory_limit: '64M'
# php_fpm: Maximum execution time of each script (seconds)
self_service_password_php_max_execution_time: 30
# php-fpm: Maximum amount of time each script may spend parsing request data (seconds)
self_service_password_php_max_input_time: 60
# php-fpm: Maximum size of POST data that PHP will accept (K, M, G)
self_service_password_php_post_max_size: '8M'
# php-fpm: Maximum allowed size for uploaded files (K, M, G)
self_service_password_php_upload_max_filesize: '2M'
```


## owncast

[roles/owncast/defaults/main.yml](https://gitlab.com/nodiscc/xsrv/-/blob/master/roles/owncast/defaults/main.yml)

```yaml
# Fully Qualified Domain Name for the owncast instance
owncast_fqdn: "owncast.CHANGEME.org"
# the owncast OCI image to pull (https://github.com/owncast/owncast/releases.atom)
owncast_image: "docker.io/owncast/owncast:0.2.3"
# password to access the admin interfaces at /admin (username admin)
owncast_admin_password: "CHANGEME"
# HTTPS and SSL/TLS certificate mode for the owncast webserver virtualhost
#   letsencrypt: acquire a certificate from letsencrypt.org
#   selfsigned: generate a self-signed certificate
owncast_https_mode: "selfsigned"
# start/stop the gitea service, enable/disable it on boot (yes/no) (redirect users to maintenance page if disabled)
owncast_enable_service: yes
# firewall zones for the owncast RTMP stream ingestion service (zone, state), if nodiscc.xsrv.common/firewalld role is deployed
# 'zone:' is one of firewalld zones, set 'state:' to 'disabled' to remove the rule (the default is state: enabled)
owncast_firewalld_zones:
  - zone: internal
    state: enabled
  - zone: public
    state: enabled
# list of IP addresses allowed to access the owncast web interface (IP or IP/netmask format)
# set to empty list [] to allow access from any IP address
owncast_allowed_hosts: []
# enable HTTP basic authentication to access the web interface (yes/no)
owncast_auth_enabled: no
# if HTTP basic authentication is enabled, username and password for viewers
owncast_auth_username: CHANGEME
owncast_auth_password: CHANGEME
```


## postgresql

[roles/postgresql/defaults/main.yml](https://gitlab.com/nodiscc/xsrv/-/blob/master/roles/postgresql/defaults/main.yml)

```yaml
##### POSTGRESQL DATABASE SERVER #####
# start/stop the postgresql service, enable/disable it on boot (yes/no)
postgresql_enable_service: yes
# pgmetrics version (https://github.com/rapidloop/pgmetrics/releases.atom, without leading v)
postgresql_pgmetrics_version: "1.18.0"
```


## readme_gen

[roles/readme_gen/defaults/main.yml](https://gitlab.com/nodiscc/xsrv/-/blob/master/roles/readme_gen/defaults/main.yml)

```yaml
##### MARKDOWN INVENTORY GENERATION #####
# the set of hosts for which documentation should be auto-generated
# Example: readme_gen_limit: ['host1.CHANGEME.org', 'host2.CHANGEME.org']
readme_gen_limit: "{{ groups['all'] }}"
# write GTK bookmarks to access hosts over SFTP in the output README.md (yes/no)
readme_gen_gtk_bookmarks: no
# path to the markdown template
readme_gen_template: "readme_gen.md.j2"
```


## samba

[roles/samba/defaults/main.yml](https://gitlab.com/nodiscc/xsrv/-/blob/master/roles/samba/defaults/main.yml)

```yaml
##### SAMBA FILE SHARING SERVER #####
# Server name and description
samba_netbios_name: "{{ ansible_hostname }}"
samba_server_string: "{{ ansible_hostname }} file server"
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
# user/group storage backend for samba accounts (tdbsam/ldapsam)
#   tdbsam: use local UNIX user accounts and samba's internal TDB database
#   ldapsam: use a LDAP server to store users and groups
samba_passdb_backend: "tdbsam"
# List of samba_users (only for samba_passdb_backend: "tdbsam")
# Each item has the following attributes:
#   username: the username. Do not use a username already in use by a system service or interactive user!
#   password: password for this user. It is best to store this value in ansible-vault
# Example:
# samba_users:
#   - username: alice
#     password: "{{ samba_user_password_alice }}"
#   - username: bob
#     password: "{{ samba_user_password_bob }}"
samba_users: []
# list of hosts allowed to connect to samba services (CIDR)
# do not expose samba on the Internet/public networks!
samba_hosts_allow:
  - '192.168.0.0/16'
  - '172.31.0.0/12'
  - '10.0.0.0/8'
# firewall zones for the apache service, if nodiscc.xsrv.common/firewalld role is deployed
# 'zone:' is one of firewalld zones, set 'state:' to 'disabled' to remove the rule (the default is state: enabled)
# never expose the samba service to the public zone
samba_firewalld_zones:
  - zone: internal
    state: enabled
  - zone: public
    state: disabled
# (yes/no) enable automatic backups of samba share directories (when the backup role is enabled)
# disable this and/or set backup paths manually if samba backups consume too
# much disk space on the backup storage, or if you don't care about losing the data.
samba_enable_backups: yes
# start/stop samba service, enable/disable it on boot (yes/no)
samba_enable_service: yes
# Samba log level (1-10, allows additional component:level)
samba_log_level: '1 passdb:2 auth:2 auth_audit:3'
# Log the following audit events (on success)
# Example: 'chdir chmod chown close closedir connect disconnect fchmod fchown ftruncate link lock mkdir mknod open opendir pread pwrite read readlink realpath rename rmdir sendfile symlink unlink write !closedir !connectpath !get_alloc_size !lstat !opendir !pread !readdir !strict_unlock !telldir'
samba_log_full_audit_success_events: 'mkdir rmdir rename open unlink connect disconnect'
# Max size of log files (in KiB)
samba_max_log_size_kb: 10000
# base path for samba share directories
samba_shares_path: /var/lib/samba/shares/
# list of hosts allowed to access the $IPC share anonymously
# windows clients require access to $IPC to be able to access any other share,
# so it is recommended to keep the same value as samba_hosts_allow
samba_hosts_allow_ipc: "{{ samba_hosts_allow }}"
# 0-999: nscd debug log level
samba_nscd_debug_level: 0
# (seconds): time after which user/group/passwords are invalidated in nscd cache
samba_nscd_cache_time_to_live: 60
```


## searxng

[roles/searxng/defaults/main.yml](https://gitlab.com/nodiscc/xsrv/-/blob/master/roles/searxng/defaults/main.yml)

```yaml
# Fully Qualified Domain Name for the searxng instance
searxng_fqdn: "search.CHANGEME.org"
# (required) 64 charecter random secret used for cryptography purposes
searxng_secret: "CHANGEME64"
# proxy image search results through the searx instance by default (yes/no)
searxng_image_proxy: yes
# the searxng OCI image to pull
searxng_image: "docker.io/searxng/searxng:latest"
# HTTPS and SSL/TLS certificate mode for the searxng webserver virtualhost
#   letsencrypt: acquire a certificate from letsencrypt.org
#   selfsigned: generate a self-signed certificate
searxng_https_mode: "selfsigned"
# start/stop the searxng service, enable/disable it on boot (yes/no) (redirect users to maintenance page if disabled)
searxng_enable_service: yes
# enable HTTP basic authentication to access the web interface (yes/no)
searxng_auth_enabled: no
# if HTTP basic authentication is enabled, username and password for viewers
searxng_auth_username: CHANGEME
searxng_auth_password: CHANGEME
```


## shaarli

[roles/shaarli/defaults/main.yml](https://gitlab.com/nodiscc/xsrv/-/blob/master/roles/shaarli/defaults/main.yml)

```yaml
##### SHAARLI BOOKMARKING SERVICE #####
# Fully Qualified Domain Name for the shaarli instance
shaarli_fqdn: "links.CHANGEME.org"
# Shaarli login and password
shaarli_username: "CHANGEME"
shaarli_password: "CHANGEME"
# 40 character random salt used to hash shaarli password
shaarli_password_salt: "CHANGEME"
# 12 character REST API secret
shaarli_api_secret: "CHANGEME"
# shaarli timezone (see https://www.php.net/manual/en/timezones.php)
shaarli_timezone: "Europe/Paris"
# location of the shaarli "home" link
shaarli_header_link: "?"
# hide timestamps (yes/no)
shaarli_hide_timestamps: no
# enable debug log messages (yes/no)
shaarli_debug: no
# shaarli description formatter (default/markdown/markdownExtra)
shaarli_formatter: "markdown"
# enable thumbnails for all hosts, or only common media hosts, or none (all/common/none)
shaarli_thumbnails_mode: common
# default number of links per page
shaarli_links_per_page: 30
# theme/template to use (default/vintage/stack/...)
shaarli_theme: stack
# overwrite shaarli configuration if it already exists (yes/no - yes will overwrite any changes made from Shaarli tools menu)
shaarli_overwrite_config: no
# Mode for SSL/TLS certificates for the shaarli webserver virtualhost
#   letsencrypt: acquire a certificate from letsencrypt.org
#   selfsigned: generate a self-signed certificate (will generate warning in browsers and clients)
shaarli_https_mode: selfsigned
# install python-shaarli-client, dump all shaarli data to /var/shaarli/shaarli.json every hour (yes/no)
shaarli_setup_python_client: no
# shaarli installation directory
shaarli_install_dir: "/var/www/{{ shaarli_fqdn }}"
# shaarli version to install - https://github.com/shaarli/Shaarli/releases.atom
shaarli_version: 'v0.15.0'
# list of IP addresses allowed to access shaarli (IP or IP/netmask format)
# set to empty list [] to allow access from any IP address
shaarli_allowed_hosts: []
# default view mode when using the stack template (small/medium/large)
shaarli_stack_default_ui: "medium"
# shaarli stack template version (https://github.com/RolandTi/shaarli-stack/releases.atom)
shaarli_stack_version: "0.12"
# php-fpm: Maximum amount of memory a script may consume (K, M, G)
shaarli_php_memory_limit: '256M'
# php_fpm: Maximum execution time of each script (seconds)
shaarli_php_max_execution_time: 30
# php-fpm: Maximum amount of time each script may spend parsing request data (seconds)
shaarli_php_max_input_time: 60
# php-fpm: Maximum size of POST data that PHP will accept (K, M, G)
shaarli_php_post_max_size: '8M'
# php-fpm: Maximum allowed size for uploaded files (K, M, G)
shaarli_php_upload_max_filesize: '2M'
# enable/disable the shaarli php-fpm pool (redirect users to maintenance page if disabled)
shaarli_enable_service: yes
```


## stirlingpdf

[roles/stirlingpdf/defaults/main.yml](https://gitlab.com/nodiscc/xsrv/-/blob/master/roles/stirlingpdf/defaults/main.yml)

```yaml
# Fully Qualified Domain Name for the stirlingpdf instance
stirlingpdf_fqdn: "pdf.CHANGEME.org"
# the stirlingpdf OCI image to pull (https://github.com/Stirling-Tools/Stirling-PDF/releases.atom)
stirlingpdf_image: "docker.io/stirlingtools/stirling-pdf:1.5.0"
# HTTPS and SSL/TLS certificate mode for the stirlingpdf webserver virtualhost
#   letsencrypt: acquire a certificate from letsencrypt.org
#   selfsigned: generate a self-signed certificate
stirlingpdf_https_mode: selfsigned
# start/stop the stirlingpdf service, enable/disable it on boot (yes/no) (redirect users to maintenance page if disabled)
stirlingpdf_enable_service: yes
# IP addresses allowed to access the stirlingpdf web interface (IP or IP/netmask format)
# set to empty list [] to allow access from any IP address
stirlingpdf_allowed_hosts: []
```


## transmission

[roles/transmission/defaults/main.yml](https://gitlab.com/nodiscc/xsrv/-/blob/master/roles/transmission/defaults/main.yml)

```yaml
##### TRANSMISSION BITTORRENT CLIENT #####
# username/password for transmission remote control web interface
transmission_username: "CHANGEME"
transmission_password: "CHANGEME"
# fully qualified domain name for the transmission web interface
transmission_fqdn: torrent.CHANGEME.org
# torrents download directory
transmission_download_dir: '/var/lib/transmission-daemon/downloads'
# list of users to add to the debian-transmission group (may read/write files inside the downloads directory)
transmission_users:
  - "{{ ansible_user }}"
# HTTPS and SSL/TLS certificate mode for the transmission webserver virtualhost
#   letsencrypt: acquire a certificate from letsencrypt.org
#   selfsigned: generate a self-signed certificate (will generate warning in browsers and clients)
transmission_https_mode: selfsigned
# start/stop the transmission bitorrent client, enable/disable it on boot, redirect users to maintenance page if disabled (yes/no)
transmission_enable_service: yes
# backup transmission downloads automatically, if the nodiscc.xsrv.backup role is enabled (yes/no)
# disabled by default as it can consume a lot of disk space
transmission_backup_downloads: no
# list of IP addresses allowed to access transmission web interface (IP or IP/netmask format)
# set to empty list [] to allow access from any IP address
transmission_allowed_hosts: []
# firewall zones for the transmission bittorrent service (peer communication), if nodiscc.xsrv.common/firewalld role is deployed
# 'zone:' is one of firewalld zones, set 'state:' to 'disabled' to remove the rule (the default is state: enabled)
transmission_firewalld_zones:
  - zone: public
    state: enabled
```


## tt_rss

[roles/tt_rss/defaults/main.yml](https://gitlab.com/nodiscc/xsrv/-/blob/master/roles/tt_rss/defaults/main.yml)

```yaml
##### TT-RSS FEED READER #####
# domain name (FQDN) for the tt-rss instance
tt_rss_fqdn: "rss.CHANGEME.org"
# tt-rss main user/admin username/password
tt_rss_user: "CHANGEME"
tt_rss_password: "CHANGEME"
# tt-rss database settings
tt_rss_db_name: "ttrss"
tt_rss_db_user: "ttrss"
tt_rss_db_password: "CHANGEME"
# random 250 characters string used to salt the password
tt_rss_password_salt: "CHANGEME"
# HTTPS/SSL/TLS certificate mode for the tt-rss webserver virtualhost
#   letsencrypt: acquire a certificate from letsencrypt.org
#   selfsigned: generate a self-signed certificate (will generate warning in browsers and clients)
tt_rss_https_mode: selfsigned
# tt-rss installation directory (must be under a valid documentroot)
tt_rss_install_dir: "/var/www/{{ tt_rss_fqdn }}"
# full public URL of your tt-rss installation (update this if you changed the install location to a subdirectory)
tt_rss_full_url: "https://{{ tt_rss_fqdn }}/"
# tt-rss version (git revision)
tt_rss_version: "c67b943aa894b90103c4752ac430958886b996b2"
# Maximum number of users allowed to register accounts
tt_rss_account_limit: 10
# Error log destination. setting this to blank uses PHP logging/webserver error log (sql, syslog, '')
tt_rss_log_destination: ''
# list of IP addresses allowed to access tt-rss (IP or IP/netmask format)
# set to empty list [] to allow access from any IP address
tt_rss_allowed_hosts: []
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
# enable/disable the tt-rss php-fpm pool (redirect users to maintenance page if disabled)
tt_rss_enable_service: yes
```


## wireguard

[roles/wireguard/defaults/main.yml](https://gitlab.com/nodiscc/xsrv/-/blob/master/roles/wireguard/defaults/main.yml)

```yaml
##### WIREGUARD VPN SERVER #####
# IP address at which the VPN server can be contacted by clients
wireguard_server_public_ip: "CHANGEME"
# IP address of the VPN server on the VPN network (CIDR notation)
# if you change this after deployment, please delete /etc/firewalld/zones/000-wireguard.xml from the server first
wireguard_server_ip: "10.200.200.1/24"
# yes/no: enable/disable the wireguard server service
wireguard_enable_service: yes

# List of wireguard peers (clients) allowed to connect to the server
# clients can generate a private/public key pair by running: wg genkey | (umask 0077 && tee wireguard.key) | wg pubkey > wireguard.pub
# wireguard_peers:
#   - name: client1 # arbitrary name for the peer
#     state: present # (optional, present/absent, default present) set to absent to remove the peer and its keys)
#     public_key: Faz...4vEQ= # (optional) public key of the peer (contents of its wireguard.pub) - if not specified a private/public key pair will be generated on the server
#     ip_address: 10.200.200.10 # IP address of the client on the VPN network (CIDR notation), must be part of the VPN server network
#     routes: # (optional, default 0.0.0.0/0 - route all traffic through the VPN) list of IP addresses/networks to route through the VPN on the client
#       - 1.2.3.4/32
#       - 192.168.18.0/24
#   - name: client2
#     state: present
#     ip_address: 10.200.200.11
#     routes:
#       - 10.200.200.1/32 # required for wireguard client/server traffic
#       - 10.0.10.1/24 # example, only route traffic to the server's local network through the VPN
#   - name: client3
#     state: absent
wireguard_peers: []

# firewall zones from which peers are allowed to connect to the VPN service, if nodiscc.xsrv.common/firewalld role is deployed
# 'zone:' is one of firewalld zones, set 'state:' to 'disabled' to remove the rule (the default is state: enabled)
wireguard_firewalld_zones:
  - zone: public
    state: enabled
  - zone: internal
    state: enabled

# allow forwarding wireguard peers traffic to other zones (e.g. internet) (yes/no)
wireguard_allow_forwarding: yes

# allow wireguard clients to connect to these firewalld services/ports on the host
# Example:
# wireguard_firewalld_services:
#   - name: ssh # service name
#     state: enabled # enabled/disabled (default enabled)
#   - name: dns
#     state: enabled
#   - name: http
#   - name: https
#   - name: imaps
#     state: disabled
wireguard_firewalld_services:
  - name: dns
    state: enabled
```
<!--END ROLES LIST-->
