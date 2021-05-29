# xsrv.common

This role will install/configure a basic Debian-based server:

- hostname
- DNS resolution (`/etc/resolv.conf`)
- sysctl/kernel settings: networking, swap/memory management, security
- APT package management, automatic daily security updates
- NTP date/time synchronization
- user accounts, resources, PAM restrictions
- SSH server
 - `sftponly` group (SFTP-only accounts in SSH `chroot`)
- firewall (`firehol`)
- intrusion/bruteforce detection and prevention system (`fail2ban`)
- outgoing mail through an external SMTP relay (`msmtp`)
- basic command-line utilities/diagnostic tools
- streamlining/removal of unwanted packages
- `haveged` random number generator/entropy source for virtual machines

All sections can be disabled/enabled independently


## Requirements/dependencies/example playbook

- Ansible 2.10 or higher on the controller
- Debian 9/10 on the target host
- The inventory hostname resolves to the host using DNS records, a `hosts` file entry, or the `ansible_host: $HOST_IP_ADDRESS` host variable is set
- SSH server on the host, reachable from the controller on `ansible_ssh_port` (default `22`)
- `python3 sudo aptitude` packages installed on the host
- User account on the host, member of the `sudo` and `ssh` groups
- Controller SSH key authorized on this user account (`ssh-copy-id myusername@my.CHANGEME.org`)


```yaml
# playbook.yml
- hosts: my.CHANGEME.org
  roles:
     - nodiscc.xsrv.common

# required variables:
# ansible-vault edit host_vars/my.example.org/my.example.org.vault.yml
ansible_user: "CHANGEME"
ansible_become_pass: "CHANGEME"
```

See [defaults/main.yml](defaults/main.yml) for all configuration variables

**Sending e-mail** requires an external SMTP server (see `*msmtp*` configuration variables) and is disabled by default. If you don't have a SMTP server, you can use a free transactional e-mail service such as [Mailjet](https://www.mailjet.com/) (requires public DNS A and TXT records for the host), or a [Gmail](https://caupo.ee/blog/2020/07/05/how-to-install-msmtp-to-debian-10-for-sending-emails-with-gmail/) (requires enabling 2FA and less-secure app access) or other e-mail account.


## Usage

 - SSH access: `ssh user@example.org`
 - SFTP access: `sftp://user@example.org` (clients: [Thunar](http://docs.xfce.org/xfce/thunar/start), [Nautilus](https://wiki.gnome.org/action/show/Apps/Nautilus), [Dolphin](https://www.kde.org/applications/system/dolphin/)), `sftp`, `rsync`, `scp`, Windows: [WinSCP](https://winscp.net/eng/index.php), PuTTY...)
- Force a power off: `ssh user@my.example.org sudo poweroff`
- Force an immediate reboot: `ssh user@my.example.org sudo reboot`
- Force purge of unused configuration files: `ssh user@my.example.org sudo aptitude -y purge ~c`
- Force rotation of system logs: `ssh user@my.example.org sudo logrotate -f /etc/logrotate.conf`
- If running in a KVM virtual machine in libvirt/virt-manager, to share a directory from the hypervisor to the VM: access VM settings in `virt-manager`. Click `Add hardware > Filesystem`, Set Mode: `Mapped`, Source path: `/path/to/the/directory/to/share` (on the hypervisor), Target path: `/exampleshareddirectory` (in the VM), then inside the VM run `sudo apt install 9mount, mount -t 9p /exampleshareddirectory /mnt/example`.
- Upgrade all packages without waiting for unattended-upgrades `ssh user@my.example.org 'sudo apt update && sudo apt upgrade'`
- Stop the firewall, allow all connections incoming/outgoing connections (be careful) `ssh user@my.example.org sudo firehol stop # or start` - or set `policy: ACCEPT` in firehol definitions for permanent effect
- Backups: nothing to backup. See the [backup](../backup/README.md) role.


## License

[GNU GPLv3](../../LICENSE)


## References

- https://stdout.root.sx/links/?searchtags=debian
- https://stdout.root.sx/links/?searchtags=dns
- https://stdout.root.sx/links/?searchtags=ssh
- https://stdout.root.sx/links/?searchtags=security
- https://stdout.root.sx/links/?searchtags=network
- https://stdout.root.sx/links/?searchtags=linux
- https://stdout.root.sx/links/?searchtags=admin
