### Debian server preparation

#### Hardware requirements

The server machine can be a physical computer (server-grade, desktop/laptop, small factor board/barebone), or a [virtual Machine](https://en.wikipedia.org/wiki/Virtualization) on your personal computer, at a VPS provider, or a dedicated/hardware hypervisor.

Virtualization software includes [virt-manager](https://en.wikipedia.org/wiki/Virtual_Machine_Manager) (Linux), [Virtualbox](https://en.wikipedia.org/wiki/VirtualBox) (Linux/OSX/Windows), [Proxmox VE](https://en.wikipedia.org/wiki/Proxmox_Virtual_Environment) (dedicated hypervisor).

Resource usage will vary depending on installed roles (read each role's documentation), the number of users, and how much user data you need to store. A minimal configuration for a personal server with 2-10 users:

 - Computer with x86/64 compatible CPU
 - 1024-2048MB+ RAM
 - 40GB-∞ drive space

**Power:** Use low power consumption components. To increase availability, setup the BIOS to reboot after a power loss, setup an [UPS](https://en.wikipedia.org/wiki/Uninterruptible_power_supply), and/or multiple power supplies.

**Storage:** A basic installation without user data requires about `~??GB` of disk space. 40GB+ is a good start to start storing documents, shared files and other data.

**CPU/RAM:** Some roles will require more processing power and memory. Read each role's README before use.


#### Network setup

The server must have Internet access during deployment and upgrades. Prefer fast and reliable network links. Here we assume the server has a single network interface.

If the network interface is in a private network behind a router, during Debian installation:
- assign a [static, private IP address](https://en.wikipedia.org/wiki/Private_network#Private_IPv4_addresses) (eg `192.168.0.10`) 
- set the router's IP address as **gateway**
- set the **DNS server** to either your internal DNS server, your ISP/hoster's DNS server, or a [public DNS service](https://en.wikipedia.org/wiki/Public_recursive_name_server)

On the router, setup **NAT (port forwarding)** if you need to access your services from other networks/Internet. You may want to forward the following ports/services to your server's private IP address:

```
SSH server:                      TCP 22
Web server:                      TCP 443
BitTorrent incoming connections: TCP/UDP 52943
Mumble VoIP server:              TCP/UDP 64738
```

The server's **hostname ([FQDN](https://en.wikipedia.org/wiki/Fully_qualified_domain_name))** must be resolvable from the controller and clients, and pointing to the server's IP address. This assumes either:

- A DNS (`A` or `CNAME`) record in the public DNS system - rent a domain name from a [registrar](https://en.wikipedia.org/wiki/Domain_name_registrar), or get a free public DNS subdomain at [freedns.afraid.org](https://freedns.afraid.org/domain/registry/)
- A [hosts file](https://en.wikipedia.org/wiki/Hosts_(file) entry on clients that need to access the server
- A DNS record on your private DNS resolver, your clients and controllers must be configured to use this resolver.

The default **firewall** configuration assumes the server network interface is facing both your local network and the Internet.
 - IP networks `192.168.0.0/16`, `10.0.0.0/8`, and `172.16.0.0/12` are considered local networks.
 - To increase security, tighten firewall configuration, use additional network filters, VLANs or other methods to isolate your server from untrusted machines on the network.


#### Operating system setup

This playbook is designed to run against minimal [Debian](https://www.debian.org/) 10 installations:

- Download a [Debian 10 netinstall image](https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/)
- Load the ISO image in your virtual machine's CD drive, or write the image to a 1GB+ USB drive (Linux: [`dd`](https://wiki.archlinux.org/index.php/USB_flash_installation_media#In_GNU.2FLinux), [GNOME disks](https://www.techrepublic.com/article/how-to-create-disk-images-using-gnome-disk/). Windows: [win32diskimager](http://sourceforge.net/projects/win32diskimager/))
- Boot your server/VM from the Debian installer ISO image/USB.
- Select `Advanced > Graphical advanced install`.
- Follow the installation procedure, using the following options:
  - Set the machine's locale/language to English (`en_US.UTF-8`)
  - IP address/gateway/DNS server: Refer to the network setup section above.
  - Enable `root` account, set a strong password and store it someplace safe like a Keepass database
  - Do not create an additional user account
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
- From the server console, login as `root` and run:

```bash
# Install requirements for remote admin/ansible access
apt install python aptitude sudo

# Create a user account for remote administration (replace 'deploy' with the desired account name)
useradd  --create-home --groups ssh,sudo --shell /bin/bash deploy
# Set the sudo password for this user account
passwd deploy

# test internet connectivity, test DNS resolution
ping -c1 1.1.1.1
getent hosts debian.org

# lock the console
logout
```

|      |       |
|------|-------|
|  ♦  | At this point, if your server is a virtual machine, it is a good idea to stop the VM and use it as a template. Every time you need to deploy a new server, clone the template, boot the clone, from the console edit the IP address in `/etc/network/interfaces`, `systemctl restart networking`, and set a new root password `passwd root`. |
