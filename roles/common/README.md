# xsrv.common

This role will configure a basic Debian-based server:

- [hostname](tasks/hostname.yml) configuration
- [DNS](tasks/dns.yml) resolution (`/etc/resolv.conf`)
- [hosts](tasks/hosts.yml) file (`/etc/hosts`)
- [sysctl/kernel](tasks/sysctl.yml) settings: networking, swap/memory management, security, modules...
- [APT package manager configuration](tasks/apt.yml)
- [date/time and NTP synchronization](tasks/datetime.yml)
- [Linux user accounts](tasks/users.yml) (user account creation/deletion, resources, PAM restrictions)
- [cron task scheduler](tasks/cron.yml) (hardening, logging)
- [SSH server](tasks/ssh.yml) (hardening, chrooted SFTP accounts)
- [firewall](tasks/firewalld.yml) ([`firewalld`](https://en.wikipedia.org/wiki/Firewalld))
- [fail2ban](tasks/fail2ban.yml) intrusion/bruteforce prevention system
- [outgoing mail](tasks/mail.yml) (forwarding through an external mail relay)
- streamlining/removal of unwanted [packages](tasks/packages.yml), installation of basic system utilities/diagnostic tools
- automated procedure to upgrade hosts from [Debian 10 to 11](tasks/utils-debian10to11.yml)

All components can be disabled/enabled independently.


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

**Sending e-mail** requires an external SMTP server (see `msmtp_*` configuration variables) and is disabled by default. You can use your own SMTP server or a commercial e-mail service such as [Mailjet](https://www.mailjet.com/) (requires public DNS A and TXT records for the host), or a [Gmail](https://caupo.ee/blog/2020/07/05/how-to-install-msmtp-to-debian-10-for-sending-emails-with-gmail/) (requires enabling 2FA and less-secure app access) or other e-mail account.

```yaml
# host_vars/my.example.org/my.example.org.yml
setup_msmtp: yes
msmtp_host: "smtp.CHANGEME.org"
msmtp_admin_email: "CHANGEME@CHANGEME.org"
# ansible-vault edit host_vars/my.example.org/my.example.org.vault.yml
msmtp_username: "CHANGEME"
msmtp_password: "CHANGEME"
```

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
