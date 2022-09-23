# xsrv.jellyfin

This role will install [Jellyfin](https://jellyfin.org/), a media solution that puts you in control of your media.
Stream to any device from your own server, with no strings attached. Your media, your server, your way.
 - Movies: Hold your entire movie collection, with a beautiful collection of posters.
 - TV Shows: Collect your TV Shows, and have them automatically organized by season.
 - Music: Enjoy your music collection. Make playlists, and listen on the go.
 - Live TV & DVR: Watch Live TV and set automatic recordings to expand your library.
 - Your data: no tracking, phone-home, or central servers collecting your data.
 - LDAP authentication support

[![](https://jellyfin.org/images/screenshots/home_thumb.png)](https://jellyfin.org/images/screenshots/home_full.png)
[![](https://jellyfin.org/images/screenshots/movie_thumb.png)](https://jellyfin.org/images/screenshots/movie_full.png)
[![](https://jellyfin.org/images/screenshots/playback_thumb.png)](hthttps://jellyfin.org/images/screenshots/playback_full.png)


## Requirements/dependencies/example playbook

See [meta/main.yml](meta/main.yml)

```yaml
# playbook.yml
- hosts: my.CHANGEME.org
  roles:
    - nodiscc.xsrv.common # (optional) hardening, firewall, login bruteforce protection
    - nodiscc.xsrv.monitoring # (optional) samba server monitoring
    - nodiscc.xsrv.backup # (optional) automatic local backups
    - nodiscc.xsrv.samba # (optional) manage jellyfin files/library over samba file sharing
    - nodiscc.xsrv.apache # (required) webserver/reverseproxy and SSL/TLS certificates
    - nodiscc.xsrv.jellyfin

# required variables
# host_vars/my.CHANGEME.org/my.CHANGEME.org.yml
jellyfin_fqdn: media.CHANGEME.org
```

See [defaults/main.yml](defaults/main.yml) for all configuration variables.


## Usage

After initial installation, open https://media.CHANGEME.org in a web browser, and:
- set a Jellyfin administrator login/password
- add media libraries pointing to directories where your media files are stored:
  - Default media directory: `/var/lib/jellyfin/media/{movies,books,mixedcontent,shows,music,musicvideos,shows,photos}`
  - Jellyfin samba share (if the [samba](../samba) role is enabled): `/var/lib/jellyfin/sambashare/{movies,books,mixedcontent,shows,music,musicvideos,shows,photos}`
  - Transmission downloads directory (if the [transmission](../transmission) role is enabled): `/var/lib/transmission-daemon/downloads/{movies,books,mixedcontent,shows,music,musicvideos,shows,photos}`

### Uploading media

- Upload media files over [SFTP](../common#usage) to `~/MEDIA/` (symbolic link to `/var/lib/jellyfin/media/`)
- If the [samba](../samba) role is enabled and [`jellyfin_samba_share_enabled: yes` and a list of valid users](defaults/main.yml) are specified, upload files to the `smb://my.CHANGEME.org/jellyfin` samba share
- Download files from bittorrent using [transmission](../transmission)

### Playing media

Jellyfin lets you watch your media from a web browser on your computer, apps on your Roku, Android, iOS (including AirPlay), Android TV, or Fire TV device, or via your Chromecast or existing Kodi installation. See all [clients](https://jellyfin.org/clients/).

You can also browse play Jellyfin media from any [DLNA](https://en.wikipedia.org/wiki/Digital_Living_Network_Alliance#Specification)-compatible media player on your local network, or use Jellyfin to play media thorugh any DLNA Media Renderer on your network. To use DLNA you must enable incoming/outgoing `UDP multicast on port 1900` traffic in the [firewall](../common). If you don't use DLNA it is recommended to turn it off completely under `Admin Dashboard > DLNA`.

### Backups

Automatic backups of the default media directory are disabled by default, unless [`jellyfin_enable_media_backups: yes`](defaults/main.yml). See the included [rsnapshot configuration](templates/etc/rsnapshot.d_jellyfin.conf.j2) for information about directories to backup/restore.

### LDAP authentication

To allow logins to Jellyfin using LDAP user accounts (for example from [openldap](../openldap)):
- Login to jellyfin using the initial/administrator account
- Open `Admin > Dashboard > Plugins > Catalog`
- Open `LDAP authentication` and click `Install`
- Restart the jellyfin server (from `Server > Dashboard > Restart` or `xsrv shell > sudo systemctl restart jellyfin`)
- Open `Admin > Dashboard > Plugins > LDAP-Auth` and configure the plugin:
  - LDAP server: `ldap.CHANGEME.org`
  - Secure LDAP: enabled (or disabled if your LDAP server does not support SSL/TLS)
  - Skip SSL verification: enable if your server is using a self-signed certificate
  - LDAP Base DN for searches: `dc=CHANGEME,dc=org`
  - LDAP port: `636` (SSL/TLS) or `389`
  - LDAP attributes: `uid, cn, mail`
  - LDAP Name Attribute: `uid`
  - LDAP User Filter: set to `(objectClass=inetOrgPerson)` if your LDAP server does not support the `memberOf` overlay (all LDAP users will be allowed to access Jellyfin). Otherwise set `memberOf=GROUPNAME` to the LDAP group name allowed to access Jellyfin (eg. `access_jellyfin`)
  - LDAP Admin Filter: users matching this filter will be given Jellyfin administrator privileges:
    - Set to `(enabledService=JellyfinAdministrator)` (default): if a LDAP user has the `jellyfinAdministrator` objectClass, it will automatically be set as Jellyfin administrator.
    - Set to `(objectClass=inetOrgPerson)` to give all users administrator rights by default. Administrators can still be managed manually from the web admin interface.
    - Use a `memberOf` filter looking for a specific group (eg. `(memberOf=cn=jellyfin_admins,ou=groups,dc=CHANGEME,dc=org)`) if your server supports `memberOf`, and add admin users to the LDAP group `jellyfin_admins`.
  - LDAP Bind User: `cn=bind,ou=system,dc=CHANGEME,dc=org`
  - LDAP Bind User Password: the value of `{{ openldap_bind_password }}`
  - [x] Enable User Creation
  - Click `Save`
- Restart the jellyfin server from the `Server > Dashboard` settings page

### Performance

When using Jellyfin from a web browser, media will be converted/transcoded on-the-fly to a format supported by the browser. You can also force transcoding to a lower quality directly from the `Settings > Quality` menu directly from the player. Transcoding will consume a noticeable amount of system (CPU/RAM) resources. On resource-constrained systems this may lead to playback issues or freezes and the server becoming unresponsive. To fix this several options exist:
- Disable `Allow playback of media that requires transcoding` for each user under `Admin > Dashboard > Users`. Currently there is [no global setting](https://github.com/jellyfin/jellyfin/issues/645) to disable transcoding globally for all users.
- Use a [native client](https://jellyfin.org/clients/) which does not require server-side transcoding
- Manually setup [hardware acceleration](https://jellyfin.org/docs/general/administration/hardware-acceleration.html)

### Subtitles

To search and download video subtitles, register an account on https://opensubtitles.com, enable the `Opensubtitles` plugin from `Admin > Plugins` and set your opensubtitles.org username/password in the plugin preferences. Then obtain an API key by following the link the plugin settings. You will then be able to use right-click > `Edit subtitles` on any video from your library and search for matching subtitles.

### Metadata

The [Youtube Metadata Plugin](https://github.com/ankenyr/jellyfin-youtube-metadata-plugin) can be used to automatically set metadata for videos downloaded using [yt-dlp](https://github.com/yt-dlp/yt-dlp).


## Tags

<!--BEGIN TAGS LIST-->
```
jellyfin - setup jellyfin media server
```
<!--END TAGS LIST-->


## License

[GNU GPLv3](../../LICENSE)


## References

- https://stdout.root.sx/links/?searchterm=jellyfin
