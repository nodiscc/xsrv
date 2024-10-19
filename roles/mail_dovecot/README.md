# xsrv.mail_dovecot

This role will install and configure [dovecot](https://en.wikipedia.org/wiki/Dovecot_(software)), an [IMAP](https://en.wikipedia.org/wiki/Internet_Message_Access_Protocol) mailbox server and [Mail Delivery agent](https://en.wikipedia.org/wiki/Message_delivery_agent), including:
- LDAP authentication
- SSL/TLS certificates (self-signed)
- (optional) login bruteforce protection with [fail2ban](../common)
- (optional) monitoring with [netdata](../monitoring_netdata)
- setup default mailbox virtual folders (All, Flagged, Sent, Junk, Drafts, Trash)


## Requirements/dependencies/example playbook

See [meta/main.yml](meta/main.yml)

```yaml
# playbook.yml
- hosts: my.CHANGEME.org
  roles:
    - nodiscc.xsrv.common # (optional) hardening, firewall, login bruteforce prevention
    - nodiscc.xsrv.monitoring # (optional) IMAP server monitoring
    - nodiscc.xsrv.backup # (optional) automatic local backups
    - nodiscc.xsrv.EXAMPLE

# required variables
# host_vars/my.CHANGEME.org/my.CHANGEME.org.yml
dovecot_fqdn: "imap.CHANGEME.org"
dovecot_ldap_uri: "ldap://ldap.CHANGEME.org"
dovecot_ldap_base: "ou=users,dc=CHANGEME,dc=org"
dovecot_ldap_bind_dn: "cn=bind,ou=system,dc=CHANGEME,dc=org"

# ansible-vault edit host_vars/my.CHANGEME.org/my.CHANGEME.org.vault.yml
dovecot_ldap_bind_password: "CHANGEME"
```

See [defaults/main.yml](defaults/main.yml) for all configuration variables.


## Usage

Dovecot does not send or receive e-mail by itself, it only allows you to access/manage mailboxes over IMAPS.

**Mail client configuration:** Configure e-mail clients such as [Thunderbird](https://en.wikipedia.org/wiki/Mozilla_Thunderbird) with the following settings:
- Host: the value of `dovecot_fqdn`
- Protocol: IMAP
- Port: 993
- Encryption: SSL/TLS
- Login method: Plain
- Username: LDAP account username or e-mail
- Password: LDAP password

**Migrating mail from other mailboxes:**
- Manual: Connect to both accounts from a desktop e-mail client  and manually move folders/messages from the old to the new account.
- See other [migration methods](https://doc.dovecot.org/admin_manual/migrating_mailboxes/)

**Self-signed certificates** may not work with all versions of Mozilla Thunderbird [[1]](https://bugzilla.mozilla.org/show_bug.cgi?id=1681960) (no dialog to add an exception/trust the certificate is shown during account creation/`SSL alert number 42`/`sslv3 alert bad certificate`).

### Backups

See the included [rsnapshot configuration](templates/etc_rsnapshot.d_dovecot.conf.j2) for information about directories to backup/restore.

### Uninstall

```bash
sudo apt purge dovecot-core dovecot-imapd dovecot-ldap
sudo rm -r /var/mail/vhosts/ /etc/dovecot/ /etc/ssl/certs/dovecot.crt
sudo firewall-cmd --remove-service=imaps --zone=public --permanent
sudo firewall-cmd --remove-service=imaps --zone=internal --permanent
sudo rm /etc/netdata/health.d/systemdunits.conf.d/dovecot.conf
sudo find /etc/netdata/health.d/systemdunits.conf.d/ -type f |sort | xargs sudo cat | sudo tee /etc/netdata/health.d/systemdunits.conf
sudo systemctl restart netdata
sudo systemctl reload firewalld
```


## Tags

<!--BEGIN TAGS LIST-->
```
dovecot - setup dovecot MDA/IMAP server
```
<!--END TAGS LIST-->


## License

[GNU GPLv3](../../LICENSE)


## References

- https://stdout.root.sx/links/?searchterm=EXAMPLE
