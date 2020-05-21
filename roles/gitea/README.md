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


Requirements
------------

This role requires Ansible 2.8 or higher.


Role Variables
--------------

See [defaults/main.yml](defaults/main.yml)


Dependencies
------------

Recommended:

- The [lamp](https://gitlab.com/nodiscc/ansible-xsrv-lamp) role or similar apache setup
- The [common](https://gitlab.com/nodiscc/ansible-xsrv-common) role for fail2ban support
- The [backup](https://gitlab.com/nodiscc/ansible-xsrv-common) role automatic backups

The web server must be configured to forward requests to the gitea server. Example using the [lamp role](https://gitlab.com/nodiscc/ansible-xsrv-lamp):

```yaml
apache_virtualhosts:
  - servername: my.example.org
    ...
    reverse_proxies:
      - name: gitea
      - location: /gitea
        backend: http://localhost:3000
        response_headers:
          - Content-Security-Policy "script-src 'self' 'unsafe-inline' 'unsafe-eval'; frame-ancestors 'none'"

```

Example Playbook
----------------

```yaml
- hosts: my.example.org
  roles:
    - common
    - apache2
    - gitea
  vars:
    gitea_admin_user: "CHANGEME"
    gitea_admin_password: "CHANGEME"
    gitea_admin_email: "CHANGEME@my.example.org"
```

Usage
-----

### Clients

Gitea can be used from:
- a web browser such as [Firefox](https://www.mozilla.org/en-US/firefox/)
- the [`git`](https://git-scm.com/) command line client
- any other [git GUI client](https://git-scm.com/downloads/guis)
- the [GitNex](https://f-droid.org/en/packages/org.mian.gitnex/) Android application

### Backups

See the included [rsnapshot configuration](templates/etc_rsnapshot.d_gitea.conf.j2) for the [backup](https://gitlab.com/nodiscc/ansible-xsrv-backup) role.

In short, your backup service must run the `gitea dump` command and backup the resulting `.zip` file. If your backup service is not running as root, `sudoers` must be configured to allow the backup user to run `sudo -u gitea gitea` without password. See [Gitea docs - backup and restore](https://docs.gitea.io/en-us/backup-and-restore/)

Restoring a backup: TODO

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
# Create your projects
gitea --description "LAMP stack (apache webserver / MySQL database / PHP interpreter) - ansible role" --private new xsrv/ansible-xsrv-lamp
gitea --description "incremental backup server (rsnapshot) - ansible role" --private new xsrv/ansible-xsrv-backup
gitea --description "basic Linux server setup - ansible role" --private new xsrv/ansible-xsrv-common
gitea --description "Docker containerization system - ansible role" --private new xsrv/ansible-xsrv-docker
gitea --description "Firewall and network filtering system (firehol/fail2ban) - ansible role" --private new xsrv/ansible-xsrv-firewall
gitea --description "Gitea self-hosted Git service/software forge - ansible role" --private new xsrv/ansible-xsrv-gitea
gitea --description "Gitlab self-hosted Git service/software forge - ansible role" --private new xsrv/ansible-xsrv-gitlab
gitea --description "Gitlab Continuous Integration runner/worker service - ansible role" --private new xsrv/ansible-xsrv-gitlab-runner
gitea --description "Icecast media streaming server - ansible role" --private new xsrv/ansible-xsrv-icecast
gitea --description "Log aggregation and analysis server (rsyslog/graylog) - ansible role" --private new xsrv/ansible-xsrv-logserver
gitea --description "System monitoring and auditing (netdata/other) - ansible role" --private new xsrv/ansible-xsrv-monitoring
gitea --description "Mumble voice chat server - ansible role" --private new xsrv/ansible-xsrv-mumble
gitea --description "Nextcloud self-hosted personal/groupware cloud service - ansible role" --private new xsrv/ansible-xsrv-nextcloud
gitea --description "Nginx web server/reverse proxy - ansible role" --private new xsrv/ansible-xsrv-nginx
gitea --description "OpenLDAP directory service - ansible role" --private new xsrv/ansible-xsrv-openldap
gitea --description "PulseAudio network streaming server - ansible role" --private new xsrv/ansible-xsrv-pulseaudio
gitea --description "Linux software RAID - ansible role" --private new xsrv/ansible-xsrv-raid
gitea --description "Samba CIFS/SMB file sharing server - ansible role" --private new xsrv/ansible-xsrv-samba
gitea --description "Shaarli bookmarking/link sharing application - ansible role" --private new xsrv/ansible-xsrv-shaarli
gitea --description "Transmission bittorrent client and web interface - ansible role" --private new xsrv/ansible-xsrv-transmission
gitea --description "Tiny-Tiny-RSS (tt-rss) RSS/ATOM feed reader" --private new xsrv/ansible-xsrv-tt-rss

# Get the list of issues for a project
./gitea issues xsrv/xsrv | jq -r '.[] | "#\(.number) - \(.title)"'
```

[tea](https://gitea.com/gitea/tea) will be the officially suported command line Gitea API client.

### Troubleshooting

* Gitea refuses to start with the message `Failed to initialize issue indexer: leveldb: manifest corrupted` in `/var/lib/gitea/log/*log`: delete indexer directories `sudo rm -r /var/lib/gitea/data/indexers/* /var/lib/gitea/indexers/*` ([1](https://github.com/go-gitea/gitea/issues/7013))


License
-------

[GNU GPLv3](LICENSE)

References/Documentation
-------------

https://stdout.root.sx/links/?searchterm=gitea