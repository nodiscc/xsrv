jellyfin
=============

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


Requirements/Dependencies
------------

- Ansible 2.10 or higher installed on the controller
- [apache](../apache) role (web server/reverse proxy)


Configuration variables
-----------------------

See [defaults/main.yml](defaults/main.yml)


Example Playbook
----------------

playbook.yml:

```yaml
- hosts: my.CHANGEME.org
  roles:
    - common
    - monitoring
    - apache
    - jellyfin
```

Usage
-----

After initial installation, open https://media.CHANGEME.org in a web browser, and fill in:
- a Jellyfin administrator login/password
- paths to your media files (please set to `/var/lib/jellyfin/media/` when unsure)


### Uploading media

A link is created from `~/MEDIA/` in your home directory, to `/var/lib/jellyfin/media`, allowing you to easily upload media files over [SFTP](../common#usage)


### Playing media

Jellyfin lets you watch your media from a web browser on your computer, apps on your Roku, Android, iOS (including AirPlay), Android TV, or
Fire TV device, or via your Chromecast or existing Kodi installation. See all [clients](https://jellyfin.org/clients/).


License
-------

[GNU GPLv3](../../LICENSE)


References
-----------------

- https://stdout.root.sx/links/?searchtags=jellyfin

