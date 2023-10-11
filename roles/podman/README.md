# xsrv.podman

This role will install [podman](https://podman.io/), an OCI container engine and management tools. Podman can be used as a replacement for [Docker](../docker).

## Requirements/dependencies/example playbook

See [meta/main.yml](meta/main.yml)

```yaml
# playbook.yml
- hosts: my.CHANGEME.org
  roles:
    - nodiscc.xsrv.monitoring # (optional) server/container health and performance monitoring
    - nodiscc.xsrv.podman

# required variables
# none
```

See [defaults/main.yml](defaults/main.yml) for all configuration variables.

_Note: the `podman` role will ask you to first [uninstall the `docker` role](../docker/README.md#uninstallation) if it is deployed to the host._

## Usage

Podman can be used as a base component to deploy other/services and applications. The [`gitea_act_runner`](../gitea_act_runner/) role uses podman to manage containers in which workflows are run. You can also use it directly from the [podman command-line tools](https://manpages.debian.org/bookworm/podman/podman.1.en.html).


### Uninstallation

```bash
TAGS=utils-podman-uninstall xsrv deploy
```


### Backups

There is no data worth backing up. Applications/services/roles using podman to store data should manage their own backups.

## Tags

<!--BEGIN TAGS LIST-->
```
podman - setup podman container engine
utils-podman-uninstall - (manual) uninstall podman container engine
```
<!--END TAGS LIST-->


## License

[GNU GPLv3](../../LICENSE)


## References

- https://stdout.root.sx/links/?searchterm=podman
- https://stdout.root.sx/links/?searchterm=docker
- https://stdout.root.sx/links/?searchterm=container
- https://stdout.root.sx/links/?searchtags=virtualization

## New role checklist

- [ ] `make doc_md`
- [ ] Update `CHANGELOG.md`
