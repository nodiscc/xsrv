# Debian

# Installation

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
