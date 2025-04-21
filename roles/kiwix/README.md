# xsrv.kiwix

This role will install [kiwix](https://kiwix.org/), allowing you to serve a local copy of Wikipedia or other wikis from your server.

A demo instance of kiwix can be found at https://library.kiwix.org/

[![](https://gitlab.com/nodiscc/toolbox/-/raw/master/DOC/SCREENSHOTS/kiwix2.png)](https://gitlab.com/nodiscc/toolbox/-/raw/master/DOC/SCREENSHOTS/kiwix2.png)


## Requirements/dependencies/kiwix playbook

See [meta/main.yml](meta/main.yml)

```yaml
# playbook.yml
- hosts: my.CHANGEME.org
  roles:
    - nodiscc.xsrv.common # (optional) base server setup, hardening, firewall, bruteforce prevention
    - nodiscc.xsrv.monitoring # (optional) server monitoring, log aggregation
    - nodiscc.xsrv.backup # (optional) automatic backups
    - nodiscc.xsrv.apache # (required in the standard configuration) webserver/reverse proxy, SSL certificates
    - nodiscc.xsrv.kiwix

# required variables
# host_vars/my.CHANGEME.org/my.CHANGEME.org.yml
kiwix_fqdn: kiwix.CHANGEME.org
kiwix_zim_urls:
- https://download.kiwix.org/zim/wikipedia/wikipedia_en_all_maxi_2024-01.zim # 109GB, full english wikipedia
- https://download.kiwix.org/zim/wikipedia/wikipedia_fr_all_maxi_2024-05.zim # 37GB, full french wikipedia
- https://download.kiwix.org/zim/other/rationalwiki_en_all_maxi_2021-03.zim #116MB, rationalwiki.org
```

See [defaults/main.yml](defaults/main.yml) for all configuration variables.


## Usage


### Backups

See the included [rsnapshot configuration](templates/etc_rsnapshot.d_kiwix.conf.j2) for information about directories to backup/restore.

## Tags

<!--BEGIN TAGS LIST-->
```
```
<!--END TAGS LIST-->


## License

[GNU GPLv3](../../LICENSE)


## References

- https://stdout.root.sx/links/?searchterm=kiwix
