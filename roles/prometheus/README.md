# toolbox.prometheus

This role will install [Prometheus](https://en.wikipedia.org/wiki/Prometheus_(software)), an event monitoring and alerting application and time-series database.

[![](https://upload.wikimedia.org/wikipedia/commons/thumb/3/38/Prometheus_software_logo.svg/120px-Prometheus_software_logo.svg.png)](https://upload.wikimedia.org/wikipedia/commons/thumb/3/38/Prometheus_software_logo.svg/120px-Prometheus_software_logo.svg.png)


## Requirements/dependencies/example playbook

See [meta/main.yml](meta/main.yml)

```yaml
- hosts: my.CHANGEME.org
  roles:
    - nodiscc.xsrv.common # (optional) base server setup, hardening, firewall, bruteforce prevention
    - nodiscc.xsrv.monitoring # (optional) server monitoring, log aggregation
    - nodiscc.toolbox.prometheus
    - nodiscc.xsrv.apache # (optional) webserver/reverse proxy, SSL certificates for grafana
    - nodiscc.toolbox.grafana # (optional) visualization tools and dashboards for prometheus data


# required variables:
# none
```

See [defaults/main.yml](defaults/main.yml) for all configuration variables.


## Usage

When `prometheus_scrape_local_netdata: yes` (the default), Prometheus will scape data from a netdata instance installed on the same host (for example using the [nodiscc.toolbox.netdata](https://gitlab.com/nodiscc/toolbox/-/tree/master/ARCHIVE/ANSIBLE-COLLECTION/roles/netdata) role). Metrics from all netdata instances configured to stream data to this netdata instance, will be made available in Prometheus. Coupled with the [nodiscc.toolbox.grafana](../grafana) role, this provides a very simple yet flexible and powerful visualization solution for metrics across your whole infrastructure.


### Backups

TODO


## Tags

<!--BEGIN TAGS LIST-->
```
prometheus - setup prometheus monitoring service and time-series database
```
<!--END TAGS LIST-->


## License

[GNU GPLv3](../../LICENSE)

## References/Documentation

- https://stdout.root.sx/links/?searchterm=prometheus
- https://stdout.root.sx/links/?searchtags=monitoring
