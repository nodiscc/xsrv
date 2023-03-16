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

## Tags

<!--BEGIN TAGS LIST-->
```
```
<!--END TAGS LIST-->


## License

[GNU GPLv3](../../LICENSE)


## References

- https://stdout.root.sx/links/?searchterm=EXAMPLE

## New role checklist

- [ ] Add the role to the [test playbook](https://gitlab.com/nodiscc/xsrv/-/blob/master/tests/playbooks/xsrv-test/playbook.yml)
- [ ] Add the role to the [default xsrv playbook](https://gitlab.com/nodiscc/xsrv/-/blob/master/playbooks/xsrv/playbook.yml)
- [ ] Add integration with the [homepage](https://gitlab.com/nodiscc/xsrv/-/tree/master/roles/homepage) role if needed
- [ ] Add integration with the [readme_gen](https://gitlab.com/nodiscc/xsrv/-/tree/master/roles/readme_gen) role if needed
- [ ] Add required role variables to the default [host_vars](https://gitlab.com/nodiscc/xsrv/-/blob/master/playbooks/xsrv/host_vars/my.example.org/my.example.org.yml) file and [vaulted host_vars file](https://gitlab.com/nodiscc/xsrv/-/blob/master/playbooks/xsrv/host_vars/my.example.org/my.example.org.vault.yml)
- [ ] Add screenshots (57px high) to main [README.md](https://gitlab.com/nodiscc/xsrv/-/blob/master/README.md) if needed
- [ ] Add DNS records to the [server preparation documentation](https://gitlab.com/nodiscc/xsrv/-/blob/master/docs/installation/server-preparation.md) if needed
- [ ] `make doc_md`
- [ ] Update `CHANGELOG.md`
