# Debian

> [Debian GNU/Linux](https://en.wikipedia.org/wiki/Debian) is a GNU/Linux distribution composed of [free and open-source software](https://en.wikipedia.org/wiki/Free_and_open-source_software), developed by the community-supported Debian Project. Debian is one of the oldest operating systems based on the Linux kernel, and also the basis for many other distributions, most notably Ubuntu. The project is coordinated over the Internet by a team of volunteers guided by three foundational documents: the [Debian Social Contract](https://en.wikipedia.org/wiki/Debian_Social_Contract), the [Debian Constitution](https://www.debian.org/devel/constitution), and the [Debian Free Software Guidelines](https://en.wikipedia.org/wiki/Debian_Free_Software_Guidelines).

## Installation

### From ISO image

- Download a [Debian 11 netinstall image](https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/)
- Load the ISO image in your virtual machine's CD drive, or write the image to a 1GB+ USB drive (Linux: [`dd`](https://wiki.archlinux.org/index.php/USB_flash_installation_media#In_GNU.2FLinux), [GNOME disks](https://www.techrepublic.com/article/how-to-create-disk-images-using-gnome-disk/). Windows: [win32diskimager](http://sourceforge.net/projects/win32diskimager/))
- Boot your server/VM from the Debian installer ISO image/USB.
- Select `Advanced > Graphical advanced install`.
- Follow the installation procedure, using the following options:
  - Set the machine's locale/language to English (`en_US.UTF-8`)
  - IP address: preferably a static IP address and the correct network mask/gateway, or use automatic configuration/DHCP
  - DNS server: specify your ISP/hoster's DNS server, a [public DNS service](https://en.wikipedia.org/wiki/Public_recursive_name_server),
or your private DNS server ([pfSense](pfsense.md) is a good start to boostrap a private DNS server)
  - Enable the `root` account, set a strong password and store it somewhere safe like a Keepass database
  - Do **not** create an additional user account yet
  - Any disk partitioning scheme is OK, here are some generic recommendations:
    - 10-15GB should be enough for the root `/` partition.
    - Set a size of 1GB for the `/boot` partition.
    - Define a separate `/var` partition, make it as large as possible (user data is stored under `/var/`).
    - Add a swap partition with a size of 1.5x your RAM if the RAM is less than 8GB, or 2GB if the RAM is more than 8GB.
    - Use LVM (Logical Volumes) instead of raw partitions/disks if possible. This will greatly facilitate disk management (resizing, adding drives...).
    - Setup RAID to increase availability (RAID is not a backup)
    - `noatime` and `nodiratime` mount options are recommended for better disk performance
  - When asked, only install `Standard system utilities` and `SSH server`
  - Finish installation and reboot to disk.

#### Ansible requirements

- From the server console, login as `root`
- Install ansible requirements: `apt update && apt --no-install-recommends install python3 aptitude sudo openssh-server`
- Create an administrator user account (replace `deploy` with the desired name): `useradd --create-home --groups ssh,sudo --shell /bin/bash deploy`
- Set the `sudo` password for this user: `passwd deploy`
- Lock the console: `logout`


### From a VM template

If you already have a [libvirt](virt-manager.md) Debian VM set up as described above, it can be reused as a template for other VMs. Using templates significantly reduces the time needed to setup a new VM and make it ready for deployment. Using `xsrv init-vm`:

```bash
$ ./xsrv init-vm --help
  ╻ ╻┏━┓┏━┓╻ ╻
░░╺╋╸┗━┓┣┳┛┃┏┛
  ╹ ╹┗━┛╹┗╸┗┛ v1.6.0
USAGE: ./xsrv init-vm --template TEMPLATE_NAME --name VM_NAME --ip VM_IP --netmask VM_NETMASK --gateway VM_GATEWAY [--ssh-port VM_SSH_PORT] --sudo-user VM_SUDO_USER [--sudo-password VM_sudo_password] --ssh-pubkey 'ssh-rsa AAAAB...' [--root-password VM_ROOT_PASSWORD] [--disk-path /path/to/my.CHANGEME.org.qcow2] [--memory MEM_SIZE] [--vcpus NUM_CPU]
        EXAMPLE: ./xsrv init-vm --template debian11-base --name my.CHANGEME.org --ip 10.0.0.223 --netmask 24 --gateway 10.0.0.1 --sudo-user deploy --sudo-password CHANGEME --ssh-pubkey 'ssh-rsa AAAAB...' --root-password CHANGEME --memory 3G --vcpus 4
        If not specified, random sudo/root passwords will be generated automatically
        If not specified, memory and vcpu values from the template will be kept
        If not specified, the VM disk image will be created at /var/lib/libvirt/images/VM_NAME.qcow2
```

### From a hosting provider

Most VPS providers allow you to install a preconfigured Debian system with basic SSH `root` access. Follow your hosting provider's documentation - make sure requirements  above are met (user account in the `sudo` group).


## See also

- [debian-live-config](https://debian-live-config.readthedocs.io/) - Debian GNU/Linux desktop operating system for personal computers & workstations.
- https://stdout.root.sx/?searchtags=debian
