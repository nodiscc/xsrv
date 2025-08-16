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

## New role checklist

- [ ] Add the role to the [test playbook](https://gitlab.com/nodiscc/xsrv/-/blob/master/tests/playbooks/xsrv-test/playbook.yml) and its [host_vars](https://gitlab.com/nodiscc/xsrv/-/tree/master/tests/playbooks/xsrv-test/host_vars/my.example.test)
- [ ] Add the role to the [default xsrv playbook](https://gitlab.com/nodiscc/xsrv/-/blob/master/playbooks/xsrv/playbook.yml)
- [ ] Add integration with the [homepage](https://gitlab.com/nodiscc/xsrv/-/tree/master/roles/homepage) role if needed
- [ ] Add integration with the [readme_gen](https://gitlab.com/nodiscc/xsrv/-/tree/master/roles/readme_gen) role if needed
- [ ] Add required role variables to the default [host_vars](https://gitlab.com/nodiscc/xsrv/-/blob/master/playbooks/xsrv/host_vars/my.example.org/my.example.org.yml) file and [vaulted host_vars file](https://gitlab.com/nodiscc/xsrv/-/blob/master/playbooks/xsrv/host_vars/my.example.org/my.example.org.vault.yml)
- [ ] Add screenshots (57px high) to main [README.md](https://gitlab.com/nodiscc/xsrv/-/blob/master/README.md) if needed
- [ ] Add DNS records to the [server preparation documentation](https://gitlab.com/nodiscc/xsrv/-/blob/master/docs/installation/server-preparation.md) if needed
- [ ] `make doc_md`
- [ ] Update `CHANGELOG.md`
