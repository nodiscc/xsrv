# Controller preparation

A **controller** machine will be used for deployment and remote administration.

The controller can be any laptop/desktop PC, dedicated server, VM or container where a SSH client, python and bash are available. It will connect to your [hosts](server-preparation.md) using SSH and perform configuration tasks remotely. On the controller:

```bash
# install requirements (example for debian-based systems)
sudo apt update && sudo apt install git bash python3-venv python3-pip ssh pwgen
# on macOS: sudo easy_install pip; sudo pip install ansible
# clone the repository
git clone https://gitlab.com/nodiscc/xsrv
# (optional) install the command line tool to your $PATH
sudo cp xsrv/xsrv /usr/local/bin/
```

It is also possible (but not recommended) to use the server itself as a controller. It will then configure itself without need for a SSH connection/separate administration machine. Clone and install `xsrv` directly on the host, and set `connection: local` in the playbook for this host (on the same level as `roles:`) during playbook initialization, or with `xsrv edit-playbook`.

Once the controller has been set up, [deploy](first-deployment.md) roles and configuration to your hosts.
