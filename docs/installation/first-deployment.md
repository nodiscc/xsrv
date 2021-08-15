# First deployment

`xsrv` will help you create a new _playbook_ based on the [template](https://gitlab.com/nodiscc/xsrv/-/tree/master/playbooks/xsrv/).

```bash
# generate a SSH key pair if you don't have one
ssh-keygen -b 4096
# authorize your SSH key on the remote user account (replace 'deploy' with the user you created during server preparation)
ssh-copy-id deploy@my.CHANGEME.org
# create a new playbook, enable desired roles (uncomment them), set required variables
xsrv init-playbook
```

- You will be asked for the _hostname_ of the server to configure
- You will be asked for a list of [roles](https://xsrv.readthedocs.io/en/latest/#roles) that should be deployed to the host ([playbook file](https://gitlab.com/nodiscc/xsrv/-/blob/master/playbooks/xsrv/playbook.yml))
- You will be asked for required [configuration variables](../configuration-variables.md) such as domain names, usernames/passwords ([host_vars file](https://gitlab.com/nodiscc/xsrv/-/blob/master/playbooks/xsrv/host_vars/my.example.org/my.example.org.yml) and [encrypted host_vars/vault file](https://gitlab.com/nodiscc/xsrv/-/blob/master/playbooks/xsrv/host_vars/my.example.org/my.example.org.vault.yml))
- These files can be accessed later using [`xsrv edit-playbook`, `xsrv edit-host`, `xsrv edit-vault`...](usage.md)
- Apply changes to the host:

```bash
xsrv deploy
```

- Wait for the initial setup to complete
- **Your first server is ready to use!**


[![](https://asciinema.org/a/kGt6mVg3GxFlDPXwagiwg4Laq.svg)](https://asciinema.org/a/kGt6mVg3GxFlDPXwagiwg4Laq)


## Accessing services

- Access your services from their domain names or URLs configured in `host_vars`
- The [homepage](https://gitlab.com/nodiscc/xsrv/-/tree/master/roles/homepage) role provides quick access to your services and useful information at `https://{{ homepage_fqdn }}`
- Check [usage](../usage.md) or [roles](https://xsrv.readthedocs.io/en/latest/#roles) documentation for more information
<!-- TODO - Run `xsrv info` to display host information in your terminal, and update the summary in [README.md](https://gitlab.com/nodiscc/xsrv/-/blob/master/playbooks/xsrv/README.md) in your playbook directory -->

