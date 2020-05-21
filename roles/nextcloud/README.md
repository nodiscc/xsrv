nextcloud
=========

This role will install [Nextcloud](https://en.wikipedia.org/wiki/Nextcloud), a file hosting, sharing, and synchronization service.

Basic functionality includes uploading, viewing, editing, downloading and sharing files from a web interface. Nextcloud [clients](#clients) can be installed on any computer (Linux/OSX/Windows) or mobile device (Android/iOS) and allow automatically synchronizing your files with the server. It can be extended to a full personal cloud/collaborative suite/groupware solution by more than 200 [applications](https://apps.nextcloud.com/).

Default installed applications include:

- [Contacts](https://apps.nextcloud.com/apps/contacts): Edit, view, share address books and synchronize them across devices (CardDav)
- [Calendar](https://apps.nextcloud.com/apps/calendar): Manage calendar events with search, alarms, invitation management, contacts integration, sharing and synchronization across devices (CalDAV/ICS)
- [Tasks](https://apps.nextcloud.com/apps/tasks): Task/todo-list management (supports due dates, reminders, priorities, comments, tasks sharing, sub-tasks), and synchronize them across devices (CalDAV)
- [Music](https://apps.nextcloud.com/apps/music): Play audio files directly from teh file list or in a library view (supports playlists, search, ampache and more)
- [Notes](https://apps.nextcloud.com/apps/notes): Note taking app with markdown support, notes are saved as files in your Nextcloud so you can view and edit them from anywhere.
- [Gallery](https://github.com/nextcloud/gallery): Media gallery with previews for all media types
- Viewers and editors for common file types (PDF, text, video...)
- Federation between Nextcloud instances (seamless access to other instances files/shares)
- Remote file storage access (FTP, SFTP, Samba/CIFS, local directory/drive...).

Nextcloud is an alternative to services such as Dropbox, Google Drive/Agenda... See the [comparison page](https://nextcloud.com/compare/).


Requirements
------------

This role requires Ansible 2.8 or higher.


Configuration Variables
-----------------------

See [defaults/main.yml](defaults/main.yml)


Dependencies
------------

The [`lamp`](https://gitlab.com/nodiscc/ansible-xsrv-lamp) role


Example Playbook
----------------

```yaml
- hosts: my.example.org
  roles:
    - common
    - lamp
    - nextcloud
```


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

### Useful commands

- Clear nextcloud previews cache: `ssh -t my.example.org sudo find /var/nextcloud/data/appdata_ocasr47zovdz/ -type d -name "previews" -exec rm -rv '{}' \;`
- Empty nextcloud trashes: `ssh -y my.example.org sudo -u www-data /usr/bin/php /var/www/nextcloud/occ trashbin:cleanup --all-users`
- Clear nextcloud filecaches: `ssh -y my.example.org sudo -u www-data /usr/bin/php /var/www/nextcloud/occ files:cleanup`

### Backups

See the included [rsnapshot configuration](templates/etc_rsnapshot.d_nextcloud.conf.j2) for the [backup](https://gitlab.com/nodiscc/ansible-xsrv-backup) role.

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
mysql -u root -p nextcloud < /var/backups/xsrv/daily.0/localhost/var/backups/mysql/nextcloud/nextcloud.sql

# Restore the data directory
rsync -avP --delete /var/backups/xsrv/daily.0/localhost/var/nextcloud/data /var/nextcloud/

# Rescan files
sudo -u www-data /usr/bin/php /var/www/my.example.org/nextcloud/occ files:scan
```

License
-------

[GNU GPLv3](LICENSE)


References
----------

- https://stdout.root.sx/links?searchtags=nextcloud

