# First deployment

The [default playbook](https://gitlab.com/nodiscc/xsrv/-/blob/master/playbooks/xsrv/playbook.yml) installs/manages a basic set of roles on a single server.

```bash
# authorize your SSH key on target server (host)
ssh-copy-id myusername@my.CHANGEME.org

# create a base directory for your playbooks/environments
mkdir ~/playbooks/

# create a new playbook named 'default'
xsrv init-playbook
```

Setup roles and required configuration before initial deployment. By default all roles except very basic components are disabled, uncomment (remove leading `#`) any role to enable it:

```bash
# enable desired roles by uncommenting them
xsrv edit-playbook

# setup passwords and secret values (replace any values labeled CHANGEME)
xsrv edit-vault

# edit configuration variables (replace any values labeled CHANGEME)
xsrv edit-host
```

Deploy changes to the host:

```bash
xsrv deploy
```

[![](https://asciinema.org/a/kGt6mVg3GxFlDPXwagiwg4Laq.svg)](https://asciinema.org/a/kGt6mVg3GxFlDPXwagiwg4Laq)

**Your server is ready to use!**

Access your services from their domain names or URIs, specified in configuration variables. A summary of all access points and client software can be found at `homepage_fqdn` if the `homepage` role is enabled.
