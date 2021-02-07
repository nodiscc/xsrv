gitea
=============

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

[![](https://i.imgur.com/Rks90zV.png)](https://i.imgur.com/2TGIshE.png)
[![](https://i.imgur.com/cBktctp.png)](https://i.imgur.com/EauaJxq.png)
[![](https://i.imgur.com/gvcfs6G.png)](https://i.imgur.com/DHku4ke.png)
[![](https://i.imgur.com/4NhXqdG.png)](https://i.imgur.com/d5glB4P.png)


## Requirements/dependencies/example playbook

See [meta/main.yml](meta/main.yml)

```yaml
- hosts: my.CHANGEME.org
  roles:
    - nodiscc.xsrv.common # bruteforce prevention, SSH
    - nodiscc.xsrv.backup # (optional) automatic backups
    - nodiscc.xsrv.apache # webserver/reverse proxy, SSL certificates
    - nodiscc.xsrv.postgresql # database engine
    - nodiscc.xsrv.gitea
  vars:
    gitea_fqdn: "git.CHANGEME.org"

# ansible-vault edit host_vars/my.example.org/my.example.org.vault.yml
vault_gitea_admin_username: "CHANGEME"
vault_gitea_admin_password: "CHANGEME"
vault_gitea_admin_email: "CHANGEME@CHANGEME.org"
vault_gitea_secret_key: "CHANGEME64"
vault_gitea_internal_token: "CHANGEME160"
vault_gitea_oauth2_jwt_secret: "CHANGEME43"
vault_gitea_lfs_jwt_secret: "CHANGEME43"
```

See [defaults/main.yml](defaults/main.yml) for all configuration variables.


## Usage

### Backups

See the included [rsnapshot configuration](templates/etc_rsnapshot.d_gitea.conf.j2) for the [backup](../backup) role and [Gitea docs - backup and restore](https://docs.gitea.io/en-us/backup-and-restore/)

Restoring a backup: TODO


### Clients

Gitea can be used from:
- a [web browser](https://www.mozilla.org/en-US/firefox/)
- [`git`](https://git-scm.com/) command line client
- any other [git GUI client](https://git-scm.com/downloads/guis)
- [GitNex](https://f-droid.org/en/packages/org.mian.gitnex/) Android application

### Repository mirroring

#### Mirror from gitea to other hosts

To mirror a gitea repository to github/gitlab [[1]](https://github.com/go-gitea/gitea/issues/3480), add a post-receive hook in the project settings:

```bash
#!/bin/bash
user="myusername"
token="qwertyuiopasdfghjklmzxcvbn"
host="github.com"
repo="myproject"
git push --mirror --quiet https://$user:$token@$host/$user/$repo.git &> /dev/null
echo "$host/$user/$repo updated"
```

#### Mirror from other hosts to gitea

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

[tea](https://gitea.com/gitea/tea) will be the officially suported command line Gitea API client.

### Troubleshooting

* Gitea refuses to start with the message `Failed to initialize issue indexer: leveldb: manifest corrupted` in `/var/lib/gitea/log/*log`: delete indexer directories `sudo rm -r /var/lib/gitea/data/indexers/* /var/lib/gitea/indexers/*` ([1](https://github.com/go-gitea/gitea/issues/7013))


License
-------

[GNU GPLv3](../../LICENSE)

References/Documentation
-------------

- https://github.com/nodiscc/xsrv/tree/master/roles/gitea
- https://gitlab.com/nodiscc/xsrv/-/tree/master/roles/gitea
- https://stdout.root.sx/links/?searchterm=gitea
- https://stdout.root.sx/links/?searchtags=git
