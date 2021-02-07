# xsrv.nextcloud

This role will install [Nextcloud](https://en.wikipedia.org/wiki/Nextcloud), a file hosting, sharing, and synchronization service.

Basic functionality includes uploading, viewing, editing, downloading and sharing files from a web interface. Nextcloud [clients](#clients) can be installed on any computer (Linux/OSX/Windows) or mobile device (Android/iOS) and allow automatically synchronizing your files with the server. It can be extended to a full personal cloud/collaborative suite/groupware solution by more than 200 [applications](https://apps.nextcloud.com/).

Default installed applications include:

- [Calendar](https://apps.nextcloud.com/apps/calendar): Manage calendar events with search, alarms, invitation management, contacts integration, sharing and synchronization across devices (CalDAV/ICS)
- [Contacts](https://apps.nextcloud.com/apps/contacts):E dit, view, share address books and synchronize them across devices (CardDav)
- [Tasks](https://apps.nextcloud.com/apps/tasks): Task/todo-list management (supports due dates, reminders, priorities, comments, tasks sharing, sub-tasks), and synchronize them across devices (CalDAV)
- [Music](https://apps.nextcloud.com/apps/music): Play audio files directly from teh file list or in a library view (supports playlists, search, ampache and more)
- [Photos](https://github.com/nextcloud/photos): Media gallery with previews for all media types
- [Notes](https://apps.nextcloud.com/apps/notes): Note taking app with markdown support, notes are saved as files in your Nextcloud so you can view and edit them from anywhere.
- [Deck](https://apps.nextcloud.com/apps/deck): Kanban style organization tool aimed at personal planning and project organization for teams.
- [Maps](https://apps.nextcloud.com/apps/maps): Map and routing service using [OpenStreetMap](https://www.openstreetmap.org/)
- Viewers and editors for common file types (PDF, text, video...)
- Federation between Nextcloud instances (seamless access to other instances files/shares)
- Remote file storage access (FTP, SFTP, Samba/CIFS, local directory/drive...).

Nextcloud is an alternative to services such as Dropbox, Google Drive/Agenda... See the [comparison page](https://nextcloud.com/compare/).

[![](https://i.imgur.com/kQyXV9S.png)](https://i.imgur.com/nCXJMus.png)
[![](https://i.imgur.com/lXroRsI.png)](https://i.imgur.com/XlDrlS4.png)
[![](https://i.imgur.com/cCg6HgB.png)](https://i.imgur.com/iuWdvKG.png)
[![](https://i.imgur.com/URs7XH5.png)](https://i.imgur.com/V6CR3we.png)
[![](https://i.imgur.com/0ALCk1W.png)](https://i.imgur.com/qRYPBdU.png)
[![](https://i.imgur.com/PPVIb6V.png)](https://i.imgur.com/1YaT357.png)
[![](https://i.imgur.com/Co3DHUr.png)](https://i.imgur.com/Tu1lVHo.png)
[![](https://i.imgur.com/TJTvqtd.png)](https://i.imgur.com/ztI0rJz.png)

## Requirements/dependencies/example playbook

See [meta/main.yml](meta/main.yml)

```yaml
- hosts: my.CHANGEME.org
  roles:
    - nodiscc.xsrv.common # fail2ban bruteforce protection
    - nodiscc.xsrv.monitoring # (optional)
    - nodiscc.xsrv.backup # (optional) automatic backups
    - nodiscc.xsrv.apache # webserver, PHP interpreter and SSL certificates
    - nodiscc.xsrv.postgresql # database engine
    - nodiscc.xsrv.nextcloud

# host_vars/my.example.org/my.example.org.vault.yml
nextcloud_fqdn: "cloud.CHANGEME.org"

# ansible-vault edit host_vars/my.example.org/my.example.org.vault.yml
vault_nextcloud_user: "CHANGEME"
vault_nextcloud_password: "CHANGEME"
vault_nextcloud_db_password: "CHANGEME"
```

See [defaults/main.yml](defaults/main.yml) for all configurable variables


Usage
-----

### Clients

Access Nextcloud from any Web browser or from one of the available clients:

File synchronization:
 * [Desktop application (Linux/OSX/Windows)](https://nextcloud.com/install/#install-clients)
 * [Android app](https://f-droid.org/repository/browse/?fdid=com.nextcloud.android)
 * [iOS app](https://itunes.apple.com/us/app/nextcloud/id1125420102)

Calendar, contacts and tasks synchronization:
 * [Thunderbird](https://www.mozilla.org/en-US/thunderbird/) + [Lightning](https://www.mozilla.org/en-US/projects/calendar/) (Linux/OSX/Windows)
 * [DAVDroid](https://f-droid.org/repository/browse/?fdid=at.bitfire.davdroid) (Android)
 * [OpenTasks](https://f-droid.org/repository/browse/?fdid=org.dmfs.tasks) (Android)

Other:
 * [Notes](https://f-droid.org/en/packages/it.niedermann.owncloud.notes/) (Android)
 * [Deck](https://f-droid.org/en/packages/it.niedermann.nextcloud.deck/) (Android)

### Useful commands

- Clear nextcloud previews cache: `ssh -t my.example.org sudo find /var/nextcloud/data/appdata_ocasr47zovdz/ -type d -name "previews" -exec rm -rv '{}' \;`
- Empty nextcloud trashes: `ssh -y my.example.org sudo -u www-data /usr/bin/php /var/www/nextcloud/occ trashbin:cleanup --all-users`
- Clear nextcloud filecaches: `ssh -y my.example.org sudo -u www-data /usr/bin/php /var/www/nextcloud/occ files:cleanup`

### Backups

See the included [rsnapshot configuration](templates/etc_rsnapshot.d_nextcloud.conf.j2) for the [backup](../backup/README.md) role.

To restore a backup:

```bash
# Remove the nextcloud database (nextcloud by default)
mysql -u root -p -e 'DROP database nextcloud;'

# Remove the nextcloud installation directory
rm -rv /var/www/my.example.org/nextcloud

# Remove the nextcloud data directory
rm -rv /var/nextcloud/data

# Reinstall nextcloud by running the playbook/nextcloud role, then
# Restore the database
mysql -u root -p nextcloud < /var/backups/rsnapshot/daily.0/localhost/var/backups/mysql/nextcloud/nextcloud.sql

# Restore the data directory
rsync -avP --delete /var/backups/rsnapshot/daily.0/localhost/var/nextcloud/data /var/nextcloud/

# Rescan files
sudo -u www-data /usr/bin/php /var/www/my.example.org/nextcloud/occ files:scan
```

License
-------

[GNU GPLv3](../../LICENSE)


References
----------

- https://stdout.root.sx/links?searchtags=nextcloud

