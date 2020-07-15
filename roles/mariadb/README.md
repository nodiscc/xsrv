mariadb
====

This role will install [MariaDB]https://en.wikipedia.org/wiki/MariaDB), a community-developed, commercially supported fork of the MySQL relational database management system (RDBMS)

Requirements/Dependencies
------------

- Ansible 2.9 or higher.


Configuration Variables
-----------------------

See [defaults/main.yml](defaults/main.yml)

Example Playbook
----------------

```yaml
# host_vars.my.example.org/my.example.org.yml
- hosts: my.example.org
  roles:
     - common
     - apache-php
     - mariadb

# ansible-vault edit host_vars/my.example.org/my.example.org.vault.yml
vault_mariadb_root_password: "CHANGEME"
```

Usage
-----


License
-------

- [GNU GPLv3](../../LICENSE)


References
-----------------

- https://stdout.root.sx/links?searchtags=database
