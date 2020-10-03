# xsrv.docker

An Ansible Role that installs [Docker](https://www.docker.com) on Linux.

## Requirements/Dependencies

- Ansible 2.9+
- [`common`](../common) role.

## Role Variables

See [`defaults/main.yml`](defaults/main.yml)


## Example Playbook

```yaml
- hosts: my.example.org
  roles:
    - common
    - monitoring
    - docker
```

## License

[MIT](https://opensource.org/licenses/MIT)


## References

- https://github.com/geerlingguy/ansible-role-docker
- https://stdout.root.sx/links/?searchtags=doc+docker
