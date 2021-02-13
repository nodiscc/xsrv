# Usage

`xsrv` is a wrapper around the [ansible](https://en.wikipedia.org/wiki/Ansible_%28software%29) suite of tools. Configuration settings are stored in the `~/playbooks/` directory on the [controller](installation/controller-preparation.md) in simple [YAML](https://en.wikipedia.org/wiki/YAML) files. To change server ([host](installation/server-preparation.md)) configuration and roles, you must first edit the YAML configuration, then apply changes to the host using the `deploy` command.

## Changing configuration

- `xsrv edit-playbook`: edit the list of enabled roles (`playbook`)
- `xsrv edit-host`: edit configuration settings for the host and its roles (`host_vars`)
- `xsrv show-defaults`: show all available configuration variables, and their default values (by default, only basic settings are set in `host_vars` to keep the file manageable). To change one of the defaults, simply copy it to your `host_vars` file and edit its value there.
- `xsrv edit-vault`: edit secret/encrypted configuration variables. To prevent storing sensitive/secret values such as passwords in plain text, this file is encrypted with [ansible-vault](https://docs.ansible.com/ansible/latest/cli/ansible-vault.html), and decrypted on the fly during deployment. The decryption password for the vault must be present in `.ansible-vault-password`

All commands support and additional playbook/host name parameter if you have multiple playbook/hosts. See below for complete usage examples.

**After any changes to the playbook, inventory or configuration variables**, apply your changes:

```bash
xsrv deploy
```

## Command-line usage

Full list of commands:

```bash
  ╻ ╻┏━┓┏━┓╻ ╻
░░╺╋╸┗━┓┣┳┛┃┏┛
  ╹ ╹┗━┛╹┗╸┗┛ vX.Y.Z

USAGE: xsrv COMMAND [playbook] [host]

# PLAYBOOK-LEVEL COMMANDS
init-playbook [playbook]         initialize a new playbook
edit-playbook [playbook]         edit/show playbook (list of roles)
edit-inventory [playbook]        edit/show inventory file (list of hosts)

# HOST-LEVEL COMMANDS
init-host [playbook] [host]      add a new host to an existing playbook
check [playbook] [host]          simulate deployment, report what would be changed
deploy [playbook] [host]         deploy a playbook (apply configuration/roles)
edit-host [playbook] [host]      edit host configuration (host_vars)
edit-vault [playbook] [host]     edit encrypted (vault) host configuration
fetch-backups [playbook] [host]  fetch backups from a host to the local backups/ directory
upgrade [playbook] [host]        upgrade roles to latest version
shell [playbook] [host]          open an interactive shell on a host
logs [playbook] [host]           view system log on a host
show-defaults [role]             show all variables and their default values
help                             show this message

# ENVIRONMENT VARIABLES (usage: VARIABLE=VALUE xsrv COMMAND)
TAGS               comma-separated list of ansible tags (eg. TAGS=common,monitoring xsrv deploy)
SKIP_VENV          advanced: skip installation of pip dependencies (yes/no, default: no)
EDITOR             text editor to use (default: nano)
PAGER              pager to use (default: less)


```

Examples:

```bash
xsrv deploy default # deploy all hosts in the 'default' playbook
xsrv deploy # deploy all hosts in the default playbook (default is assumed when no playbook name is specified)
xsrv init-playbook infra # initialize a new playbook/environment named 'infra'
xsrv deploy infra # deploy all hosts in the playbook named 'infra'
xsrv init-host infra ex2.CHANGEME.org # add a new host 'ex2.CHANGEME.org' to the playbook named 'infra'
xsrv edit-host infra ex2.CHANGEME.org # edit host variables for the host 'ex2.CHANGEME.org' in the playbook 'infra'
xsrv edit-vault infra ex2.CHANGEME.org # edit secret/vaulted variables for 'ex2.CHANGEME.org' in the playbook 'infra'
xsrv deploy infra ex1.CHANGEME.org,ex2.CHANGEME.org # deploy only the hosts ex1.CHANGEME.org and ex2.CHANGEME.org in the playbook 'infra'
TAGS=nextcloud,gitea deploy infra ex3.CHANGEME.org # run tasks tagged nextcloud or gitea on ex3.CHANGEME.org
BRANCH=1.0.0 xsrv upgrade infra # upgrade roles in the playbook 'infra' to version 1.0.0
```


## Storing sensitive configuration

Ensure no sensitive config values/secrets are stored as plaintext! Encrypt secret variables with ansible-vault:

```yaml
# xsrv edit-vault
xyz_password: "$3CR3T"
```
