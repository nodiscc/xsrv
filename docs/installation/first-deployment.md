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

Setup roles and required configuration before initial deployment:

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

```bash
TODO ASCIINEMA
```

