# xsrv.common

This role will configure a basic Debian-based server:

- [hostname](tasks/hostname.yml) configuration
- [DNS](tasks/dns.yml) resolution (`/etc/resolv.conf`)
- [hosts](tasks/hosts.yml) file (`/etc/hosts`)
- [sysctl/kernel](tasks/sysctl.yml) settings: networking, swap/memory management, security, modules...
- [APT package manager configuration](tasks/apt.yml)
- [date/time and NTP synchronization](tasks/datetime.yml)
- [Linux user accounts](tasks/users.yml) (user account creation/deletion, resources, PAM/login restrictions)
- [cron task scheduler](tasks/cron.yml) (hardening, logging)
- [SSH server](tasks/ssh.yml) (hardening, chrooted SFTP accounts)
- [firewall](tasks/firewalld.yml) ([`firewalld`](https://en.wikipedia.org/wiki/Firewalld))
- [fail2ban](tasks/fail2ban.yml) intrusion/bruteforce prevention system
- [outgoing mail](tasks/mail.yml) (forwarding through an external mail relay)
- streamlining/removal of unwanted [packages](tasks/packages.yml), installation of basic system utilities/diagnostic tools
- automated procedures to upgrade hosts from [Debian 10 to 11](tasks/utils-debian10to11.yml), [Debian 11 to 12](tasks/utils-debian11to12.yml)

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

**Firewall:** All roles from the `nodiscc.xsrv` collection will setup appropriate rules when this role is deployed. See each role's `*_firewall_zones` configuration variables.


## Usage

- SSH access: `ssh user@my.CHANGEME.org` or `xsrv shell default my.CHANGEME.org`
  - Windows clients: [PuTTY](https://www.chiark.greenend.org.uk/~sgtatham/putty/)
- SFTP access: `sftp://user@my.CHANGEME.org`
  - Linux clients: [Thunar](http://docs.xfce.org/xfce/thunar/start), [Nautilus](https://wiki.gnome.org/action/show/Apps/Nautilus), [Dolphin](https://www.kde.org/applications/system/dolphin/), `sftp`, `rsync`, `scp`,
  - Windows clients: [WinSCP](https://winscp.net/eng/index.php)
- Upgrade from Debian 10 to Debian 11: `TAGS=utils-debian10to11 xsrv deploy` or `ansible-playbook --tags utils-debian10to11 playbook.yml`
- Upgrade from Debian 11 to Debian 12: `TAGS=utils-debian11to12 xsrv deploy` or `ansible-playbook --tags utils-debian11to12 playbook.yml`. Upgrading from one distribution version to another can take a while, and some services may become shortly unavailable during the operation. You can follow progress by watching `apt` logs on the host (or `/var/log/syslog` if the [`monitoring_rsyslog`](../monitoring_rsyslog) role is deployed).
- Upgrade all packages immediately, using unattended-upgrades: `TAGS=utils-apt-unattended-upgrade`. This allows upgrading immediately, without waiting for the daily unattended-upgrades timer to run. It respects the `apt_unattended_upgrades_origins_patterns` variable/`Origins-Pattern` setting.
- Upgrade all packages immediately: `TAGS=utils-apt-upgrade`. This will upgrade all upgradable packages, regardless of unattended-upgrades configuration (in particular the `apt_unattended_upgrades_origins_patterns` variable/`Origins-Pattern` setting).
- Get information about IP addresses banned by fail2ban: `TAGS=utils-fail2ban-get-banned xsrv deploy my.CHANGEME.org`
- Get information about firewalld status: `TAGS=utils-firewalld-info xsrv deploy my.CHANGEME.org`
- Reboot the host immediately: `TAGS=utils-reboot xsrv deploy default my.CHANGEME.org`
- Shut down the host immediately: `TAGS=utils-shutdown xsrv deploy default my.CHANGEME.org`

## Troubleshooting

**Package installation blocked by apt-listbugs:** When `apt_listbugs: yes` is set, apt-listbugs will, by default, prevent installation/upgrade of packages on which grave/serious bugs have been reported in the [Debian Bug Tracking System (BTS)](https://www.debian.org/Bugs/). The output of package management tasks will show something similar to:

```
grave bugs of ntpsec (→ 1.2.2+dfsg1-1) <Outstanding>
 b1 - #1038422 - ntpsec: ntpd segmentation fault in libcrypto.so[7f6d3ecc5000+278000]
serious bugs of usrmerge (→ 35) <Outstanding>
 b2 - #1033167 - usrmerge: messes with /etc/shells
serious bugs of bind9-libs (1:9.16.42-1~deb11u1 → 1:9.18.16-1~deb12u1) <Outstanding>
 b3 - #1014503 - bind9-libs: please provide libraries that enable reverse dependencies to use them
serious bugs of ca-certificates-java (20190909 → 20230103) <Outstanding>
 b4 - #1037478 - ca-certificates-java: Loop in the execution of the trigger
 b5 - #1039472 - ca-certificates-java: openjdk-17 update caused install regressions (Fixed: ca-certificates-java/20230620)
[...]
Summary:
 gcc-12-base(1 bug), usrmerge(1 bug), debianutils(1 bug), ntpsec(1 bug), bind9-libs(1 bug), ca-certificates-java(3 bugs)
**********************************************************************
****** Exiting with an error in order to stop the installation. ******
**********************************************************************
```

In that case you should check the bug report details on https://bugs.debian.org/BUGNUMBER, and if you find that the risk is acceptable or the bug does not apply to your particular setup, you can either:
- add the bug number to [`apt_listbugs_ignore_list`](defaults/main.yml) and re-run the playbook/common role/`apt-listbugs` tag before retrying package installation
- set `apt_listbugs_action` to `force-yes` and re-run the playbook/common role/`apt-listbugs` tag before retrying package installation
- add the bug number manually to `/etc/apt/listbugs/ignore_bugs` on the target host, temporarily

## Tags

<!--BEGIN TAGS LIST-->
```
common - setup base system
apt - setup APT package management
checks - check that variables are correctly defined
datetime - setup date/time configuration
dns - setup DNS resolution
fail2ban - setup fail2ban intrusion prevention system
firewall - setup firewall
hostname - setup hostname
hosts - setup /etc/hosts entries
packages - additional package istallation/removal
sysctl - setup sysctl kernel configuration
users - setup users and groups
ssh - setup SSH server
ssh-authorized-keys - setup ssh authorized keys
mail - setup outgoing system mail
msmtp - setup outgoing system mail
services - start/stop/enable/disable services
utils-apt-unattended-upgrade - (manual) run unattended-upgrade now
utils-apt-upgrade - (manual) run apt upgrade now
utils-debian10to11 - (manual) upgrade debian 10 hosts to debian 11
utils-debian11to12 - (manual) upgrade debian 11 hosts to debian 12
utils-fail2ban-get-banned - (manual) download the list of banned IPs
utils-firewalld-info - (manual) get firewall status informations
utils-shutdown - (manual) shut down the host
utils-reboot - (manual) reboot the host
cron - configure cron task scheduler
apt-listbugs - configure apt-listbugs bug prevention tool
```
<!--END TAGS LIST-->


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
