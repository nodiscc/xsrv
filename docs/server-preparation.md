# Server preparation

## Hardware requirements

The server machine can be:
 - a physical computer (dedicated server, repurposed desktop/laptop, small factor board/barebone...)
 - a [virtual machine](https://en.wikipedia.org/wiki/Virtualization) on your personal computer, at a VPS provider, or a dedicated/hardware hypervisor.

Virtualization software includes [virt-manager](https://en.wikipedia.org/wiki/Virtual_Machine_Manager) (Linux), [Virtualbox](https://en.wikipedia.org/wiki/VirtualBox) (Linux/OSX/Windows), [Proxmox VE](https://en.wikipedia.org/wiki/Proxmox_Virtual_Environment) (dedicated hypervisor).

Resource usage will vary depending on installed components (read each role's documentation), the number of users, and how much user data you need to store. Example minimal configuration for a personal/small team server with 2-10 users:

```
Computer with x86/64 compatible CPU
1024-2048MB+ RAM
10GB storage space for system and applications
1-∞GB storage space for user data
```

Use low power consumption components. To increase availability, setup the BIOS to reboot after a power loss, setup an [UPS](https://en.wikipedia.org/wiki/Uninterruptible_power_supply), and/or multiple power supplies.


## Network

The server must have Internet access during deployment and upgrades. Prefer fast and reliable network links. Here we assume the server has a single network interface.

Setup a **static IP address** + default gateway on the server during installation.

Setup **DNS resolution** during installation (use your ISP/hoster's DNS server, a [public DNS service](https://en.wikipedia.org/wiki/Public_recursive_name_server), or your private DNS server - [pfSense](https://en.wikipedia.org/wiki/PfSense) is a good start to boostrap a private DNS server).

### NAT

If the network interface is in a [private network](https://en.wikipedia.org/wiki/Private_network#Private_IPv4_addresses) behind a router, setup **NAT (port forwarding)** on the router if you need to access your services from other networks/Internet. Forward the following ports to your server's private IP address:

```
SSH server:                      TCP 22
Web server:                      TCP 80/443
BitTorrent incoming connections: TCP/UDP 52943
Mumble VoIP server:              TCP/UDP 64738
```

### DNS records

The server's **hostname** ([FQDN](https://en.wikipedia.org/wiki/Fully_qualified_domain_name)) must be resolvable from the controller (`A` or `CNAME` record at a public [DNS registrar]([registrar](https://en.wikipedia.org/wiki/Domain_name_registrar)), a [free subdomain service](https://freedns.afraid.org/domain/registry/) or your private DNS resolver, entry in your [hosts file](https://en.wikipedia.org/wiki/Hosts_(file)), or configure `ansible_ssh_host` to point ot server's IP address).

Setup any additional records/subdomains required to access your applications (webserver virtualhosts). By default the following subdomains are required (if corresponding roles are enabled):

```bash
cloud.CHANGEME.org # nextcloud
rss.CHANGEME.org   # tt-rss
gitea.CHANGEME.org # gitea
links.CHANGEME.org # shaarli
radio.CHANGEME.org # icecast
```

### Debian installation

This playbook is designed to run against minimal [Debian](https://www.debian.org/) 10 ([_Stable_](https://wiki.debian.org/DebianStable)) installations:

- Download a [Debian 10 netinstall image](https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/)
- Load the ISO image in your virtual machine's CD drive, or write the image to a 1GB+ USB drive (Linux: [`dd`](https://wiki.archlinux.org/index.php/USB_flash_installation_media#In_GNU.2FLinux), [GNOME disks](https://www.techrepublic.com/article/how-to-create-disk-images-using-gnome-disk/). Windows: [win32diskimager](http://sourceforge.net/projects/win32diskimager/))
- Boot your server/VM from the Debian installer ISO image/USB.
- Select `Advanced > Graphical advanced install`.
- Follow the installation procedure, using the following options:
  - Set the machine's locale/language to English (`en_US.UTF-8`)
  - IP address/gateway/DNS server: Refer to the [network](#network) section above.
  - Enable `root` account, set a strong password and store it someplace safe like a Keepass database
  - Do **not** create an additional user account yet
  - Any disk partitioning scheme is OK, with the following recommendations:
    - Use LVM if possible. This will greatly facilitate disk management if the need arises.
    - Create a separate `/var` partition, make it as large as possible (variable data is stored under `/var/`).
    - 10-15GB should be enough for the root `/` partition.
    - Add a swap partition with a size of 1.5x your RAM if the RAM is less than 8GB.
    - Add a swap partition with a size of 2GB if the RAM is more than 8GB.
    - Setup RAID to increase availability (RAID is not a backup)
    - `noatime` and `nodiratime` mount options are recommended for better disk performance
  - When asked, only install `Standard system utilities` and `SSH server`
  - Finish Debian installation.

### Ansible requirements

From the server console, login as `root` and run:

```bash
# Install requirements for remote admin/ansible access
apt install python aptitude sudo

# Create a user account for remote administration (replace 'deploy' with the desired account name)
useradd  --create-home --groups ssh,sudo --shell /bin/bash deploy
# Set the sudo password for this user account
passwd deploy

# test internet connectivity
ping -c1 1.1.1.1
# test DNS resolution
getent hosts debian.org

# lock the console
logout
```

|      |       |
|------|-------|
|  ♦  | At this point, if your server is a virtual machine, it is a good moment to stop the VM and use it as a template. Every time you need to deploy a new server, clone the template, boot the clone, from the console edit the IP address in `/etc/network/interfaces`, `systemctl restart networking`, and set new passwords `passwd root && passwd deploy`. |
