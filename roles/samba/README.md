# xsrv.samba

This role will install [Samba](https://en.wikipedia.org/wiki/Samba_(software)), a file sharing service for various operating systems. Samba is a free software re-implementation of Microsoft SMB networking protocol.

The server is set up as a "standalone"/workgroup server (ie. not part of a domain) and uses standard Linux users as a backend for user accounts.


Requirements
------------

- Ansible 2.9 or higher.


Role Variables
--------------

See [defaults/main.yml](defaults/main.yml)


Dependencies
------------

- [common](../common/README.md) role (optional)
- [backup](../backup/README.md) role (for automatic backups, optional)


Example Playbook
----------------

```yaml
- hosts: my.example.org
  roles:
    - common
    - monitoring
    - backup
    - samba
  vars:
    samba_shares:
      - name: mycompany
        comment: "File share for the whole company"
        allow_read_users:
          - alice
          - bob
          - martin
          - eve
          - boss
      - name: eve-personal
        comment: "Eve's personal file storage (hidden from share listing)"
        browseable: no
        allow_write_users:
          - eve
      - name: accounting
        comment: "Share for the accounting department"
        allow_write_users:
          - martin
        allow_read_users:
          - boss
      - name: old_share
        state: absent
    samba_users:
      - username: alice
        password: "{{ vault_samba_user_password_alice }}"
      - username: bob
        password: "{{ vault_samba_user_password_bob }}"

# ansible-vault edit host_vars/my.example.org/my.example.org.vault.yml
vault_samba_user_password_alice: "CHANGEME"
vault_samba_user_password_bob: "CHANGEME"
```

Usage
-----

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
