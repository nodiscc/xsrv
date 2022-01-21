# Controller preparation

A **controller** machine will be used for deployment and remote administration. The controller stores a [text description of your setup](usage.md), and deploys it to your [hosts](server-preparation.md) remotely over SSH.

Any PC, dedicated server, VM or container where a SSH client, Python and Bash are available can be used as a controller. 

## Linux

```bash
# install requirements (example for debian-based systems)
sudo apt update && sudo apt install git bash python3-venv python3-pip python3-cryptography ssh pwgen wget
# download the main script
wget https://gitlab.com/nodiscc/xsrv/-/raw/release/xsrv
# (optional) copy the script to your $PATH
sudo cp xsrv /usr/local/bin/
```

<!--
## Mac OSX
TODO
## Windows
TODO-->

------------------------

You can then [setup your first project](first-project.md).
