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
USAGE: xsrv COMMAND [playbook] [host]
init-playbook   initialize a new playbook
init-host       add a new host to an existing playbook
deploy          deploy a playbook
check           simulate deployment, report what would be changed
edit-playbook   edit a playbook
edit-inventory  edit inventory file for a playbook
edit-host       edit a host vars file
edit-vault      edit a host vault file
shell           open an interactive shell on a host
logs            view system log on a host
help            show this message
fetch-backups   fetch backups from a host to the playbook backups directory
upgrade         ugrade xsrv script and roles to latest versions
show-hosts      list hosts in a playbook/inventory
show-defaults   show all variables and their default values (accepts a role as argument)

The following environment variables are supported:
TAGS               comma-separated list of ansible tags (eg. TAGS=common,monitoring xsrv deploy)
BRANCH             advanced (upgrade only): git branch to checkout/pull before upgrade
XSRV_TEMPLATES_DIR advanced: path to role/playbook templates (default /opt/xsrv)
SKIP_VENV          advanced: skip creation of virtualenv/dependencies installation (yes/no, default no)
EDITOR             text editor to use (default nano)
PAGER              pager to use (default less)
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
