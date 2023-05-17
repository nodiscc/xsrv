# xsrv.gitea

This role will install the [Gitea](https://gitea.io/en-us/) self-hosted Git service.
Gitea is a lightweight code hosting solution written in Go. Gitea features include:

- [Git](https://en.wikipedia.org/wiki/Git) repository management (view, edit, log, blame, diff, merge, releases, branches...)
- Issue management/collaboration (labels, milestones, pull requests, assignees...)
- Dashboards, activity tracker
- Search in code, issues, repositories...
- Web based code editing tools, code highlighting, file upload
- Administration tools (user/instance management, keys/2FA authentication, permissions...)
- Organizations and teams
- Markdown rendering and code highlighting
- Wikis
- LDAP authentication

[![](https://gitlab.com/nodiscc/toolbox/-/raw/master/DOC/SCREENSHOTS/Rks90zV.png)](https://gitlab.com/nodiscc/toolbox/-/raw/master/DOC/SCREENSHOTS/2TGIshE.png)
[![](https://gitlab.com/nodiscc/toolbox/-/raw/master/DOC/SCREENSHOTS/cBktctp.png)](https://gitlab.com/nodiscc/toolbox/-/raw/master/DOC/SCREENSHOTS/EauaJxq.png)
[![](https://gitlab.com/nodiscc/toolbox/-/raw/master/DOC/SCREENSHOTS/gvcfs6G.png)](https://gitlab.com/nodiscc/toolbox/-/raw/master/DOC/SCREENSHOTS/DHku4ke.png)
[![](https://gitlab.com/nodiscc/toolbox/-/raw/master/DOC/SCREENSHOTS/4NhXqdG.png)](https://gitlab.com/nodiscc/toolbox/-/raw/master/DOC/SCREENSHOTS/d5glB4P.png)


## Requirements/dependencies/example playbook

See [meta/main.yml](meta/main.yml)

```yaml
- hosts: my.CHANGEME.org
  roles:
    - nodiscc.xsrv.common # (optional) base server setup, hardening, firewall, bruteforce prevention
    - nodiscc.xsrv.monitoring # (optional) server monitoring, log aggregation
    - nodiscc.xsrv.backup # (optional) automatic backups
    - nodiscc.xsrv.apache # (required in the standard configuration) webserver/reverse proxy, SSL certificates
    - nodiscc.xsrv.postgresql # (required in the standard configuration) database engine
    - nodiscc.xsrv.gitea

# required variables:
# host_vars/my.CHANGEME.org/my.CHANGEME.org.yml
gitea_fqdn: "git.CHANGEME.org"
# ansible-vault edit host_vars/my.CHANGEME.org/my.CHANGEME.org.vault.yml
gitea_admin_username: "CHANGEME"
gitea_admin_password: "CHANGEME"
gitea_admin_email: "CHANGEME@CHANGEME.org"
gitea_secret_key: "CHANGEME64"
gitea_internal_token: "CHANGEME160"
gitea_oauth2_jwt_secret: "CHANGEME43"
gitea_lfs_jwt_secret: "CHANGEME43"
```

See [defaults/main.yml](defaults/main.yml) for all configuration variables.


## Usage

### Clients

Gitea can be used from:
- a [web browser](https://www.mozilla.org/en-US/firefox/)
- [`git`](https://git-scm.com/) command line client
- any other [git GUI client](https://git-scm.com/downloads/guis)
- [GitNex](https://f-droid.org/en/packages/org.mian.gitnex/) Android application

### LDAP authentication

The example below is given for a LDAP server configured with the [openldap](../openldap) role.

- Access `Site administration > Authentication sources` (https://git.CHANGEME.org/admin/auths)
- Click `Add authentication source`
- Authentication type: `LDAP (via BindDN)`
- Authentication Name: `LDAP`
- Security protocol: `LDAPS` (or `Unencrypted` if your LDAP server does not support SSL/TLS)
- Host: `ldap.CHANGEME.org` (hostname of your LDAP server)
- Port: `636` (or `389` if your LDAP server does not support SSL/TLS)
- BindDN: `cn=bind,ou=system,dc=CHANGEME,dc=org`
- Bind password: the value of `{{ openldap_bind_password }}` on the LDAP server
- User search base: `ou=users,dc=CHANGEME,dc=org`
- User filter: `(&(objectClass=posixAccount)(uid=%s))`
- Admin filter: ``
- Restricted filter: ``
- Username attribute: `uid`
- First name attribute: `givenName`
- Surname attribute: `sn`
- Email attribute: `mail`
- Public SSH key attribute: `SshPublicKey`
- Avatar attribute: `jpegPhoto`
- [ ] Verify group membership in LDAP
- [ ] Use paged search
- [ ] Skip local 2FA
- [ ] Allow an empty search result to deactivate all users
- [ ] Fetch attributes in Bind DN context
- [x] Enable user synchronization
- [x] This authentication source is activated
- Click `Add authentication source`

If your LDAP server uses a self-signed SSL/TLS certificate, you must copy it to `/usr/local/share/ca-certificates/` and update the OS certificate store. Example:

```bash
rsync -avzP certificates/ldap.CHANGEME.org.openldap.crt my.example.org:
ssh my.EXAMPLE.org
sudo cp ldap.CHANGEME.org.openldap.crt /usr/local/share/ca-certificates/
sudo update-ca-certificates
```

### Repository mirroring

**Mirror from gitea to other hosts**

Got to your project `Settings > Repository` and configure the remote repository to mirror to.

<!--
<summary>DEPRECATED git hooks method</summary>
This method uses git hooks, which are disabled by default (`gitea_enable_git_hooks: no`). To mirror a gitea repository to github/gitlab [[1]](https://github.com/go-gitea/gitea/issues/3480), add a post-receive hook in the project settings:

```bash
#!/bin/bash
user="myusername"
token="qwertyuiopasdfghjklmzxcvbn"
host="github.com"
repo="myproject"
git push --mirror --quiet https://$user:$token@$host/$user/$repo.git &> /dev/null
echo "$host/$user/$repo updated"
```
-->

**Mirror from other hosts to gitea**

Gitea also allows setting up an automatic, local/self-hosted git mirror of your favorite projects from other forges:

- Click `+ > New migration`
- Enter the URL, the owner (you can create a dedicated organization for your mirrors), and the mirror name
- Enable `This repository will be a mirror`
- Fill in other details if needed
- `Migrate` repository

Repeat for every repository, you can then see your list list of mirrors at https://my.example.org/gitea/my-org

### API usage

Example [gitea-cli](https://github.com/bashup/gitea-cli) usage (command-line project creation):

```bash
#Edit ~/.config/gitearc:
export GITEA_USER=someone
export GITEA_API_TOKEN='aaabbbccdddefffggghhiijjs'
export GITEA_URL='https://example.com/gitea/'
# If your server certificate is self-signed:
curl() { command curl --insecure "$@"; }
# Add a function to get the list of issues for a repo
gitea.issues() {
  split_repo "$1"
  auth curl --silent "${GITEA_URL%/}/api/v1/repos/$REPLY/issues?limit=50"
}

```

```bash
# Create a project
gitea --description "My new project" --private new myusername/myproject

# Get the list of issues for a project
./gitea issues myusername/myproject | jq -r '.[] | "#\(.number) - \(.title)"'
```

[tea](https://gitea.com/gitea/tea) will be the officially supported command line Gitea API client.

### Troubleshooting

* Gitea refuses to start with the message `Failed to initialize issue indexer: leveldb: manifest corrupted` in `/var/lib/gitea/log/*log`: delete indexer directories `sudo rm -r /var/lib/gitea/data/indexers/* /var/lib/gitea/indexers/*` ([1](https://github.com/go-gitea/gitea/issues/7013))

### Backups

See the included [rsnapshot configuration](templates/etc_rsnapshot.d_gitea.conf.j2) for the [backup](../backup) role and [Gitea docs - backup and restore](https://docs.gitea.io/en-us/backup-and-restore/)

To restore a backup:

```bash
# Stop the gitea service
sudo systemctl stop gitea
# Remove the gitea postgresql database and user
sudo -u postgres psql --command 'DROP database gitea;'
sudo -u postgres psql --command 'DROP user gitea;'
# Remove the gitea data directory and installation state file
sudo rm -r /var/lib/gitea/ /etc/ansible/facts.d/gitea.fact
# Reinstall gitea by running the playbook/gitea role
xsrv deploy
# Stop the gitea service
sudo systemctl stop gitea
# Restore the database
sudo cp /var/backups/rsnapshot/daily.0/localhost/var/backups/postgresql/gitea.sql /var/tmp/
sudo chown postgres:postgres /var/tmp/gitea.sql
sudo -u postgres pg_restore --clean --dbname gitea --verbose /var/tmp/gitea.sql
sudo rm /var/tmp/gitea.sql
# Restore the data directory
sudo rsync -avP --delete /var/backups/rsnapshot/daily.0/localhost/var/lib/gitea/ /var/lib/gitea/
# Start the gitea service
sudo systemctl start gitea
```


## Tags

<!--BEGIN TAGS LIST-->
```
gitea - setup gitea git service/software forge
gitea-config - update gitea configuration
```
<!--END TAGS LIST-->


## License

[GNU GPLv3](../../LICENSE)

## References/Documentation

- https://github.com/nodiscc/xsrv/tree/master/roles/gitea
- https://gitlab.com/nodiscc/xsrv/-/tree/master/roles/gitea
- https://stdout.root.sx/links/?searchterm=gitea
- https://stdout.root.sx/links/?searchtags=git
