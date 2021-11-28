# Server preparation

## Hardware

The server (_host_) machine can be:
- a physical computer (dedicated server, repurposed desktop/laptop, small factor board...)
- a [virtual machine](https://en.wikipedia.org/wiki/Virtualization) (virtualization software: [libvirt/virt-manager](../../appendices/virt-manager.md), [Proxmox VE](https://en.wikipedia.org/wiki/Proxmox_Virtual_Environment), [Virtualbox](https://en.wikipedia.org/wiki/VirtualBox), ...) or a [VPS](https://en.wikipedia.org/wiki/Virtual_private_server) from a hosting service.

Resource usage will vary depending on installed components (read each role's documentation), the number of concurrent users, and how much user data you need to store. Example minimal configuration for a personal/small team server with 2-10 users:

```
Computer with x86/64 compatible CPU
1024-2048+ MB RAM
10+ GB storage for system and applications files
1-∞ GB storage for user data
```

Prefer low power consumption hardware. To increase availability, setup the BIOS to reboot after a power loss, setup an [UPS](https://en.wikipedia.org/wiki/Uninterruptible_power_supply), and/or multiple power supplies.


## Network


### Internet access

The server must have Internet access during deployment and upgrades. Prefer fast and reliable network links. 


### NAT/port forwarding

If the network interface is in a [private network](https://en.wikipedia.org/wiki/Private_network#Private_IPv4_addresses) behind a router, setup [port forwarding (NAT)](https://en.wikipedia.org/wiki/Port_forwarding) on the router if you need to access your services from other networks/Internet. Forward the following ports to your server's private IP address (if corresponding services are installed):

```
SSH server:                      TCP 22
Netdata monitoring system:       TCP 19999
Web server:                      TCP 80/443
BitTorrent incoming connections: TCP/UDP 52943
Mumble VoIP server:              TCP/UDP 64738
Graylog TCP input:               TCP 5140
```

### Domain names

The controller must be able to resolve the server's _host name_ ([Fully Qualified Domain Name](https://en.wikipedia.org/wiki/Fully_qualified_domain_name)). Separate domain/subdomain names are required for web applications. Point `A` or `CNAME` DNS records to the public IP address of your server using a public [domain name registrar](https://en.wikipedia.org/wiki/Domain_name_registrar), a [free subdomain service](https://freedns.afraid.org/domain/registry/) or your [private DNS resolver](PFSENSE.md#dns).

By default the following subdomains are configured (if corresponding roles are enabled):

```bash
***.CHANGEME.org # host name in the inventory/playbook
www.CHANGEME.org # homepage
cloud.CHANGEME.org # nextcloud
git.CHANGEME.org # gitea
links.CHANGEME.org # shaarli
rss.CHANGEME.org # tt-rss
torrent.CHANGEME.org # transmission
mumble.CHANGEME.org # mumble server
ldap.CHANGEME.org # openldap server/LDAP account manager
ssp.CHANGEME.org # LDAP self-service password
chat.CHANGEME.org # rocketchat
media.CHANGEME.org # jellyfin
logs.CHANGEME.org # graylog
tty.CHANGEME.org # gotty
```

_Alternatively, you can add [hosts](https://en.wikipedia.org/wiki/Hosts_%28file%29) entries on your client devices for each domain name._

_Public DNS records are required to obtain Let's Encrypt SSL/TLS (HTTPS) certificates._


## Operating System

Roles in this collection are designed to run against minimal [Debian](https://www.debian.org/) [_Stable_](https://wiki.debian.org/DebianStable) systems: [Install Debian](../../appendices/debian.md) or use a preconfigured Debian installation image from your hosting provider.


## Ansible requirements

From the server console, login as `root` and run:

```bash
# install requirements for remote admin/ansible access
apt update && apt --no-install-recommends install python aptitude sudo openssh-server
# create a user account for remote administration (replace 'deploy' with the desired account name)
useradd --create-home --groups ssh,sudo --shell /bin/bash deploy
# set the sudo password for this user account
passwd deploy
# lock the console
logout
```

At this point you may stop your newly created VM, and use it as a [template](../../appendices/virt-manager.md) for future deployments.

You should now [prepare the controller](controller-preparation.md).
