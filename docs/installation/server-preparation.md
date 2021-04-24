# Server preparation

## Hardware requirements

The server (_host_) machine can be:
 - a physical computer (dedicated server, repurposed desktop/laptop, small factor board/barebone...)
 - a [virtual machine](https://en.wikipedia.org/wiki/Virtualization) on your personal computer, at a VPS provider, or a dedicated/hardware hypervisor.

Virtualization software includes [libvirt/virt-manager](virt-manager.md) (Linux), [Proxmox VE](https://en.wikipedia.org/wiki/Proxmox_Virtual_Environment) (hypervisor manager based on Debian and KVM), [Virtualbox](https://en.wikipedia.org/wiki/VirtualBox) (Linux/OSX/Windows)

Resource usage will vary depending on installed components (read each role's documentation), the number of users, and how much user data you need to store. Example minimal configuration for a personal/small team server with 2-10 users:

```
Computer with x86/64 compatible CPU
1024-2048+ MB RAM
10+ GB storage space for system and applications
1-∞ GB storage space for user data
```

Use low power consumption components. To increase availability, setup the BIOS to reboot after a power loss, setup an [UPS](https://en.wikipedia.org/wiki/Uninterruptible_power_supply), and/or multiple power supplies.


## Network

The default configuration assumes the server has a single network interface.


### Internet access

The server must have Internet access during deployment and upgrades. Prefer fast and reliable network links. 


### NAT/port forwarding

If the network interface is in a [private network](https://en.wikipedia.org/wiki/Private_network#Private_IPv4_addresses) behind a router,
setup **NAT (port forwarding)** on the router if you need to access your services from other networks/Internet.

Forward the following ports to your server's private IP address (if corresponding services are installed):

```
SSH server:                      TCP 22
Netdata monitoring system:       TCP 19999
Web server:                      TCP 80/443
BitTorrent incoming connections: TCP/UDP 52943
Mumble VoIP server:              TCP/UDP 64738
```

### Domain names

Clients (and the controller) must be able to resolve the server's IP address by its ([Fully Qualified Domain Name](https://en.wikipedia.org/wiki/Fully_qualified_domain_name)). Separate domain or subdomain names are required for each service/application.

- Setup `A` or `CNAME` DNS records at a public [domain name registrar](https://en.wikipedia.org/wiki/Domain_name_registrar),
a [free subdomain service](https://freedns.afraid.org/domain/registry/) or on your private DNS resolver.
- Alternatively an entry the client [hosts file](https://en.wikipedia.org/wiki/Hosts_%28file%29) will work.

By default the following subdomains are required (if corresponding roles are enabled):

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
```


## Debian installation

Roles in this project are designed to run against minimal [Debian](https://www.debian.org/) 10 ([_Stable_](https://wiki.debian.org/DebianStable)) installations:

- Download a [Debian 10 netinstall image](https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/)
- Load the ISO image in your virtual machine's CD drive, or write the image to a 1GB+ USB drive (Linux: [`dd`](https://wiki.archlinux.org/index.php/USB_flash_installation_media#In_GNU.2FLinux), [GNOME disks](https://www.techrepublic.com/article/how-to-create-disk-images-using-gnome-disk/). Windows: [win32diskimager](http://sourceforge.net/projects/win32diskimager/))
- Boot your server/VM from the Debian installer ISO image/USB.
- Select `Advanced > Graphical advanced install`.
- Follow the installation procedure, using the following options:
  - Set the machine's locale/language to English (`en_US.UTF-8`)
  - IP address: preferably a static IP address and the correct network mask/gateway, or use automatic configuration/DHCP
  - DNS server: specify your ISP/hoster's DNS server, a [public DNS service](https://en.wikipedia.org/wiki/Public_recursive_name_server),
or your private DNS server ([pfSense](../advanced/pfsense.md) is a good start to boostrap a private DNS server)
  - Enable the `root` account, set a strong password and store it somewhere safe like a Keepass database
  - Do **not** create an additional user account yet
  - Any disk partitioning scheme is OK, here are some generic recommendations:
    - Use LVM if possible. This will greatly facilitate disk management if the need arises.
    - Define a separate `/var` partition, make it as large as possible (user data is stored under `/var/`).
    - 10-15GB should be enough for the root `/` partition.
    - Set the `/boot` partition to 1GB.
    - Add a swap partition with a size of 1.5x your RAM if the RAM is less than 8GB, or 2GB if the RAM is more than 8GB.
    - Setup RAID to increase availability (RAID is not a backup)
    - `noatime` and `nodiratime` mount options are recommended for better disk performance
  - When asked, only install `Standard system utilities` and `SSH server`
  - Finish installation and reboot to disk.


## Ansible requirements

From the server console, login as `root` and run:

```bash
# Install requirements for remote admin/ansible access
apt --no-install-recommends install python aptitude sudo

# Create a user account for remote administration (replace 'deploy' with the desired account name)
useradd  --create-home --groups ssh,sudo --shell /bin/bash deploy
# Set the sudo password for this user account
passwd deploy

# lock the console
logout
```

You should now [authorize your SSH key](controller-preparation.md) on the server.

|      |       |
|------|-------|
|  ♦  | At this point, if your server is a virtual machine, it is a good moment to stop the VM and use it as a template. Every time you need to deploy a new server, clone the template, boot the clone, from the console edit the IP address in `/etc/network/interfaces`, `systemctl restart networking`, and set new passwords `passwd root && passwd deploy`. |
