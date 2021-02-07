# xsrv.jellyfin

This role will install [Jellyfin](https://jellyfin.org/), a media solution that puts you in control of your media.
Stream to any device from your own server, with no strings attached. Your media, your server, your way.
 - Movies: Hold your entire movie collection, with a beautiful collection of posters.
 - TV Shows: Collect your TV Shows, and have them automatically organized by season.
 - Music: Enjoy your music collection. Make playlists, and listen on the go.
 - Live TV & DVR: Watch Live TV and set automatic recordings to expand your library.
 - Your data: no tracking, phone-home, or central servers collecting your data. 

[![](https://jellyfin.org/images/screenshots/home_thumb.png)](https://jellyfin.org/images/screenshots/home_full.png)
[![](https://jellyfin.org/images/screenshots/movie_thumb.png)](https://jellyfin.org/images/screenshots/movie_full.png)
[![](https://jellyfin.org/images/screenshots/playback_thumb.png)](hthttps://jellyfin.org/images/screenshots/playback_full.png)


## Requirements/dependencies/example playbook

See [meta/main.yml](meta/main.yml)

```yaml
# playbook.yml
- hosts: my.CHANGEME.org
  roles:
    - nodiscc.xsrv.common # (optional)
    - nodiscc.xsrv.monitoring # (optional)
    - nodiscc.xsrv.apache # webserver/reverseproxy and SSL/TLS certificates
    - nodiscc.xsrv.jellyfin

# host_vars/my.CHANGEME.org/my.CHANGEME.org.yml
jellyfin_fqdn: media.CHANGEME.org
```

See [defaults/main.yml](defaults/main.yml) for all configuration variables


## Usage

After initial installation, open https://media.CHANGEME.org in a web browser, and fill in:
- a Jellyfin administrator login/password
- paths to your media files (please set to `/var/lib/jellyfin/media/` when unsure)


### Uploading media

- Upload media files over [SFTP](../common#usage) to `~/MEDIA/`
- If the [samba](../samba) role is enabled, upload files over samba to the ``smy://my.CHANGEME.org/jellyfin` share


### Playing media

Jellyfin lets you watch your media from a web browser on your computer, apps on your Roku, Android, iOS (including AirPlay), Android TV, or
Fire TV device, or via your Chromecast or existing Kodi installation. See all [clients](https://jellyfin.org/clients/).


## License

[GNU GPLv3](../../LICENSE)


## References

- https://stdout.root.sx/links/?searchtags=jellyfin
