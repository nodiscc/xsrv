# xsrv.backup

This role will setup [rsnapshot](https://rsnapshot.org), an incremental backup system.

>rsnapshot is a filesystem snapshot utility based on rsync.
>rsnapshot makes it easy to make periodic snapshots of local machines, and remote machines over ssh.
>It makes extensive use of hard links whenever possible, to greatly reduce the disk space required.
>rsnapshot allows running scripts before taking actual snapshots of the filesystem (for example, dumping a database, performing an application data export...)

- configurable backup sources (local/remote), destinations, scripts and retention policy
- loads any additional/custom configuration from `/etc/rsnapshot.d/*.conf`
- (optional) aggregation of rsnapshot logs to syslog
- monitoring of time since last successful daily backup


## Requirements/dependencies/example playbook

- See [meta/main.yml](meta/main.yml)
- On hosts that should be backed up, firewall/NAT rules allowing SSH connections from the backup server

```yaml
# playbook.yml
- hosts: my.CHANGEME.org
  roles:
    - nodiscc.xsrv.common # (optional) base server setup, hardening, firewall, bruteforce prevention
    - nodiscc.xsrv.backup
    - nodiscc.xsrv.monitoring # (optional) rsnapshot log aggregation, health monitoring
```

See [defaults/main.yml](defaults/main.yml) for all configuration variables




## Usage

- force running backups immediately: `TAGS=utils-backup-now xsrv deploy` or `ssh -t user@my.example.org sudo rsnapshot daily`
- show the size of backups on the host: `ssh -t user@my.example.org sudo du --human-readable --summarize --time /var/backups/srv01/*`
- transfer latest daily backups to local machine (this may take a while): `xsrv fetch-backups PROJECT my.CHANGEME.org`, or:

```
rsync --quiet --hard-links --archive --verbose --compress --partial --progress --delete \
--rsh "ssh -p $ansible_ssh_port"
"user@my.example.org:/var/backups/srv01/daily.0" "/path/to/offsite-backups/${inventory_hostname}-daily.0.$(date +%Y-%m-%d)"
```

**Backups size:** If a file is completely unchanged between two backups, the second backup  will not consume more space on disk ([incremental backup](https://en.wikipedia.org/wiki/Incremental_backup), deduplication using hardlinks). If you rename the file or change a single byte, the full file will we backed up again. This can increase disk usage if you keep renaming/editing large files.

**Local backups** are inherently not secure, because the device being backed up is able to delete/compromise its own backup. Prefer remote _pull_ backups from another machine.

**backup data from remote machines:**
 - configure the list of hosts, SSH users, ports, paths... in  `rsnapshot_remote_backups` in configuration variables
 - setup a user account on the remote machine, authorize the backup server's `root` SSH key (the key is displayed during setup), and allow it to run `sudo rsync` without password.

```yaml
# Example using https://gitlab.com/nodiscc/ansible-xsrv-common/
linux_users:
   - name: "rsnapshot"
     groups: [ "ssh-access", "sudo" ]
     comment: "limited user account for remote backups"
     ssh_authorized_keys: ['public_keys/root@backupserver.CHANGEME.org']
     sudo_nopasswd_commands: ['/usr/bin/rsync']
```

**Removing old backups:** if a backup job is added at some point, than later removed (for example, removed backup jobs for a decomissionned server), the corresponding files **will be kept** in later backup generations. To clean up files produced by removed backup jobs, delete the corresponding directory in `/var/backups/rsnapshot/*/`.

## Tags

<!--BEGIN TAGS LIST-->
```
backup - setup rsnapshot backup utility
rsnapshot-ssh-key - generate ssh key for rsnapshot backup utility
utils-backup-now - (manual) transfer latest daily backups from the host to the controller
```
<!--END TAGS LIST-->


## References

- https://stdout.root.sx/links/?searchtag=backups


## License

[GPLv3](../../LICENSE)
