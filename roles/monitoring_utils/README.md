# xsrv.monitoring_utils

This role will install and configure various [monitoring](../monitoring) and audit utilities:
- [lynis](https://cisofy.com/lynis/) security auditing tool
- [htop](https://hisham.hm/htop/) system monitor/process manager
- [nethogs](https://github.com/raboof/nethogs) network bandwidth monitor
- [ncdu](https://en.wikipedia.org/wiki/Ncdu) disk usage viewer
- [logwatch](https://sourceforge.net/projects/logwatch/) log analyzer
- (optional) [duc](https://duc.zevv.nl/) disk usage analyzer

[![](https://screenshots.debian.net/shrine/screenshot/14778/simage/small-452873bef369d0f5e75810ae017f68a8.png)](https://screenshots.debian.net/package/htop)
[![](https://screenshots.debian.net/shrine/screenshot/1778/simage/small-0c752cadb8feb5a6b61ce71ac57297de.png)](https://screenshots.debian.net/package/ncdu)
[![](https://screenshots.debian.net/shrine/screenshot/24326/simage/small-1167322e1240250cff9315a66de3a8be.png)](https://screenshots.debian.net/package/duc)

## Requirements/dependencies/example playbook

See [meta/main.yml](meta/main.yml)

```yaml
- hosts: my.CHANGEME.org
  roles:
    - nodiscc.xsrv.common # (optional) basic setup, hardening, firewall
    - nodiscc.xsrv.monitoring_utils
    # - nodiscc.xsrv.monitoring # (optional) full monitoring suite including monitoring_utils
```

See [defaults/main.yml](defaults/main.yml) for all configuration variables


## Usage

- Show htop process manager: `ssh -t user@my.CHANGEME.org sudo htop`
- Analyze disk usage by directory: `ssh -t user@my.CHANGEME.org sudo ncdu /`
- Show network bandwidth usage by process: `ssh -t user@my.CHANGEME.org sudo nethogs`
- Show network connections: `ssh -t user@my.CHANGEME.org sudo watch -n 2 ss -laptu`
- Visualize disk usage by directory: `TAGS=utils-duc xsrv deploy default my.CHANGEME.org` and run `duc gui --database=data/duc-my.CHANGEME.org.db /` on the controller (requires [duc](https://packages.debian.org/bookworm/duc))
- Use [lnav](https://lnav.readthedocs.io/) to navigate/search/filter aggregated system logs:

```bash
# using https://xsrv.readthedocs.io/en/latest/
xsrv logs [project] [host]
# using ssh
ssh -t user@my.CHANGEME.org sudo lnav /var/log/syslog
```

Useful lnav commands:
- `:filter-in <expression>` only display messages matching filter expression
- `:set-min-log-level debug|info|warning|error` only display messages above a defined log level.
- `:<TAB><TAB>` display internal command list
- `Ctrl+R` clear all filters/reset session
- `?` lnav help
- `q` exit lnav

To be able to read system logs as a non-root/sudoer user, add your user to the `adm` group. Example using the [../common](common) role:

```yaml
linux_users:
   - name: "{{ ansible_user }}"
     groups: adm
     append: yes
     comment: "ansible user/allowed to read system logs"
```


## Tags

<!--BEGIN TAGS LIST-->
```
lynis - setup lynis security audit tool
monitoring_utils - setup command-line/additional monitoring utilities
utils-duc - (manual) run duc disk usage analyzer and download the database on the controller
```
<!--END TAGS LIST-->


## License

[GNU GPLv3](../../LICENSE)


## References

- https://stdout.root.sx/links/?searchtags=monitoring
- https://stdout.root.sx/links/?searchtags=security
