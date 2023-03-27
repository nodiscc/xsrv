# Debian

> [Debian GNU/Linux](https://en.wikipedia.org/wiki/Debian) is a GNU/Linux distribution composed of [free and open-source software](https://en.wikipedia.org/wiki/Free_and_open-source_software), developed by the community-supported Debian Project. Debian is one of the oldest operating systems based on the Linux kernel, and also the basis for many other distributions, most notably Ubuntu. The project is coordinated over the Internet by a team of volunteers guided by three foundational documents: the [Debian Social Contract](https://en.wikipedia.org/wiki/Debian_Social_Contract), the [Debian Constitution](https://www.debian.org/devel/constitution), and the [Debian Free Software Guidelines](https://en.wikipedia.org/wiki/Debian_Free_Software_Guidelines).

## Installation

### Manual, from ISO image

- Download a [Debian 11 netinstall image](https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/)
- Load the ISO image in your virtual machine's CD drive, or write the image to a 1GB+ USB drive (Linux: [`dd`](https://wiki.archlinux.org/index.php/USB_flash_installation_media#In_GNU.2FLinux), [GNOME disks](https://www.techrepublic.com/article/how-to-create-disk-images-using-gnome-disk/). Windows: [win32diskimager](http://sourceforge.net/projects/win32diskimager/))
- Boot your server/VM from the Debian installer ISO image/USB.
- Select `Advanced > Graphical advanced install`.
- Follow the installation procedure, using the following options:
  - Set the machine's locale/language to English (`en_US.UTF-8`)
  - IP address: preferably a static IP address and the correct network mask/gateway, or use automatic configuration/DHCP
  - DNS server: specify your ISP/hoster's DNS server, a [public DNS service](https://en.wikipedia.org/wiki/Public_recursive_name_server), or your private/internal DNS server
  - Enable the `root` account, set a strong password and store it somewhere safe like a Keepass database
  - Do **not** create an additional user account yet
  - Any disk partitioning scheme is OK, here are some generic recommendations:
    - Use LVM (Logical Volumes) instead of raw partitions/disks if possible. This will greatly facilitate disk management (resizing, adding drives...).
    - 10-15GB should be enough for the root `/` filesystem.
    - Define a separate `/var` filesystem/partition, make it as large as possible (user data is stored under `/var/`).
    - 1GB should be allocated to the `/boot` filesystem/partition if it is separate from the root partition.
    - Add a swap partition with a size of 1.5x your RAM if the RAM is less than 8GB, or 2GB if the RAM is more than 8GB.
    - `noatime` and `nodiratime` mount options are recommended for better disk performance
  - When asked, only install `Standard system utilities` and `SSH server`
  - Finish installation and reboot to disk.

**Ansible requirements**:

- From the server console, login as `root`
- Install ansible requirements: `apt update && apt --no-install-recommends install python3 aptitude sudo openssh-server`
- Create an administrator user account (replace `deploy` with the desired name): `useradd --create-home --groups sudo --shell /bin/bash deploy`
- Set the `sudo` password for this user: `passwd deploy`
- Lock the console: `logout`


### Automated, from preseed file

`xsrv` allows automated creation/provisioning of VMs with a minimal Debian operating system as described above. [libvirt](virt-manager.md) and must be [installed](../installation/controller-preparation.md) on the machine where these commands are run.

The template will be created by downloading an [official Debian installer image](http://deb.debian.org/debian/dists/bullseye/main), and applying a [preseed](https://wiki.debian.org/DebianInstaller/Preseed) file to automate answers to all installer questions. Provisioning a new host using this method should be no longer than a few minutes.

```bash
$ xsrv init-vm-template --help
USAGE: ./xsrv init-vm-template [--name debian11-base] --ip IP_ADDRESS --gateway GATEWAY_IP [--netmask 255.255.255.0] [--nameservers '1.1.1.1 1.0.0.1'] [--root-password TEMPLATE_ROOT_PASSWORD] [--sudo-user deploy] [--sudo-password SUDO_PASSWORD] [--storage-path /var/lib/libvirt/images] [--memory 1G] [--vcpus 2] [--disk-size 20] [--network default] [--preseed-file /home/live/.local/share/xsrv/git/docs/preseed.cfg]
        Initialize a libvirt VM template from official Debian netinstall image and a preseed file. This template can be reused as --template from xsrv init-vm.
        Requirements: libvirt, current user in the libvirt group
        --name          name of the VM/template to create (default debian11-base)
        --ip            REQUIRED IP address of the VM/template
        --gateway       REQUIRED default network gateway of the VM
        --netmask       network mask of the VM (default 255.255.255.0)
        --nameservers   space-separated list of DNS nameservers (default cloudflare, '1.1.1.1 1.0.0.1')
        --root-password root account password (default generate and display a random password)
        --sudo-user     administrative (sudoer) user account (default deploy)
        --sudo-password password for the administrative (sudoer) user account (default generate and display a random password)
        --storage-path  path to the directory where qcow2 disk images will be stored (default /var/lib/libvirt/images)
        --memory        VM memory with M or G suffix (default 1G)
        --vcpus         VM vCPUs (default 2)
        --disk-size     size of the disk image to create, in GB (default 20)
        --network       name of the libvirt network to attach the VM to (default default)
        --preseed-file  path to the preseed/preconfiguration file (default /home/live/.local/share/xsrv/git/docs/preseed.cfg)
```

The default preseed file can be found [here](https://gitlab.com/nodiscc/xsrv/-/blob/master/docs/preseed.cfg) and can be overriden using `--preseed /path/to/custom/preseed.cfg`.

[![](https://asciinema.org/a/FIlybeNFgNlAAhQVnDl96FPUv.svg)](https://asciinema.org/a/FIlybeNFgNlAAhQVnDl96FPUv?speed=2&theme=monokai&autoplay=true)


### Automated, from a VM template

If you already have a [libvirt](virt-manager.md) Debian VM set up as described above, it can be reused as a template (_golden image_) for other VMs. This significantly reduces the time needed to setup a new VM and make it ready for deployment. The time required to provision a new host using this method should not exceed 1 minute.

```bash
$ ./xsrv init-vm --help
USAGE: ./xsrv init-vm  --name VM_NAME [--template debian11-base] --ip VM_IP [--netmask 24] --gateway VM_GATEWAY [--ssh-port VM_SSH_PORT] [--sudo-user deploy] [--sudo-password VM_SUDO_PASSWORD] --ssh-pubkey 'ssh-rsa AAAAB...' [--root-password VM_ROOT_PASSWORD] [--disk-path /path/to/my.CHANGEME.org.qcow2] [--memory 1024] [--vcpus NUM_CPU]
        EXAMPLE: ./xsrv init-vm --template debian11-base --name my.CHANGEME.org --ip 10.0.0.223 --netmask 24 --gateway 10.0.0.1 --sudo-user deploy --sudo-password CHANGEME --ssh-pubkey 'ssh-rsa AAAAB...' --root-password CHANGEME --memory 3G --vcpus 4 [--dumpxml /path/to/libvirt/vm/definition.xml]
        Initialize a libvirt VM from a template, configure resources/users/SSH access, and start the VM.
        Requirements: openssh-client sshpass libvirt virtinst libvirt-daemon-system libguestfs-tools pwgen netcat-openbsd util-linux
        --template      name of the template to create the new VM from (default debian11-base)
        --name          REQUIRED name of the VM to create
        --ip            REQUIRED IP address of the VM
        --gateway       REQUIRED default network gateway of the VM
        --netmask       network mask of the VM (CIDR notation, default 24)
        --root-password root account password (default generate and display a random password)
        --sudo-user     administrative (sudoer) user account (default deploy)
        --sudo-password password for the administrative (sudoer) user account (default generate and display a random password)
        --ssh-pubkey    REQUIRED public key to authorize on the administrative (sudoer) account
        --disk-path     path to the qcow2 disk image to create (default: /var/lib/libvirt/images/VM_NAME.qcow2)
        --memory        VM memory with M or G suffix (default 1G)
        --vcpus         number of vCPUs (default: same value as the template)
        --dumpxml       write the VM XML definition to a file after creation
```

[![](https://asciinema.org/a/XXqAHsCMA7JNdEjxWnrsz7z0k.svg)](https://asciinema.org/a/XXqAHsCMA7JNdEjxWnrsz7z0k?speed=2&theme=monokai&autoplay=true)

You can then use the [`nodiscc.xsrv.libvirt`](https://gitlab.com/nodiscc/xsrv/-/tree/master/roles/libvirt) role to manage VMs, the [`virsh`](https://manpages.debian.org/bullseye-backports/libvirt-clients/virsh.1.en.html) command-line tool, and/or [virt-manager](virt-manager.md) to manage the hypervisor from a remote machine.


### From a hosting provider

Most VPS providers allow you to install a preconfigured Debian system with basic SSH `root` access. Follow your hosting provider's documentation - make sure requirements above are met (`python aptitude sudo` installed, user account in the `sudo` group).


## See also

- [debian-live-config](https://debian-live-config.readthedocs.io/) - Debian GNU/Linux desktop operating system for personal computers & workstations.
- https://stdout.root.sx/?searchtags=debian
