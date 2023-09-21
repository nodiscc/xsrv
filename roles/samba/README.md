# xsrv.samba

This role will install [Samba](https://en.wikipedia.org/wiki/Samba_(software)), a file sharing service compatible with many operating systems. Samba is a free software re-implementation of Microsoft [SMB/CIFS](https://en.wikipedia.org/wiki/Server_Message_Block) communication protocol.

The server is set up as a "standalone"/workgroup server (ie. not part of a domain) and can use one of these backends for user accounts:
- standard local Linux users
- LDAP users

## Requirements/dependencies/example playbook

- See [meta/main.yml](meta/main.yml)
- The LDAP server must be running on the same host as the samba server if `samba_passdb_backend: ldpsam` is used, and be deployed before the samba role.

```yaml
# playbook.yml
- hosts: my.CHANGEME.org
  roles:
    - nodiscc.xsrv.common # (optional) base server setup, hardening, firewall
    - nodiscc.xsrv.monitoring # (optional) system/server monitoring and health checks
    - nodiscc.xsrv.backup # (optional) automatic backups
    - nodiscc.xsrv.openldap # (required if samba_passdb_backend: ldapsam) LDAP user backend
    - nodiscc.xsrv.samba
```

See [defaults/main.yml](defaults/main.yml) for all configuration variables


## Usage

### Accessing samba shares

- **From Windows clients:** access from the `Network` entry in the Windows file manager sidebar, or directly at `\\SERVER_ADDRESS` in the explorer location bar.
- **From Mac OSX clients:** access from the `Network` entry in the OSX Finder sidebar, or directly at `smb://SERVER_ADDRESS/` from the `Go > Connect to server...` finder menu entry.
- **From Linux clients:** access from the `Network > Windows Network` entry in the file manager sidebar, or directly at `smb://SERVER_ADDRESS/` from the `File > Connect to server...` menu entry.

### Backups

See the included [rsnapshot configuration](templates/etc_rsnapshot.d_samba.conf.j2) for the [backup](../backup/) role.

### Removing samba users

This role does not remove any user accounts. To remove a samba user account, remove it from the `samba_users` list, and remove their account from the server manually with `sudo deluser my_old_user`

## Tags

<!--BEGIN TAGS LIST-->
```
samba - setup samba file server
samba-shares - configfure samba file shares
samba-users - configfure samba user accounts
utils-samba-listusers - (manual) list samba users
```
<!--END TAGS LIST-->

## License

[GNU GPLv3](../../LICENSE)


## References

- https://stdout.root.sx/links/?searchtag=samba
