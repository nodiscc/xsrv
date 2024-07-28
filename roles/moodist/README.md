# xsrv.moodisc

This role will setup [Moodist](https://moodist.app/), an ambient sound mixer for focus and calm.

Moodist will be deployed as a rootless [podman](../podman) container managed by a systemd service.

![](https://gitlab.com/nodiscc/toolbox/-/raw/master/DOC/SCREENSHOTS/moodist.png)

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
    - nodiscc.xsrv.moodist

# required variables:
moodist_fqdn: "moodist.CHANGEME.org"
```

See [defaults/main.yml](defaults/main.yml) for all configuration variables


## Usage


## Tags

<!--BEGIN TAGS LIST-->
```
moodist - setup Moodist ambient sound mixer
```
<!--END TAGS LIST-->

## License

[GNU GPLv3](../../LICENSE)
