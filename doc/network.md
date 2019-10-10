#### Network setup

The server must have Internet access during deployment and upgrades. Prefer fast and reliable network links. Here we assume the server has a single network interface.

If the network interface is in a private network behind a router, you should assign a [static, private IP address](https://en.wikipedia.org/wiki/Private_network#Private_IPv4_addresses) (eg `192.168.0.10`) in the corresponding network during installation, set the router's IP address as **gateway**, set the **DNS server** to either your internal DNS server, your ISP/hoster's DNS server, or a [public DNS service](https://en.wikipedia.org/wiki/Public_recursive_name_server). Setup **NAT (port forwarding)** on the router if you need to access your services from other networks/the Internet. You may want to forward the following ports/services to your server's private IP address:

```
SSH server:                      TCP 22
Web server:                      TCP 443
BitTorrent incoming connections: TCP/UDP 55702
Mumble VoIP server:              TCP/UDP 64738
```

The server's **hostname ([FQDN](https://en.wikipedia.org/wiki/Fully_qualified_domain_name))** must be resolvable from the ansible controller/the clients (DNS `A` record, [hosts file](https://en.wikipedia.org/wiki/Hosts_(file)...), and pointing to the server's IP address (public IP if behind a NAT) - ie. configuring the server by direct IP address access will not work as expected. You can rent a domaine name from a [registrar](https://en.wikipedia.org/wiki/Domain_name_registrar), or get a free public DNS subdomain at [freedns.afraid.org](https://freedns.afraid.org/domain/registry/), or setup an internal/private DNS server (for example with [pfSense](https://pfsense.org)).

The default **firewall** configuration assumes the server network interface is facing both your local network and the Internet. IP networks `192.168.0.0/16`, `10.0.0.0/8`, and `172.16.0.0/12` are considered local networks. To increase security, tighten firewall configuration, use additional network filters, VLANs or other methods to isolate your server from untrusted machines on the network.
