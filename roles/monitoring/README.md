# xsrv.monitoring

This role will install a lightweight monitoring system on a Linux machine:
 - (optional) log aggregation for most services/applications, using [rsyslog](https://en.wikipedia.org/wiki/Rsyslog)
 - [netdata](https://my-netdata.io/), a real-time, efficient, distributed performance and health monitoring system.
 - (optional) netdata modules/graphs: [needrestart](https://gitlab.com/nodiscc/netdata-needrestart), [logcount](https://gitlab.com/nodiscc/netdata-logcount), [modtime](https://gitlab.com/nodiscc/netdata-modtime), [debsecan](https://gitlab.com/nodiscc/netdata-debsecan)
 - (optional) [lnav](http://lnav.org/) log viewer, [htop](https://hisham.hm/htop/) system monitor/process manager, [nethogs](https://github.com/raboof/nethogs) network bandwidth monitor, [ncdu](https://en.wikipedia.org/wiki/Ncdu) disk usage viewer

[![](https://screenshots.debian.net/screenshots/000/015/229/thumb.png)](https://screenshots.debian.net/package/netdata)
[![](https://screenshots.debian.net/screenshots/000/010/371/thumb.png)](https://screenshots.debian.net/package/lnav)
[![](https://screenshots.debian.net/screenshots/000/014/778/thumb.png)](https://screenshots.debian.net/package/htop)

## Requirements/dependencies/example playbook

See [meta/main.yml](defaults/main.yml) for all configuration variables

```yaml
- hosts: my.CHANGEME.org
  roles:
    - nodiscc.xsrv.common # (optional) basic setup, hardening, firewall
    - nodiscc.xsrv.monitoring
```

See [defaults/main.yml](defaults/main.yml) for all configuration variables

The service must be reachable on port `tcp/19999` through firewall/NAT


## Usage

### Netdata

- Netdata dashboard access: https://my.example.org:19999.
- When there is an abnormal condition on the host, an alarm will show up in the alarms panel, and a mail will be sent to the server admin e-mail address, using the system's Mail Transfer Agent (see the [common](../common) role and `msmtp*` variables)

Read [netdata documentation](https://docs.netdata.cloud/) for more info.

### Logs

Navigate/search/filter aggregated system logs (using [lnav](https://lnav.org/)): `ssh -t user@my.example.org sudo lnav /var/log/syslog`. Some useful internal lnav [commands](https://lnav.readthedocs.io/en/latest/):

- `:filter-in <expression>` only display messages matching filter expression
- `:set-min-log-level debug|info|warning|error` only display messages above a defined log level.
- `:<TAB><TAB>` display internal command list
- `Ctrl+R` clear all filters/reset session
- `?` lnav help

Read [lnav documentation](https://lnav.readthedocs.io/) for more info.

### Other

- Show running processes: `ssh user@my.example.org sudo htop`
- Analyze disk usage by directory: `ssh user@my.example.org sudo ncdu /`
- Show network connections on the host `ssh -t user@my.example.org sudo watch -n 2 ss -laptu`


### Integration with other roles

Roles that need to install custom `httpcheck`/`x509check`/`portcheck`/`modtime`/`processes` module/alarm configurations must create relevant files in `/etc/netadata/{go,python,health}.d/$module_name.conf.d/` and notify the `assemble netadata configuration` handler.


## License

[GNU GPLv3](../../LICENSE)


## References

- https://stdout.root.sx/links/?searchtags=monitoring
