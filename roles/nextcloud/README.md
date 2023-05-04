# xsrv.nextcloud

This role will install [Nextcloud](https://en.wikipedia.org/wiki/Nextcloud), a private file hosting/sharing/synchronization service and groupware/collaboration platform.

Nextcloud is an alternative to services such as Dropbox, Google Drive/Agenda... See the [comparison page](https://nextcloud.com/compare/). Features:
- Uploading, viewing, editing, downloading and sharing files from a web interface
- [Clients](#clients) for PC or mobile devices
- Realtime file synchronization
- Can be extended to a full personal cloud/collaborative suite/groupware solution by more than 200 [applications](https://apps.nextcloud.com/)
- LDAP authentication

Default installed applications include:

- [Calendar](https://apps.nextcloud.com/apps/calendar): Manage calendar events with search, alarms, invitation management, contacts integration, sharing and synchronization across devices (CalDAV/ICS)
- [Contacts](https://apps.nextcloud.com/apps/contacts):E dit, view, share address books and synchronize them across devices (CardDav)
- [Tasks](https://apps.nextcloud.com/apps/tasks): Task/todo-list management (supports due dates, reminders, priorities, comments, tasks sharing, sub-tasks), and synchronize them across devices (CalDAV)
- [Music](https://apps.nextcloud.com/apps/music): Play audio files directly from the file list or in a library view (supports playlists, search, ampache and more)
- [Photos](https://github.com/nextcloud/photos#readme): Media gallery with previews for all media types
- [Notes](https://apps.nextcloud.com/apps/notes): Note taking app with markdown support, notes are saved as files in your Nextcloud so you can view and edit them from anywhere.
- [Maps](https://apps.nextcloud.com/apps/maps): Map and routing service using [OpenStreetMap](https://www.openstreetmap.org/)
- Viewers and editors for common file types (PDF, text, video...)
- Federation between Nextcloud instances (seamless access to other instances files/shares)
- Remote file storage access (FTP, SFTP, Samba/CIFS, local directory/drive...).

[![](https://i.imgur.com/PPVIb6V.png)](https://i.imgur.com/1YaT357.png)
[![](https://i.imgur.com/URs7XH5.png)](https://i.imgur.com/V6CR3we.png)
[![](https://i.imgur.com/bVMzmr1.png)](https://github.com/nextcloud/photos#readme)
[![](https://i.imgur.com/Co3DHUr.png)](https://f-droid.org/en/packages/com.nextcloud.client/)
[![](https://i.imgur.com/wJEAiab.png)](https://f-droid.org/en/packages/it.niedermann.owncloud.notes/)
[![](https://i.imgur.com/89xj4sa.png)](https://f-droid.org/en/packages/org.tasks/)
[![](https://i.imgur.com/GFthLWl.png)](https://f-droid.org/packages/at.bitfire.davdroid/)
[![](https://i.imgur.com/lXroRsI.png)](https://i.imgur.com/XlDrlS4.png)
[![](https://i.imgur.com/cCg6HgB.png)](https://i.imgur.com/iuWdvKG.png)
[![](https://i.imgur.com/kQyXV9S.png)](https://i.imgur.com/nCXJMus.png)
[![](https://i.imgur.com/TJTvqtd.png)](https://i.imgur.com/ztI0rJz.png)



## Requirements/dependencies/example playbook

See [meta/main.yml](meta/main.yml)

```yaml
# playbook.yml
- hosts: my.CHANGEME.org
  roles:
    - nodiscc.xsrv.common # (optional) base server setup, hardening, bruteforce prevention
    - nodiscc.xsrv.monitoring # (optional) server monitoring and log aggregation
    - nodiscc.xsrv.backup # (optional) automatic backups
    - nodiscc.xsrv.apache # (required in the standard configuration) webserver, PHP interpreter and SSL certificates
    - nodiscc.xsrv.postgresql # (required in the standard configuration) database engine
    - nodiscc.xsrv.nextcloud

# required variables:
# host_vars/my.example.org/my.example.org.vault.yml
nextcloud_fqdn: "cloud.CHANGEME.org"
# ansible-vault edit host_vars/my.example.org/my.example.org.vault.yml
nextcloud_user: "CHANGEME"
nextcloud_password: "CHANGEME"
nextcloud_db_password: "CHANGEME"
nextcloud_db_password: "CHANGEME@CHANGEME.org"
```

See [defaults/main.yml](defaults/main.yml) for all configuration variables


## Usage

### Clients

Access Nextcloud from any Web browser or from one of the available clients:

File synchronization:
 * [Nextcloud Desktop](https://nextcloud.com/install/#install-clients) (Linux/OSX/Windows)
 * [Nextcloud Android](https://f-droid.org/en/packages/com.nextcloud.client/)
 * [Nextcloud iOS](https://itunes.apple.com/us/app/nextcloud/id1125420102)

Calendar, contacts and tasks synchronization:
 * Desktop (Linux/OSX/Windows): [Thunderbird](https://www.mozilla.org/en-US/thunderbird/) + [Lightning](https://www.mozilla.org/en-US/projects/calendar/) [CardBook](https://addons.thunderbird.net/en-US/thunderbird/addon/cardbook/)
 * Android: [DAVx⁵](https://f-droid.org/repository/browse/?fdid=at.bitfire.davdroid) + [Tasks.org](https://f-droid.org/en/packages/org.tasks/) (Android)

Other:
 * [Notes](https://f-droid.org/en/packages/it.niedermann.owncloud.notes/) (Android)

### Useful commands

- Clear nextcloud previews cache: `ssh -t my.example.org sudo find /var/nextcloud/data/appdata_ocasr47zovdz/ -type d -name "previews" -exec rm -rv '{}' \;`
- Empty nextcloud trashes: `ssh -y my.example.org sudo -u www-data /usr/bin/php /var/www/nextcloud/occ trashbin:cleanup --all-users`
- Clear nextcloud filecaches: `ssh -y my.example.org sudo -u www-data /usr/bin/php /var/www/nextcloud/occ files:cleanup`

### Backups

See the included [rsnapshot configuration](templates/etc_rsnapshot.d_nextcloud.conf.j2) for the [backup](../backup/README.md) role.

To backup files from a remote host with the `nodiscc.xsrv.backup` role:

```yaml
# xsrv edit-host default backup.CHANGEME.org
rsnapshot_backup_execs:
  - 'ssh -oStrictHostKeyChecking=no rsnapshot@nextcloud.CHANGEME.org /usr/local/bin/postgres-dump-all-databases.sh'
rsnapshot_remote_backups:
  - { user: 'rsnapshot', host: 'nextcloud.CHANGEME.org', path: '/var/backups/postgresql' }
  - { user: 'rsnapshot', host: 'nextcloud.CHANGEME.org', path: '/var/nextcloud' }
  - { user: 'rsnapshot', host: 'nextcloud.CHANGEME.org', path: '/var/www/cloud.CHANGEME.org/config/config.php' }
```
```yaml
# xsrv edit-host default nextcloud.CHANGEME.org
  - name: "rsnapshot"
    groups: [ "ssh", "sudo", "postgres", "nextcloud" ]
    comment: "limited user account for remote backups"
    ssh_authorized_keys: ['data/public_keys/root@backup.CHANGEME.org.pub']
    sudo_nopasswd_commands: ['/usr/bin/rsync', '/usr/bin/psql', '/usr/bin/pg_dump', '/usr/bin/pg_dumpall' ]
```

To restore a backup:

```bash
# deploy the nextcloud role
xsrv deploy
# SSH to the backup server
xsrv shell default  backup.CHANGEME.org
# copy the last database dump somewhere readable by the postgres user
deploy@backup:~$ sudo rsync -avzP --rsync-path '/usr/bin/sudo /usr/bin/rsync' /var/backups/rsnapshot/daily.0/nextcloud.CHANGEME.org/var/backups/postgresql/nextcloud.sql rsnapshot@nextcloud.CHANGEME.org:/tmp/
# restore the data directory and configuration file
deploy@backup:~$ sudo rsync -avzP --rsync-path '/usr/bin/sudo /usr/bin/rsync' /var/backups/rsnapshot/daily.0/nextcloud.CHANGEME.org/var/nextcloud/ rsnapshot@nextcloud.CHANGEME.org:/var/nextcloud/
deploy@backup:~$ sudo rsync -avzP --rsync-path '/usr/bin/sudo /usr/bin/rsync' /var/backups/rsnapshot/daily.0/nextcloud.CHANGEME.org/var/www/cloud.CHANGEME.org/config/config.php rsnapshot@nextcloud.CHANGEME.org:/var/www/cloud.CHANGEME.org/config/config.php

# SSH to the nextcloud server
xsrv shell default nextcloud.CHANGEME.org
# fix permissions on restored files
deploy@nextcloud:~$ sudo chown -R nextcloud:nextcloud /var/nextcloud/ /var/www/cloud.CHANGEME.org/config/config.php 
# create a plaintext sql dump from the custom-formatted dump
deploy@nextcloud:~$ sudo -u postgres pg_restore --file - --clean --create /tmp/nextcloud.sql > /tmp/nextcloud.txt.sql
# restore the plaintext sql dump
deploy@nextcloud:~$ sudo -u postgres psql --echo-errors --file /tmp/nextcloud.txt.sql 
# rescan files
deploy@nextcloud:~$ sudo -u nextcloud /usr/bin/php /var/www/cloud.CHANGEME.org/occ files:scan --all
```


### Other

#### Change the database password

Changing the database password is not supported by the role at this time. To change the database password, you must first set the new password manually in `/var/www/$nextcloud_fqdn/config.php`, then change the value of `nexctloud_db_password` in host variables, and run the playbook.

#### LDAP authentication

- Create a group (eg. `posixGroup: access_nextcloud`) in your LDAP directory and add users that should be able to access Nextcloud to this group
- Access your Nextcloud LDAP settings (https://cloud.CHANGEME.org/index.php/settings/admin/ldap):
  - `Server > Host: ldap.CHANGEME.org` or `ldaps://ldap.CHANGEME.org`
  - click `Detect port`
  - `Server > User DN: cn=bind,ou=system,dc=CHANGEME,dc=org` the DN for your unprivilegied/bind LDAP user
  - `Server > Password:` the password for your bind LDAP user
  - `Server > Base DN: ou=users,dc=CHANGEME,dc=org` the base DN for the LDAP directory (or click `Detect base DN`)
  - click `Test base DN`
  - `Users > Object classes: inetOrgPerson` if using OpenLDAP
  - `Users > Groups:` (your LDAP server must support the memberOf overlay)
  - `Login attributes: [x] LDAP/AD user name`
  - `Groups: Only in groups: access_nextcloud`

To trust a self-signed LDAP server certificate:

```bash
# copy the LDAP server PEM CA certificate file to /etc/ssl/certs/
rsync -avzP certificates/ldap.CHANGEME.org.openldap.crt my.CHANGEME.org:
ssh my.CHANGEME.org
sudo mv ldap.CHANGEME.org.openldap.crt /etc/ssl/certs/
# update the LDAP client configuration file
sudo nano /etc/ldap/ldap.conf
```
```
TLS_CACERT /etc/ssl/certs/ldap.xinit.se.openldap.crt
```
```bash
# restart the php7.4-fpm service
sudo systemctl restart php7.4-fpm
```

#### Share files with other services

[External storage](https://docs.nextcloud.com/server/latest/admin_manual/configuration_files/external_storage_configuration_gui.html) can be configured to make files from other services available in Nextcloud. This includes local directories on the server, SFTP, other Nextcloud instances, SMB/CIFS, WebDav, S3...


##### Transmission

Example configuration to access files from the [transmission](../transmission/) bittorrent service running on the same host.

Under `Settings > Administration > External storage`, add a new storage:
- Folder name: `TORRENTS`
- External storage: `Local`
- Configuration/location: `/var/lib/transmission-daemon/downloads/`

##### Jellyfin

Example configuration to access files from the [jellyfin](../jellyfin/) media center service running on the same host:

The jellyfin media directory must be readable by the `nextcloud` user:
```bash
# access the server over SSH
$ xsrv shell
# add the nextcloud user to the jellyfin group
deploy@EXAMPLE:~ $ sudo usermod --append --groups jellyfin nextcloud
```

Under `Settings > Administration > External storage`, add a new storage:
- Folder name: `JELLYFIN`
- External storage: `Local`
- Configuration/location: `/var/lib/jellyfin/media/`


#### Uninstallation

This will remove all application files and data, and related configuration

```bash
$ sudo rm -r /var/www/cloud.CHANGEME.org/ /var/nextcloud/ /etc/ansible/facts.d/nextcloud.fact /etc/apache2/sites-available/nextcloud.conf  /etc/apache2/sites-enabled/nextcloud.conf /etc/php/7.4/fpm/pool.d/nextcloud.conf /etc/netdata/go.d/httpcheck.conf.d/nextcloud.conf /etc/rsnapshot.d/nextcloud.conf /etc/rsyslog.d/nextcloud.conf /etc/fail2ban/filter.d/nextcloud-auth.conf /etc/fail2ban/jail.d/nextcloud.conf 
$ sudo find /etc/netdata/go.d/httpcheck.conf.d/ -type f |sort | xargs sudo cat | sudo tee /etc/netdata/go.d/httpcheck.conf
$ sudo systemctl restart apache2.service php7.4-fpm.service fail2ban.service netdata.service
$ sudo -u postgres psql -c 'DROP DATABASE nextcloud;'
$ sudo -u postgres psql -c 'DROP USER nextcloud;'
$ sudo userdel --remove nextcloud
```


## Tags

<!--BEGIN TAGS LIST-->
```
nextcloud - setup nextcloud file sharing/collaboration platform
nextcloud-applications - setup nextcloud applications
nextcloud-config - setup main nextcloud configuration settings
```
<!--END TAGS LIST-->


## License

[GNU GPLv3](../../LICENSE)


## References

- https://stdout.root.sx/links?searchtags=nextcloud
