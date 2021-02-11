# Usage

## Changing configuration

At any point, to edit your configuration:
 - enable more roles with `xsrv edit-playbook`
 - show all available configuration variables, and their default value with `xsrv show-defaults`
 - edit configuration variables with `xsrv edit-host` (copy/paste any variable from defaults and change its value)
 - edit secret/encrypted configuration variables with `xsrv edit-vault`

All commands support and additional playbook/host name parameter if you have multiple playbook/hosts. See below for advanced ussage.

**After any changes to the playbook, inventory or configuration variables**, apply your changes:

```bash
xsrv deploy
```

## Command-line usage

Full list of commands:

```bash
  ╻ ╻┏━┓┏━┓╻ ╻
░░╺╋╸┗━┓┣┳┛┃┏┛
  ╹ ╹┗━┛╹┗╸┗┛ v0.24.0

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
# xsrv edit-host
xyz_password: {{ vault_xyz_password }}

# xsrv edit-vault
vault_xyz_password: "$3CR3T"

```
