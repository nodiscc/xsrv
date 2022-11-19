# xsrv.dnsmasq

This role will install and configure [dnsmasq](https://en.wikipedia.org/wiki/Dnsmasq), a lightweight DNS server for small computer networks.

## Requirements/dependencies/example playbook

See [meta/main.yml](meta/main.yml)

```yaml
# playbook.yml
- hosts: my.CHANGEME.org
  roles:
    - nodiscc.xsrv.common # (optional) basic setup, hardening, firewall
    - nodiscc.xsrv.monitoring # (optional) dsnmasq monitoring
    - nodiscc.xsrv.dnsmasq

# host_vars/my.CHANGEME.org/my.CHANGEME.org.yml
dnsmasq_upstream_servers:
  - 1.1.1.1
  - 1.0.0.1
```

See [defaults/main.yml](defaults/main.yml) for all configuration variables


## Usage

It is recommended to configure the host running dnsmasq, to use dnsmasq as resolver. Set `nameserver 127.0.0.1` in `/etc/resolv.conf`, or using the [common](../common) role:

```yaml
# host_vars/my.CHANGEME.org/my.CHANGEME.org.yml
setup_dns: yes
dns_nameservers:
  - 127.0.0.1
```

Configure clients to contact the dnsmasq server for name resolution in `/etc/resolv.conf` or using the [common](../common) role:

```yaml
# host_vars/client1.CHANGEME.org/client1.CHANGEME.org.yml
setup_dns: yes
dns_nameservers:
  - 10.1.2.3 # IP address of the dnsmasq server
```

Or use your DHCP server to automatically configure clients.


## Tags

<!--BEGIN TAGS LIST-->
```
dnsmasq - setup dnsmasq DNS server
```
<!--END TAGS LIST-->


## License

[GNU GPLv3](../../LICENSE)


## References

- https://stdout.root.sx/links/?searchtags=dns
