# xsrv.monitoring_rsyslog

This role will setup [rsyslog](https://en.wikipedia.org/wiki/Rsyslog):
- aggregation of common log files (APT/unattended-upgrades/fail2ban) to a single `/var/log/syslog` file
- retention policy (`logrotate`)
- `systemd-journald` storage settings
- (optional) log filtering/discarding of unwanted messages
- (optional) log forwarding over TCP/SSL/TLS

[![](https://screenshots.debian.net/shrine/screenshot/10371/simage/large-24897d7d91b1b5fc33cca4accd70781b.png)](https://screenshots.debian.net/package/lnav)


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

If `rsyslog_enable_receive: yes`, the host must be reachable by syslog clients on port `514/tcp`.
If `rsyslog_enable_receive: yes`, the host must be deployed **before** syslog clients in the playbook execution order (the syslog server's CA certificate must already exist in order to sign client certificates)

## Tags

<!--BEGIN TAGS LIST-->
```
rsyslog - setup system log processing
```
<!--END TAGS LIST-->


## License

[GNU GPLv3](../../LICENSE)


## References

- https://stdout.root.sx/links/?searchtags=monitoring
- https://stdout.root.sx/links/?searchtags=logs
