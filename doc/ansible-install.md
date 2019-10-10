## Ansible installation

### In a virtualenv (recommended)

This method doesn't require root access and doesn't interact with other python libraries installed on the system. It provides the best isolation and flexibility. The only downside is that you have to activate the virtualenv before using the programs inside it.

```bash
# install git and pip (example on Debian-based systems)
sudo apt install git python3-pip
# create the virtualenv
python3 -m venv ~/.ansible-venv
# activate the virtualenv - this must be done in every terminal session where you want to use ansible:
source ~/.ansible-venv/bin/activate
# install ansible
pip3 install ansible==2.8.0
```

## Install for the current user

This method provides isolation from your system python libraries but is not as easy to manage as a single virtualenv directory. You will need to add  `~/.local/bin/` to your `$PATH` (for example in `~/.bashrc`), or call ansible by its full path (`~/.local/bin/ansible`) every time.

```bash
pip3 install --user ansible==2.8.0
```

### Install system-wide from your package manager

This will install ansible from your Linux distribution repositories. It is probably the easiest to manage, but your roles might need a more recent ansible version. Example on Debian-based systems:

```bash
sudo apt install ansible
```

Don't use `sudo pip3 install` as it will possibily overwrite or cause conflicts with your system-wide python packages.
