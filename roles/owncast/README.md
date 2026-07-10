# xsrv.owncast

This role will install [owncast](https://owncast.online/), an open source, self-hosted, decentralized, single user live video streaming and chat server for running your own live streams similar in style to the large mainstream options. It offers complete ownership over your content, interface, moderation and audience.

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

**Streaming performance:** The default video streaming settings uses transcoding to convert the source video stream to a lower bitrate more suitable for live streaming. On low-end servers without hardware transcoding capabilities (e.g. VPS), this may cause excessive CPU usage, wich results in bad streaming performance (choppy stream, high frame drop in your streaming software). You can disable transcoding by going to `Configuration > Video` in the admin interface, then under `Stream output > Add new variant`, add a variant named `SOURCE`, and enable `Advanced Settings > Use video passthrough`. The video stream from your streaming software will be copied directly to the clients watching the stream, without transcoding on the server. All audio/video settings will be determined by your streaming software (bitrate, codec, ...), so make sure you select a widely supported video format like h.264 and a bitrate suitable for your server bandwidth.

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

- https://github.com/owncast/owncast
- https://owncast.online/docs/
- https://owncast.online/docs/chat/chat-authentication/
- https://owncast.online/docs/chat/moderation/
- https://owncast.online/docs/chat/emoji/
- https://owncast.online/docs/configuration/
- https://owncast.online/docs/website/
- https://owncast.online/docs/video/
- https://owncast.online/docs/storage/
- https://owncast.online/docs/directory/
- https://owncast.online/quickstart/installation/
- https://owncast.online/quickstart/manual/
- https://owncast.online/quickstart/container/
- https://owncast.online/docs/resources-requirements/
- https://owncast.online/docs/systemservice/
- https://owncast.online/docs/social/
- https://owncast.online/docs/stream-keys/
- https://owncast.online/docs/metrics/
- https://owncast.online/docs/codecs/
- https://owncast.online/docs/scaling/
- https://owncast.online/docs/backups/
- https://owncast.online/docs/custom-javascript/
- https://owncast.online/docs/appearance/
- https://owncast.online/troubleshoot/
- https://github.com/owncast/owncast/releases
