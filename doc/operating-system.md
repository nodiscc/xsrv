#### Base Debian installation

- Download the [Debian 10 netinstall image](https://cdimage.debian.org/debian-cd/current/amd64/iso-cd/debian-10.1.0-amd64-netinst.iso)
- Load the ISO image in your virtual machine's CD drive, or write the image to a 1GB+ USB drive (Linux: [`dd`](https://wiki.archlinux.org/index.php/USB_flash_installation_media#In_GNU.2FLinux), [GNOME disks](https://www.techrepublic.com/article/how-to-create-disk-images-using-gnome-disk/). Windows: [win32diskimager](http://sourceforge.net/projects/win32diskimager/))
- Boot your server/VM from the Debian installer ISO image/USB.
- Select `Advanced > Graphical advanced install`.
- Follow the installation procedure, using the following options:
  - IP address/gateway/DNS server: Refer to [#network](#network) above
  - Allow root (administrator) login (set a strong password), do not create an additional user account yet
  - Any disk partitioning scheme is OK, but prefer a separate `/var` with as much space as possible for user data. 10-15GB should be enough for the root filesystem partition. Setup LVM if possible. Setup RAID if to increase availability (RAID is not a backup)
  - When asked, only install `Standard system utilities` and `SSH server`
- Finish installation, reboot, login as `root` and run:

```bash
# Install requirements for remote admin/ansible access
apt install python aptitude sudo

# Create a user account for remote administration (replace 'deploy' with the desired account name)
useradd  --create-home deploy --groups ssh,sudo --shell /bin/bash deploy

# test internet connectivity, test DNS resolution
ping -c1 8.8.8.8
getent hosts debian.org

# lock the console
logout
```
