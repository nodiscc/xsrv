# xsrv.victoriametrics

This role will install [VictoriaMetrics](https://docs.victoriametrics.com/), an event monitoring and alerting application and time-series database. VictoriaMetrics is a drop-in replacement for [Prometheus](https://prometheus.io/).

VictoriaMetrics receives metrics via remote write from [vmagent](https://docs.victoriametrics.com/vmagent/) instances deployed by the [monitoring.exporters](../exporters/) role on each host.

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

Hosts running `vmagent` must be able to reach VictoriaMetrics on port 8428/tcp. Firewall zones allowing remote write are configured via `victoriametrics_firewalld_zones`.


## Usage

Metrics sent by the [monitoring.exporters](../exporters) role to Victoriametrics, will be automatically displayed in grafana dashboards if the [monitoring.grafana](../grafana) role is deployed to the same host as victoriametrics.

Alerts will be sent by mail to the recipient configurezd in `victoriametrics_alertmanager_email_to` (this requires a working SMTP relay and `victoriametrics_alertmanager_smtp_auth_username:/password` credentials)

### List currently active alerts

* access the Grafana alerts dashboard
* You may also SSH to the host running victoriametrics and run:

```bash
# display active alerts in json format
curl http://127.0.0.1:8880/api/v1/alerts
```

### Delete metrics for a specific host

SSH to the host running victoriametrics and run:

```bash
password=$(sudo cat /etc/victoriametrics/exporters_auth_password)
curl -v -u "vmagent:$password" --insecure -X POST https://127.0.0.1:8428/api/v1/admin/tsdb/delete_series -d 'match[]={instance="host.example.org"}'
```


### Backups

## Tags

<!--BEGIN TAGS LIST-->
```
```
<!--END TAGS LIST-->


## License

[GNU GPLv3](../../LICENSE)

## References/Documentation

- https://github.com/samber/awesome-prometheus-alerts
- https://utcc.utoronto.ca/~cks/space/blog/sysadmin/PrometheusGrafanaSetup-2019
- https://samber.github.io/awesome-prometheus-alerts/rules.html
- https://docs.victoriametrics.com/victoriametrics/single-server-victoriametrics/
- https://docs.victoriametrics.com/vmalert.html
- https://docs.victoriametrics.com/anomaly-detection/guides/guide-vmanomaly-vmalert/
- https://docs.victoriametrics.com/victoriametrics/vmagent/
