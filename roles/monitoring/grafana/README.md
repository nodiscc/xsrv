# toolbox.grafana

This role will install [Grafana](https://en.wikipedia.org/wiki/Grafana), an open-source analytics and interactive visualization web application.

VictoriaMetrics will be added as a data source for Grafana if the [nodiscc.xsrv.victoriametrics](../victoriametrics/) role is deployed on the same host. Authentication credentials for the VictoriaMetrics datasource are configured automatically via `grafana_victoriametrics_auth_password`.

[![](https://grafana.com/media/grafana/images/grafana-dashboard-english.png)](https://grafana.com/media/grafana/images/grafana-dashboard-english.png)


## Requirements/dependencies/example playbook

See [meta/main.yml](meta/main.yml)

```yaml
- hosts: my.CHANGEME.org
  roles:
    - nodiscc.xsrv.common # (optional) base server setup, hardening, firewall, bruteforce prevention
    - # nodiscc.xsrv.monitoring # (alternative) full monitoring stack including prometheus exporters, victoriametrics and grafana
    - nodiscc.xsrv.monitoring.base # (required in the standard configuration) basic prometheus metrics exporters and exporter-exporter
    - nodiscc.xsrv.example # (example) any role that exposes metrics through prometheus exporter-exporter
    - nodiscc.xsrv.apache # (required in the standard configuration) webserver/reverse proxy, SSL certificates
    - nodiscc.xsrv.monitoring.victoriametrics # (required in the standard configuration) time-series database and scraper for prometheus metrics
    - nodiscc.toolbox.grafana

# required variables:
# host_vars/my.CHANGEME.org/my.CHANGEME.org.yml
grafana_fqdn: "grafana.CHANGEME.org"
# ansible-vault edit host_vars/my.CHANGEME.org/my.CHANGEME.org.vault.yml
grafana_admin_username: "CHANGEME"
grafana_admin_password: "CHANGEME20"
grafana_admin_email: "CHANGEME@CHANGEME.org"
```

See [defaults/main.yml](defaults/main.yml) for all configuration variables.


## Usage

Access the Grafana instance from a web browser at `https://{{ grafana_fqdn }}`.

## Tags

<!--BEGIN TAGS LIST-->
```
grafana - setup grafana analytics and interactive visualization web application
grafana-config - update grafana configuration
```
<!--END TAGS LIST-->


## License

[GNU GPLv3](../../LICENSE)

## References/Documentation

- https://stdout.root.sx/links/?searchterm=grafana
- https://stdout.root.sx/links/?searchtags=monitoring
