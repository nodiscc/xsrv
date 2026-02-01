# xsrv.monitoring.exporters

This role will install and configure various basic monitoring agents (exporters) and expose their metrics through a single [exporter-exporter](https://packages.debian.org/bookworm/prometheus-exporter-exporter). Metrics are pushed to a central [VictoriaMetrics](../victoriametrics/) instance via [vmagent](https://docs.victoriametrics.com/vmagent/) remote write. [Grafana](../grafana/) can be used to visualize metrics stored in VictoriaMetrics.


## Requirements/dependencies/example playbook

See [meta/main.yml](meta/main.yml)

```yaml
- hosts: my.CHANGEME.org
  roles:
    - nodiscc.xsrv.common # (optional) basic setup, hardening, firewall
    - nodiscc.xsrv.monitoring.base # (optional) basic monitoring utilities
    - nodiscc.xsrv.monitoring.exporters
    - nodiscc.xsrv.monitoring.victoriametrics # (optional) monitoring metrics scraper and time-series database
    # - nodiscc.xsrv.apache # (example) any role that integrates a prometheus exporter
    # - nodiscc.xsrv.postgresql # (example) any role that integrates a prometheus exporter
    # - nodiscc.xsrv.monitoring.grafana # (optional) central scraper for prometheus metrics + visualization dashboards
```

```yaml
# xsrv edit-host default my.CHANGEME.org
monitoring_victoriametrics_url: "http://monitoring.CHANGEME.org:8428"

# xsrv edit-vault default my.CHANGEME.org
monitoring_exporters_auth_password: CHANGEME
```

See [defaults/main.yml](defaults/main.yml) for all configuration variables

This role should be deployed (in playbook order) before any other roles that integrate prometheus exporters. Their exporter will automatically register with exporter-exporter and expose its metrics through it.


## Usage

## Development

### Integration with other roles

Each role/component that needs to expose metrics through prometheus exporter-exporter needs to add an exporter-exporter configuration at under `/etc/prometheus/exporter-exporter/ROLENAME.yaml` and trigger the `restart prometheus-exporter-exporter` handler (this means that `nodiscc.xsrv.handlers` must be added to the role's `dependencies:` in `meta/main.yml`). See [roles/apache/tasks/exporters.yml](../../apache/tasks/exporters.yml) for a complete example.

## Tags

<!--BEGIN TAGS LIST-->
```
```
<!--END TAGS LIST-->


## License

[GNU GPLv3](../../LICENSE)


## References

- https://stdout.root.sx/links/?searchtags=monitoring
- https://stdout.root.sx/links/?searchterm=prometheus

