# xsrv.monitoring_netdata

This role will install and configure [Netdata](https://my-netdata.io/), a real-time, efficient, distributed performance and health monitoring system, and optional netdata modules/graphs:
 - [needrestart](https://gitlab.com/nodiscc/netdata-needrestart)
 - [logcount](https://gitlab.com/nodiscc/netdata-logcount)
 - [debsecan](https://gitlab.com/nodiscc/netdata-debsecan)
 - [apt](https://gitlab.com/nodiscc/netdata-apt)

[![](https://gitlab.com/nodiscc/toolbox/-/raw/master/DOC/SCREENSHOTS/netdata-dashboard.png)](https://gitlab.com/nodiscc/toolbox/-/raw/master/DOC/SCREENSHOTS/netdata-dashboard.png)


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

- To reboot hosts that have a pending Linux kernel upgrade:

```bash
# using xsrv
$ TAGS=utils-autorestart xsrv deploy
# using ansible command-line tools
$ ansible-playbook playbook.yml --tags=utils-autorestart
```

- `debsecan` will send an email summary of possible security vulnerabilities in packages installed on the host to the system administrator, every time a new vulnerability is found or an existing one is fixed. For each reported CVE, you should try to determine if it is applicable to your specific configuration/threat model, and if necessary, whitelist it in `/var/lib/debsecan/whitelist`. A more thorough example of vulnerability analysis procedure can be found [here](https://old.reddit.com/r/debian/comments/10z4im0/security_updates_with_nodsa/j83hcst/). Below is an example whitelist file:

```
VERSION 0
CVE-2022-1897,
CVE-2022-3099,
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
netdata-apt - setup netdata apt module
utils-autorestart - (manual) reboot hosts if a Linux kernel upgrade is pending
utils-netdata-test-notifications - send test netdata notification
netdata-downtime - configure netdata downtime/silence schedules
```
<!--END TAGS LIST-->


## License

[GNU GPLv3](../../LICENSE)


## References

- https://stdout.root.sx/links/?searchtags=monitoring
