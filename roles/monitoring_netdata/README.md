# xsrv.monitoring_netdata

This role will install and configure [Netdata](https://my-netdata.io/), a real-time, efficient, distributed performance and health monitoring system, and optional netdata modules/graphs:
 - [needrestart](https://gitlab.com/nodiscc/netdata-needrestart)
 - [logcount](https://gitlab.com/nodiscc/netdata-logcount)
 - [debsecan](https://gitlab.com/nodiscc/netdata-debsecan)

[![](https://i.imgur.com/vqfWelH.png)](https://i.imgur.com/vqfWelH.png)


## Requirements/dependencies/example playbook

See [meta/main.yml](meta/main.yml)

```yaml
- hosts: my.CHANGEME.org
  roles:
    - nodiscc.xsrv.common # (optional) basic setup, hardening, firewall
    - nodiscc.xsrv.monitoring_netdata
    # - nodiscc.xsrv.monitoring # (optional) full monitoring suite including monitoring_netdata
```

See [defaults/main.yml](defaults/main.yml) for all configuration variables


## Usage

- Netdata dashboard access: https://my.CHANGEME.org:19999 (or https://IP_ADDRESS:19999)
- When there is an abnormal condition on the host, an alarm will be raised in the alarms panel of the dashboard, and a mail will be sent to the server admin e-mail address, using the system's Mail Transfer Agent (see the [common](../common) role and `msmtp*` variables)

[netdata documentation](https://docs.netdata.cloud/)

- To reboot hosts that have Linux kernel upgrade pending:

```bash
# using xsrv
$ TAGS=utils-autorestart xsrv deploy
# using ansible command-line tools
$ ansible-playbook playbook.yml --tags=utils-autorestart
```

### Integration with other roles/manual configuration

To install custom `httpcheck`/`x509check`/`portcheck`/`processes` module/alarm, create relevant files in `/etc/netadata/{go,python,health}.d/$module_name.conf.d/` and notify the `assemble netadata configuration` [handler](https://gitlab.com/nodiscc/xsrv/-/blob/master/roles/monitoring/handlers/main.yml) (`$module_name.conf` will be assembled from configuration fragments).


## Tags

<!--BEGIN TAGS LIST-->
```
netdata - setup netdata monitoring system
netdata-config - copy netdata configuration files
netdata-modules - setup custom netdata modules
netdata-needrestart - setup netdata needrestart module
netdata-logcount - setup netdata logcount module
netdata-debsecan - setup netdata debsecan module
utils-autorestart - (manual) reboot hosts if a Linux kernel upgrade is pending
```
<!--END TAGS LIST-->


## License

[GNU GPLv3](../../LICENSE)


## References

- https://stdout.root.sx/links/?searchtags=monitoring
