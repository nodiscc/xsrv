# xsrv.docker

An Ansible Role that installs [Docker](https://www.docker.com) on Linux.

## Requirements/Dependencies/example playbook

See [`meta/main.yml`](meta/main.yml)

```yaml
# playbook.yml
- hosts: my.CHANGEME.org
  roles:
    - nodiscc.xsrv.common # (optional) basic setup, hardening, firewall
    - nodiscc.xsrv.monitoring # (optional) system/container monitoring and health checks
    - nodiscc.xsrv.docker

# required variables:
# none
```

See [`defaults/main.yml`](defaults/main.yml) for all configuration variables.


## Usage

### Uninstallation

```bash
# run uninstallation tasks THIS WILL REMOVE ALL DOCKER DATA under /var/lib/docker
TAGS=utils-docker-uninstall xsrv deploy
# remove the role from your playbook
xsrv edit-playbook
# remove all docker_* configuration variables from your hosts configuration
xsrv edit-host
```

## Tags

<!--BEGIN TAGS LIST-->
```
docker - setup docker engine
utils-docker-uninstall - uninstall docker engine and remove all docker data
```
<!--END TAGS LIST-->


## License

[MIT](https://opensource.org/licenses/MIT)


## References

- https://github.com/geerlingguy/ansible-role-docker
- https://stdout.root.sx/links/?searchtags=doc+docker
