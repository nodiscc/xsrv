# xsrv.libvirt

This role will install and configure [libvirt], a collection of software that provides a convenient way to manage virtual machines and other virtualization functionality, such as storage and network interface management.


## Requirements/dependencies/example playbook

See [meta/main.yml](meta/main.yml)

```yaml
# playbook.yml
- hosts: my.CHANGEME.org
  roles:
    - nodiscc.xsrv.libvirt
```

See [defaults/main.yml](defaults/main.yml) for all configurable variables

## Usage

Below is an example of a simple setup with 2 libvirt hypervisors using shared storage:

```yaml
# $ xsrv edit-group
# ~/playbooks/default/group_vars/all/all.yml
libvirt_networks:
  - name: default
    mac_address: "52:55:56:78:91:11"
    forward_dev: "eth0"
    bridge_name: "virbr0"
    ip_address: "10.100.100.1"
    netmask: "255.255.255.0"
    dhcp_start: "10.100.100.128"
    dhcp_end: "10.100.100.254"
  - name: lambdacore
    mac_address: "52:54:00:18:0c:cd"
    bridge_name: "virbr1"
    ip_address: "10.10.10.1"
    netmask: "255.255.255.0"
  - name: test
    mac_address: "52:54:00:18:0c:cd"
    bridge_name: "virbr2"
    ip_address: "10.200.200.1"
    netmask: "255.255.255.0"
    state: inactive
    autostart: no

# shared storage
libvirt_storage_pools:
  - name: LIBVIRT-STORAGE
    path: /mnt/LIBVIRT-STORAGE
    mode: "0770"

# wait for the shared storage to be mounted before autostarting VMs
libvirt_service_after:
  - 'media-EXT4\x2d2TB\x2dA.mount'
```

```yaml
# $ xsrv edit-host default hv1.example.org
# playbooks/default/host_vars/hv1.example.org/hv1.example.org.yml
# forward ports 443 and 22003 to th VM vm21.example.org
libvirt_port_forwards:
  - host_ip: 192.168.127.3
    host_port: 443
    protocol: tcp
    vm_ip: 10.10.10.21
    vm_port: 443
    vm_name: vm21.example.org
    bridge: virbr1
  - host_ip: 192.168.127.3
    host_port: 22003
    protocol: tcp
    vm_ip: 10.10.10.23
    vm_port: 22
    vm_name: vm21.example.org
    bridge: virbr1

# VMs on hv1.example.org
libvirt_vms:
  - name: vm21.example.org
    xml_file: "{{ playbook_dir }}/data/libvirt/vm21.example.org.xml"
    state: running
```

```yaml
# $ xsrv edit-host default hv1.example.org
# playbooks/default/host_vars/hv1.example.org/hv1.example.org.yml
# VMs on hv2.example.org
libvirt_vms:
  - name: demo1.example.org
    xml_file: "{{ playbook_dir }}/data/libvirt/demo1.example.org.xml"
  - name: demo2.example.org
    xml_file: "{{ playbook_dir }}/data/libvirt/demo2.example.org.xml"
  - name: demo777.example.org
    xml_file: "{{ playbook_dir }}/data/libvirt/builder.example.org.xml"
    autostart: no
```

Note: changing VM resources (RAM/CPU) in the XML definition, and applying the role will not affect **running** VMs until they are stopped and restarted. To force the current memory values defined in XML definitions to be applied immediately, without stopping/restarting VMs, use the tag `utils-libvirt-setmem` (or SSH to the hypervisor and use [`virsh setmem --live`](https://manpages.debian.org/bullseye-backports/libvirt-clients/virsh.1.en.html#setmem) directly). The maximum memory allocation for the VM (`<memory>` XML tag ) must already be greater than the requested/current memory (`<currentMemory>` XML tag).


## Tags

<!--BEGIN TAGS LIST-->
```
libvirt - setup libvirt virtualization toolkit
libvirt-storage - setup libvirt storage pools
libvirt-networks - setup libvirt virtual networks
libvirt-port-forwards - setup libvirt port forwards
libvirt-vms - setup libvirt virtual machines
utils-libvirt-setmem - (manual) update libvirt VMs current memory settings immediately
```
<!--END TAGS LIST-->


## License

[GNU GPLv3](../../LICENSE)

## References

- https://stdout.root.sx/links/?searchterm=libvirt
- https://stdout.root.sx/links/?searchtags=virtualization

