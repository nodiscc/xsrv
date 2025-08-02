# toolbox.grafana

This role will install [Grafana](https://en.wikipedia.org/wiki/Grafana), an open-source analytics and interactive visualization web application.

[![](https://upload.wikimedia.org/wikipedia/commons/8/89/Grafana_dashboard.png)](https://upload.wikimedia.org/wikipedia/commons/8/89/Grafana_dashboard.png)


## Requirements/dependencies/example playbook

See [meta/main.yml](meta/main.yml)

```yaml
- hosts: my.CHANGEME.org
  roles:
    - nodiscc.xsrv.common # (optional) base server setup, hardening, firewall, bruteforce prevention
    - nodiscc.xsrv.monitoring # (optional) server monitoring, log aggregation
    - nodiscc.toolbox.prometheus # (optional) prometheus data source
    - nodiscc.xsrv.apache # (required in the standard configuration) webserver/reverse proxy, SSL certificates
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

By deploying the [nodiscc.toolbox.prometheus](../prometheus/) role alongside Grafana, you can add a Prometheus data source to your Grafana configuration and visualize Prometheus metrics in Grafana. Coupled with the [nodiscc.toolbox.netdata](https://gitlab.com/nodiscc/toolbox/-/tree/master/ARCHIVE/ANSIBLE-COLLECTION/roles/netdaya) role, this provides a very simple yet flexible and powerful visualization solution for metrics across your whole infrastructure.


### Backups


TODO


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
