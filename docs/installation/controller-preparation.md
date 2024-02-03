# Controller preparation

The controller machine will be used for deployment and remote administration. The controller stores all procedures (`playbook`/`roles`) and configuration values (`vars`) for your specific setup, and deploys it to remote [hosts](server-preparation.md) over SSH.

Any PC, dedicated server, VM or container where a SSH client, Python >=3.9 and Bash are available can be used as a controller.

Roles can be used from the `xsrv` command-line tool, or as a [collection](usage.md) in your own ansible playbooks.

## Linux

```bash
# install requirements (example for debian-based systems)
sudo apt update && sudo apt install git bash python3-venv python3-pip python3-cryptography openssh-client pwgen wget
# download the main script and (optional) copy it to your $PATH
wget https://gitlab.com/nodiscc/xsrv/-/raw/release/xsrv
chmod a+x xsrv
sudo cp xsrv /usr/local/bin/
# (optional) download and install the tab/auto-completion script
wget https://gitlab.com/nodiscc/xsrv/-/raw/release/xsrv-completion.sh
chmod a+x xsrv-completion.sh
sudo cp xsrv-completion.sh /etc/bash_completion.d/
# generate a SSH key pair if not already done
ssh-keygen -b 4096
# authorize your SSH key on the remote user account
# replace 'deploy' with the user created during server preparation
ssh-copy-id deploy@my.CHANGEME.org
# create a new project
xsrv init-project
```

<!--
## Mac OSX
TODO
## Windows
TODO-->

------------------------

You can then [setup your first project](first-project.md).
