# xsrv.searxng

This role will setup [SearXNG](https://docs.searxng.org/), a free internet metasearch engine which aggregates results from more than 70 search services.

searxng will be deployed as a rootless [podman](../podman) container managed by a systemd service.

![](https://upload.wikimedia.org/wikipedia/commons/e/eb/SearXNG_Homepage_Screenshot.png)

## Requirements/dependencies/example playbook

See [meta/main.yml](meta/main.yml)

```yaml
# playbook.yml
- hosts: my.CHANGEME.org
  roles:
    - nodiscc.xsrv.common # (optional) base server setup, hardening, firewall, bruteforce prevention
    - nodiscc.xsrv.monitoring # (optional) apache monitoring
    - nodiscc.xsrv.apache # (required in the standard configuration) reverse proxy and SSL certificates
    - nodiscc.xsrv.podman # container engine
    - nodiscc.xsrv.searxng

# required variables:
# host_vars/my.CHANGEME.org/my.CHANGEME.org.yml
searxng_fqdn: "search.CHANGEME.org"
# ansible-vault edit host_vars/my.CHANGEME.org/my.CHANGEME.org.vault.yml
searxng_secret: "CHANGEME64"
```

See [defaults/main.yml](defaults/main.yml) for all configuration variables


## Usage

### Troubleshooting

Due to the "rolling release" development model of SearXNG, tha `latest` OCI image is pulled every time the role is deployed, so deployments may not yield the same results (idempotence) depending on the time at which they were ran.


## Tags

<!--BEGIN TAGS LIST-->
```
searxng - setup SearXNG metasearch engine
```
<!--END TAGS LIST-->

## License

[GNU GPLv3](../../LICENSE)


## New role checklist

- [ ] `make doc_md`
- [ ] Update `CHANGELOG.md`
