# xsrv.rocketchat

This role will install and configure [rocket.chat](https://rocket.chat), a self-hosted instant messaging and communication platform. 

[![](https://rocket.chat/wp-content/uploads/2020/07/devices-screens-768x433.png.webp)](https://rocket.chat)

Rocket.Chat features include:
- Public/private group chats (channels)
- One-to-one chat
- File uploads
- Audio/video calls/conferencing and screensharing
- Mobile apps (Android: [F-Droid](https://f-droid.org/en/packages/chat.rocket.android/), [Google Play](https://play.google.com/store/apps/details?id=chat.rocket.android); [iOS](https://apps.apple.com/us/app/rocket-chat/id1148741252))
- Notifications
- Bots/integrations with other platforms
- Emebedded media, markdown syntax support
- Full-text search
- Off-the-record messaging/end-to-end encryption
- LDAP authentication

It provides an alternative to proprietary SaaS software like Slack, Discord, Google Meet...

## Requirements/dependencies

See [meta/main.yml](defaults/main.yml)


```yaml
# playbook.yml
- hosts: my.CHANGEME.org
  roles:
    - nodiscc.xsrv.common # optional
    - nodiscc.xsrv.backup # (optional) automatic backups
    - nodiscc.xsrv.apache # webserver and SSL/TLS certificates
    - nodiscc.xsrv.docker # docker swarm

# host_vars/my.CHANGEME.org/my.CHANGEME.org.yml
rocketchat_fqdn: chat.CHANGEME.org
```

See [defaults/main.yml](defaults/main.yml) for all configuration variables.

--------------------

## Usage

**Post-installation:** After first deployment, access your rocket.chat instance at https://chat.CHANGEME.org, and provide configuration details:
- Admin username/password - store these credentials in a password manager!
- Organization info
- Register server (recommended: `Keep standalone`)

**LDAP configuration:**
- Access https://chat.CHANGEME.org/admin/LDAP
- Enable: `yes`
- Login Fallback: `no`
  - This prevents rocketchat from caching LDAP passwords for better security (no cleartext storage of passwords, also prevents disabled/locked LDAP users from logging in). If the LDAP server is down, users will not be able to login. 
- Find user after login: `yes`
- Host: the LDAP server host name (set this to `172.17.0.1` - the IP address of the `docker0` bridge if LDAP server runs on the docker host)
- Reconnect: `yes`
- `Test connection`
- Encryption: `No encryption` (or `LDAPS` if the LDAP server is on a separate host)
- Base DN: `ou=users,dc=CHANGEME,dc=org` (the LDAP base DN for users)
- Internal log level: `Info`
- Authentication: Enable: `yes`
- User DN: `cn=bind,ou=system,dc=CHANGEME,dc=org` (LDAP account used to login to the directory and search for users)
  - All valid LDAP users will be able to login and access the default `general` channel
- Password: the bind user password (value of `openldap_bind_password` if using the [openldap](../openldap) role)
- Sync/Import: Username field: `uid` on OpenLDAP servers
- Merge existing users: `yes`
- Sync user data: `yes`
- Sync LDAP groups: `yes`
- LDAP Group Base DN: `ou=groups,dc=CHANGEME,dc=org` (the LDAP base DN for groups)
- Sync user avatar: `yes`
- Background sync: `yes`
- Background Sync Interval: `Every 12 hours`
- Background Sync Import New Users: `yes`
- Background Sync Update Existing Users: `yes`
- User Search: Search field: `uid` on OpenLDAP servers
- `Save changes`
- `Execute synchronization now`

**Video conference:** In this configuration rocketchat will integrate with public https://meet.jit.si servers
- Access https://chat.CHANGEME.org/admin/Video%2520Conference
- Jitsi: Enable: `yes`
- Always open in new window: `yes`
- Enable in channels: `yes`
- `Save changes`


**Markdown support:** For better markdown support ([CommonMark](https://spec.commonmark.org/0.29/), [GFM](https://github.github.com/gfm/))):
- Access https://chat.CHANGEME.org/admin/Message
- Markdown > Markdown parser: `Marked`
- `Save changes`

**Backups:** see the included [rsnapshot configuration](templates/etc_rsnasphot.d_rocketchat.conf.j2) and [rocketchat dump script](templates/_user_local_bin_rocketchat-dump.sh.j2)

**Mobile clients:**
- [Android app](https://f-droid.org/en/packages/chat.rocket.android/)
- [iOS app](https://apps.apple.com/us/app/rocket-chat/id1148741252)


## License

[GNU GPLv3](../../LICENSE)

## References

- https://stdout.root.sx/links/?searchtem=rocketchat
