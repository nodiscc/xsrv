# xsrv.monitoring

This role will install a monitoring, alerting and logging system on a Linux machine. It is an alias for the following roles:
 - [nodiscc.xsrv.monitoring_rsyslog](../monitoring_rsyslog)
 - [nodiscc.xsrv.monitoring_netdata](../monitoring_netdata)
 - [nodiscc.xsrv.monitoring_utils](../monitoring_utils)

## Requirements/dependencies/example playbook

See [meta/main.yml](meta/main.yml)

```yaml
- hosts: my.CHANGEME.org
  roles:
    - nodiscc.xsrv.common # (optional) basic setup, hardening, firewall
    - nodiscc.xsrv.monitoring
    # or enable only specific roles:
    # - nodiscc.xsrv.monitoring_rsyslog
    # - nodiscc.xsrv.monitoring_netdata
    # - nodiscc.xsrv.monitoring_lynis
```


## Tags

<!--BEGIN TAGS LIST-->
```
monitoring - setup monitoring/alerting/logging system/utilities
```
<!--END TAGS LIST-->


## License

[GNU GPLv3](../../LICENSE)


## References

- https://stdout.root.sx/links/?searchtags=monitoring
