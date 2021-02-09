backup
=============

This role will setup [rsnapshot](https://rsnapshot.org), an incremental backup system.

>rsnapshot is a filesystem snapshot utility based on rsync.
>rsnapshot makes it easy to make periodic snapshots of local machines, and remote machines over ssh.
>It makes extensive use of hard links whenever possible, to greatly reduce the disk space required.
>rsnapshot allows running scripts before taking actual snapshots of the filesystem (for example, dumping a database, performing an application data export...)

- configurable backup sources (local/remote), destinations, scripts and retention policy
- loads any additional/custom configuration from `/etc/rsnapshot.d/*.conf`


Requirements/dependencies/example playbook
------------

See [meta/main.yml](meta/main.yml)

```yaml
# playbook.yml
- hosts: my.CHANGEME.org
  roles:
    - nodiscc.xsrv.common # (optional) hardening, SSH
    - nodiscc.xsrv.backup
```

See [defaults/main.yml](defaults/main.yml) for all configuration variables

License
-------

[GPLv3](../../LICENSE)

Usage
------------

- force running backups immediately: `ssh user@my.example.org sudo -u rsnapshot rsnapshot daily`
- show the size of backups on the host: `ssh user@my.example.org du --human-readable --summarize --time /var/backups/srv01/*`
- transfer latest daily backups to local machine (this may take a while):

```
rsync --quiet --hard-links --archive --verbose --compress --partial --progress --delete \
--rsh "ssh -p $ansible_ssh_port"
"user@my.example.org:/var/backups/srv01/daily.0" "/path/to/offsite-backups/${inventory_hostname}-daily.0.$(date +%Y-%m-%d)"
```

**Backups schedule:** Automatic backups will run:
- daily: at 01:00 every day
- weekly: at 00:30 every sunday
- monthly: at 00:01 on the first day of the month


**Backups size:** If a file is completely unchanged between two backups, the second backup  will not consume more space on disk ([incremental backup](https://en.wikipedia.org/wiki/Incremental_backup), deduplication using hardlinks). If you rename the file or change a single byte, the full file will we backed up again. This can increase disk usage if you keep renaming/editing large files.

**backup data from remote machines:**
 - configure the list of hosts, SSH users, ports, paths... in  `rsnapshot_remote_backups` in configuration variables
 - setup a user account on the remote machine, authorize the backup server's `root` SSH key (the key is displayed during setup)

```yaml
# Example using https://gitlab.com/nodiscc/ansible-xsrv-common/
linux_users:
   - name: "remotebackup"
     password: "{{ vault_linux_users_remotebackup_password }}"
     groups: [ "ssh", "sudo" ]
     comment: "limited user account for remote backups"
     ssh_authorized_keys: []
     sudo_nopasswd_commands: ['/usr/bin/mysqldump']
```


References
------------

- https://stdout.root.sx/links/?searchtag=backups
