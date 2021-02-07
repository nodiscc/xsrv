# xsrv.samba

This role will install [Samba](https://en.wikipedia.org/wiki/Samba_(software)), a file sharing service for various operating systems. Samba is a free software re-implementation of Microsoft SMB networking protocol.

The server is set up as a "standalone"/workgroup server (ie. not part of a domain) and uses standard Linux users as a backend for user accounts.


## Requirements/dependencies/example playbook


See [meta/main.yml](meta/main.yml)

```yaml
# playbook.yml
- hosts: my.CHANGEME.org
  roles:
    - nodiscc.xsrv.common # (optional) hardening, firewall
    - nodiscc.xsrv.monitoring # (optional)
    - nodiscc.xsrv.backup # optional
    - nodiscc.xsrv.apache # (optional) webserver, PHP interpreter and SSL/TLS certificates for ldap-account-manager
    - nodiscc.xsrv.samba
```

See [defaults/main.yml](defaults/main.yml) for all configuration variables


## Usage

### Clients

- **From Windows clients:** access from the `Network` entry in the Windows file manager sidebar, or directly at `\\SERVER_ADDRESS` in the explorer location bar.
- **From Mac OSX clients:** access from the `Network` entry in the OSX Finder sidebar, or directly at `smb://SERVER_ADDRESS/` from the `Go > Connect to server...` finder menu entry.
- **From Linux clients:** access from the `Network > Windows Network` entry in the file manager sidebar, or directly at `smb://SERVER_ADDRESS/` from the `File > Connect to server...` menu entry.


### Backups

See the included [rsnapshot configuration](templates/etc_rsnapshot.d_samba.conf.j2) for the [backup](../backup/) role.


### Listing samba users

`ssh my.example.org sudo pdbedit -Lv`


### Removing samba users

This role does not remove any user accounts. To remove a samba user account, remove it from the `samba_users` list, and remove their account from the server manually with `sudo deluser my_old_user`


License
-------

[GNU GPLv3](../../LICENSE)


References
-----------------

- https://stdout.root.sx/links/?searchtag=samba
