# xsrv.owncast

This role will install [owncast](https://example.org/), an open source, self-hosted, decentralized, single user live video streaming and chat server for running your own live streams similar in style to the large mainstream options. It offers complete ownership over your content, interface, moderation and audience.

[![](https://owncast.online/images/owncast-splash.png)](https://owncast.online/images/owncast-splash.png)


## Requirements/dependencies/example playbook

See [meta/main.yml](meta/main.yml)

```yaml
# playbook.yml
- hosts: my.CHANGEME.org
  roles:
    - nodiscc.xsrv.common # (optional) base server setup, hardening, firewall, bruteforce prevention
    - nodiscc.xsrv.monitoring # (optional) server monitoring, log aggregation
    - nodiscc.xsrv.backup # (optional) automatic backups
    - nodiscc.xsrv.apache # (required in the standard configuration) webserver/reverse proxy, SSL certificates
    - nodiscc.xsrv.podman # container engine
    - nodiscc.xsrv.owncast

# required variables
# host_vars/my.CHANGEME.org/my.CHANGEME.org.yml
owncast_fqdn: "owncast.CHANGEME.org"

# ansible-vault edit host_vars/my.CHANGEME.org/my.CHANGEME.org.vault.yml
owncast_admin_password: "CHANGEME"
```

See [defaults/main.yml](defaults/main.yml) for all configuration variables.


## Usage

You can configure details of your owncast instance, get access to your streaming keys, etc. by accessing `https://owncast.CHANGEME.org/admin` in a Web browser, and logging in using the `admin` username and your admin password defined in `owncast_admin_password`.

Instructions for connecting a streaming client such as [OBS Studio](https://obsproject.com/) can be found in the [Owncast documentation](https://owncast.online/docs/broadcasting/). Owncast is compatible with any software that uses RTMP to broadcast to a remote server. Documentation about managing the [live chat](https://owncast.online/docs/chat/chat-authentication/) or social features of Owncast can also be found there.

Viewers only need to access `https://owncast.CHANGEME.org/` to display the live stream.


### Backups

See the included [rsnapshot configuration](templates/etc_rsnapshot.d_owncast.conf.j2) for information about directories to backup/restore.

## Tags

<!--BEGIN TAGS LIST-->
```
owncast - setup owncast live streaming server
```
<!--END TAGS LIST-->


## License

[GNU GPLv3](../../LICENSE)


## References

- https://stdout.root.sx/links/?searchterm=owncast
