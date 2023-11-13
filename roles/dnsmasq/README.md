# xsrv.dnsmasq

This role will install and configure [dnsmasq](https://en.wikipedia.org/wiki/Dnsmasq), a lightweight DNS server for small computer networks.

Optionally, DNS blocklists can be configured, for example to block advertisements or malware-related domains on all clients of the DNS server.


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

**Client configuration:** Configure clients to contact the dnsmasq server for name resolution in `/etc/resolv.conf`, or configure your DHCP server to automatically provide the dnsmasq server address to your clients. For example using the [common](../common) role:

```yaml
# host_vars/client1.CHANGEME.org/client1.CHANGEME.org.yml
setup_dns: yes
dns_nameservers:
  - 10.1.2.3 # IP address of the dnsmasq server
```

**Blocklists:** DNS blocklists can be configured through `dnsmasq_blocklist_url`, `dnsmasq_blocklist_mode` and `dnsmasq_blocklist_whitelist` configuration variables. The blocklist will be downloaded from the specified URL and can use either the standard [`hosts` file format](https://en.wikipedia.org/wiki/Hosts_(file)) or the `dnsmasq` configuration file format (list of `address=` directives). A few example curated blocklists are provided as an example. Check the description of each list before enabling it, and keep in mind that some lists may yield many false positives that will need to be whitelisted manually. Only entries pointing to 0.0.0.0 (or using the /# syntax for dnsmasq-formatted files) will be kept in the blocklist. The blocklist will be updated daily (or when the configfuration is changed) - you can also force an update by using the `utils-dnsmasq-update-blocklist` ansible tag (`TAGS=utils-dnsmasq-update-blocklist xsrv deploy`). If you need to add custom entries to the DNS blocklist, you should maintain your own list and make it available for download - tools such as [hosts-bl](https://github.com/ScriptTiger/Hosts-BL) and [ghosts](https://github.com/StevenBlack/ghosts) can help you manage large blocklists efficiently.


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
