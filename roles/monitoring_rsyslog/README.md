# xsrv.monitoring_rsyslog

This rolle will setup [rsyslog](https://en.wikipedia.org/wiki/Rsyslog) basic log aggregation, logrotate retention, and log forwarding over TCP/SSL/TLS, and [lnav](http://lnav.org/) log file viewer.
 
[![](https://screenshots.debian.net/screenshots/000/010/371/thumb.png)](https://screenshots.debian.net/package/lnav)

## Requirements/dependencies/example playbook

See [meta/main.yml](meta/main.yml)

```yaml
- hosts: my.CHANGEME.org
  roles:
    - nodiscc.xsrv.common # (optional) basic setup, hardening, firewall
    - nodiscc.xsrv.monitoring_rsyslog
    # - nodiscc.xsrv.monitoring # (optional) full monitoring suite including monitoring_rsyslog
```

See [defaults/main.yml](defaults/main.yml) for all configuration variables

## License

[GNU GPLv3](../../LICENSE)


## References

- https://stdout.root.sx/links/?searchtags=monitoring
- https://stdout.root.sx/links/?searchtags=logs
