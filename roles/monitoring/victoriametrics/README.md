# xsrv.victoriametrics

This role will install [VictoriaMetrics](https://docs.victoriametrics.com/), an event monitoring and alerting application and time-series database. VictoriaMetrics is a drop-in replacement for [Prometheus](https://prometheus.io/).

VictoriaMetrics will scrape metrics from hosts where the [monitoring.exporters](../exporters/) role is deployed.

VictoriaMetrics metrics can be visualized through Grafana, the simplest way to achieve this is to deploy the [grafana](../grafana/) role on the same host as VictoriaMetrics.


## Requirements/dependencies/example playbook

See [meta/main.yml](meta/main.yml)

```yaml
- hosts: my.CHANGEME.org
  roles:
    - nodiscc.xsrv.common # (optional) base server setup, hardening, firewall, bruteforce prevention
    - nodiscc.xsrv.monitoring.utils # (optional) basic monitoring utilities
    - nodiscc.xsrv.monitoring.exporters # (required in the standard configuration) monitoring agents/metric exporters
    - nodiscc.xsrv.monitoring.victoriametrics
    - nodiscc.xsrv.apache # (optional) webserver/reverse proxy, SSL certificates for grafana
    - nodiscc.toolbox.grafana # (optional) visualization tools and dashboards for prometheus data

# required variables:
# xsrv edit-host default my.example.org
victoriametrics_alertmanager_smtp_host: CHANGEME
victoriametrics_alertmanager_smtp_port: CHANGEME
victoriametrics_alertmanager_smtp_from: CHANGEME
victoriametrics_alertmanager_email_to: CHANGEME@CHANGEME.org

# xsrv edit-vault default my.example.org
victoriametrics_alertmanager_smtp_auth_username: CHANGEME
victoriametrics_alertmanager_smtp_auth_password: CHANGEME
```

See [defaults/main.yml](defaults/main.yml) for all configuration variables.

VictoriaMetrics must be able to reach `exporter-exporter` on other hosts over port 9999/tcp.


## Usage

### Backups

## Tags

<!--BEGIN TAGS LIST-->
```
```
<!--END TAGS LIST-->


## License

[GNU GPLv3](../../LICENSE)

## References/Documentation

- https://stdout.root.sx/links/?searchterm=prometheus
- https://stdout.root.sx/links/?searchterm=victoriametrics
- https://stdout.root.sx/links/?searchtags=monitoring
