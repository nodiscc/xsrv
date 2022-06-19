# xsrv.EXAMPLE

This role will install [EXAMPLE](https://example.org/), the description of EXAMPLE goes here.
- Feature 1
- Feature 2
- Feature 3

[![](https://example.org/screenshot1_thumb.png)](https://example.org/screenshot1.png)
[![](https://example.org/screenshot2_thumb.png)](https://example.org/screenshot2.png)


## Requirements/dependencies/example playbook

See [meta/main.yml](meta/main.yml)

```yaml
# playbook.yml
- hosts: my.CHANGEME.org
  roles:
    - nodiscc.xsrv.role1 # (optional) purpose of role1 related to EXAMPLE role
    - nodiscc.xsrv.role2 # (optional) purpose of role2 related to EXAMPLE role
    - nodiscc.xsrv.role3 # purpose of role3 related to EXAMPLE role
    - nodiscc.xsrv.EXAMPLE

# required variables
# host_vars/my.CHANGEME.org/my.CHANGEME.org.yml
some_required_variable: "CHANGEME"

# ansible-vault edit host_vars/my.CHANGEME.org/my.CHANGEME.org.vault.yml
some_required_sensitive_variable: "CHANGEME"
```

See [defaults/main.yml](defaults/main.yml) for all configuration variables.


## Usage

Notes about using the deployed service.


### Backups

Notes about backing up data generated/used by the service. See the included [rsnapshot configuration](templates/etc/rsnapshot.d_EXAMPLE.conf.j2) for information about directories to backup/restore.


## License

[GNU GPLv3](../../LICENSE)


## References

- https://stdout.root.sx/links/?searchterm=EXAMPLE

## New role checklist

- [ ] Add the role to the [test playbook](https://gitlab.com/nodiscc/xsrv/-/blob/master/tests/playbook.yml)
- [ ] `make doc`
- [ ] Update `CHANGELOG.md`
