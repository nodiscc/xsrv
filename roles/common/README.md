# xsrv.common

This role will install/configure a basic Debian-based server:

- hostname
- DNS resolution (`/etc/resolv.conf`)
- hosts file (`/etc/hosts`)
- sysctl/kernel settings: networking, swap/memory management, security
- **APT package manager** configuration:
  - Debian stable + Debian security + Debian backports [repositories](https://wiki.debian.org/SourcesList)
  - Automatic security updates ([`unattended-upgrades`](https://wiki.debian.org/UnattendedUpgrades))
  - Preserve manually changed [`conffiles`](https://www.debian.org/doc/manuals/maint-guide/dother.en.html#conffiles) during upgrades
  - Don't install [`recommended`](https://www.debian.org/doc/debian-policy/ch-relationships.html#binary-dependencies-depends-recommends-suggests-enhances-pre-depends) packages
- NTP date/time synchronization
- user accounts, resources, PAM restrictions
- SSH server
 - `sftponly` group (SFTP-only accounts in SSH `chroot`)
- firewall ([`firewalld`](https://en.wikipedia.org/wiki/Firewalld))
- intrusion/bruteforce detection and prevention system (`fail2ban`)
- outgoing mail through an external SMTP relay (`msmtp`)
- basic command-line utilities/diagnostic tools
- streamlining/removal of unwanted packages
- `haveged` random number generator/entropy source for virtual machines

All sections can be disabled/enabled independently.

In addition, this role provides a procedure to upgrade Debian 10 hosts to Debian 11. The tag `debian10to11` must be passed explicitly for this procedure to run.

## Requirements/dependencies/example playbook

See [meta/main.yml](meta/main.yml)


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

**Firewall:** All roles from the `nodiscc.xsrv` collection will setup appropriate rules when this role is deployed. See each role's `*_firewall_zones` configuration variables.


## Usage

- SSH access: `ssh user@example.org`
  - Windows clients: [PuTTY](https://www.chiark.greenend.org.uk/~sgtatham/putty/)
- SFTP access: `sftp://user@example.org`
  - Linux clients: [Thunar](http://docs.xfce.org/xfce/thunar/start), [Nautilus](https://wiki.gnome.org/action/show/Apps/Nautilus), [Dolphin](https://www.kde.org/applications/system/dolphin/)), `sftp`, `rsync`, `scp`,
  - Windows clients: [WinSCP](https://winscp.net/eng/index.php)
- Upgrade from Debian 10 to Debian 11: `ansible-playbook --tags debian10to11 playbook.yml`
- Get current firewall configuration: `ansible-playbook --tags utils-firewalld-info playbook.yml`


## License

[GNU GPLv3](../../LICENSE)


## References

- https://stdout.root.sx/links/?searchtags=debian
- https://stdout.root.sx/links/?searchtags=dns
- https://stdout.root.sx/links/?searchtags=ssh
- https://stdout.root.sx/links/?searchtags=security
- https://stdout.root.sx/links/?searchtags=network
- https://stdout.root.sx/links/?searchtags=firewall
- https://stdout.root.sx/links/?searchtags=linux
- https://stdout.root.sx/links/?searchtags=admin
