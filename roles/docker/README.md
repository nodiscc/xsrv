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
# remove the role from your playbook
xsrv edit-playbook
# remove all docker_* configuration variables from your hosts configuration
xsrv edit-host
```

```bash
sudo apt purge docker-ce docker-compose
sudo rm -rf /etc/apt/sources.list.d/docker.list /etc/docker /etc/cron.d/docker-system-prune-all /etc/ansible/facts.d/docker.fact /etc/netdata/health.d/dockerd.conf /etc/netdata/health.d/systemdunits.conf.d/docker.conf /var/lib/docker /root/.docker /run/docker
sudo groupdel docker
sudo ip link delete docker0
sudo ip link delete docker_gwbridge
sudo find /etc/netdata/health.d/systemdunits.conf.d/ -type f | sort | xargs sudo cat | sudo tee /etc/netdata/health.d/systemdunits.conf
sudo systemctl restart netdata
```


## Tags

<!--BEGIN TAGS LIST-->
```
docker - setup docker engine
```
<!--END TAGS LIST-->


## License

[MIT](https://opensource.org/licenses/MIT)


## References

- https://github.com/geerlingguy/ansible-role-docker
- https://stdout.root.sx/links/?searchtags=doc+docker
