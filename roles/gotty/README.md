# xsrv.gotty

This role installs and configures [goTTY](https://github.com/sorenisanerd/gotty), a tool to access a server terminal as a web application.


[![](https://raw.githubusercontent.com/sorenisanerd/gotty/master/screenshot.gif)](https://raw.githubusercontent.com/sorenisanerd/gotty/master/screenshot.gif)

## Requirements/dependencies/example playbook

See [meta/main.yml](meta/main.yml)

```yaml
- hosts: my.CHANGEME.org
  roles:
    - nodiscc.xsrv.common # (optional) basic server setup/hardening, firewall, bruteforce prvention
    - nodiscc.xsrv.monitoring # (optional) server monitoring, log aggregation
    - nodiscc.xsrv.apache # webserver/reverse proxy, SSL certificates
    - nodiscc.xsrv.gotty

# required variables:
# host_vars/my.CHANGEME.org/my.CHANGEME.org.yml
gotty_fqdn: "tty.CHANGEME.org"
# ansible-vault edit host_vars/my.CHANGEME.org/my.CHANGEME.org.vault.yml
gotty_auth_username: "CHANGEME"
gotty_auth_password: "CHANGEME"
gotty_run_username: "CHANGEME"
```

See [defaults/main.yml](defaults/main.yml) for all configuration variables.


## Usage

Access gotty from a [web browser](https://www.mozilla.org/en-US/firefox/) at `https://$gotty_fqdn` and login using credentials configured in `gotty_auth_username/password`

<!--
### Troubleshooting
### Backups
## References/Documentation
-->

## License

[GNU GPLv3](../../LICENSE)

