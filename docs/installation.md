# Installation

`xsrv` uses [Ansible](https://en.wikipedia.org/wiki/Ansible_(software)), an open-source software provisioning, configuration management, and application-deployment tool. Optionally [libvirt](appendices/virt-manager.md) is used to provision virtual machines.

`xsrv`/Ansible runs from a [controller](installation/controller-preparation.md) (administration machine) and configures remote servers ([hosts](server-preparation.md)) over the network, using [SSH](https://en.wikipedia.org/wiki/Secure_Shell).
 
![](ansible-diagram.png)

- [Server preparation](installation/server-preparation.md)
- [Controller preparation](installation/controller-preparation.md)
- [Initial configuration and deployment](installation/first-project.md)
