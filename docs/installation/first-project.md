# First project

This example will create a new project based on a [template](https://gitlab.com/nodiscc/xsrv/-/tree/master/playbooks/xsrv/) - this is the simplest setup using a single server ([host](server-preparation.md)) with multiple roles. On the [controller](controller-preparation.md):


```bash
$ xsrv init-project
  ╻ ╻┏━┓┏━┓╻ ╻
░░╺╋╸┗━┓┣┳┛┃┏┛
  ╹ ╹┗━┛╹┗╸┗┛ v1.3.1
[xsrv] INFO: creating virtualenv in /home/live/playbooks/default/.venv
[xsrv] INFO: installing ansible in /home/live/playbooks/default/.venv
[....]
[xsrv] INFO: installing default collection git+https://gitlab.com/nodiscc/xsrv,release
[....]
Installing 'nodiscc.xsrv:1.3.1' to '/home/live/playbooks/default/ansible_collections/nodiscc/xsrv'
Created collection for nodiscc.xsrv:1.3.1 at /home/live/playbooks/default/ansible_collections/nodiscc/xsrv
nodiscc.xsrv:1.3.1 was installed successfully
[xsrv] INFO: creating files and directories for default
[xsrv] INFO: Generating random password for ansible-vault
[xsrv] INFO: vault password stored in /home/live/playbooks/default/.ansible-vault-password
[xsrv] INFO: Keep this file private! Keep backups of this file!
# enter the hostname for the first host to add to the project
[xsrv] Host name to add to the default project (ex: my.CHANGEME.org): my.example.org
[xsrv] INFO: adding my.example.org to the last inventory group
[xsrv] INFO: adding default play for my.example.org to project default
[xsrv] INFO: creating default host vars file for my.example.org
[xsrv] INFO: creating default vault file for my.example.org
[xsrv] INFO: generating random passwords for my.example.org
[xsrv] INFO: opening playbook file /home/live/playbooks/default/playbook.yml
```

```yaml
# enable additional roles by uncommenting them
- hosts: my.example.org
  roles:
    - nodiscc.xsrv.common # base setup
    - nodiscc.xsrv.monitoring # monitoring, alerting and logging
    # - nodiscc.xsrv.backup # backup service
    # - nodiscc.xsrv.apache # web server + PHP interpreter
    # - nodiscc.xsrv.openldap # LDAP directory server
    # - nodiscc.xsrv.postgresql # database engine
    # - nodiscc.xsrv.nextcloud # file hosting/sharing/synchronization and collaboration
    # - nodiscc.xsrv.tt_rss # news feed reader
    # - nodiscc.xsrv.shaarli # bookmarking & link sharing
    # - nodiscc.xsrv.gitea # git service/software forge
    # - nodiscc.xsrv.transmission # bittorrent client
    # - nodiscc.xsrv.mumble # VoIP/voice chat server
    # - nodiscc.xsrv.docker # application containerization
    # - nodiscc.xsrv.matrix # real-time secure communication server and web client
    # - nodiscc.xsrv.jellyfin # media server
    # - nodiscc.xsrv.jitsi # video conferencing solution
    # - nodiscc.xsrv.samba # file sharing server
    # - nodiscc.xsrv.dnsmasq # lightweight DNS server
    # - nodiscc.xsrv.wireguard # fast and modern VPN server
    # - nodiscc.xsrv.mail_dovecot # IMAP mailbox server
    # - nodiscc.xsrv.gotty # access server terminal as a web application
    # - nodiscc.xsrv.libvirt # libvirt virtualization toolkit
    # - nodiscc.xsrv.graylog # log management, capture and analysis platform
    # - nodiscc.xsrv.homepage # simple webserver homepage
```
```
[xsrv] INFO: opening host vars file /home/live/playbooks/default/host_vars/my.example.org/my.example.org.yml
```
```yaml
# configuration variables for my.example.org
# Set required configuration variables
# Please set all values labeled CHANGEME.
# You may remove variables for roles you don't use

##### GITEA - https://gitlab.com/nodiscc/xsrv/-/blob/master/roles/gitea/defaults/main.yml
gitea_fqdn: "git.CHANGEME.org"

##### HOMEPAGE - https://gitlab.com/nodiscc/xsrv/-/blob/master/roles/homepage/defaults/main.yml
homepage_fqdn: "www.CHANGEME.org"

##### JELLYFIN - https://gitlab.com/nodiscc/xsrv/-/blob/master/roles/jellyfin/defaults/main.yml
jellyfin_fqdn: "media.CHANGEME.org"

##### NEXTCLOUD - https://gitlab.com/nodiscc/xsrv/-/blob/master/roles/nextcloud/defaults/main.yml
nextcloud_fqdn: "cloud.CHANGEME.org"

##### SHAARLI - https://gitlab.com/nodiscc/xsrv/-/blob/master/roles/shaarli/defaults/main.yml
shaarli_fqdn: "links.CHANGEME.org"

##### TRANSMISSION - https://gitlab.com/nodiscc/xsrv/-/blob/master/roles/transmission/defaults/main.yml
transmission_fqdn: "torrent.CHANGEME.org"

##### TT-RSS - https://gitlab.com/nodiscc/xsrv/-/blob/master/roles/tt_rss/defaults/main.yml
tt_rss_fqdn: "rss.CHANGEME.org"
...
```
```
[xsrv] INFO: opening vault file /home/user/playbooks/default/host_vars/my.example.org/my.example.org.vault.yml
```
```yaml
# encrypted configuration variables for my.example.org
# Set required (encrypted) secrets.
# Random values are generated where possible
# Please set all values labeled CHANGEME.
# You may remove variables for roles you don't use

##### GENERAL #####
# administrator account (sudo) username/password
ansible_user: "CHANGEME"
ansible_become_pass: "CHANGEME"
# default global username/password/email for applications/services admin accounts
xsrv_admin_username: "CHANGEME"
xsrv_admin_password: "CHANGEME20"
xsrv_admin_email: "CHANGEME@CHANGEME.org"

##### APACHE - https://gitlab.com/nodiscc/xsrv/-/blob/master/roles/apache/defaults/main.yml
apache_letsencrypt_email: "{{ xsrv_admin_email }}"

##### NEXTCLOUD - https://gitlab.com/nodiscc/xsrv/-/blob/master/roles/nextcloud/defaults/main.yml
nextcloud_user: "{{ xsrv_admin_username }}"
nextcloud_password: "{{ xsrv_admin_password }}"
nextcloud_admin_email: "{{ xsrv_admin_email }}"
nextcloud_db_password: "CHANGEME20"

##### SHAARLI - https://gitlab.com/nodiscc/xsrv/-/blob/master/roles/shaarli/defaults/main.yml
shaarli_username: "{{ xsrv_admin_username }}"
shaarli_password: "{{ xsrv_admin_password }}"
shaarli_password_salt: "CHANGEME40" # 40 characters
shaarli_api_secret: "CHANGEME12" # 12 or more characters
...
```

```
[xsrv] INFO: Encrypting secrets file
Encryption successful
[xsrv] INFO: Host is ready for deployment. Run xsrv deploy default my.example.org
[xsrv] INFO: project default initialized in /home/live/playbooks/default
[xsrv] INFO: run xsrv deploy to apply configuration now, or xsrv help for more options
```

**Apply roles and configuration changes** to the host:

```bash
xsrv deploy
```

**Your services are now ready to use.** Access your services and web applications from domain names configured earlier. You can get a human-readable list of installed services, their URLs and other useful information using:
- the [homepage](https://gitlab.com/nodiscc/xsrv/-/tree/master/roles/homepage) role
- the [readme_gen](https://gitlab.com/nodiscc/xsrv/-/tree/master/roles/readme_gen) role

[![](https://asciinema.org/a/kGt6mVg3GxFlDPXwagiwg4Laq.svg)](https://asciinema.org/a/kGt6mVg3GxFlDPXwagiwg4Laq?speed=2&theme=monokai&autoplay=true)


You may now [add more services, edit configuration or deploy additional hosts](../usage.md).
