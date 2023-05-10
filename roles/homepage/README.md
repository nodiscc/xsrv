# xsrv.homepage

This role will setup a simple webserver homepage/dashboard:
- Links to services installed on the host (if managed by xsrv [roles](https://xsrv.readthedocs.io/en/latest/#roles))
- [Custom links](#adding-custom-links)

[![](https://i.imgur.com/oA8WG4e.png)](https://i.imgur.com/oA8WG4e.png)


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

You can add custom links using the `homepage_custom_links` variable (list). For example:

```yaml
$ xsrv edit-host default my.example.org
homepage_custom_links:
  - url: https://dev.example.org
    title: demo1.xinit.se
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

You can use any of the [icons provided by this role](https://gitlab.com/nodiscc/xsrv/-/tree/master/roles/homepage/files/res) as value for the `icon:` key. If you wish to upload custom icons, you can create a custom role as a supplement to this one:

```bash
$ tree roles/homepage-extra-icons/
roles/homepage-extra-icons/
├── files
│   ├── github.png
│   ├── gmail.png
│   └── steam.png
└── tasks
    └── main.yml
```

```yaml
$ cat roles/homepage-extra-icons/tasks/main.yml
- name: copy extra icons
  become: yes
  copy:
    src: roles/homepage-extra-icons/files/
    dest: "/var/www/{{ homepage_fqdn }}/res/"
    owner: root
    group: root
    mode: "0644"
  ignore_errors: "{{ ansible_check_mode }}"
  tags:
    - homepage
    - homepage-extra-icons
```

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
