# xsrv.openldap

This role will install and configure a [LDAP](https://en.wikipedia.org/wiki/Lightweight_Directory_Access_Protocol) directory server:
- [OpenLDAP](https://en.wikipedia.org/wiki/OpenLDAP) server
- (optional) [LDAP Account Manager](https://ldap-account-manager.org/) web interface for easy management of the LDAP directory
- (optional) [Self Service Password](https://ltb-project.org/documentation/self-service-password) LDAP password change tool

[![](https://screenshots.debian.net/shrine/screenshot/6946/simage/small-58bc88c5ca84c0544180e2c0f7de1445.png)](https://screenshots.debian.net/package/ldap-account-manager)
[![](https://screenshots.debian.net/shrine/screenshot/16087/simage/small-d9cc1bf64acddc45d98715f41fada68c.png)](https://screenshots.debian.net/package/ldap-account-manager)
[![](https://i.imgur.com/loA7FGf.png)](https://i.imgur.com/vaimb8j.png)


## Requirements/dependencies/example playbook

- See [meta/main.yml](meta/main.yml)
- The server must be reachable by clients over TCP ports 389 and 636 (SSL/TLS).

```yaml
# playbook.yml
- hosts: my.example.org
  roles:
    - nodiscc.xsrv.common # (optional) base server setup, hardening, firewall, bruteforce protection
    - nodiscc.xsrv.monitoring # (optional) system/server monitoring and health checks
    - nodiscc.xsrv.backup # (optional) automatic backups
    - nodiscc.xsrv.apache # (required in the standard configuration if openldap_setup_lam/ssp: yes) webserver, PHP interpreter and SSL certificates
    - nodiscc.xsrv.openldap

# required variables:
# host_vars/my.CHANGEME.org/my.CHANGEME.org.yml
openldap_fqdn: "ldap.CHANGEME.org"
openldap_domain: "CHANGEME.org"
openldap_organization: "CHANGEME"
openldap_base_dn: "dc=CHANGEME,dc=org"
# ansible-vault edit host_vars/my.example.org/my.example.org.vault.yml
openldap_admin_password: "CHANGEME"
openldap_bind_password: "CHANGEME"
```

See [defaults/main.yml](defaults/main.yml) for all configuration variables


## Usage

### LDAP administration

- **CN**: Common Name (non-unique identifier for an entry, relative to the container it is in - eg `jane.doe`)
- **DN**: Distinguished Name (unique identifier, full path from root of the LDAP tree to the object - eg. `cn=jane.doe,ou=Users,dc=example,dc=org`)
- **DC**: Domain Component (component of a distinguished name - eg. `example, org`)
- **Base DN** or **Search base**: the top of your domain hierarchy, eg. `dc=CHANGEME,dc=org`
- **Users DN** container for the whole users hierarchy - eg. `ou=Users,dc=CHANGEME,dc=org`
- **OU**: [Organizational Unit](https://ldapwiki.com/wiki/OrganizationalUnit) (arbitrary subtree/subdirectory in LDAP hierarchy), for organizational/separation purposes - **not** permissions management purposes)
- **Group:** a list ([posixGroup](https://ldapwiki.com/wiki/PosixGroup)) of user DNs with a specific role/access level, for permissions management purposes - **not** organizational purposes. eg. `access_fileshare_XYZ`, `access_application_XYZ`, `access_instant_messaging`...)

**Accessing LDAP account manager settings:** LAM should be configured from the templates provided by this role. If you need to temporarily access LAM settings from the web interface (your changes will be overwritten on the next ansible deployment), edit these files:
- `/var/www/{{ ldap_account_manager_fqdn }}/config/config.cfg`: `password: CHANGEME`
- `/var/www/{{ ldap_account_manager_fqdn }}/config/lam.conf`, `Passwd: CHANGEME`

**Privileges/security:** By default, Self Service Password uses an unprivilegied LDAP user to access the directory, then uses user-provided credentials to change their own password. If the [samba](../samba) role is enabled, Self Service Password will use the LDAP `admin` credentials to access the directory - only expose the service on trusted networks (by default it is exposed to LAN/RFC1918 private IP addresses).

**UIDs/GIDs:** For most applications users should be of the [inetOrgPerson](https://ldapwiki.com/wiki/InetOrgPerson) object class. The identifying attribute for numeric user ID lookups is [uid](https://ldapwiki.com/wiki/uid).

LDAP users and groups should be created with a UID/GID above 10000 to **prevent conflicts with local user accounts**.If you have both a local and LDAP user account with the same name and different passwords/UIDs/..., file permissions/ownership/group membership, accepted passwords and privileges will be inconsistent. For this reason all usernames must be **unique** across `/etc/passwd` and LDAP. Do **NOT** add LDAP users with the same name as a local username. For this reason try to stick to `firstname.lastname` for LDAP user names, and `privilege.object` LDAP group names.

**Changing the OpenLDAP log level manually**:

```bash
$ sudo ldapmodify -Q -H ldapi:/// -Y EXTERNAL <<EOF
dn: cn=config
changetype: modify
replace: olcLogLevel
olcLogLevel: 2040
EOF
```

To look for LDAP authentication failures, set the log level to `256` and search for `err=49` in slapd log messages.

### Backups

See the included [rsnapshot configuration](templates/etc_rsnasphot.d_openldap.conf.j2) and [openldap dump script](templates/_user_local_bin_openldap-dump.sh.j2)


## Tags

<!--BEGIN TAGS LIST-->
```
openldap - setup LDAP server
ldap-account-manager - setup LDAP account manager
self-service-password - setup LDAP self-service password
```
<!--END TAGS LIST-->


## License

[GNU GPLv3](../../LICENSE)


## References

- https://stdout.root.sx/links/?searchtags=doc+ldap
- https://stdout.root.sx/links/?searchtags=doc+idmanagement
