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
- transfer latest daily backups form the host to the controller (this may take a while): `xsrv fetch-backups PROJECT my.CHANGEME.org`

**Backups size:** If a file is completely unchanged between two backups, the second backup  will not consume more space on disk ([incremental backup](https://en.wikipedia.org/wiki/Incremental_backup), deduplication using hardlinks). If you rename the file or change a single byte, the full file will we backed up again. This can increase disk usage if you keep adding/removing/renaming/editing large files. If you want to free up disk space, and you are **certain** you will not need to recover files from old backups, you can start by deleting the oldest generations (e.g. `xsrv shell` then `sudo rm -r /var/backups/rsnapshot/monthly.5`). You can visualize disk space consumed by each backup generatino using tools such as `ncdu` or `duc` provided by the [monitoring.base](../monitoring/base/) role.

**Local backups** are inherently not secure, because the device being backed up is able to delete/compromise its own backups, and backups are stored in the same location as the live data. Local backups still offer a recovery solution for accidental deletion of a specific piece of data, or application bugs. For disaster recovery, prefer remote _pull_ backups from another machine (i.e. setup the backup role on a dedicated machine, and configure it to pull backups from other hosts, see [backup data from remote machines](#backup-data-from-remote-machines)). In addition, you should perform periodic copies of the latest backup generation to an offline/offiste storage, using the `xsrv fetch-backups` command, or manually:

<details><summary>Example Using shell commands:</summary>

```bash
rsync --quiet --hard-links --archive --verbose --compress --partial --progress --delete \
--rsh "ssh -p $ansible_ssh_port"
"user@my.example.org:/var/backups/srv01/daily.0" "/path/to/offsite-backups/${inventory_hostname}-daily.0.$(date +%Y-%m-%d)"
```
</details>

**Backup data from remote machines:**
 - configure the list of hosts, SSH users, ports, paths... in the [`rsnapshot_remote_backups`](backup/defaults/main.yml#L41) configuration variable and deploy the role to the backup server.
 - setup a user account on the machine to backup, authorize the backup server's `root` public SSH key to connect to it (the key is displayed when the `backup` role is deployed, and a copy is downloaded to `"{{ playbook_dir }}/data/public_keys/root@{{ inventory_hostname }}.pub"` on the controller), and allow it to run `sudo rsync` without password.

```yaml
# example using https://gitlab.com/nodiscc/xsrv/-/tree/master/roles/common
linux_users:
   - name: "rsnapshot"
     groups: [ "ssh-access", "sudo" ]
     comment: "limited user account for remote backups"
     ssh_authorized_keys: ['public_keys/root@backupserver.CHANGEME.org.pub']
     sudo_nopasswd_commands: ['/usr/bin/rsync']
```

<details><summary>Example using shell commands:</summary>

```bash
# upload the backup server's public SSH key to the remote host
user@controller:~ $ rsync -avP public_keys/root@backupserver.CHANGEME.org.pub:
# login to the remote host using SSH
user@controller:~ $ ssh remotehost.CHANGEME.org
# create a limited user account to which the backup server will connect
user@remotehost:~ $ sudo useradd --groups ssh-access,sudo --comment "limited user account for remote backups" rsnapshot
# authorize the backup server's SSH key on the rsnapshot user account
user@remotehost:~ $ sudo mkdir /home/rsnapshot/.ssh && cat root@backupserver.CHANGEME.org.pub | sudo tee -a /home/rsnapshot/.ssh/authorized_keys && sudo chown -R g-rwx /home/rsnapshot/.ssh/
# allow the rsnapshot user to run sudo rsync without password
user@remotehost:~ $ echo 'rsnapshot ALL=(ALL) NOPASSWD: /usr/bin/rsync' | sudo tee -a /etc/sudoers.d/nopasswd && sudo chmod 0660 /etc/sudoers.d/nopasswd
```
</details>


**Removing old backup jobs:** if a backup job is added at some point, then later removed (for example, removed backup jobs for a decomissionned server), the corresponding files **will be kept** in later backup generations. To clean up files produced by removed backup jobs, delete the corresponding directory in `/var/backups/rsnapshot/*/`.


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
