# xsrv.stirlingpdf

This role will install [Stirling-PDF](https://github.com/Stirling-Tools/Stirling-PDF), a tool to carry out various operations on PDF files, including splitting, merging, converting, reorganizing, adding images, rotating, compressing, and more.

Stirling PDF will be deployed as a rootless [podman](../podman) container managed by a systemd service.

![](https://github.com/Stirling-Tools/Stirling-PDF/raw/main/images/stirling-home.jpg)

## Requirements/dependencies/example playbook

See [meta/main.yml](meta/main.yml)

```yaml
# playbook.yml
- hosts: my.CHANGEME.org
  roles:
    - nodiscc.xsrv.common # (optional) base server setup, hardening, firewall, bruteforce prevention
    - nodiscc.xsrv.backup # (optional) automatic backups
    - nodiscc.xsrv.monitoring # (optional) apache monitoring
    - nodiscc.xsrv.apache # (required in the standard configuration) reverse proxy and SSL certificates
    - nodiscc.xsrv.podman # container engine
    - nodiscc.xsrv.stirlingpdf

# required variables:
stirlingpdf_fqdn: "pdf.CHANGEME.org"
```

See [defaults/main.yml](defaults/main.yml) for all configuration variables


## Usage


## Tags

<!--BEGIN TAGS LIST-->
```
stirlingpdf - setup Stirling PDF PDF manipulation tools
```
<!--END TAGS LIST-->

## License

[GNU GPLv3](../../LICENSE)
