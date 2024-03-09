# xsrv.matrix

This role will install a [Matrix](https://en.wikipedia.org/wiki/Matrix_(protocol)) server. Matrix is an open standard and communication protocol for real-time communication. This role deploys:
- [Synapse](https://matrix.org/docs/projects/server/synapse), Matrix.org's reference server
- [Element Web](https://matrix.org/docs/projects/client/element), a Matrix client for the Web
- [synapse-admin](https://github.com/Awesome-Technologies/synapse-admin), a Matrix user/room administration web interface

The configuration is designed for a private (i.e. not federated) server, for use inside your organization.

Matrix/Element features include:
- End-to-end encryption
- Interoperability with other messaging apps/services through [bridges](https://matrix.org/bridges/)
- Integration with other services through [bots and widgets](https://element.io/integrations)
- Web, desktop and mobile clients
- Secure device verification and authorization
- Public and private chats
- Chat room grouping/organization though Spaces
- Unlimited 1:1 and group voice and video calls

[![](https://gitlab.com/nodiscc/toolbox/-/raw/master/DOC/SCREENSHOTS/NphBOWR.png)](https://gitlab.com/nodiscc/toolbox/-/raw/master/DOC/SCREENSHOTS/NphBOWR.png)


## Requirements/dependencies/example playbook

See [meta/main.yml](meta/main.yml)

```yaml
# playbook.yml
- hosts: my.CHANGEME.org
  roles:
    - nodiscc.xsrv.common # (optional) base server setup, hardening, firewall
    - nodiscc.xsrv.monitoring # (optional) system/server monitoriong and health checks
    - nodiscc.xsrv.openldap # (optional) LDAP directory server
    - nodiscc.xsrv.backup # (optional) automatic backups of uploaded media files
    - nodiscc.xsrv.apache # (required in the standard configuration) webserver/reverse proxy, SSL certificates
    - nodiscc.xsrv.postgresql # (required) database engine
    - nodiscc.xsrv.matrix

# required variables
# host_vars/my.CHANGEME.org/my.CHANGEME.org.yml
matrix_synapse_fqdn: "matrix.CHANGEME.org"
matrix_element_fqdn: "chat.CHANGEME.org"

# ansible-vault edit host_vars/my.CHANGEME.org/my.CHANGEME.org.vault.yml
matrix_synapse_admin_user: "CHANGEME"
matrix_synapse_admin_password: "CHANGEME25"
matrix_synapse_db_password: "CHANGEME20"
matrix_synapse_registration_shared_secret: "CHANGEME25"
matrix_synapse_macaroon_secret_key: "CHANGEME25"
```

See [defaults/main.yml](defaults/main.yml) for all configuration variables.


## Usage

The matrix server can be used from the Element Web client which will be deployed at `https://{{ matrix_element_fqdn }}`, or any of the mobile or desktop [Matrix clients](https://matrix.org/clients/). Element is also available as an Android, iOS, Windows, Linux, MacOS application [here](https://element.io/download).

### User accounts management

An admin user (`matrix_synapse_admin_user`) is created during deployment. Public registration of new users is disabled by default, but server admins can create/deactivate and manage user accounts from the synapse-admin administration web interface at `https://{{ matrix_synapse_fqdn }}`.

Alternatively, the user/room management API can be accessed directly using `curl`:

<details>

**Create user accounts:**

```bash
# access the server over SSH
xsrv shell # using xsrv https://xsrv.readthedocs.io/en/latest/usage.html
ssh my.CHANGEME.org # using a SSH client
# create a new account
register_new_matrix_user --config /etc/matrix-synapse/homeserver.yaml --user USERNAME --password PASSWORD
```

**Deactivate user accounts:**

```bash
# access the server over SSH
xsrv shell # using xsrv https://xsrv.readthedocs.io/en/latest/usage.html
ssh my.CHANGEME.org # using a SSH client
# get the access token for your admin user
$ curl -X POST -data '{"type":"m.login.password", "user":"ADMIN_USERNAME", "password":"ADMIN_PASSWORD"}' "http://localhost:8008/_matrix/client/r0/login"
{"user_id":"@test:matrix-test.xinit.se","access_token":"syt_dGVzdA_egQMvgdyrhjosi9kslnlFT_0ue4W2","home_server":"matrix.CHANGEME.org","device_id":"OWYKMSGPGN"}
# send a request to deactivate the user, providing the admin access token
$ curl -X POST --header 'Authorization: Bearer syt_dGVzdA_egQMvgdyrhjosi9kslnlFT_0ue4W2' --data '{}' 'http://localhost:8008/_synapse/admin/v1/deactivate/%40SOMEONE%3Amatrix.CHANGEME.org'
{"id_server_unbind_result":"success"}
```

**Add/remove admin privileges for a user**:

```bash
# access the server over SSH
xsrv shell # using xsrv https://xsrv.readthedocs.io/en/latest/usage.html
ssh my.CHANGEME.org # using a SSH client
# access the postgresql database
$ sudo -u postgres psql --dbname=synapse
# list users and their admin privileges
synapse=# SELECT name,admin from USERS;
# add admin privileges to a user
synapse=# UPDATE users SET admin=1 WHERE name = '@USER:DOMAIN';
# or SET admin=0 to remove admin privileges
```
</details>

### Backups

See the included [rsnapshot configuration](templates/etc/rsnapshot.d_matrix.conf.j2) for information about directories to backup/restore.

## Tags

<!--BEGIN TAGS LIST-->
```
matrix - setup matrix chat server and web client
synapse - setup synapse (matrix) chat server
element - setup element matrix web chat client
synapse-admin - setup synapse-admin matrix administration web interface
```
<!--END TAGS LIST-->


## License

[GNU GPLv3](../../LICENSE)


## References

- https://stdout.root.sx/links/?searchterm=matrix&searchtags=communication
