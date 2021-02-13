# libvirt / virt-manager

[virt-manager](https://en.wikipedia.org/wiki/Virtual_Machine_Manager) is a graphical interface for [`libvirt`](https://en.wikipedia.org/wiki/Libvirt), a toolkit to manage [virtual machines](https://en.wikipedia.org/wiki/Virtual_machine) and accompanying virtual storage, networking, and more.

[KVM](https://en.wikipedia.org/wiki/Kernel-based_Virtual_Machine) is a module in the Linux kernel that allows Linux to function as a hypervisor (a computer that runs virtual machines).
[QEMU](https://en.wikipedia.org/wiki/QEMU) is an emulator that interfaces with KVM, and provides additional VM, storage and network management features.
The [libvirt](https://en.wikipedia.org/wiki/Libvirt) project allows easy and comprehensie management QEMU virtual machines through graphical (`virt-manager`) and command-line (`virsh`) interfaces.

Advantages of virtualization include:

- Run many independent operating systems/environmnents on a single machine.
- Quickly create, clone and delete virtual machines for temporary/testing environments
- VMs are isolated from each other and from the hypervisor (at the OS level).
- Easy rollback: snapshot the state of a VM at any time - restore it to roll back to the exact previous state
- Easy management of resources, virtual storage, RAM, CPU...)
- Create simple or complex virtual networks with routing, switching, firewalling...
- Easy migration of VMs between hypervisors (without/with few downtime) for emergencies or load balancing.
- QEMU/KVM virtual machine performance is very close to the performance on a real, physical host ([Type 1 Hypervisor](https://en.wikipedia.org/wiki/Hypervisor#Classification)) - in contrast with Type 2 hypervisors (VirtualBox, VMWare Player...)

libvirt/virt-manager can be installed on a dedicated machine, or on any GNU/Linux desktop computer.


#### Installation

On Debian-based systems:

```bash
sudo apt install virt-manager
```

(Optional) add your normal user account to the `libvirt` group to allow it to manage virtual machines without using `sudo` or entering your password during normal operation:

```bash
sudo usermod -G $USER libvirt
```


#### Virtual machine creation

Run virt-manager from the main menu and click `New virtual machine`

![](https://i.imgur.com/1e2jNP0.png)

Select QEMU/KVM as the virtual machine type:

![](https://i.imgur.com/F7ZSXFS.png)

Select the installation media/ISO image for the operating system you want to install:

![](https://i.imgur.com/o5Fu0IX.png)

Set memory amount and virtual CPU number depending on your performance requirements:

![](https://i.imgur.com/0aQlobJ.png)

Create a new virtual hard disk image for your VM depending on your storage requirements:

![](https://i.imgur.com/Ra4vp3S.png)

Set a unique name (such as a [FQDN](https://en.wikipedia.org/wiki/Fully_qualified_domain_name)) for your VM, and attach it to the default `NAT` virtual network:

![](https://i.imgur.com/3Tn34xD.png)

Click `Finish` and start the VM from virt-manager's main window.

![](https://i.imgur.com/aJGkUJz.png)

You can also create a VM from the command-line using the [virsh](https://manpages.debian.org/buster/libvirt-clients/virsh.1.en.html) command-line tool:

```bash
virt-install --name mynew.example.org --os-type linux --ram 1024M --vcpu 2 --disk path=/path/to/mynew.example.org.qcow2,size=20 --graphics virtio --noautoconsole --hvm --cdrom /path/to/debian-10.3.1_amd64.iso --boot cdrom,hd
```


#### Managing resources

**CPU:** TODO

**RAM:** TODO

**Ballooning:** TODO

**VIDEO:** TODO

#### Managing virtual networks

**NAT:** TODO

**Port forwarding from the hypervisor:** TODO

**Bridged:** TODO


#### Cloning VMs

It is common practice to setup a virtual machine with the bare minimum components required to access it over SSH,
then use [configuration management](configuration-management.md) to manage all other software components.

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

#### Alternatives

[Proxmox VE](https://en.wikipedia.org/wiki/Proxmox_Virtual_Environment), a dedicated hypervisor manager based on Debian/KVM

