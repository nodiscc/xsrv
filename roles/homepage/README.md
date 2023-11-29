# xsrv.homepage

This role will setup a simple webserver homepage/dashboard:
- Links to services installed on the host (if managed by xsrv [roles](https://xsrv.readthedocs.io/en/latest/#roles))
- [Custom links](#adding-custom-links)

[![](https://gitlab.com/nodiscc/toolbox/-/raw/master/DOC/SCREENSHOTS/oA8WG4e.png)](https://gitlab.com/nodiscc/toolbox/-/raw/master/DOC/SCREENSHOTS/oA8WG4e.png)


## Requirements/dependencies/example playbook

See [meta/main.yml](meta/main.yml)

```yaml
- hosts: my.CHANGEME.org
  roles:
    - nodiscc.xsrv.common # (optional) base server setup, hardening
    - nodiscc.xsrv.monitoring # (optional) system/server monitoring and health checks
    - nodiscc.xsrv.apache # (required in the standard configuration) web server and SSL/TLS certificates
    - nodiscc.xsrv.shaarli # (example) any supported role, a link to this application on the homepage will be added
    - nodiscc.xsrv.nextcloud # (example) any supported role, a link to this application on the homepage will be added
    - nodiscc.xsrv.homepage # the homepage role must be deployed *after* application roles

# required variables:
# host_vars/my.CHANGEME.org/my.CHANGEME.org.yml
homepage_fqdn: "www.CHANGEME.org"
```

See [defaults/main.yml](defaults/main.yml) for all configuration variables


## Usage

Access the homepage in a [web browser](https://www.mozilla.org/firefox/) at the URL/domain name defined by `{{ homepage_fqdn }}`.


### Adding custom links

You can add custom links using the [`homepage_custom_links`](defaults/main.yml) variable/list. For example:

```yaml
$ xsrv edit-host default my.example.org
homepage_custom_links:
  - url: https://dev.example.org
    title: dev.example.org
    description: "Development server 1"
  - url: https://cloud2.example.org
    title: Cloud2
    description: "Public file sharing server"
    icon: nextcloud
  - url: https://steamcommunity.com/chat/
    title: Steam Chat
    description: "Steam community web chat"
    icon: steam
  - url: https://mail.google.com/mail/u/0/#inbox
    title: Gmail
    icon: gmail
  - url: https://github.com/issues/assigned
    title: Github
    icon: github
```

You can use any of the [icons provided by this role](https://gitlab.com/nodiscc/xsrv/-/tree/master/roles/homepage/files/res) as value for the `icon:` key. If you wish to upload custom icons, you can create a custom role as a supplement to this one. See the [`nodiscc.toolbox.homepage_extra_icons`](https://gitlab.com/nodiscc/toolbox/-/tree/master/ARCHIVE/ANSIBLE-COLLECTION/roles/homepage_extra_icons) role for an example.

Icons must have a `.png` extension, and should have dimensions of 16x16px for a consistent appearance.


## Tags

<!--BEGIN TAGS LIST-->
```
homepage - setup simple webserver homepage
```
<!--END TAGS LIST-->


## License

[GNU GPLv3](../../LICENSE)


## References

- https://github.com/ThisIsDallas/Simple-Grid
