# xsrv.wireguard

This role will install [Wireguard](https://en.wikipedia.org/wiki/WireGuard), a [virtual private network (VPN)](https://en.wikipedia.org/wiki/Virtual_private_network) server designed with the goals of ease of use, high speed performance, and low attack surface.

Clients of the wireguard server will be able to route their traffic through it.

## Requirements/dependencies/example playbook

See [meta/main.yml](meta/main.yml)

```yaml
# playbook.yml
- hosts: my.CHANGEME.org
  roles:
    - nodiscc.xsrv.common # (optional) base server setup, hardening, firewall
    - nodiscc.xsrv.monitoring # (optional) system/server monitoring and health checks
    - nodiscc.xsrv.backup # (optional) automatic local backup of private keys
    - nodiscc.xsrv.dnsmasq # DNS resolution for VPN clients
    - nodiscc.xsrv.wireguard # fast and modern VPN server

# required variables
# host_vars/my.CHANGEME.org/my.CHANGEME.org.yml
wireguard_server_public_ip: "CHANGEME"
wireguard_peers:
  - name: client1
    public_key: Faz...4vEQ=
    ip_address: "10.200.200.10/24"

```

See [defaults/main.yml](defaults/main.yml) for all configuration variables.

The server's UDP port `51820` must be reachable by clients. Configure NAT/port forwarding on your router if necessary, and allow port `51820/udp` in the host's firewall (if the [`ansible.xsrv.common`](../common) role is deployed, a `firewalld` rule is automatically added).

IP forwarding must be enabled on the host, for example using the [common](../common) role:

```yaml
sysctl_allow_forwarding: yes
```

## Usage

**Connecting VPN clients** VPN clients (peers) must generate their private/public keys beforehand:

> Please generate VPN keys by running:  
> `sudo apt install wireguard-tools`  
> `wg genkey | (umask 0077 && tee $HOSTNAME-wireguard.key) | wg pubkey > $HOSTNAME-wireguard.pub`  
> and send the contents of the `$HOSTNAME-wireguard.pub` file to the VPN server administrator. Keep a copy of the content of `$HOSTNAME-wireguard.key` somewhere safe as you will need it later. You may then delete `$HOSTNAME-wireguard.pub/key` files.

Setup clients in `wireguard_peers` using the `public_key` value they provided and deploy the role. A configuration file for each client will be generated in `data/wireguard/` in the playbook directory. Send their respective configuration file to all clients - it contains further instructions to connect to the VPN on client machines.


**List connected clients:** Access the server over SSH (`xsrv ssh`) and run `sudo wg`.

### Debugging

You can turn on debug logging at any time by running `echo module wireguard +p | sudo tee /sys/kernel/debug/dynamic_debug/control`. To disable debug logging: `echo module wireguard -p | sudo tee /sys/kernel/debug/dynamic_debug/control`. Debug logging will log events such as peers connecting/disconnecting and rejected connection attempts.

### Backups

The server's private/public keys should be backed up. See the included [rsnapshot configuration](templates/etc/rsnapshot.d_wireguard.conf.j2) for information about directories to backup/restore.

## Tags

<!--BEGIN TAGS LIST-->
```
wireguard - setup wireguard
```
<!--END TAGS LIST-->

## License

[GNU GPLv3](../../LICENSE)


## References

- https://stdout.root.sx/links/?searchterm=wireguard
- https://stdout.root.sx/links/?searchtags=vpn
