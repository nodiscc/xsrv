# Server preparation

## Hardware & resources

The server (_host_) machine can be:
- a physical computer (dedicated server, repurposed desktop/laptop, small factor board...)
- a [virtual machine](https://en.wikipedia.org/wiki/Virtual_machine) (VM)
- a [VPS](https://en.wikipedia.org/wiki/Virtual_private_server) from a hosting provider

Virtualization software ([hypervisors](https://en.wikipedia.org/wiki/Hypervisor)) include [libvirt/virt-manager](../../appendices/virt-manager.md), [Proxmox VE](https://en.wikipedia.org/wiki/Proxmox_Virtual_Environment), [Virtualbox](https://en.wikipedia.org/wiki/VirtualBox), ...

Resource usage will vary depending on installed components (read each role's documentation), the number of concurrent users, and how much user data you need to store. Example minimal configuration for a personal/small team server with 2-10 users:

```
Computer with x86/64 compatible CPU
1024-2048+ MB RAM
10+ GB storage for system and applications files
1-∞ GB storage for user data
```

If hosting on a physical server, prefer low power consumption hardware. Setup the BIOS to reboot after a power loss. If availability is important, setup hardware-level redundancy/failover mechanisms such as [RAID](https://en.wikipedia.org/wiki/RAID), multiple network links, an [UPS](https://en.wikipedia.org/wiki/Uninterruptible_power_supply), and/or multiple power supplies.


## Network

- The server must have a valid IPv4 address and gateway set during operating system installation.
- The server must have a valid DNS resolver set during installation. You can either use:
  - Your hosting/Internet service provider's DNS resolvers
  - Public DNS resolvers such as [Google Public DNS](https://en.wikipedia.org/wiki/Google_Public_DNS) (`8.8.8.8 8.8.4.4`), [Cloudflare public DNS](https://en.wikipedia.org/wiki/1.1.1.1) (`1.1.1.1 1.0.0.1`)
  - Your private DNS resolver
- The server must have Internet access during deployment and upgrades.
- Prefer fast and reliable network links.


### NAT/port forwarding

If the network interface is in a [private network](https://en.wikipedia.org/wiki/Private_network#Private_IPv4_addresses) behind a router, setup [port forwarding (NAT)](https://en.wikipedia.org/wiki/Port_forwarding) on the router if you need to access your services from other networks/Internet. Depending on which services are installed on the server, forward the following ports to your server's private IP address (if corresponding services are installed):

```
SSH server:                      TCP 22
Netdata monitoring system:       TCP 19999
Web server:                      TCP 80/443
BitTorrent incoming connections: TCP/UDP 52943
Mumble VoIP server:              TCP/UDP 64738
Graylog TCP input:               TCP 5140
Valheim server:                  TCP 2456-2457/27015/27030/27036-27037, UDP 2456-2457/4380/27000-27031/27036
```


### Domain names

The controller must be able to resolve the server's name from the [inventory](usage.md), using either:

- (preferred) `A` or `CNAME` DNS records to the public IP address of your server, from:
  - a public [domain name registrar](https://en.wikipedia.org/wiki/Domain_name_registrar) ([namecheap.com](https://namecheap.com), [gandi.net](https://gandi.net), ...)
  - your private DNS resolver
  - a [free subdomain service](https://freedns.afraid.org/domain/registry/)
- [hosts file](https://en.wikipedia.org/wiki/Hosts_%28file%29) entries
- the `ansible_host` variable in the host's [configuration](usage.md) file (e.g. `ansible_host: 192.168.1.220`)

Prefer using [Fully Qualified Domain Names](https://en.wikipedia.org/wiki/Fully_qualified_domain_name). Accessing the host directly by IP address is discouraged, use DNS records.

Public DNS records are required to obtain Let's Encrypt SSL/TLS (HTTPS) certificates - private DNS records will not work (you may still use self-signed certificates).

Separate domain/subdomain names are required to allow clients to access web applications. For example:

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
rss-bridge.CHANGEME.org # rss_bridge
```


## Base Operating System

`xsrv` roles are designed to run against minimal [Debian](https://www.debian.org/) [_Stable_](https://wiki.debian.org/DebianStable) systems: [Install Debian](../appendices/debian.md) on the host.

-------------------

You should now [prepare the controller](controller-preparation.md).
