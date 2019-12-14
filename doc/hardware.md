#### Hardware

The server machine can be a physical computer (server-grade, desktop/laptop, small factor board/barebone), or a [virtual Machine](https://en.wikipedia.org/wiki/Virtualization) on your personal computer, at a VPS provider, or a dedicated/hardware hypervisor.

Virtualization software includes [virt-manager](https://en.wikipedia.org/wiki/Virtual_Machine_Manager) (Linux), [Virtualbox](https://en.wikipedia.org/wiki/VirtualBox) (Linux/OSX/Windows), [Proxmox VE](https://en.wikipedia.org/wiki/Proxmox_Virtual_Environment) (dedicated hypervisor).

Resource usage will vary depending on installed roles (read each role's documentation), the number of users, and how much user data you need to store. A minimal configuration for a personal server with 2-10 users:

 - Computer with x86/64 compatible CPU
 - 1024-2048MB+ RAM
 - 40GB-∞ drive space

**Power:** Use low power consumption components. To increase availability, setup the BIOS to reboot after a power loss, setup an [UPS](https://en.wikipedia.org/wiki/Uninterruptible_power_supply), and/or multiple power supplies.

**Storage:** A basic installation without user data requires about `~??GB` of disk space. 40GB+ is a good start to start storing documents, shared files and other data.

**CPU/RAM:** Some roles will require more processing power and memory. Read each role's README before use.
