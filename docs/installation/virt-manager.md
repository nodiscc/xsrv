# libvirt and virt-manager

Management of [virtual machines](https://en.wikipedia.org/wiki/Virtual_machine) (VMs) with [virt-manager](https://en.wikipedia.org/wiki/Virtual_Machine_Manager) on a Linux system.

`virt-manager` is a graphical interface for [`libvirt`](https://en.wikipedia.org/wiki/Libvirt), a toolkit to manage VMs and accompanying virtual storage, virtual networks... and more.

libvirt can manage many types of virtualization/container technologies.
[KVM](https://en.wikipedia.org/wiki/Kernel-based_Virtual_Machine) is a module in the Linux kernel that allows the kernel to function as a hypervisor (a computer that runs virtual machines). [QEMU](https://en.wikipedia.org/wiki/QEMU) is an emulator that interfaces with KVM, and provides additional management features on top of it.
libvirt allows managing QEMU virtual machines, through easy graphical and command-line interfaces.

Advantages and use cases of virtualization:

- Spin up a VM to test an operating system, and destroy it afterwards without affecting your computer. Virtual Machines provide isolation from the hypervisor.
- Create a snapshot of the state of a VM at any time, run experiments in it, break it, and restore the snapshot to go back to where you were (testing environments).
- Change the resources allocated to each VM (virtual storage/disk space, RAM, CPU...) and easily scale up/down depending on your needs.
- Use a default, transparent network setup, or create complex virtual networks with routing, switching, firewalling... without investing in networking hardware.
- Run many operating systems/environmnents on a single machine, without them affecting each other one.
- Easily migrate a VM between hypervisors (in some configurations, without any downtime) for emergencies or load balancing.
- The performance of a QEMU/KVM virtual machine is very close to the performance on the real, physical host ([Type 1 Hypervisor](https://en.wikipedia.org/wiki/Hypervisor#Classification)). This is in contrast with Type 2 hypervisors such as VirtualBox, VMWare Player/Workstation which have a greater performance penalty.

There are Linux distributions dedicated to managing hypervisors such as [Proxmox](https://en.wikipedia.org/wiki/Proxmox_Virtual_Environment).

One advantage of virt-manager/libvirt is that you can reuse your daily desktop machine as a hypevisor, and spare the investment in a dedicated machine for virtualization.


#### Installing virt-manager

On Debian-based systems:

```bash
sudo apt install virt-manager
```

You may add your normal user account to the `libvirt` group to allow it to manage virtual machines without using `sudo` or entering your password during normal operation:

```bash
sudo usermod -G $USER libvirt
```

#### Setting up a VM

<!-- TODO update screenshots -->

Run virt-manager from the main menu and click `New virtual machine`

![](https://1081754738.rsc.cdn77.org/wp-content/uploads/2020/08/2-4.png)

Select QEMU/KVM as the virtual machine type:

![]()

Select the installation media/ISO image for the operating system you want to install:

![](https://1081754738.rsc.cdn77.org/wp-content/uploads/2020/08/3-3.png)

Set memory amount and virtual CPU number depending on your performance requirements:

![](https://1081754738.rsc.cdn77.org/wp-content/uploads/2020/08/5-1.png)

Create a new virtual hard disk image for your VM depending on your storage requirements:

![](https://1081754738.rsc.cdn77.org/wp-content/uploads/2020/08/6-1.png)

Set a unique name ()such as a [FQDN](https://en.wikipedia.org/wiki/Fully_qualified_domain_name)) for your VM, adn attach it to the default `NAT` virtual network:

![](https://1081754738.rsc.cdn77.org/wp-content/uploads/2020/08/7-1.png)

Click `Finish` and start the VM from virt-manager's main window.

You can also create a VM from the command-line using the [virsh](https://manpages.debian.org/buster/libvirt-clients/virsh.1.en.html) command-line tool:

```bash
virt-install --name mynew.example.org --os-type linux --ram 1024M --vcpu 2 --disk path=/path/to/mynew.example.org.qcow2,size=20 --graphics virtio --noautoconsole --hvm --cdrom /path/to/debian-10.3.1_amd64.iso --boot cdrom,hd
```

#### Managing resources

#### Managing virtual networks

#### Cloning VMs

It is common practice to setup a virtual machine with the bare minimum components required to access it over SSH, then use [configuration management](configuration-management.md) to manage its additional components.

Once the template VM has been set up ([server-preparation.md](server-preparation.md)), clone it to a new VM:

```bash
virt-clone --original vm-template --name myclone.example.org --file /path/to/myclone.example.org.qcow2
# start the new VM
virsh start myclone.example.org
```

#### Migrating VMs between hypervisors

```bash
# dump the VM xml definition
srvadmin@hv1:~$ virsh dumpxml my.virtual.machine > my.virtual.machine.xml
# copy the VM XML definition to the destination host
srvadmin@hv1:~$ rsync -avP my.virtual.machine.xml srvadmin@hv2.example.org:my.virtual.machine.xml
# copy the VM disks to the destination host (same directory)
srvadmin@hv1:~$ rsync -avP /var/lib/libvirt/images/my.virtual.machine.qcow2 srvadmin@hv2.example.org:/var/lib/libvirt/images/my.virtual.machine.qcow2
# ssh to the destination host
srvadmin@hv1:~$ ssh srvadmin@hv2.example.org
# create a VM from the XML definition
srvadmin@hv2:~$ virsh define my.virtual.machine.xml
# start the VM
srvadmin@hv2:~$ virsh start my.virtual.machine.xml
```



