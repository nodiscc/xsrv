# Change Log

All notable changes to this project will be documented in this file.
The format is based on [Keep a Changelog](http://keepachangelog.com/).

#### [v2.0.0](https://gitlab.com/nodiscc/xsrv/-/releases#2.0.0) - UNRELEASED

**Upgrade procedure:**

**BREAKING: monitoring roles refactoring:**
- update your playbook (`xsrv edit-playbook`):
  - remove the `nodiscc.xsrv.monitoring` and `nodiscc.xsrv.monitoring_netdata` roles from all your hosts
  - add the `nodiscc.xsrv.monitoring.utils`, `nodiscc.xsrv.monitoring.rsyslog` and `nodiscc.xsrv.monitoring.exporters` roles to all your hosts, early in the playbook
  - add the `nodiscc.xsrv.monitoring.victoriametrics` role to one of your hosts. This host will act as a central monitoring point and scrape metrics from all hosts where the `nodiscc.xsrv.monitoring.exporters` is deployed
  - add the `nodiscc.xsrv.monitoring.grafana` role to the same host as the victoriametrics role (but after the the `apache` role). This will provide visualizations/dashboards for metrics collected by victoriametrics
  - if present, rename `nodiscc.xsrv.monitoring_goaccess` to `nodiscc.xsrv.monitoring.goaccess`
  - make sure the host where victoriametrics is deployed, can access hosts where exporters are deployed on port 9999/tcp (NAT, firewalls)
  - update your hosts/groups (`xsrv edit-host/edit-group`) and remove all variables named `netdata_*`, use the equivalents listed below instead:
    - `netdata_allow_connections_from`: [`grafana_allowed_hosts`](https://gitlab.com/nodiscc/xsrv/-/blob/master/roles/monitoring/grafana/defaults/main.yml)
    - `netdata_http_checks`: [`victoriametrics_http_checks`](https://gitlab.com/nodiscc/xsrv/-/blob/master/roles/monitoring/victoriametrics/defaults/main.yml)
    - `netdata_x509_checks`: removed - use `victoriametrics_http_checks` instead, which includes automatic certificate validity/expiration time checks.
    - `netdata_port_checks`: removed, might be re-added later.
    - `netdata_fping_hosts`: removed, might be re-added later.
    - `netdata_firewalld_zones`: [`exporter_firewalld_zones`](https://gitlab.com/nodiscc/xsrv/-/blob/master/roles/monitoring/base/defaults/main.yml)

The `nodiscc.xsrv.monitoring.exporters` role will uninstall netdata and remove all its configuration files/historical data unless you explicitely set `netdata_uninstall: false`. You should remove all NAT/firewall rules allowing access to hosts on port 19999/tcp (netdata).

**Other changes:**
- **libvirt:** in [libvirt_port_forwards](https://gitlab.com/nodiscc/xsrv/-/blob/master/roles/libvirt/defaults/main.yml), move `*.dnat.*.host_interface` to the top-level list (same level as `vm_name`)
- **wireguard:** remove the `data/wireguard/` directory and its contents from your project directory since it is no longer used
- **wireguard:** if you had custom `routes` defined under `wireguard_peers`, update them to use the new list syntax

```diff
-#     routes: "1.2.3.4/32, 192.168.18.0/24"
+#     routes:
+#       - 1.2.3.4/32
+#       - 192.168.18.0/24
```

- `xsrv upgrade` to upgrade roles/ansible environments to the latest release
- `xsrv check` (optional) to simulate changes that will be applied
- `xsrv deploy` to apply changes

**Removed:**
- monitoring_netdata: remove role, [archive](https://gitlab.com/nodiscc/toolbox/-/tree/master/ARCHIVE/ANSIBLE-COLLECTION) it to separate repository
- monitoring_rsyslog: ensure logrotate is installed
- common/ssh: remove ability to revoke SSH keys globally using `ssh_server_revoked_keys`
- libvirt: remove ability to route/forward ports between bridges (`libvirt_port_forwards.*.forward`)
- libvirt: remove ability to forward ports using `host_ip` (only `host_interface` must be used)

**Added:**
- add [`monitoring.exporters`](roles/monitoring/exporters) role (monitoring agents/metrics exporters)
- add [`monitoring.victoriametrics`](roles/monitoring/victoriametrics/) role (monitoring metrics scraper and time-series database)
- add [`monitoring.grafana`](roles/monitoring/grafana) role (analytics and interactive visualization web application)
- add [`kiwix`](https://gitlab.com/nodiscc/xsrv/-/tree/master/roles/kiwix) role (offline viewer for Wikipedia and other wikis)
- common/firewalld: allow defining a manual IP address/network blocklist ([`firewalld_blocklist`](https://gitlab.com/nodiscc/xsrv/-/blob/master/roles/common/defaults/main.yml))
- searxng: allow protecting the web interface behind HTTP Basic authentication ([`searxng_auth_enabled/username/password`](https://gitlab.com/nodiscc/xsrv/-/blob/master/roles/searxng/defaults/main.yml))
- moodist/owncast/searxng/stirlingpdf: automatically remove unused podman images/containers, nightly (conserve disk space)
- wireguard: generate a QR code for each wireguard_peer containing the configuration (can be scanned with mobile apps such as WG Tunnel)
- common: make the value of `kernel.yama.ptrace_scope` configurable

**Changed:**
- rename `monitoring_utils` role to `monitoring.utils`
- rename `monitoring_rsyslog` role to `monitoring.rsyslog`
- rename `monitoring_goaccess` to `monitoring.goaccess`
- default playbook: only enable the common role by default, let user select which roles to enable
- common/firewalld: ensure ufw is removed before installing firewalld
- wireguard: allow specifying [`wireguard_peers`]((https://gitlab.com/nodiscc/xsrv/-/blob/master/roles/wireguard/defaults/main.yml) without a `public_key`, in which case a private/public key pair will be generated automatically on the server
- libvirt: use firewalld to manage port forwarding to libvirt VMs, remove direct iptables management
- wireguard: allow wireguard clients/peers traffic to flow out the default network interface by default (allows clients to tunnel all their internet traffic through the VPN)
- wireguard: allow wireguard peers to connect to the DNS service on the wireguard server by default
- wireguard: allow forwarding of wireguard peers network traffic to other zones by default (`wireguard_allow_forwarding: yes/no`)
- nextcloud: schedule start of maintenance window (resource intensive tasks) at 02:00
- ollama: pull `gemma3:4b` model by default
- ollama: disable installation of ollama-ui web interface by default
- searxng: allow returning results as JSON (add `&format=json` to URL parameters)
- searxng: increase sepiasearch search engine weight to 2
- searxng: increase wiby search engine weight to 1.2
- searxng: enable [searchmysite](https://searchmysite.net) search engine by default, increase weight to 2
- common: ssh: ensure ssh is automatically started at boot, disable socket activation
- common: ensure cron is installed
- monitoring.rsyslog: ensure logrotate is installed
- doc: gitea actions: document manually triggering a workflow from the actions page (workflow_dispatch)
- shaarli: update stack template to v0.12 [[1]](https://github.com/RolandTi/shaarli-stack/releases/tag/0.12) [[1]](https://github.com/RolandTi/shaarli-stack/releases/tag/0.12)
- shaarli: udpate to [v0.15.0](https://github.com/shaarli/Shaarli/releases/tag/v0.15.0)
- nextcloud: update to 30.0.17 [[1]](https://nextcloud.com/changelog/#latest29) [[2]](https://nextcloud.com/changelog/#latest30) [[3]](https://nextcloud.com/blog/nextcloud-hub9/)
- gitea: update to v1.24.7 [[1]](https://github.com/go-gitea/gitea/releases/tag/v1.23.5) [[2]](https://github.com/go-gitea/gitea/releases/tag/v1.23.6) [[3]](https://github.com/go-gitea/gitea/releases/tag/v1.23.7) [[4]](https://github.com/go-gitea/gitea/releases/tag/v1.23.8) [[5]](https://github.com/go-gitea/gitea/releases/tag/v1.24.0) [[6]](https://github.com/go-gitea/gitea/releases/tag/v1.24.1) [[7]](https://github.com/go-gitea/gitea/releases/tag/v1.24.2) [[8]](https://github.com/go-gitea/gitea/releases/tag/v1.24.3) [[9]](https://github.com/go-gitea/gitea/releases/tag/v1.24.4) [[10]](https://github.com/go-gitea/gitea/releases/tag/v1.24.5) [[11]](https://github.com/go-gitea/gitea/releases/tag/v1.24.6) [[12]](https://github.com/go-gitea/gitea/releases/tag/v1.24.7)
- owncast: update to v0.2.3 [[1]](https://github.com/owncast/owncast/releases/tag/v0.2.2) [[2]](https://github.com/owncast/owncast/releases/tag/v0.2.3)
- postgresql: update pgmetrics to v1.18.0 [[1]](https://github.com/rapidloop/pgmetrics/releases/tag/v1.17.1) [[2]](https://github.com/rapidloop/pgmetrics/releases/tag/v1.18.0)
- stirlingpdf: update to v1.5.0 [[1]](https://github.com/Stirling-Tools/Stirling-PDF/releases/tag/v0.44.0) [[2]](https://github.com/Stirling-Tools/Stirling-PDF/releases/tag/v0.44.1) [[3]](https://github.com/Stirling-Tools/Stirling-PDF/releases/tag/v0.44.2) [[4]](https://github.com/Stirling-Tools/Stirling-PDF/releases/tag/v0.44.3) [[5]](https://github.com/Stirling-Tools/Stirling-PDF/releases/tag/v0.45.0) [[6]](https://github.com/Stirling-Tools/Stirling-PDF/releases/tag/v0.45.1) [[7]](https://github.com/Stirling-Tools/Stirling-PDF/releases/tag/v0.45.2) [[8]](https://github.com/Stirling-Tools/Stirling-PDF/releases/tag/v0.45.3) [[9]](https://github.com/Stirling-Tools/Stirling-PDF/releases/tag/v0.45.4) [[10]](https://github.com/Stirling-Tools/Stirling-PDF/releases/tag/v0.45.5) [[11]](https://github.com/Stirling-Tools/Stirling-PDF/releases/tag/v0.45.11) [[12]](https://github.com/Stirling-Tools/Stirling-PDF/releases/tag/v0.46.0) [[13]](https://github.com/Stirling-Tools/Stirling-PDF/releases/tag/v0.46.1) [[14]](https://github.com/Stirling-Tools/Stirling-PDF/releases/tag/v0.46.2) [[15]](https://github.com/Stirling-Tools/Stirling-PDF/releases/tag/v1.0.0) [[16]](https://github.com/Stirling-Tools/Stirling-PDF/releases/tag/v1.0.1) [[17]](https://github.com/Stirling-Tools/Stirling-PDF/releases/tag/v1.0.2) [[18]](https://github.com/Stirling-Tools/Stirling-PDF/releases/tag/v1.1.0) [[19]](https://github.com/Stirling-Tools/Stirling-PDF/releases/tag/v1.2.0) [[20]](https://github.com/Stirling-Tools/Stirling-PDF/releases/tag/v1.2.0) [[21]](https://github.com/Stirling-Tools/Stirling-PDF/releases/tag/v1.3.0) [[22]](https://github.com/Stirling-Tools/Stirling-PDF/releases/tag/v1.3.1) [[23]](https://github.com/Stirling-Tools/Stirling-PDF/releases/tag/v1.3.2) [[24]](https://github.com/Stirling-Tools/Stirling-PDF/releases/tag/v1.4.0) [[25]](https://github.com/Stirling-Tools/Stirling-PDF/releases/tag/v1.5.0)
- ollama: update to [v0.12.6](https://github.com/ollama/ollama/releases)
- gotty: update to v1.6.0 [[1]](https://github.com/sorenisanerd/gotty/releases/tag/v1.5.1) [[2]](https://github.com/sorenisanerd/gotty/releases/tag/v1.6.0)
- ollama: pull `gemma3:4b` model by default
- ollama: disable installation of ollama-ui web interface by default
- searxng: allow returning results as JSON (add `&format=json` to URL parameters)
- searxng: increase sepiasearch search engine weight to 2
- searxng: increase wiby search engine weight to 1.2
- jellyfin: update opensubtitles plugin to v22.0.0
- searxng: enable [searchmysite](https://searchmysite.net) search engine by default, increase weight to 2
- matrix: update element-web to v1.12.2 [[1]](https://github.com/element-hq/element-web/releases/tag/v1.11.95) [[2]](https://github.com/element-hq/element-web/releases/tag/v1.11.96) [[3](-) [[4]](https://github.com/element-hq/element-web/releases/tag/v1.11.98) [[5]](https://github.com/element-hq/element-web/releases/tag/v1.11.99) [[6]](https://github.com/element-hq/element-web/releases/tag/v1.11.100) [[7]](https://github.com/element-hq/element-web/releases/tag/v1.11.101) [[8]](https://github.com/element-hq/element-web/releases/tag/v1.11.102) [[9]](https://github.com/element-hq/element-web/releases/tag/v1.11.103) [[10]](https://github.com/element-hq/element-web/releases/tag/v1.11.104) [[11]](https://github.com/element-hq/element-web/releases/tag/v1.11.105) [[12]](https://github.com/element-hq/element-web/releases/tag/v1.11.106) [[13]](https://github.com/element-hq/element-web/releases/tag/v1.11.107) [[13]](https://github.com/element-hq/element-web/releases/tag/v1.11.108) [[14]](https://github.com/element-hq/element-web/releases/tag/v1.11.109) [[15]](https://github.com/element-hq/element-web/releases/tag/v1.11.110) [[16]](https://github.com/element-hq/element-web/releases/tag/v1.11.111) [[17]](https://github.com/element-hq/element-web/releases/tag/v1.11.112) [[18]](https://github.com/element-hq/element-web/releases/tag/v1.12.0) [[19]](https://github.com/element-hq/element-web/releases/tag/v1.12.1) [[20]](https://github.com/element-hq/element-web/releases/tag/v1.12.1)
- matrix: update synapse-admin to v0.11.0 [[1]](https://github.com/Awesome-Technologies/synapse-admin/releases/tag/0.11.0) [[2]](https://github.com/Awesome-Technologies/synapse-admin/releases/tag/0.10.4)
- openldap: update ldap-account-manager to v9.2 [[1]](https://github.com/LDAPAccountManager/lam/releases/tag/9.0) [[2]](https://github.com/LDAPAccountManager/lam/releases/tag/9.1) [[3]](https://github.com/LDAPAccountManager/lam/releases/tag/9.2)
- openldap: upgrade self-service-password to [v1.7.3](https://github.com/ltb-project/self-service-password/releases/tag/v1.7.3)
- xsrv: update ansible to v11.11.0 [[1]](https://github.com/ansible-community/ansible-build-data/blob/main/11/CHANGELOG-v11.rst)
- xsrv: update trivy security scanner to [v0.66.0](https://github.com/aquasecurity/trivy/releases)
- gitea_act_runner: update act-runner to v0.2.12 [[1]](https://gitea.com/gitea/act_runner/releases/tag/v0.2.12)
- goaccess: update IP to Country GeoIP database, adjust version number automatically base on current date
- common: ssh: ensure ssh is automatically started at boot, disable socket activation
- common: ensure cron is installed
- common/apt: make unattended-upgrades configuration and sources.list file compatible with Debian 13
- doc: gitea actions: document manually triggering a workflow from the actions page (workflow_dispatch)
- doc: update comments in several files to reflect new documentation in Debian 13
- update documentation

**Fixed:**
- tt-rss: switch git repository to mirror on https://gitlab.com/nodiscc/tt-rss (upstream repository removed)
- tt-rss: `clone/upgrade tt-rss` task no longer always returns changed (pin version to latest commit from upstream)
- searxng: remove engines that no longer exist from config file, fix warnings in logs
- jitsi: fix apt prosody apt repository failing to update with `The following signatures couldn't be verified because the public key is not available: NO_PUBKEY F7A37EB33D0B25D7`
- matrix: update APT repository signing key (the previous key has expired)
- postgresql: fix `'postgresql_version' is undefined` error when running the `monitoring` tag alone
- wireguard: really delete peers and associated keys/configuration when [`wireguard_peers[*].state`](https://gitlab.com/nodiscc/xsrv/-/blob/master/roles/wireguard/defaults/main.yml) is set to `absent`
- shaarli: fix missing php extension php-xml
- nextcloud: fix `trusted_proxies is not correctly defined` warning in admin area

[Full changes since v1.27.0](https://gitlab.com/nodiscc/xsrv/-/compare/1.27.0...1.28.0)

------------------


#### [v1.27.0](https://gitlab.com/nodiscc/xsrv/-/releases#1.27.0) - 2025-03-02

**Upgrade procedure:**
- `xsrv self-upgrade` to upgrade the xsrv script
- `xsrv upgrade` to upgrade roles/ansible environments to the latest release
- `xsrv deploy` to apply changes
- netdata: if you run into the error `No available installation candidate` during netdata packages installation/downgrade, please SSH to your server (`xsrv ssh`) and downgrade packages manually:

```bash
sudo apt install netdata-dashboard=2.1.1 netdata-plugin-apps=2.1.1 netdata-plugin-chartsd=2.1.1 netdata-plugin-debugfs=2.1.1 netdata-plugin-ebpf=2.1.1 netdata-plugin-go=2.1.1 netdata-plugin-nfacct=2.1.1 netdata-plugin-perf=2.1.1 netdata-plugin-pythond=2.1.1 netdata-plugin-slabinfo=2.1.1 netdata=2.1.1
```

**Added:**
- owncast: allow protecting the web interface behind HTTP Basic authentication ([`owncast_auth_enabled/username/password`](https://gitlab.com/nodiscc/xsrv/-/blob/master/roles/owncast/defaults/main.yml))

**Changed:**
- nextcloud: upgrade to v29.0.12 [[1]](https://nextcloud.com/changelog/) [[2](https://nextcloud.com/blog/nextcloud-hub8/)]
- gitea: upgrade to v1.23.4 [[1]](https://github.com/go-gitea/gitea/releases/tag/v1.23.0) [[2]](https://github.com/go-gitea/gitea/releases/tag/v1.23.1) [[3]](https://github.com/go-gitea/gitea/releases/tag/v1.23.2) [[4]](https://github.com/go-gitea/gitea/releases/tag/v1.23.3) [[5]](https://github.com/go-gitea/gitea/releases/tag/v1.23.4)
- openldap: upgrade self-service-password to [v1.7.2](https://github.com/ltb-project/self-service-password/releases/tag/v1.7.2)
- homepage/readme_gen: link directly to the netdata v3 dashboard, skip 'welcome'/sign-in page
- stirlingpdf: upgrade to v0.43.2 [[1]](https://github.com/Stirling-Tools/Stirling-PDF/releases/tag/v0.37.0) [[2]](https://github.com/Stirling-Tools/Stirling-PDF/releases/tag/v0.37.1) [[3]](https://github.com/Stirling-Tools/Stirling-PDF/releases/tag/v0.38.0) [[4]](https://github.com/Stirling-Tools/Stirling-PDF/releases/tag/v0.39.0) [[5]](https://github.com/Stirling-Tools/Stirling-PDF/releases/tag/v0.40.0) [[6]](https://github.com/Stirling-Tools/Stirling-PDF/releases/tag/v0.40.1) [[7]](https://github.com/Stirling-Tools/Stirling-PDF/releases/tag/v0.40.2) [[8]](https://github.com/Stirling-Tools/Stirling-PDF/releases/tag/v0.41.0) [[9]](https://github.com/Stirling-Tools/Stirling-PDF/releases/tag/v0.42.0) [[10]](https://github.com/Stirling-Tools/Stirling-PDF/releases/tag/v0.43.0) [[11]](https://github.com/Stirling-Tools/Stirling-PDF/releases/tag/v0.43.1) [[12]](https://github.com/Stirling-Tools/Stirling-PDF/releases/tag/v0.43.2)
- netdata: pin version to v2.1.1, further versions artifically limit the number of nodes that can be accessed from the web dashboard [[1]](https://community.netdata.cloud/t/suddenly-local-dashboard-is-limited-to-5-nodes/)
- netdata: send all alerts to the 'sysadmin' recipent by default (root)
- netdata: disable systemd-journal log collection module by default ([`netdata_disabled_plugins`](https://gitlab.com/nodiscc/xsrv/-/blob/master/roles/monitoring_netdata/defaults/main.yml))
- netdata: allow defining different access control lists from dashboard access and streaming ([`netdata_allow_dashboard_from/netdata_allow_streaming_from`](https://gitlab.com/nodiscc/xsrv/-/blob/master/roles/monitoring_netdata/defaults/main.yml))
- xsrv: update trivy security scanner to [v0.59.1](https://github.com/aquasecurity/trivy/releases)
- xsrv: update ansible to v11.3.0 [[1]](https://github.com/ansible-community/ansible-build-data/blob/main/11/CHANGELOG-v11.rst)
- matrix: update element-web to v1.11.91 [[1]](https://github.com/vector-im/element-web/releases/tag/v1.11.90) [[2]](https://github.com/vector-im/element-web/releases/tag/v1.11.91) [[3]](https://github.com/vector-im/element-web/releases/tag/v1.11.92) [[4]](https://github.com/vector-im/element-web/releases/tag/v1.11.93) [[5]](https://github.com/vector-im/element-web/releases/tag/v1.11.94)
- owncast: update to v0.2.1 [[1]](https://github.com/owncast/owncast/releases/tag/v0.2.1) [[2]](https://github.com/owncast/owncast/releases/tag/v0.2.0)
- goaccess: update IP to Country GeoIP database to v2025-02

**Fixed:**
- owncast: fix occasional `Job for container-owncast.service failed because the service did not take the steps required by its unit configuration.` error during service restart

[Full changes since v1.26.0](https://gitlab.com/nodiscc/xsrv/-/compare/1.26.0...1.27.0)

------------------

#### [v1.26.0](https://gitlab.com/nodiscc/xsrv/-/releases#1.26.0) - 2025-01-06

**Upgrade procedure:**
- `xsrv self-upgrade` to upgrade the xsrv script
- `xsrv upgrade` to upgrade roles/ansible environments to the latest release
- monitoring_netdata: if you had changed the default value of `netdata_dbengine_disk_space` in your host/group configuration, remove this variable and configure [`netdata_dbengine_tier0/1/2_retention_days`](https://gitlab.com/nodiscc/xsrv/-/blob/master/roles/monitoring_netdata/defaults/main.yml) instead
- `xsrv deploy` to apply changes

**Added:**
- add [`searxng`](https://gitlab.com/nodiscc/xsrv/-/tree/master/roles/searxng) role (metasearch engine)

**Changed:**
- monitoring_netdata: define maximum metrics retention in days (`netdata_dbengine_tier0/1/2_retention_days`) instead of MB (default to 7 days of per-second data, 30 days of per-minute data, 730 days of per-hour data)
- gitea: make router logs less verbose (warnings only)
- gitea: upgrade to v1.22.6 [[1]](https://github.com/go-gitea/gitea/releases/tag/v1.22.4) [[2]](https://github.com/go-gitea/gitea/releases/tag/v1.22.5) [[3]](https://github.com/go-gitea/gitea/releases/tag/v1.22.6)
- nextcloud: upgrade to v28.0.14 [[1]](https://nextcloud.com/changelog/)
- shaarli: upgrade to [v0.14.0](https://github.com/shaarli/Shaarli/releases/tag/v0.14.0)
- stirlingpdf: pin version and upgrade to v0.36.6 [[1]](https://github.com/Stirling-Tools/Stirling-PDF/releases/tag/v0.30.1) [[2]](https://github.com/Stirling-Tools/Stirling-PDF/releases/tag/v0.31.0) [[3]](https://github.com/Stirling-Tools/Stirling-PDF/releases/tag/v0.31.1) [[4]](https://github.com/Stirling-Tools/Stirling-PDF/releases/tag/v0.32.0) [[5]](https://github.com/Stirling-Tools/Stirling-PDF/releases/tag/v0.33.0) [[6]](https://github.com/Stirling-Tools/Stirling-PDF/releases/tag/v0.33.1) [[7]](https://github.com/Stirling-Tools/Stirling-PDF/releases/tag/v0.34.0) [[8]](https://github.com/Stirling-Tools/Stirling-PDF/releases/tag/v0.35.0) [[9]](https://github.com/Stirling-Tools/Stirling-PDF/releases/tag/v0.35.1) [[10]](https://github.com/Stirling-Tools/Stirling-PDF/releases/tag/v0.36.0) [[11]](https://github.com/Stirling-Tools/Stirling-PDF/releases/tag/v0.36.1) [[12]](https://github.com/Stirling-Tools/Stirling-PDF/releases/tag/v0.36.2) [[13]](https://github.com/Stirling-Tools/Stirling-PDF/releases/tag/v0.36.3) [[14]](https://github.com/Stirling-Tools/Stirling-PDF/releases/tag/v0.36.4) [[15]](https://github.com/Stirling-Tools/Stirling-PDF/releases/tag/v0.36.5) [[16]](https://github.com/Stirling-Tools/Stirling-PDF/releases/tag/v0.36.6)
- owncast: pin version to [v0.1.3](https://github.com/owncast/owncast/releases)
- openldap: update self-service-password to v1.7.1 [[1]](https://github.com/ltb-project/self-service-password/releases/tag/v1.7.0) [[2]](https://github.com/ltb-project/self-service-password/releases/tag/v1.7.1)
- openldap: update ldap-account-manager to [v8.9](https://github.com/LDAPAccountManager/lam/releases/tag/8.9)
- matrix: update element-web to v1.11.89 [[1]](https://github.com/vector-im/element-web/releases/tag/v1.11.78) [[2]](https://github.com/vector-im/element-web/releases/tag/v1.11.79) [[3]](https://github.com/vector-im/element-web/releases/tag/v1.11.80) [[4]](https://github.com/vector-im/element-web/releases/tag/v1.11.81) [[4]](https://github.com/vector-im/element-web/releases/tag/v1.11.82) [[5]](https://github.com/vector-im/element-web/releases/tag/v1.11.83) [[6]](https://github.com/vector-im/element-web/releases/tag/v1.11.84) [[7]](https://github.com/vector-im/element-web/releases/tag/v1.11.85) [[8]](https://github.com/element-hq/element-web/releases/tag/v1.11.86) [[9]](https://github.com/element-hq/element-web/releases/tag/v1.11.87) [[10](https://github.com/element-hq/element-web/releases/tag/v1.11.88) [[11]](https://github.com/element-hq/element-web/releases/tag/v1.11.89)
- shaarli: update stack template to v0.10 [[1]](https://github.com/RolandTi/shaarli-stack/releases/tag/0.9) [[2]](https://github.com/RolandTi/shaarli-stack/releases/tag/0.10)
- goaccess: update IP to Country GeoIP database to v2024-11
- xsrv: update ansible to v11.1.0 [[1](https://github.com/ansible-community/ansible-build-data/blob/main/9/CHANGELOG-v9.rst) [[2]](https://github.com/ansible-community/ansible-build-data/blob/main/10/CHANGELOG-v10.rst) [[3]](https://github.com/ansible-community/ansible-build-data/blob/main/11/CHANGELOG-v11.rst)
- xsrv: update trivy security scanner to [v0.58.0](https://github.com/aquasecurity/trivy/releases)
- homepage: minor style tweaks
- update documentation

**Fixed:**
- jellyfin: fix jellyfin not upgrading automatically from v10.9 to v10.10
- podman: fix inability to restart systemd user services using `systemctl`
- owncast: fix deployment always restaring the service/always returning `changed` on `generate systemd unit file for owncast container`
- moodist, owncast, stirlingpdf: fix OCI image not updated to latest version on re-deployment
- owncast: fix container/service not restarting after upgrades
- netdata: fix netdata unable to determine podman container names

[Full changes since v1.25.1](https://gitlab.com/nodiscc/xsrv/-/compare/1.25.1...1.26.0)

------------------

#### [v1.25.1](https://gitlab.com/nodiscc/xsrv/-/releases#1.25.1) - 2024-10-19

**Upgrade procedure:**
- `xsrv upgrade` to upgrade roles/ansible environments to the latest release
- `xsrv deploy` to apply changes

**Fixed:**
- moodist: fix variable name ([`moodist_https_mode`](https://gitlab.com/nodiscc/xsrv/-/blob/master/roles/moodist/defaults/main.yml))

[Full changes since v1.25.0](https://gitlab.com/nodiscc/xsrv/-/compare/1.25.0...1.25.1)

------------------

#### [v1.25.0](https://gitlab.com/nodiscc/xsrv/-/releases#1.25.0) - 2024-10-19

**Upgrade procedure:**
- `xsrv self-upgrade` to upgrade the xsrv script
- `xsrv upgrade` to upgrade roles/ansible environments to the latest release
- `xsrv deploy` to apply changes

**Added:**
- add [`stirlingpdf`](https://gitlab.com/nodiscc/xsrv/-/tree/master/roles/stirlingpdf) role (PDF manipulation tools)
- add [`moodist`](https://gitlab.com/nodiscc/xsrv/-/tree/master/roles/moodist) role (ambient sound mixer)
- libvirt: enable [KSM](https://packages.debian.org/bookworm/ksmtuned) (VM memory deduplication)

**Changed:**
- shaarli: increase default max memory size for php-fpm pool to 256MB
- nextcloud: upgrade to v28.0.11 [[1]](https://nextcloud.com/changelog/)
- gitea: upgrade to v1.22.3 [[1]](https://github.com/go-gitea/gitea/releases/tag/v1.22.0) [[2]](https://github.com/go-gitea/gitea/releases/tag/v1.22.1) [[3]](https://github.com/go-gitea/gitea/releases/tag/v1.22.2) [[4]](https://github.com/go-gitea/gitea/releases/tag/v1.22.3)
- ollama: upgrade to v0.3.5 [[1]](https://github.com/ollama/ollama/releases/tag/v0.1.34) [[2]](https://github.com/ollama/ollama/releases/tag/v0.1.35) [[3]](https://github.com/ollama/ollama/releases/tag/v0.1.36) [[4]](https://github.com/ollama/ollama/releases/tag/v0.1.37) [[5]](https://github.com/ollama/ollama/releases/tag/v0.1.38) [[6]](https://github.com/ollama/ollama/releases/tag/v0.1.39) [[7]](https://github.com/ollama/ollama/releases/tag/v0.1.40) [[8]](https://github.com/ollama/ollama/releases/tag/v0.1.41) [[9]](https://github.com/ollama/ollama/releases/tag/v0.1.42) [[10]](https://github.com/ollama/ollama/releases/tag/v0.1.43) [[11]](https://github.com/ollama/ollama/releases/tag/v0.1.44) [[12]](https://github.com/ollama/ollama/releases/tag/v0.1.45) [[13]](https://github.com/ollama/ollama/releases/tag/v0.1.46) [[14]](https://github.com/ollama/ollama/releases/tag/v0.1.47) [[15]](https://github.com/ollama/ollama/releases/tag/v0.1.48) [[16]](https://github.com/ollama/ollama/releases/tag/v0.1.49) [[17]](https://github.com/ollama/ollama/releases/tag/v0.2.0) [[18]](https://github.com/ollama/ollama/releases/tag/v0.2.2) [[19]](https://github.com/ollama/ollama/releases/tag/v0.2.3) [[20]](https://github.com/ollama/ollama/releases/tag/v0.2.4) [[21]](https://github.com/ollama/ollama/releases/tag/v0.2.5) [[22]](https://github.com/ollama/ollama/releases/tag/v0.2.6) [[23]](https://github.com/ollama/ollama/releases/tag/v0.2.7) [[24]](https://github.com/ollama/ollama/releases/tag/v0.2.8) [[25]](https://github.com/ollama/ollama/releases/tag/v0.3.0) [[26]](https://github.com/ollama/ollama/releases/tag/v0.3.1) [[27]](https://github.com/ollama/ollama/releases/tag/v0.3.2) [[28]](https://github.com/ollama/ollama/releases/tag/v0.3.3) [[29]](https://github.com/ollama/ollama/releases/tag/v0.3.4) [[30]](https://github.com/ollama/ollama/releases/tag/v0.3.5) [[31]](https://github.com/ollama/ollama/releases/tag/v0.3.6)
- ollama: upgrade ollama-ui to the latest version [[1]](https://github.com/ollama-ui/ollama-ui/compare/d43171206aa3ea38b4c9f17e50044000c03fc175...ada8d50707fd704528ead13e87d1ec05fdd97492)
- matrix: update element-web to v1.11.77 [[1]](https://github.com/vector-im/element-web/releases/tag/v1.11.67) [[1]](https://github.com/vector-im/element-web/releases/tag/v1.11.68) [[3]](https://github.com/vector-im/element-web/releases/tag/v1.11.69) [[4]](https://github.com/vector-im/element-web/releases/tag/v1.11.70) [[5]](https://github.com/vector-im/element-web/releases/tag/v1.11.71) [[6]](https://github.com/vector-im/element-web/releases/tag/v1.11.72) [[7]](https://github.com/vector-im/element-web/releases/tag/v1.11.73) [[8]](https://github.com/vector-im/element-web/releases/tag/v1.11.74) [[9]](https://github.com/element-hq/element-web/releases/tag/v1.11.75) [[10]](https://github.com/element-hq/element-web/releases/tag/v1.11.76) [[11]](https://github.com/element-hq/element-web/releases/tag/v1.11.77)
- openldap: update ldap-account-manager to [v8.8](https://github.com/LDAPAccountManager/lam/releases/tag/8.8)
- matrix: update synapse-admin to v0.10.3 [[1]](https://github.com/Awesome-Technologies/synapse-admin/compare/0.10.1...0.10.3)
- postgresql: update pgmetrics to [v1.17.0](https://github.com/rapidloop/pgmetrics/releases/tag/v1.17.0)
- goaccess: update IP to Country GeoIP database to v2024-09
- xsrv: update ansible to v10.5.0 [[1](https://github.com/ansible-community/ansible-build-data/blob/main/9/CHANGELOG-v9.rst) [[2]](https://github.com/ansible-community/ansible-build-data/blob/main/10/CHANGELOG-v10.rst)
- netdata: install/upgrade netdata from new self-hosted repositories [[1]](https://learn.netdata.cloud/docs/netdata-agent/installation/linux/native-linux-distribution-packages)
- netdata: make role compatible with Ubuntu 22.04
- improve test tools

**Fixed:**
- netdata: fix netdata not upgrading automatically from 1.45.6 to later versions
- jellyfin: fix jellyfin not upgrading automtically from 10.8.13 to 10.9.2
- wireguard: really delete peers from the configuration when [`wireguard_peers[*].state`](https://gitlab.com/nodiscc/xsrv/-/blob/master/roles/wireguard/defaults/main.yml) is set to `absent`
- wireguard: fix variable checks for [`wireguard_peers`](https://gitlab.com/nodiscc/xsrv/-/blob/master/roles/wireguard/defaults/main.yml) with `state: absent` and no `public_key` defined
- postgresql: rsyslog: fix postgresql log messages incorrectly tagged as `mongodb` in syslog
- openldap: fix ldap-account-manager download failing with `urlopen error timed out`
- gitea_act_runner: fix runner failing to register with `[E] Deprecated config option [oauth2].ENABLE is present, please use [oauth2].ENABLED instead`

[Full changes since v1.24.0](https://gitlab.com/nodiscc/xsrv/-/compare/1.24.0...1.25.0)

------------------

#### [v1.24.0](https://gitlab.com/nodiscc/xsrv/-/releases#1.24.0) - 2024-05-09

**Upgrade procedure:**
- `xsrv upgrade` to upgrade roles/ansible environments to the latest release
- `xsrv deploy` to apply changes

**Added:**
- add [`ollama`](https://gitlab.com/nodiscc/xsrv/-/tree/master/roles/ollama) role (local Large Language Model (LLM) server and web interface)
- monitoring_utils: add [bonnie++](https://doc.coker.com.au/projects/bonnie/) disk benchmarking tool and automated report script (`TAGS=utils-bonnie xsrv deploy`)

**Changed:**
- nextcloud: upgrade to v28.0.5 [[1]](https://nextcloud.com/changelog/) [[2]](https://github.com/nextcloud/server/releases/tag/v28.0.5)
- gitea: update to v1.21.11 [[1]](https://github.com/go-gitea/gitea/releases/tag/v1.21.8) [[2]](https://github.com/go-gitea/gitea/releases/tag/v1.21.9) [[3]](https://github.com/go-gitea/gitea/releases/tag/v1.21.10) [[4]](https://github.com/go-gitea/gitea/releases/tag/v1.21.11)
- gitea_act_runner: update act-runner to v0.2.10 [[1]](https://gitea.com/gitea/act_runner/releases/tag/v0.2.7) [[2]](https://gitea.com/gitea/act_runner/releases/tag/v0.2.8) [[3]](https://gitea.com/gitea/act_runner/releases/tag/v0.2.9) [[4]](https://gitea.com/gitea/act_runner/releases/tag/v0.2.10)
- openldap: update ldap-account-manager to [v8.7](https://github.com/LDAPAccountManager/lam/releases/tag/8.7)
- openldap: update self-service-password to v1.6.1 [[1]](https://github.com/ltb-project/self-service-password/releases/tag/v1.6.0) [[2]](https://github.com/ltb-project/self-service-password/releases/tag/v1.6.1)
- matrix: update element-web to v1.11.66 [[1]](https://github.com/vector-im/element-web/releases/tag/v1.11.61) [[2]](https://github.com/vector-im/element-web/releases/tag/v1.11.62) [[3]](https://github.com/vector-im/element-web/releases/tag/v1.11.63) [[4]](https://github.com/vector-im/element-web/releases/tag/v1.11.64) [[5]](https://github.com/element-hq/element-web/releases/tag/v1.11.65) [[6]](https://github.com/vector-im/element-web/releases/tag/v1.11.66)
- shaarli: update stack template to v0.8 [[1]](https://github.com/RolandTi/shaarli-stack/releases/tag/0.8)
- matrix: update synapse-admin to v0.10.1 [[1]](https://github.com/Awesome-Technologies/synapse-admin/compare/0.9.1...0.10.1)
- xsrv: update ansible to [v9.5.1](https://github.com/ansible-community/ansible-build-data/blob/main/9/CHANGELOG-v9.rst)

**Fixed:**
- handlers: fix recursion loop in `handlers/meta/main.yml`
- all roles/apache: ensure apache is restarted (not just reloaded) when new modules are loaded
- graylog: make syslog certificate generation idempotent (add [`graylog_cert_not_before/after`](https://gitlab.com/nodiscc/xsrv/-/blob/master/roles/graylog/defaults/main.yml) variables)
- matrix: fix broken version number comparison leading to error `'matrix_synapse_admin_action' is undefined.`

[Full changes since v1.23.0](https://gitlab.com/nodiscc/xsrv/-/compare/1.23.0...1.24.0)

------------------

#### [v1.23.0](https://gitlab.com/nodiscc/xsrv/-/releases#1.23.0) - 2024-04-09

**Upgrade procedure:**
- `xsrv self-upgrade` to upgrade the xsrv script
- `xsrv upgrade` to upgrade roles/ansible environments to the latest release
- **monitoring_netdata:** `netdata_log_to_syslog`, `netdata_disable_debug_log`, `netdata_disable_error_log`, `netdata_disable_access_log` variables are no longer used and can be removed from your configuration, if you changed them from the defaults (`xsrv edit-host/edit-group`)
- **monitoring_rsyslog:** if `rsyslog_enable_forwarding` is set to `yes` in your host/group variables (`xsrv edit-host/edit-group`), set `rsyslog_forward_to_inventory_hostname` to the inventory hostname of the syslog/graylog server receiving the logs
- **graylog:** under `Inputs`, edit all `syslog/TLS` inputs to use the new paths for TLS cert file: `/etc/ssl/syslog/ca.crt`, TLS private key: `/etc/ssl/syslog/ca.key`, TLS client auth trusted certs: `/etc/ssl/syslog/ca.crt`. You may also delete `data/certificates/*-graylog-ca.crt` files in your project directory since they are no longer used.
- `xsrv deploy` to apply changes

**Added:**
- xsrv: add [`scan`](https://xsrv.readthedocs.io/en/latest/usage.html#xsrv-scan) command (scan a project directory for cleartext secrets/passwords using [trivy](https://github.com/aquasecurity/trivy))
- xsrv: add [`show-groups`](https://xsrv.readthedocs.io/en/latest/usage.html#xsrv-show-groups) command (list all groups a host is a member of)
- monitoring_rsyslog: allow receiving logs from syslog clients over the network on port `514/tcp` ([`rsyslog_enable_receive: no/yes`](https://gitlab.com/nodiscc/xsrv/-/blob/master/roles/monitoring_rsyslog/defaults/main.yml))

**Removed:**
- monitoring_netdata: remove configuration variables `netdata_log_to_syslog`, `netdata_disable_debug_log`, `netdata_disable_error_log`, `netdata_disable_access_log`

**Changed:**
- gitea_act_runner: disable automatic nightly prune of podman images/containers by default [`gitea_act_runner_daily_podman_prune: no/yes`](https://gitlab.com/nodiscc/xsrv/-/blob/master/roles/gitea_act_runner/defaults/main.yml)
- monitoring_netdata: send all logs to systemd-journald, except access log
- monitoring_netdata: disable machine learning/anomaly detection functionality when streaming to a parent node (when [`netdata_streaming_send_enabled`](https://gitlab.com/nodiscc/xsrv/-/blob/master/roles/monitoring_netdata/defaults/main.yml) is enabled)
- shaarli: allow setting the default view mode when using the `stack` template ([`shaarli_stack_default_ui: small/medium/large`](https://gitlab.com/nodiscc/xsrv/-/blob/master/roles/shaarli/defaults/main.yml)), change the default to `medium`
- monitoring_rsyslog/graylog: setup mutual TLS authentication between syslog clients and server, sign server and client certificates with server CA certificate - [`rsyslog_forward_to_inventory_hostname`](https://gitlab.com/nodiscc/xsrv/-/blob/master/roles/monitoring_rsyslog/defaults/main.yml) is now required on rsyslog clients
- common: apt: enable non-free-firmware section when [`apt_enable_nonfree: yes`](https://gitlab.com/nodiscc/xsrv/-/blob/master/roles/common/defaults/main.yml) [[1]](https://wiki.debian.org/Firmware)
- gitea: update to v1.21.7 [[1]](https://github.com/go-gitea/gitea/releases/tag/v1.21.6) [[2]](https://github.com/go-gitea/gitea/releases/tag/v1.21.7)
- nextcloud: upgrade to v28.0.4 [[1]](https://nextcloud.com/changelog/) [[2]](https://github.com/nextcloud/server/releases/tag/v28.0.3) [[3]](https://github.com/nextcloud/server/releases/tag/v28.0.4)
- shaarli: update stack template to v0.7 [[1]](https://github.com/RolandTi/shaarli-stack/releases/tag/0.6) [[2]](https://github.com/RolandTi/shaarli-stack/releases/tag/0.7)
- matrix: update synapse-admin to [v0.9.1](https://github.com/Awesome-Technologies/synapse-admin/compare/0.8.7...0.9.1)
- matrix: update element-web to v1.11.60 [[1]](https://github.com/vector-im/element-web/releases/tag/v1.11.58) [[2]](https://github.com/vector-im/element-web/releases/tag/v1.11.59) [[3]](https://github.com/vector-im/element-web/releases/tag/v1.11.60)
- xsrv: update ansible to [v9.3.0](https://github.com/ansible-community/ansible-build-data/blob/main/9/CHANGELOG-v9.rst)
- cleanup: standardize task names, remove files from old versions of the roles, use `community.crypto.x509_certificate` instead of deprecated `openssl_certificate` modules
- update documentation, add Gitea/Github Actions example for secret scanning, add graylog backup restoration procedure
- improve automatic tests

**Fixed:**
- monitoring_netdata/rsyslog: fix netdata logs no longer being appended to syslog
- shaarli: fix stack theme favicon not being displayed
- postgresql: fix role execution when called with `rsyslog` ansible tag 

[Full changes since v1.22.0](https://gitlab.com/nodiscc/xsrv/-/compare/1.22.0...1.23.0)

------------------

#### [v1.22.0](https://gitlab.com/nodiscc/xsrv/-/releases#1.22.0) - 2024-02-03

**Upgrade procedure:**
- `xsrv self-upgrade` to upgrade the xsrv script
- `xsrv upgrade` to upgrade roles/ansible environments to the latest release
- `xsrv deploy` to apply changes

**Added:**
- add [`nmap`](https://gitlab.com/nodiscc/xsrv/-/tree/master/roles/nmap) command and role - run nmap network scanner against hosts from the inventory

**Changed:**
- graylog: support initial deployment of the role with graylog/mongodb/elasticsearch disabled
- gitea: update to v1.21.5 [[1]](https://github.com/go-gitea/gitea/releases/tag/v1.21.4) [[2]](https://github.com/go-gitea/gitea/releases/tag/v1.21.5)
- nextcloud: upgrade to v28.0.2 [[1]](https://nextcloud.com/changelog/) [[2]](https://github.com/nextcloud/server/releases/tag/v28.0.2)
- matrix: update element-web to v1.11.57 [[1]](https://github.com/vector-im/element-web/releases/tag/v1.11.56) [[2]](https://github.com/vector-im/element-web/releases/tag/v1.11.57)
- xsrv: update ansible to [v9.2.0](https://github.com/ansible-community/ansible-build-data/blob/main/9/CHANGELOG-v9.rst)
- update documentation

[Full changes since v1.21.0](https://gitlab.com/nodiscc/xsrv/-/compare/1.21.0...1.22.0)

------------------

#### [v1.21.0](https://gitlab.com/nodiscc/xsrv/-/releases#1.21.0) - 2024-01-17

**Upgrade procedure:**
- `xsrv self-upgrade` to upgrade the xsrv script
- `xsrv upgrade` to upgrade roles/ansible environments to the latest release
- **graylog:** if you are using the `graylog` role, add the `mongodb_admin_password` and `graylog_mongodb_password` variables to your host variables (`xsrv edit-vault`) and set their values to strong random passwords
- To get rid of the deprecation warning `collections_paths option does not fit var naming standard`, rename `collections_paths` to `collections_path` in `ansible.cfg` (`xsrv edit-cfg`)
- `xsrv deploy` to apply changes

**Added:**
- add [`owncast`](https://gitlab.com/nodiscc/xsrv/-/tree/master/roles/owncast) role role (live video streaming and chat server)
- graylog/mongodb: require authentication to connect to mongodb ([`mongodb_admin_password`, `graylog_mongodb_password`](https://gitlab.com/nodiscc/xsrv/-/blob/master/roles/graylog/defaults/main.yml))
- jitsi: add an automated procedure to get the list of jitsi (prosody) registered users (`TAGS=utils-jitsi-listusers xsrv deploy`)
- gitea_act_runner: allow configuring how many tasks the runner can execute concurrently ([`gitea_act_runner_capacity: 1`](https://gitlab.com/nodiscc/xsrv/-/blob/master/roles/gitea_act_runner/defaults/main.yml))
- postgresql: aggregate postgresql logs to syslog (when the `monitoring_rsyslog` role is deployed)
- wireguard/firewalld: allow configuring services to which wireguard clients can connect on the host ([`wireguard_firewalld_services`](https://gitlab.com/nodiscc/xsrv/-/blob/master/roles/wireguard/defaults/main.yml))

**Removed:**
- postgresql: drop compatibility with Debian <12

**Changed:**
- python >=3.9 is now required on the controller (ansible 9.1.0)
- cleanup: postgresql: standardize/simplify pgmetrics report generation
- gitea_act_runner: update default image labels (use the `node:21-bookworm` when `uses: ubuntu-latest` is specified in the CI configuration file), add equivalent `debian-latest` label
- monitoring_netdata: debsecan: whitelist a few minor issues in debsecan reports by default
- wireguard: never return `changed` for wireguard client configuration file generation tasks
- tt_rss: hide `changed` status of `set permissions on tt-rss files` task
- gitea: update to v1.21.3 [[1]](https://github.com/go-gitea/gitea/releases/tag/v1.21.2) [[2]](https://github.com/go-gitea/gitea/releases/tag/v1.21.3)
- postgresql: explicitly install postgresql version 15
- openldap: update ldap-account-manager to [v8.6](https://github.com/LDAPAccountManager/lam/releases/tag/8.6)
- matrix: update element-web to v1.11.55 [[1]](https://github.com/vector-im/element-web/releases/tag/v1.11.51) [[2]](https://github.com/vector-im/element-web/releases/tag/v1.11.52) [[3]](https://github.com/vector-im/element-web/releases/tag/v1.11.53) [[24]](https://github.com/vector-im/element-web/releases/tag/v1.11.54) [[5]](https://github.com/vector-im/element-web/releases/tag/v1.11.55)
- xsrv: update ansible to [v9.0.1](https://github.com/ansible-community/ansible-build-data/blob/main/9/CHANGELOG-v9.rst)
- monitoring_goaccess: update [IP to Country](https://db-ip.com/db/download/ip-to-country-lite) database to v2024-01
- improve check mode support before first actual deployment
- update documentation

**Fixed:**
- graylog: mongodb: fix mongodb backups failing (authentication required)
- default playbook: fix `goaccess_username/password/fqdn` variables not being added to the correct file (username/password belong to encrypted variables)
- monitoring_utils: fix lynis warning `MongoDB instance allows any user to access databases`
- tt_rss: fix tt-rss installation failing when `git` was not previously installed
- tt_rss: fix error on first tt-rss installation `Unsupported parameters for (postgresql_query) module: as_single_query, path_to_script.`
- shaarli: fix shaarli zip extraction failing when the `unzip` package is not installed
- nextcloud: fix Nextcloud upgrades sometimes failing with `Nextcloud is not installed - only a limited number of commands are available`
- graylog: don't fail with `'graylog_mongodb_apt_repo_distribution' is undefined` when running the `mongodb` tag alone
- dnsmasq: only attempt to update blocklists after network is online and dnsmasq has started

[Full changes since v1.20.0](https://gitlab.com/nodiscc/xsrv/-/compare/1.20.0...1.21.0)

------------------

#### [v1.20.0](https://gitlab.com/nodiscc/xsrv/-/releases#1.20.0) - 2023-12-02

**Upgrade procedure:**
- `xsrv upgrade` to upgrade roles/ansible environments to the latest release
- `xsrv deploy` to apply changes

**Added:**
- dnsmasq: allow loading custom DNS blocklists from an URL ([`dnsmasq_blocklist_url`, `dnsmasq_blocklist_mode`, `dnsmasq_blocklist_whitelist`](https://gitlab.com/nodiscc/xsrv/-/blob/master/roles/dnsmasq/defaults/main.yml))
- shaarli: install [stack](https://github.com/RolandTi/shaarli-stack) custom theme/template and enable it by default
- shaarli: allow setting the theme/template via the ([`shaarli_theme`](https://gitlab.com/nodiscc/xsrv/-/blob/master/roles/nextcloud/defaults/main.yml)) configuration variable
- dnsmasq: allow logging DNS queries processed by dnsmasq ([`dnsmasq_log_queries: no/yes`](https://gitlab.com/nodiscc/xsrv/-/blob/master/roles/dnsmasq/defaults/main.yml))
- nextcloud: allow configuring outgoing mail settings ([`nextcloud_smtp_*`](https://gitlab.com/nodiscc/xsrv/-/blob/master/roles/nextcloud/defaults/main.yml))
- common: add automated procedures to reboot or shutdown hosts ([`TAGS=utils-shutdown,utils-reboot`](https://gitlab.com/nodiscc/xsrv/-/tree/master/roles/common#usage))
- netdata: debsecan: allow whitelisting vulnerabilities reported by debsecan by CVE number ([`debsecan_whitelist`](https://gitlab.com/nodiscc/xsrv/-/blob/master/roles/monitoring_netdata/defaults/main.yml))
- act-runner: prune unused podman data automatically, nightly (volumes, networks, containers, images)
- apache: allow restricting access to individual web applications by IP address/network ([`shaarli_allowed_hosts`](https://gitlab.com/nodiscc/xsrv/-/blob/master/roles/shaarli/defaults/main.yml), [`matrix_synapse/element_admin_allowed_hosts`](https://gitlab.com/nodiscc/xsrv/-/blob/master/roles/matrix/defaults/main.yml), [`goaccess_allowed_hosts`](https://gitlab.com/nodiscc/xsrv/-/blob/master/roles/goaccess/defaults/main.yml), [`ldap_account_manager/self_service_password_allowed_hosts`](https://gitlab.com/nodiscc/xsrv/-/blob/master/roles/openldap/defaults/main.yml), [`nextcloud_allowed_hosts`](https://gitlab.com/nodiscc/xsrv/-/blob/master/roles/nextcloud/defaults/main.yml), [`transmission_allowed_hosts`](https://gitlab.com/nodiscc/xsrv/-/blob/master/roles/transmission/defaults/main.yml), [`tt_rss_allowed_hosts`](https://gitlab.com/nodiscc/xsrv/-/blob/master/roles/tt_rss/defaults/main.yml), [`jitsi_allowed_hosts`](https://gitlab.com/nodiscc/xsrv/-/blob/master/roles/jitsi/defaults/main.yml), [`homepage_allowed_hosts`](https://gitlab.com/nodiscc/xsrv/-/blob/master/roles/homepage/defaults/main.yml), [`graylog_allowed_hosts`](https://gitlab.com/nodiscc/xsrv/-/blob/master/roles/graylog/defaults/main.yml), [`gotty_allowed_hosts`](https://gitlab.com/nodiscc/xsrv/-/blob/master/roles/gotty/defaults/main.yml), [`gitea_allowed_hosts`](https://gitlab.com/nodiscc/xsrv/-/blob/master/roles/gitea/defaults/main.yml))
- jellyfin: allow disabling the allowed IP list entirely (allow access from any IP) by setting an empty [`jellyfin_allowed_hosts`](https://gitlab.com/nodiscc/xsrv/-/blob/master/roles/jellyfin/defaults/main.yml) list
- goaccess: allow configuring IP to Country GeoIP database version ([`goaccess_geoip_db_version`](https://gitlab.com/nodiscc/xsrv/-/blob/master/roles/monitoring_goaccess/defaults/main.yml))
- common: sysctl: add hardening measures against reading/writing files controlled by an attacker [`fs.protected_fifos/hardlinks/regular/symlinks`](https://gitlab.com/nodiscc/xsrv/-/blob/master/roles/common/templates/etc_sysctl.d_custom.conf.j2)
- podman: add `podman-docker` wrapper (execute `docker` commands through podman)

**Removed:**
- netdata: remove `netdata_monitor_systemd_units` variable (always enable monitoring of system unit states)
- common: remove residual support for Debian 11 in firewalld configuration

**Changed:**
- xsrv: init-vm-template: use the gateway IP address as DNS server ([`--nameservers`](https://xsrv.readthedocs.io/en/latest/appendices/debian.html#automated-from-preseed-file)) by default instead of Cloudflare public DNS
- netdata: when `*_enable_service: no`, disable HTTP checks entirely for this service (instead of accepting HTTP 503)
- netdata: debsecan: allow disabling daily debsecan mail reports ([`debsecan_enable_reports: yes/no`](https://gitlab.com/nodiscc/xsrv/-/blob/master/roles/jellyfin/defaults/main.yml))
- transmission/netdata: only accept HTTP 401 as valid return code for the HTTP check
- nextcloud: verify downloaded .zip using GPG signatures
- jellyfin: harden systemd service (`systemd-analyze security` exposure score down from `9.2 UNSAFE` to `5.7 MEDIUM`)
- shaarli: update to [v0.13.0](https://github.com/shaarli/Shaarli/releases/tag/v0.13.0)
- gitea: update to v1.21.1 [[1]](https://github.com/go-gitea/gitea/releases/tag/v1.21.0) [[2]](https://github.com/go-gitea/gitea/releases/tag/v1.21.1)
- nextcloud: upgrade to v28.0.1 [[1]](https://nextcloud.com/changelog/) [[2]](https://github.com/nextcloud/server/releases/tag/v27.1.4) [[3]](https://github.com/nextcloud/server/releases/tag/v28.0.0) [[4]](https://github.com/nextcloud/server/releases/tag/v28.0.1) [[5]](https://nextcloud.com/blog/nextcloud-hub-7-advanced-search-and-global-out-of-office-features/)
- openldap: update self-service-password to [v1.5.4](https://github.com/ltb-project/self-service-password/releases/tag/v1.5.4)
- matrix: update element-web to v1.11.50 [[1]](https://github.com/vector-im/element-web/releases/tag/v1.11.48) [[2]](https://github.com/vector-im/element-web/releases/tag/v1.11.49) [[3]](https://github.com/vector-im/element-web/releases/tag/v1.11.50)
- xsrv: upgrade ansible to [v8.6.1](https://github.com/ansible-community/ansible-build-data/blob/main/8/CHANGELOG-v8.rst)
- goaccess: update IP to Country GeoIP database to v2023-11
- cleanup: limit use of `check_mode: no` to tasks that do not change anything
- update documentation, add example usage through Gitea Actions/Github Actions

**Fixed:**
- openldap: fix deployment of ldap-account-manager failing on `copy php-fpm configuration` when deploying the `apache` tag in isolation
- jellyfin: fix internal `Restart server` function only terminating the server process without restarting
- gitea_act_runner: fix `potentially insufficient UIDs or GIDs available in user namespace` error when using podman backend
- readme_gen: fix netdata alarm badge URL for used swap alarm
- shaarli: make `remove shaarli zip extraction directory` task idempotent

[Full changes since v1.19.0](https://gitlab.com/nodiscc/xsrv/-/compare/1.19.0...1.20.0)

------------------

#### [v1.19.0](https://gitlab.com/nodiscc/xsrv/-/releases#1.19.0) - 2023-11-03

**Upgrade procedure:**
- `xsrv upgrade` to upgrade roles/ansible environments to the latest release
- **gitea_act_runner:** if you changed it from the default value, rename the variable `gitea_act_runner_gitea_instance_url` to [`gitea_act_runner_gitea_instance_fqdn`]((https://gitlab.com/nodiscc/xsrv/-/blob/master/roles/gitea_act_runner/defaults/main.yml))
- **monitoring_utils:** if your projects are under git version control, you may want to add `data/duc-*.db` to  your `.gitignore` before using the `utils-duc` tag.
- **common:** if your projects are under git version control, you may want to add `data/firewalld-info-*.log` to  your `.gitignore` before using the `utils-firewalld-info` tag.
- `xsrv deploy` to apply changes

**Added:**
- common: packages: automatically install [qemu-guest-agent](https://qemu-project.gitlab.io/qemu/interop/qemu-ga.html) when the host is a KVM VM
- gitea_act_runner: allow running workflows directly on the host without containerization ([`gitea_act_runner_labels`](https://gitlab.com/nodiscc/xsrv/-/blob/master/roles/gitea_act_runner/defaults/main.yml))
- monitoring_utils: allow analyzing disk usage by directory and visualizing it locally using [duc](https://duc.zevv.nl/) ([`TAGS=utils-duc xsrv deploy default my.CHANGEME.org`](https://gitlab.com/nodiscc/xsrv/-/tree/master/roles/monitoring_utils#usage))
- backup: allow disabling specific rsnapshot backup intervals by setting [`rsnapshot_retain_daily/weekly/monthly`](https://gitlab.com/nodiscc/xsrv/-/blob/master/roles/backup/defaults/main.yml) to `0`
- backup: allow disabling automatic/scheduled backups entirely [`rsnapshot_enable_cron: yes/no`](https://gitlab.com/nodiscc/xsrv/-/blob/master/roles/backup/defaults/main.yml)
- backup: allow disabling automatic creation of the backup storage directory [`rsnapshot_create_root: yes/no`](https://gitlab.com/nodiscc/xsrv/-/blob/master/roles/backup/defaults/main.yml)
- common: allow getting firewalld status information (`TAGS=utils-firewalld-info xsrv deploy`)
- netdata/shaarli/tt_rss/openldap/nextcloud: enable monitoring of PHP-FPM pools
- when generating self-signed certificates, download them to the controller in `data/certificates/` under the project directory

**Removed:**
- netdata: remove variable `netdata_self_monitoring_enabled` (use [`netdata_disabled_plugins: ['netdata monitoring']`](https://gitlab.com/nodiscc/xsrv/-/blob/master/roles/monitoring_netdata/defaults/main.yml) instead)
- monitoring_utils: remove `logwatch` from the list of default installed packages

**Changed:**
- netdata: disable all netdata self-monitoring by default
- netdata: update logs/db storage configuration for newer netdata versions, store 400MB of per-minute data and 200MB of per-hour data in addition to the amount of per-second data defined by [`netdata_dbengine_disk_space`](https://gitlab.com/nodiscc/xsrv/-/blob/master/roles/monitoring_netdata/defaults/main.yml)
- gitea_act_runner: don't run the runner as root but as dedicated act-runner user
- gitea_act_runner: force re-registering the runner when the `.runner` file is absent
- gitea_act_runner: rename variable `gitea_act_runner_gitea_instance_url` to `gitea_act_runner_gitea_instance_fqdn`
- gitea_act_runner: log runner registration attempts to syslog for easier debugging
- common: users/logind: don't lock auto-lock idle user sessions by default ([`systemd_logind_lock_after_idle_min: 0`](https://gitlab.com/nodiscc/xsrv/-/blob/master/roles/common/defaults/main.yml))
- jitsi/goaccess: only generate self-signed certificates when `jitsi/goaccess_https_mode: selfsigned`
- transmission: only generate self-signed certificates when apache is managed by xsrv
- nextcloud: upgrade to v27.1.3 [[1]](https://nextcloud.com/changelog/) [[2]](https://nextcloud.com/blog/introducing-hub-5-first-to-deliver-self-hosted-ai-powered-digital-workspace/) [[3]](https://github.com/nextcloud/server/releases/tag/v27.1.0) [[4]](https://github.com/nextcloud/server/releases/tag/v27.1.1) [[5]](https://github.com/nextcloud/server/releases/tag/v27.1.2) [[6]](https://github.com/nextcloud/server/releases/tag/v27.1.3)
- matrix: update element-web to v1.11.47 [[1]](https://github.com/vector-im/element-web/releases/tag/v1.11.47)
- update documentation

**Fixed:**
- netdata: fix incorrect variable name in role defaults (`netdata_api_key` -> `netdata_streaming_api_key`)
- gitea_act_runner: fix temporary error when first enabling the podman socket in act-runner systemd user session
- gitea_act_runner: fix errors when enabling the systemd service manually
- gitea_act_runner: always try to restart the runner systemd service in case of failure
- monitoring_utils/graylog: fix debsums incorrectly reporting missing files in mongodb packages
- monitoring_netdata/debsecan: fix debsecan unable to send email reports
- default playbook: fix role ordering (`podman` must be deployed before `gitea_act_runner`)

[Full changes since v1.18.0](https://gitlab.com/nodiscc/xsrv/-/compare/1.18.0...1.19.0)

------------------

#### [v1.18.0](https://gitlab.com/nodiscc/xsrv/-/releases#1.18.0) - 2023-10-11

**Upgrade procedure:**
- **docker:** if you want to keep using the [`docker`](https://gitlab.com/nodiscc/xsrv/-/tree/1.17.0/roles/docker) role, update `requirements.yml` ([`xsrv edit-requirements`](https://xsrv.readthedocs.io/en/latest/usage.html#xsrv-edit-requirements)) and `playbook.yml` ([`xsrv edit-playbook`](https://xsrv.readthedocs.io/en/latest/usage.html#xsrv-edit-playbook)) to use the archived [`nodiscc.toolbox.docker`](https://gitlab.com/nodiscc/toolbox/-/tree/master/ARCHIVE/ANSIBLE-COLLECTION) role instead. [`nodiscc.xsrv.podman`](https://gitlab.com/nodiscc/xsrv/-/tree/master/roles/podman) is now the recommended role for container management.
- `xsrv upgrade` to upgrade roles/ansible environments to the latest release
- `xsrv deploy` to apply changes

_Note: the collection will no longer be updated on https://galaxy.ansible.com/ui/repo/published/nodiscc/xsrv/ until https://github.com/ansible/galaxy/issues/2438 is fixed, please use the git repository URL in your `requirements.yml`, as documented in https://xsrv.readthedocs.io/en/latest/usage.html#use-as-ansible-collection._

**Added:**
- add [`gitea_act_runner`](https://gitlab.com/nodiscc/xsrv/-/tree/master/roles/gitea_act_runner) role (Gitea Actions CI/CD runner)
- add [`podman`](https://gitlab.com/nodiscc/xsrv/-/tree/master/roles/podman) role (OCI container engine and management tools, replacement for [`docker`](https://gitlab.com/nodiscc/xsrv/-/tree/1.17.0/roles/docker))
- gitea: allow enabling built-in [Gitea Actions](https://docs.gitea.com/next/usage/actions/overview) CI/CD system ([`gitea_enable_actions: no/yes`](https://gitlab.com/nodiscc/xsrv/-/blob/master/roles/gitea/defaults/main.yml))
- common: allow running `unattended-upgrade` or `apt upgrade` immediately ([`TAGS=utils-apt-unattended-upgrade,utils-apt-upgrade`](https://gitlab.com/nodiscc/xsrv/-/blob/master/roles/common/README.md#usage))
- matrix: allow setting up LDAP authentication backend for synapse ([`matrix_synapse_ldap_*`](https://gitlab.com/nodiscc/xsrv/-/blob/master/roles/matrix/defaults/main.yml))
- netdata: allow aggregating netdata error/health alarm/collector logs to syslog ([`netdata_logs_to_syslog: no/yes`](https://gitlab.com/nodiscc/xsrv/-/blob/master/roles/monitoring_netdata/defaults/main.yml))
- docker: add an automated procedure to uninstall docker role components ([`TAGS=utils-docker-uninstall`](https://gitlab.com/nodiscc/xsrv/-/tree/1.17.0/roles/docker#uninstallation))
- nextcloud: allow automatically checking the filesystem/data directory for changes made outside Nextcloud ([`nextcloud_filesystem_check_changes: no/yes`](https://gitlab.com/nodiscc/xsrv/-/blob/master/roles/nextcloud/defaults/main.yml))

**Removed:**
- docker: remove role, [archive](https://gitlab.com/nodiscc/toolbox/-/tree/master/ARCHIVE/ANSIBLE-COLLECTION) it to separate repository
- apache: remove remove ability to install/configure `mod-evasive` anti-DDoS module

**Changed:**
- common: datetime: replace `ntpd` time synchronization service by `systemd-timesyncd`
- common: ssh: don't accept locale/language-related environment variables set by the client by default ([`ssh_accept_locale_env: no/yes`](https://gitlab.com/nodiscc/xsrv/-/blob/master/roles/common/defaults/main.yml))
- graylog: don't perform mongodb backups when the graylog/mongodb service is disabled on the host configuration ([`graylog_enable_service: yes/no`](https://gitlab.com/nodiscc/xsrv/-/blob/master/roles/common/defaults/main.yml))
- gitea: update to v 1.20.5 [[1]](https://github.com/go-gitea/gitea/releases/tag/v1.20.5)
- matrix: update element-web to v1.11.46 [[1]](https://github.com/vector-im/element-web/releases/tag/v1.11.44) [[2]](https://github.com/vector-im/element-web/releases/tag/v1.11.45) [[3]](https://github.com/vector-im/element-web/releases/tag/v1.11.46)
- graylog: update to v5.1 [[1]](https://graylog.org/post/announcing-graylog-v5-1/) [[2]](https://graylog.org/videos/whats-new-in-v5-1/) [[3]](https://graylog.org/post/announcing-graylog-v5-1-1/) [[4]](https://graylog.org/post/announcing-graylog-v5-1-2/) [[5]](https://graylog.org/post/announcing-graylog-v5-1-3/) [[6]](https://graylog.org/post/announcing-graylog-v5-1-4/) [[7]](https://graylog.org/post/announcing-graylog-v5-1-5/)
- openldap: update ldap-account-manager to [v8.5](https://github.com/LDAPAccountManager/lam/releases/tag/8.5)
- postgresql: update pgmetrics to [v1.16.0](https://github.com/rapidloop/pgmetrics/releases/tag/v1.16.0)
- netdata: update netdata-apt to v1.1.2 [[1]](https://gitlab.com/nodiscc/netdata-apt/-/commit/63e25372a4377ff5a32d91e8393275a37091c1cf)
- xsrv: upgrade ansible to [v8.5.0](https://github.com/ansible-community/ansible-build-data/blob/main/8/CHANGELOG-v8.rst)

**Fixed:**
- jitsi: fixed jitsi-videobridge sometimes failing to connect to prosody (`org.jivesoftware.smack.sasl.SASLErrorException: SASLError using SCRAM-SHA-1: not-authorized`) - force updating jvb prosody password

[Full changes since v1.17.0](https://gitlab.com/nodiscc/xsrv/-/compare/1.17.0...1.18.0)

------------------


#### [v1.17.0](https://gitlab.com/nodiscc/xsrv/-/releases#1.17.0) - 2023-09-21

**Upgrade procedure:**
- upgrade to [v1.16.0](https://gitlab.com/nodiscc/xsrv/-/releases#1.16.0) and deploy it first, if not already done
- `xsrv upgrade` to upgrade roles/ansible environments to the latest release
- if you had changed it from its default value, rename the variable `syslog_retention_days` to [`rsyslog_retention_days`](https://gitlab.com/nodiscc/xsrv/-/blob/master/roles/monitoring_rsyslog/defaults/main.yml) in your hosts/groups configuration (`xsrv edit-host/edit-group`)
- (optional) `xsrv check` to simulate changes.
- `xsrv deploy` to apply changes
- `TAGS=debian11to12 xsrv deploy && xsrv deploy` to upgrade hosts still on Debian 11 "Bullseye" to [Debian 12 "Bookworm"](https://www.debian.org/News/2023/20230610) [[1]](https://www.debian.org/releases/bookworm/amd64/release-notes/index.en.html). Debian 11 will no longer be supported after this release.

**Added:**
- add [`monitoring_goaccess`](https://gitlab.com/nodiscc/xsrv/-/tree/master/roles/monitoring_goaccess) role - real-time web log analyzer/interactive viewer
- netdata: allow enabling health alarms for charts received from "child" streaming nodes ([`netdata_streaming_receive_alarms: yes/no`](https://gitlab.com/nodiscc/xsrv/-/blob/master/roles/monitoring_netdata/defaults/main.yml))
- netdata: allow enabling/disabling alarm notifications ([`netdata_enable_health_notifications: yes/no`](https://gitlab.com/nodiscc/xsrv/-/blob/master/roles/monitoring_netdata/defaults/main.yml))
- apache: allow enabling [HSTS](https://en.wikipedia.org/wiki/HTTP_Strict_Transport_Security) for all applications/sites using Let's Encrypt certificates ([`apache_letsencrypt_enable_hsts: no/yes`](https://gitlab.com/nodiscc/xsrv/-/blob/master/roles/apache/defaults/main.yml))
- apache/fail2ban: ban IP addresses doing requests on the default virtualhost
- monitoring_netdata: allow disabling the logcount module by setting [`netdata_logcount_update_interval`](https://gitlab.com/nodiscc/xsrv/-/blob/master/roles/monitoring_netdata/defaults/main.yml) to 0
- jellyfin: allow adding users to the `jellyfin` group (may read/write files inside the media directory), add the ansible user to this group by default ([`jellyfin_users`](https://gitlab.com/nodiscc/xsrv/-/blob/master/roles/jellyfin/defaults/main.yml))
- transmission: allow adding users to the `debian-transmission` group (may read/write files inside the downloads directory), add the ansible user to this group by default ([`transmission_users`](https://gitlab.com/nodiscc/xsrv/-/blob/master/roles/transmission/defaults/main.yml))

**Removed:**
- cleanup: remove all previous migration tasks
- netdata: remove default processes checks for sshd, ntpd, fail2ban (let systemd services module handle checks for these processes)
- tt_rss: remove ansible tags `tt_rss-app`, `tt_rss-permissions`, `tt_rss-postgresql`

**Changed:**
- nextcloud: enable the [Polls](https://apps.nextcloud.com/apps/polls) app by default
- nextcloud: enable the [Forms](https://apps.nextcloud.com/apps/forms) app by default
- nextcloud: disable the [usage survey](https://github.com/nextcloud/survey_client) app by default
- apache: always redirect `http://` to `https://` for all applications/sites using Let's Encrypt (`*_certificate_mode: letsencrypt`) certificates
- apache: don't redirect requests to the default HTTP virtualhost to HTTPS
- jitsi: configure all components to listen only on loopback interfaces, disable IPv6 listening
- graylog: cleanup list of dependencies (graylog provides its own java environment)
- netdata: decrease apache server status collection frequency to 10s (decrease log spam caused by the collector)
- apache: log requests from localhost to the default vhost with the `localhost:` prefix (for example `http://127.0.0.1/server-status` requests from netdata)
- apache: log requests from other hosts to the default vhost with the `default:` prefix (for example bad bots and scanners accessing the server by IP address)
- apache: serve a `403 Forbidden` response to for requests the default virtualhost (except those from localhost)
- common/fail2ban: increase the max number of banned IPs per jail to 1000000
- common/fail2ban: decrease the number of failed authentication attempts before triggering a ban from 5 to 3 (over 10 minutes)
- common/fail2ban: use values provided in `fail2ban_default_maxretry` (default 3), `fail2ban_default_findtime` (10min) and `fail2ban_default_bantime` (1 year) for all jails
- common/fail2ban: use `DROP` firewall rule instead of `REJECT` (drop connections from banned IPs instead of replying with TCP reset)
- common/fail2ban: do not enable the `pam-generic` jail by default as no service uses it
- common/fail2ban/all roles: only ban offenders on HTTP/HTTPS ports (not all ports) for authentication failures on web applications
- common/fail2ban: standardize permissions on fail2ban configuration files
- gitea/jellyfin/fail2ban: do not disable gitea/jellyfin jails if the corresponding service is disabled
- apache: cleanup: remove `ServerAdmin` directive from all virtualhost configuration files (this information is not used, displaying admin email in error messages is disabled)
- wireguard: write peer names as comments in the config file
- rsyslog: rename the variable `syslog_retention_days` to `rsyslog_retention_days`
- nextcloud: update to v26.0.6 [[1]](https://nextcloud.com/changelog/)
- gitea: update to v 1.20.4 [[1]](https://github.com/go-gitea/gitea/releases/tag/v1.20.2) [[2]](https://github.com/go-gitea/gitea/releases/tag/v1.20.3) [[3]](https://github.com/go-gitea/gitea/releases/tag/v1.20.4)
- matrix: update element-web to v1.11.43 [[1]](https://github.com/vector-im/element-web/releases/tag/v1.11.37) [[2]](https://github.com/vector-im/element-web/releases/tag/v1.11.38) [[3]](https://github.com/vector-im/element-web/releases/tag/v1.11.39) [[4]](https://github.com/vector-im/element-web/releases/tag/v1.11.40) [[5]](https://github.com/vector-im/element-web/releases/tag/v1.11.41) [[6]](https://github.com/vector-im/element-web/releases/tag/v1.11.42) [[7]](https://github.com/vector-im/element-web/releases/tag/v1.11.43)
- postgresql: update pgmetrics to [v1.15.2](https://github.com/rapidloop/pgmetrics/releases/tag/v1.15.2)
- xsrv: update ansible to [v8.4.0](https://github.com/ansible-community/ansible-build-data/blob/main/8/CHANGELOG-v8.rst)
- netdata: harden/standardize permissions on postgres collector configuration file
- cleanup: common/fail2ban: standardize comments/task order, do not repeat jail options that are already defined in `jail.conf`, in `jail.d/*conf`
- cleanup: xsrv: init-vm-template: remove deprecated `--os` option to `virt-install`
- improve check mode support before first actual deployment
- update documentation

**Fixed:**
- apache: fix apache not loading new/updated Let's Encrypt/`mod_md` certificates automatically every minute
- apache: fix duplicated access logs to `access.log`/`other_vhosts_access.log`, only log to `access.log`
- common/fail2ban/all roles: prevent missing/not-yet-created log files from causing failban reloads/restart to fail (e.g. when a service is initially deployed with `*_enable_service: no`)
- common: fail2ban: fix `Hash is full, cannot add more elements` error when a fail2ban jail has more than 65536 banned IPs
- monitoring_netdata/needrestart: fix automatic reboot not triggered by cron job when ABI-compatible kernel upgrades are pending
- nextcloud: fail2ban: fix `Found a match but no valid date/time` warning when a login failure is detected

[Full changes since v1.16.0](https://gitlab.com/nodiscc/xsrv/-/compare/1.16.0...1.17.0)

------------------

#### [v1.16.0](https://gitlab.com/nodiscc/xsrv/-/releases#1.16.0) - 2023-07-29

**Upgrade procedure:**
- `xsrv upgrade` to upgrade roles/ansible environments to the latest release
- (optional) `xsrv check` to simulate changes.
- (optional) `xsrv deploy && TAGS=debian11to12 xsrv deploy` to upgrade your hosts from Debian 11 "Bullseye" to [Debian 12 "Bookworm"](https://www.debian.org/News/2023/20230610) [[1]](https://www.debian.org/releases/bookworm/amd64/release-notes/index.en.html)
- `xsrv deploy` to apply changes

You must upgrade to this release and deploy it before deploying future versions (old migrations will be removed after this release).

**Added:**
- homepage: allow making individual custom links mare compact (half as wide, no description) ([`homepage_custom_links.*.compact: yes/no`](https://gitlab.com/nodiscc/xsrv/-/blob/master/roles/homepage/defaults/main.yml))

**Removed:**
- drop support for Debian 10 Buster [[1]](https://www.debian.org/releases/buster/)

**Changed:**
- libvirt: add the ansible user to the libvirt group by default (can manage libvirt VMs without sudo) ([`libvirt_users`](https://gitlab.com/nodiscc/xsrv/-/blob/master/roles/jellyfin/defaults/main.yml))
- libvirt: configure non-root user accounts to use `qemu:///system` connection URI by default (can manage libvirt VMs without sudo/without specifying `--connect qemu:///system`)
- gitea: update to v1.20.1 [[1]](https://github.com/go-gitea/gitea/releases/tag/v1.20.0) [[2]](https://github.com/go-gitea/gitea/releases/tag/v1.20.1)
- nextcloud: update to v26.0.5 [[1]](https://nextcloud.com/changelog/)
- nextcloud: enable the Maps app again by default (now compatible with Nextcloud 26)
- graylog: make role compatible with Debian 12 (upgrade to mongodb [v6.0](https://www.mongodb.com/docs/manual/release-notes/6.0/))
- matrix: update element-web to [v1.11.36](https://github.com/vector-im/element-web/releases/tag/v1.11.36)
- postgresql: update pgmetrics to [v1.15.1](https://github.com/rapidloop/pgmetrics/releases/tag/v1.15.1)
- xsrv: update ansible to [v8.2.0](https://github.com/ansible-community/ansible-build-data/blob/main/8/CHANGELOG-v8.rst)
- common/ssh: add `ansible_local.ssh.ansible_managed` local fact which can be used to detect whether SSH server is managed by xsrv
- improve check mode support before first actual deployment
- update documentation

**Fixed:**
- netdata: fix `Oops, something unexpected happened` error on alerts tab
- netdata: fix role idempotence/configuration tasks always returning changed and needlessly restarting netdata
- common: utils-debian11to12: fix upgrade procedure sometimes freezing/failing without logs
- common: utils-debian11to12: fix error `'dict object' has no attribute 'distribution_release'` after successful upgrade
- common/monitoring_utils: fail2ban/lynis: fix warning `fail2ban.configreader: WARNING 'allowipv6' not defined in 'Definition'` in lynis reports
- monitoring_utils: lynis: fix `pgrep: pattern that searches for process name longer than 15 characters will result in zero matches` message in reports (disable detection/suggestion of commercial/closed-source antivirus software)
- gitea: fix task `verify gitea GPG signatures` failing on hosts where gnupg is not installed
- gitea: fix role failing to deploy on hosts where the `common` role is not deployed (`Group ssh-access does not exist`)
- common/firewalld/libvirt: ensure libvirtd is restarted when firewalld is restarted/reloaded (re-apply port forwarding rules), fix looping libvirt restarts
- monitoring_utils/graylog: fix debsums incorrectly reporting missing files in mongodb packages (definitive fix)
- mail_dovecot/gitea/backup: fix wrong ansible tag `gitea` on dovecot backup configuration tasks

[Full changes since v1.15.0](https://gitlab.com/nodiscc/xsrv/-/compare/1.15.0...1.16.0)

------------------

#### [v1.15.0](https://gitlab.com/nodiscc/xsrv/-/releases#1.15.0) - 2023-07-16

**Upgrade procedure:**
- `xsrv self-upgrade` to upgrade the xsrv script
- `xsrv upgrade` to upgrade roles/ansible environments to the latest release
- **common**: if you had custom `linux_users` defined with `ssh` as one of their `groups:`, change the group name from `ssh` to `ssh-access`, for example:

```diff
# xsrv edit-host
# host_vars/my.example.org/my.example.org.yml
 linux_users:
   - name: "rsnapshot"
-    groups: [ "ssh", "sudo", "postgres", "nextcloud", "steam" ]
+    groups: [ "ssh-access", "sudo", "postgres", "nextcloud", "steam" ]
     comment: "limited user account for remote backups"
     ssh_authorized_keys: ['data/public_keys/root@home.example.org.pub']
     sudo_nopasswd_commands: ['/usr/bin/rsync', '/usr/bin/psql', '/usr/bin/pg_dump', '/usr/bin/pg_dumpall' ]
```

- (optional) `xsrv check` to simulate changes.
- `xsrv deploy` to apply changes
- (optional) `xsrv deploy && TAGS=debian11to12 xsrv deploy` to upgrade your host's distribution from Debian 11 "Bullseye" to [Debian 12 "Bookworm"](https://www.debian.org/News/2023/20230610) [[1]](https://www.debian.org/releases/bookworm/amd64/release-notes/index.en.html).
  - **nextcloud**: if you want to postpone upgrading your Debian 11 hosts to Debian 12, set `nextcloud_version: 25.0.12` manually in your host configuration (`xsrv edit-host/edit-group`), as Nextcloud 26 requires PHP 8 which is only available in Debian 12. Don't forget to remove this override after upgrading to Debian 12.
  - **graylog:** do **not** upgrade hosts where the `graylog` role is deployed to Debian 12, as it is not compatible with Debian 12 yet.

The Debian 11 -> 12 upgrade procedure was only tested for hosts managed by `xsrv` roles. If you have custom/third-party software installed, you should read Debian 12's [release notes](https://www.debian.org/releases/bookworm/amd64/release-notes/index.en.html) and/or execute the upgrade procedure manually. It is always advisable to do a full backup/snapshot before performing a distribution upgrade.

**Added:**
- common: add an automated procedure to upgrade Debian 11 hosts to Debian 12 (`TAGS=utils-debian11to12 xsrv deploy`)
- common: fail2ban: allow downloading the list of banned IPs to the controller (`TAGS=utils-fail2ban-get-banned xsrv deploy`)
- backup: allow taking a snapshot immediately (`TAGS=utils-backup-now xsrv deploy`)
- graylog: allow setting the admin user account timezone ([`graylog_root_timezone`](https://gitlab.com/nodiscc/xsrv/-/blob/master/roles/jellyfin/defaults/main.yml))

**Changed:**
- make all roles (except `graylog`) compatible with Debian 12 "Bookworm"
- xsrv: `init-vm-template`: use Debian 12 "Bookworm" as the base OS image [[1]](https://www.debian.org/releases/bookworm/amd64/release-notes/index.en.html)
- common: ssh: change the group name allowed to access the SSH server from `ssh` to `ssh-access` (`ssh` is a reserved group name used for internal purposes)
- common: fail2ban: use `firewallcmd-ipset` ban action when firewalld is enabled and managed by xsrv ([`setup_firewall: yes`](https://gitlab.com/nodiscc/xsrv/-/blob/master/roles/common/defaults/main.yml))
- common: firewalld: allow SSH connections from both the internal and public zones by default
- apache: harden systemd service (`systemd-analyze security` exposure score down from `9.2 UNSAFE` to `7.6 EXPOSED`)
- xsrv: `init-vm`: check that the user-provided value for `--memory` has the `M` or `G` suffix
- nextcloud: disable the [Maps](https://apps.nextcloud.com/apps/maps) app by default (incompatible with Nextcloud 26)
- nextcloud: disable the [Music](https://apps.nextcloud.com/apps/music) app by default (makes it impossible to delete directories)
- nextcloud: update to v26.0.3 [[1]](https://nextcloud.com/changelog/) [[2]](https://nextcloud.com/blog/updates-26-0-1-and-25-0-6-are-out-get-them-now/) [[3]](https://nextcloud.com/blog/hub-4-pioneers-ethical-ai-integration-for-a-more-productive-and-collaborative-future/)
- gitea: update to [v1.19.4](https://github.com/go-gitea/gitea/releases/tag/v1.19.4)
- openldap: update ldap-account-manager to [v8.4](https://github.com/LDAPAccountManager/lam/releases/tag/lam_8_4)
- matrix: update element-web to v1.11.35 [[1]](https://github.com/vector-im/element-web/releases/tag/v1.11.32) [[2]](https://github.com/vector-im/element-web/releases/tag/v1.11.33) [[3]](https://github.com/vector-im/element-web/releases/tag/v1.11.34) [[3]](https://github.com/vector-im/element-web/releases/tag/v1.11.35)
- postgresql: update pgmetrics to [v1.15.0](https://github.com/rapidloop/pgmetrics/releases/tag/v1.15.0)
- xsrv: update ansible to v8.1.0 [[1]](https://github.com/ansible-community/ansible-build-data/blob/main/7/CHANGELOG-v7.rst) [[2]](https://github.com/ansible-community/ansible-build-data/blob/main/8/CHANGELOG-v8.rst)
- apache: simplify syntax of configuration used to forbid access to `.ssh,.git,.svn,.hg` directories
- monitoring_rsyslog: drop remaining compatibility with Debian 10 "Stretch"
- cleanup: gitea: remove unneeded `php-pgsql` package installation
- cleanup: shaarli: simplify handling of conditions in installation/upgrade procedure
- tests: improve ansible-lint coverage
- improve check mode support, fix errors in check mode when running before first actual deployment
- update documentation

**Fixed:**
- common: firewalld: fix conflicting default values for `immediate` and `permanent` during `configure firewalld zone sources` (default to `permanent: yes, immediate: no`)
- shaarli: fix missing package `python3-pip` required to install python-shaarli-client when `shaarli_setup_python_client: yes`
- monitoring_utils/graylog: fix debsums incorrectly reporting missing files in mongodb packages
- xsrv: init-vm: fix help text (the value for `--memory` must have the `M` or `G` suffix)
- xsrv: init-vm: fix the VM XML filename printed out in the `libvirt_vms` copy-pastable snippet
- monitoring_utils/graylog: fix debsums incorrectly reporting missing files in mongodb packages
- graylog: decouple role from the apache role, skip apache configuration tasks when apache is not managed by ansible
- nextcloud: fix mysql ansible module arguments

[Full changes since v1.14.0](https://gitlab.com/nodiscc/xsrv/-/compare/1.14.0...1.15.0)

------------------


#### [v1.14.0](https://gitlab.com/nodiscc/xsrv/-/releases#1.14.0) - 2023-05-17

**Upgrade procedure:**
- `xsrv self-upgrade` to upgrade the xsrv script
- `xsrv upgrade` to upgrade roles/ansible environments to the latest release
- `xsrv deploy` to apply changes
- matrix: synapse: if you are getting the error `Failed to update apt cache: unknown reason`, this may be caused by the matrix/synapse APT repository signing key having expired. Deploying the `matrix` tag alone should solve this problem (`TAGS=matrix xsrv deploy`)
- (optional) download and install the tab/auto-completion script:

```bash
wget https://gitlab.com/nodiscc/xsrv/-/raw/release/xsrv-completion.sh
sudo cp xsrv-completion.sh /etc/bash_completion.d/
```

**Added:**
- matrix: add [synapse-admin](https://github.com/Awesome-Technologies/synapse-admin) user/room administration web interface
- xsrv: add (optional) bash completion script ([installation](https://xsrv.readthedocs.io/en/latest/installation/controller-preparation.html))
- jellyfin: allow installing and configuring [OpenSubtitles plugin](https://github.com/jellyfin/jellyfin-plugin-opensubtitles) ([`jellyfin_setup_opensubtitles_plugin: no/yes`](https://gitlab.com/nodiscc/xsrv/-/blob/master/roles/jellyfin/defaults/main.yml))
- homepage: allow adding custom links to the homepage ([`homepage_custom_links`](https://gitlab.com/nodiscc/xsrv/-/blob/master/roles/homepage/defaults/main.yml))
- graylog: setup automatic local backups of graylog configuration when the `nodiscc.xsrv.backup` role is deployed
- nextcloud add the [Tables](https://apps.nextcloud.com/apps/tables) app to the list of default disabled apps ([`nextcloud_apps`](https://gitlab.com/nodiscc/xsrv/-/blob/master/roles/nextcloud/defaults/main.yml))
- readme-gen: show `mumble://` server URIs/links for hosts where the `nodiscc.xsrv.mumble` role is deployed
- readme-gen: show homepage URL/link for hosts where the `nodiscc.xsrv.homepage` role is deployed
- readme-gen: display a list of storage devices with size, for each host
- readme-gen: allow adding SFTP bookmarks for GTK-based file managers to the output markdown file ([`readme_gen_gtk_bookmarks: yes/no`](https://gitlab.com/nodiscc/xsrv/-/blob/master/roles/readme_gen/defaults/main.yml))
- xsrv: [`init-vm/init-vm-template`](https://xsrv.readthedocs.io/en/latest/appendices/debian.html#automated-from-a-vm-template): validate that values of `--ip`/`--gateway` are valid IPv4 addresses

**Removed:**
- xsrv: remove `ls` command (use bash completion instead, or manually `cd` to your project directory)

**Changed:**
- monitoring_utils: lynis: disable `Reboot of system is most likely needed` warning, let netdata/needrestart send notifications when a reboot is required
- monitoring_utils: lynis: disable `Found one or more vulnerable packages` warning, let debsecan handle reporting of vulnerable packages
- homepage: display descriptions for each applications/services, improve layout
- xsrv: init-vm-template: remove the temporary preseed file after template creation
- nextcloud: update to [v25.0.6](https://nextcloud.com/changelog/)
- gitea: update to v1.19.3 [[1]](https://github.com/go-gitea/gitea/releases/tag/v1.19.2) [[2]](https://github.com/go-gitea/gitea/releases/tag/v1.19.3)
- matrix: update element-web to v1.11.31 [[1]](https://github.com/vector-im/element-web/releases/tag/v1.11.30) [[2]](https://github.com/vector-im/element-web/releases/tag/v1.11.31)
- openldap: update self-service-password to [v1.5.3](https://github.com/ltb-project/self-service-password/releases/tag/v1.5.3)
- xsrv: update ansible to [v7.5.0](https://github.com/ansible-community/ansible-build-data/blob/main/7/CHANGELOG-v7.rst)
- cleanup/internal changes: improve separation of tasks/files, clarify variable naming, remove unused/duplicate variables/tasks
- update documentation

**Fixed:**
- matrix: synapse: fix `Failed to update apt cache: unknown reason`/expired repository signing key
- xsrv: install `lxml` python module, required for `utils-libvirt-setmem` tasks
- gitea: fix fail2ban restart failing on first installation of gitea
- jellyfin: fix idempotence/opensubtitles plugin installation always returning `changed`
- decouple web application roles from the `nodiscc.xsrv.apache` role (only run apache configuration tasks if the apache role is deployed). `nodiscc.xsrv.apache` is still required in the standard configuration to act as a reverse proxy for web applications. If not deployed, you will need to provide your own reverse proxy configuration.

[Full changes since v1.13.1](https://gitlab.com/nodiscc/xsrv/-/compare/1.13.1...1.14.0)

------------------


#### [v1.13.1](https://gitlab.com/nodiscc/xsrv/-/releases#1.13.1) - 2023-04-14

**Upgrade procedure:**
- `xsrv upgrade` to upgrade roles/ansible environments to the latest release
- `xsrv deploy` to apply changes

**Added:**
- readme-gen: allow displaying custom netdata badges for each host ([`readme_gen_netdata_badges`](https://gitlab.com/nodiscc/xsrv/-/blob/master/roles/readme_gen/defaults/main.yml))
- openldap: allow enabling/disabling the service ([`openldap_enable_service: yes/no`](https://gitlab.com/nodiscc/xsrv/-/blob/master/roles/openldap/defaults/main.yml))


**Fixed:**
- readme-gen: fix syntax error in template (`template error while templating string`)

[Full changes since v1.13.0](https://gitlab.com/nodiscc/xsrv/-/compare/1.13.0...1.13.1)

------------------

#### [v1.13.0](https://gitlab.com/nodiscc/xsrv/-/releases#1.13.0) - 2023-04-14

**Upgrade procedure:**
- `xsrv self-upgrade` to upgrade the xsrv script
- `xsrv upgrade` to upgrade roles/ansible environments to the latest release
- `xsrv deploy` to apply changes
- monitoring/netdata: if you have configured custom [`netdata_port_checks`](https://gitlab.com/nodiscc/xsrv/-/blob/master/roles/monitoring_netdata/defaults/main.yml), ensure the `ports:` parameter is a list, even if it only contains a single port (e.g. `ports: [64738]`)

**Added:**
- monitoring_netdata: add [netdata-apt](https://gitlab.com/nodiscc/netdata-apt) module (monitor number of upgradeable packages, and available distribution upgrades) ([`setup_netdata_apt: yes/no`](https://gitlab.com/nodiscc/xsrv/-/blob/master/roles/monitoring_netdata/defaults/main.yml))
- apache: add a custom maintenance page (`/var/www/maintenance/maintenance.html`)
- homepage/matrix_element/nextcloud/ldap_account_manager/self_service_password/shaarli/tt_rss: allow disabling individual web applications (`*_enable_service: yes/no`), redirect to the maintenance page when disabled
- dovecot: allow enabling/disabling the service ([`dovecot_enable_service: yes/no`](https://gitlab.com/nodiscc/xsrv/-/blob/master/roles/mail_dovecot/defaults/main.yml))
- samba: allow enabling/disabling the service ([`samba_enable_service: yes/no`](https://gitlab.com/nodiscc/xsrv/-/blob/master/roles/samba/defaults/main.yml))
- postgresql: netdata: allow netdata to gather detailed statistics about the postgresql instance [[1]](https://learn.netdata.cloud/docs/data-collection/monitor-anything/Databases/PostgresSQL) [[2]](https://blog.netdata.cloud/postgresql-monitoring/)
- monitoring_netdata: allow declaring the public port (i.e. outside NAT) used to access netdata ([`netdata_public_port`](https://gitlab.com/nodiscc/xsrv/-/blob/master/roles/monitoring_netdata/defaults/main.yml)), and use it in mail notifications/[`nodiscc.xsrv.homepage`](https://gitlab.com/nodiscc/xsrv/-/tree/master/roles/homepage) role

**Removed:**
- common: remove task `ensure /var/log/wtmp is not world-readable`
- readme-gen: remove support for `readme_gen_netdata_public_port` variable (use `netdata_public_port` instead)

**Changed:**
- xsrv: [`init-vm`](https://xsrv.readthedocs.io/en/latest/appendices/debian.html#automated-from-a-vm-template): make `--gateway` optional, by default use the value of `--ip` with the last octet replaced by `.1`
- xsrv: [`init-vm`](https://xsrv.readthedocs.io/en/latest/appendices/debian.html#automated-from-a-vm-template): make `--ssh-pubkey` optional, by default use the contents of `~/.ssh/id_rsa.pub`
- xsrv: [`init-vm`](https://xsrv.readthedocs.io/en/latest/appendices/debian.html#automated-from-a-vm-template): always dump VM XML definition to a file (`--dumpxml`), by default to `$projects_dir/VM_NAME.xml`
- monitoring/netdata: disable more netdata modules by default ([`netdata_disabled_plugins`](https://gitlab.com/nodiscc/xsrv/-/blob/master/roles/monitoring_netdata/defaults/main.yml))
- monitoring/netdata: allow HTTP code 503/don't raise HTTP check alarms when web applications/services are disabled in the configuration through `*_enable_service: no`
- monitoring/rsyslog: switch systemd-journald's storage mode to volatile, don't write logs twice on disk
- monitoring/rsyslog: allow setting custom configuration directives ([`rsyslog_custom_config`](https://gitlab.com/nodiscc/xsrv/-/blob/master/roles/monitoring_rsyslog/defaults/main.yml))
- monitoring/rsyslog: don't discard any messages by default, custom discard rules can be configured through `rsyslog_custom_config`
- monitoring_utils/lynis: don't throw a warning when promiscuous network interfaces are detected
- gitea: harden systemd service (`systemd-analyze security` exposure score down from `9.2 UNSAFE` to `1.9 OK`)
- gitea: make gitea data directories owned by gitea (prevents `fatal: detected dubious ownership in repository` when manipulating files/repos from a shell as the gitea user)
- common: users: ensure that both the ansible user and root home directories permissions are set to `0700`
- gitea: update to v1.19.1 [[1]](https://github.com/go-gitea/gitea/releases/tag/v1.19.0) [[2]](https://github.com/go-gitea/gitea/releases/tag/v1.18.4) [[3]](https://blog.gitea.io/2023/03/gitea-1.19.0-is-released/) [[4]](https://github.com/go-gitea/gitea/releases/tag/v1.19.1)
- shaarli: update to [v0.12.2](https://github.com/shaarli/Shaarli/releases/tag/v0.12.2)
- nextcloud: update to [v25.0.5](https://nextcloud.com/changelog/)
- matrix: update element-web to v1.11.29 [[1]](https://github.com/vector-im/element-web/releases/tag/v1.11.25) [[2]](https://github.com/vector-im/element-web/releases/tag/v1.11.26) [[3]](https://github.com/vector-im/element-web/releases/tag/v1.11.27) [[4]](https://github.com/vector-im/element-web/releases/tag/v1.11.28) [[5]](https://github.com/vector-im/element-web/releases/tag/v1.11.29)
- openldap: update ldap-account-manager to [v8.3](https://github.com/LDAPAccountManager/lam/releases/tag/lam_8_3)
- graylog: update graylog-server and mongodb to v5.0 [[1]](https://www.graylog.org/post/graylog-5-0-a-new-day-for-it-secops/) [[2]](https://www.graylog.org/releases/)
- xsrv: update ansible to [v7.4.0](https://github.com/ansible-community/ansible-build-data/blob/main/7/CHANGELOG-v7.rst)
- update documentation
- improve check mode support
- cleanup: remove duplicate tasks, simplify installed version/upgrade detection logic, make installation/upgrade tasks less verbose, cleanup main script

**Fixed:**
- homepage/readme-gen/jitsi: display Jitsi Meet instances URLs
- monitoring_netdata: fix [`netdata_fping_hosts`](https://gitlab.com/nodiscc/xsrv/-/blob/master/roles/monitoring_netdata/defaults/main.yml)/ping checks not displaying anymore
- monitoring_netdata: fix `Go to chart` links in mail notifications pointing to Netdata Cloud/SaaS instead of the netdata instance
- monitoring_netdata: prevent duplicate alarms on failed systemd services
- monitoring_netdata: prevent duplicate alarm notifications when streaming is enabled (only send notifications from the child node)
- monitoring_utils/graylog: fix debsums incorrectly reporting missing files in mongodb packages
- monitoring_utils/lynis: prevent lynis from running twice per day, disable duplicate systemd timer
- openldap: self-service-password: fix self-service-password application not being served by the correct php-fpm pool
- apache/netdata: fix unproperly formatted log lines causing `web log unmatched` alarms/high `excluded_requests` rate
- samba/rsyslog: fix warning `file '/var/log/nscd.log' does not exist` when samba is configured with `samba_passdb_backend: ldapsam`
- shaarli: fix custom favicon location
- shaarli: make task `create initial shaarli log.txt` idempotent
- matrix: don't attempt to create synapse users when the service is disabled

[Full changes since v1.12.0](https://gitlab.com/nodiscc/xsrv/-/compare/1.12.0...1.13.0)

------------------

#### [v1.12.0](https://gitlab.com/nodiscc/xsrv/-/releases#1.12.0) - 2023-03-06

**Upgrade procedure:**
- `xsrv self-upgrade` to upgrade the xsrv script
- `xsrv upgrade` to upgrade roles/ansible environments to the latest release
- **proxmox:** if you want to keep using the [`proxmox`](https://gitlab.com/nodiscc/xsrv/-/tree/1.11.1/roles/proxmox) role, update `requirements.yml` ([`xsrv edit-requirements`](https://xsrv.readthedocs.io/en/latest/usage.html#xsrv-edit-requirements)) and `playbook.yml` ([`xsrv edit-playbook`](https://xsrv.readthedocs.io/en/latest/usage.html#xsrv-edit-playbook)) to use the archived [`nodiscc.toolbox.proxmox`](https://gitlab.com/nodiscc/toolbox/-/tree/master/ARCHIVE/ANSIBLE-COLLECTION) role instead. [`nodiscc.xsrv.libvirt`](https://gitlab.com/nodiscc/xsrv/-/tree/master/roles/libvirt) includes more features and is now the recommended role for simplified management of hypervisors and virtual machines. Proxmox VE remains suitable for more complex setups where management through a Web interface is desirable.
- **rsyslog/graylog**: if you use the [`rsyslog_forward_to_hostname`]((https://gitlab.com/nodiscc/xsrv/-/blob/master/roles/monitoring_rsyslog/defaults/main.yml)) variable and it is pointing to a graylog instance deployed with the `graylog` role, update it to use the graylog instance FQDN instead of the graylog host inventory hostname (e.g. `logs.example.org` instead of `host1.example.org`)
- **libvirt:** you will need to restart all libvirt networks and attached VMs for the changes to take effect (a full hypervisor reboot may be simpler)
- **libvirt:** if you have defined custom [`libvirt_port_forwards`](https://gitlab.com/nodiscc/xsrv/-/blob/master/roles/libvirt/defaults/main.yml), update them to use the new syntax:
- **tt_rss:** to prevent a possible error during upgrade (`fatal: detected dubious ownership in repository`), run the playbook with the `tt_rss-permissions` tag first (`TAGS=tt_rss-permissions xsrv deploy`)
- **jitsi:** set the variable `jitsi_jvb_prosody_password` to a random 8 character string in your host configuration
- make sure `fact_caching_timeout = 1` is set in your project's `ansible.cfg` (`xsrv edit-cfg`) since long cache timeouts can cause problems with tasks that expect up-to-date facts
- `xsrv deploy` to apply changes

```yaml
# old syntax
libvirt_port_forwards:
  - vm_name: vm01.CHANGEME.org
    host_ip: 1.2.3.4
    vm_ip: 10.0.0.101
    bridge: virbr1
    host_port: 80
    vm_port: 80
    protocol: tcp
  - vm_name: vm01.CHANGEME.org
    host_ip: 1.2.3.4
    vm_ip: 10.0.0.101
    bridge: virbr1
    host_port: 19101
    vm_port: 19999
    protocol: tcp
```
```yaml
# new syntax
libvirt_port_forwards:
  - vm_name: vm01.CHANGEME.org
    vm_ip: 10.0.0.101
    vm_bridge: virbr1
    dnat:
      - host_ip: 1.2.3.4
        host_port: 80
        vm_port: 80
        protocol: tcp # tcp is now the default and can be omitted
      - host_interface: eth0 # the outside network interface can now be specified instead of the IP
        host_port: 19101
        vm_port: 19999
  # additional examples
  - vm_name: vm201.CHANGEME.org
    vm_ip: 10.2.0.100
    vm_bridge: virbr2
    dnat:
      - host_interface: eth0
        host_port: 30000-30100 # port ranges separated by - are now supported
        vm_port: 30000-30100
        protocol: udp
      - host_interface: eth0 # host_interface/host_ip can be combined for finer control
        host_ip: 192.168.12.0/24
        host_port: 123
        vm_port: 123
    forward: # it is now possible to setup forwarding rules between interfaces/bridges without DNAT
      - source_interface: virbr2
        source_ip: 10.2.1.31
        vm_port: 5140
```


**Added:**
- apache: allow configuration of custom reverse proxies ([`apache_reverseproxies`](https://gitlab.com/nodiscc/xsrv/-/blob/master/roles/apache/defaults/main.yml))
- libvirt: add [`utils-libvirt-setmem` tag](https://gitlab.com/nodiscc/xsrv/-/tree/master/roles/libvirt#tags) (update libvirt VMs current memory allocation immediately)
- libvirt: add [`libvirt_users`](https://gitlab.com/nodiscc/xsrv/-/blob/master/roles/libvirt/defaults/main.yml) variable: users to add to the `libvirt/libvirt-qemu/kvm` groups so that they can use `virsh` without sudo
- libvirt: [`libvirt_port_forwards`](https://gitlab.com/nodiscc/xsrv/-/blob/master/roles/libvirt/defaults/main.yml): allow forwarding port ranges
- libvirt: [`libvirt_port_forwards`](https://gitlab.com/nodiscc/xsrv/-/blob/master/roles/libvirt/defaults/main.yml): allow limiting DNAT rules to specific source IPs/networks (`libvirt_port_forwards.*.dnat.*.source_ip`)
- libvirt: [`libvirt_port_forwards`](https://gitlab.com/nodiscc/xsrv/-/blob/master/roles/libvirt/defaults/main.yml): allow forwarding ports between libvirt bridges/networks without DNAT (`libvirt_port_forwards.*.forward`)
- readme_gen: add more information to the default host summary (`xsrv shell`, `xsrv logs`, `xsrv fetch-backups`)

**Changed:**
- xsrv: [`init-vm`](https://xsrv.readthedocs.io/en/latest/appendices/debian.html#automated-from-a-vm-template): rename `--dump` option to `--dumpxml`, require an output file as argument
- common: [`users.*.sudo_nopasswd_commands`](https://gitlab.com/nodiscc/xsrv/-/blob/master/roles/common/defaults/main.yml): allow using passwordless sudo as any user, not just root
- common: create the `ssh` group automatically during initial setup, don't require manually adding the ansible user to the group
- common/matrix: enable automatic upgrades for matrix (synapse) packages by default ([`apt_unattended_upgrades_origins_patterns`](https://gitlab.com/nodiscc/xsrv/-/blob/master/roles/common/defaults/main.yml))
- libvirt: don't install `virt-manager` automatically since it requires a graphical/desktop environment
- libvirt: always use [NAT-based](https://jamielinux.com/docs/libvirt-networking-handbook/nat-based-network.html) networks, not [routed networks](https://jamielinux.com/docs/libvirt-networking-handbook/routed-network.html)
- libvirt: [`libvirt_port_forwards`](https://gitlab.com/nodiscc/xsrv/-/blob/master/roles/libvirt/defaults/main.yml): add a `dnat` list under each `libvirt_port_forwards` entry, allowing to specify multiple port forwarding/DNAT rules (each one with its `host_interface/host_ip,host_port,vm_port,protocol`)
- libvirt: [`libvirt_port_forwards`](https://gitlab.com/nodiscc/xsrv/-/blob/master/roles/libvirt/defaults/main.yml): make `tcp` the default protocol (allow omitting `protocol: tcp`)
- graylog: rename the generated rsyslog server CA certificate to `{{ graylog_fqdn }}-graylog-ca.crt`
- graylog/rsyslog: don't aggregate noisy graylog access logs to syslog
- xsrv: don't require setting a long fact caching timeout in `ansible.cfg` anymore
- default playbook: decrease default ansible fact caching timeout to 1s
- gotty: update to v1.5.0 [[1]](https://github.com/sorenisanerd/gotty/releases/tag/v1.5.0) [[2]](https://github.com/sorenisanerd/gotty/releases/tag/v1.4.0) [[3]](https://github.com/sorenisanerd/gotty/releases/tag/v1.3.0)
- gitea: update to v1.18.5 [[1]](https://github.com/go-gitea/gitea/releases/tag/v1.18.3) [[2]](https://github.com/go-gitea/gitea/releases/tag/v1.18.4) [[3]](https://github.com/go-gitea/gitea/releases/tag/v1.18.5)
- matrix: update element-web to v1.11.24 [[1]](https://github.com/vector-im/element-web/releases/tag/v1.11.21) [[2]](https://github.com/vector-im/element-web/releases/tag/v1.11.22) [[3]](https://github.com/vector-im/element-web/releases/tag/v1.11.23) [[4]](https://github.com/vector-im/element-web/releases/tag/v1.11.24)
- postgresql: update pgmetrics to [v1.14.1](https://github.com/rapidloop/pgmetrics/releases/tag/v1.14.1)
- xsrv: update ansible to [v7.3.0](https://github.com/ansible-community/ansible-build-data/blob/main/7/CHANGELOG-v7.rst)
- common/monitoring_netdata/rsyslog/utils: make roles compatible with [Debian 12 Bookworm](https://www.debian.org/releases/bookworm/)
- cleanup: standardize task names, file permissions
- improve check mode support
- update documentation

**Removed:**
- proxmox: remove role, [archive](https://gitlab.com/nodiscc/toolbox/-/tree/master/ARCHIVE/ANSIBLE-COLLECTION) it to separate repository

**Fixed:**
- netdata: fix netdata not alerting on failed systemd services
- netdata/backup: fix netdata not alerting on outdated or absent last successful backup timestamp file
- tt_rss: `fatal: detected dubious ownership in repository` error when upgrading tt-rss
- tt-rss: disable internal version checks completely, fixes `Unable to determine version` in logs
- jitsi: fix jicofo/jitsi-videobridge unable to connect to prosody
- common: apt: ensure ca-certificates is installed (required for HTTP APT sources)
- libvirt: ensure requirements for libvirt network/storage/VM configuration tasks are installed
- libvirt: fix `configure libvirt networks` failing if the network does not already exist
- libvirt: fix storage pool owner/group ID not being applied
- libvirt: ensure old port forwarding rules are removed when `libvirt_port_forwards` is changed (restart firewalld) 
- graylog: fix `error: peer name not authorized -  not permitted to talk to it.` error
- xsrv: [`init-vm-template`](https://xsrv.readthedocs.io/en/latest/appendices/debian.html#automated-from-preseed-file): fix `unrecognized option '--preseed-file'` error
- xsrv: [`init-vm/init-vm-template`](https://xsrv.readthedocs.io/en/latest/appendices/debian.html#automated-from-preseed-file): fix inconsistent libvirt connection URI, always connect to the `qemu:///system` URI
- xsrv: [`init-vm/init-vm-template`](https://xsrv.readthedocs.io/en/latest/appendices/debian.html#automated-from-preseed-file): refuse to run if the current user is not part of required groups
- xsrv: [`init-vm`](https://xsrv.readthedocs.io/en/latest/appendices/debian.html#automated-from-a-vm-template): do not require `--sudo-user` option, use the default value `deploy` if not provided

[Full changes since v1.11.1](https://gitlab.com/nodiscc/xsrv/-/compare/1.11.0...1.12.0)

------------------


#### [v1.11.1](https://gitlab.com/nodiscc/xsrv/-/releases#1.11.1) - 2023-01-22

**Upgrade procedure:**
- `xsrv upgrade` to upgrade roles/ansible environments to the latest release
- `xsrv deploy` to apply changes

**Fixed:**
- gitea: fix gitea settings [`gitea_enable_api/gitea_api_max_results`](https://gitlab.com/nodiscc/xsrv/-/blob/master/roles/gitea/defaults/main.yml) not having any effect


[Full changes since v1.11.0](https://gitlab.com/nodiscc/xsrv/-/compare/1.11.0...1.11.1)

------------------

#### [v1.11.0](https://gitlab.com/nodiscc/xsrv/-/releases#1.11.0) - 2023-01-20

**Upgrade procedure:**
- `xsrv self-upgrade` to upgrade the xsrv script
- `xsrv upgrade` to upgrade roles/ansible environments to the latest release
- **nextcloud:** if you changed [`nextcloud_apps`](https://gitlab.com/nodiscc/xsrv/-/blob/master/roles/nextcloud/defaults/main.yml) from its default value, remove `files_videoplayer` from the list (`xsrv edit-host/edit-group`)
- **jitsi:** set [`jitsi_prosody_password`](https://gitlab.com/nodiscc/xsrv/-/blob/master/roles/jitsi/defaults/main.yml) in your host configuration variables (`xsrv edit-vault`)
- **gitea:** if `gitea_mailer_enabled` is set to `yes`, add the new [`gitea_mail_protocol/gitea_mail_port`](https://gitlab.com/nodiscc/xsrv/-/blob/master/roles/gitea/defaults/main.yml) settings to your host configuration.
- **rss_bridge:** if you want to keep using the [`rss_bridge`](https://gitlab.com/nodiscc/xsrv/-/tree/1.10.0/roles/rss_bridge) role, update `requirements.yml` ([`xsrv edit-requirements`](https://xsrv.readthedocs.io/en/latest/usage.html#xsrv-edit-requirements)) and `playbook.yml` ([`xsrv edit-playbook`](https://xsrv.readthedocs.io/en/latest/usage.html#xsrv-edit-playbook)) to use the archived [`nodiscc.toolbox.rss_bridge`](https://gitlab.com/nodiscc/toolbox/-/tree/master/ARCHIVE/ANSIBLE-COLLECTION) role instead. The primary goal for the RSS-Bridge role was to provide RSS feeds for Twitter accounts. This can be done by using https://nitter.net/ACCOUNT/rss instead (or one of the [public Nitter instances](https://github.com/zedeus/nitter/wiki/Instances)).
- **rocketchat:** consider [uninstalling rocket.chat](https://gitlab.com/nodiscc/toolbox/-/tree/master/ARCHIVE/ANSIBLE-COLLECTION/roles/rocketchat#uninstall), and migrating to [Matrix](https://gitlab.com/nodiscc/xsrv/-/tree/master/roles/matrix). Alternatively, a simple instant messaging application (Nextcloud Talk) is available through the [`nextcloud`](https://gitlab.com/nodiscc/xsrv/-/tree/master/roles/nextcloud) role, by enabling the `spreed` app under [`nextcloud_apps`](https://gitlab.com/nodiscc/xsrv/-/blob/master/roles/nextcloud/defaults/main.yml). If you want to keep using the `rocketchat` role, update `requirements.yml` ([`xsrv edit-requirements`](https://xsrv.readthedocs.io/en/latest/usage.html#xsrv-edit-requirements)) and `playbook.yml` ([`xsrv edit-playbook`](https://xsrv.readthedocs.io/en/latest/usage.html#xsrv-edit-playbook)) to use the archived [`nodiscc.toolbox.rocketchat`](https://gitlab.com/nodiscc/toolbox/-/tree/master/ARCHIVE/ANSIBLE-COLLECTION) role instead. Reasons for the deprecation can be found [here](https://gitlab.com/nodiscc/toolbox/-/tree/master/ARCHIVE/ANSIBLE-COLLECTION/roles/rocketchat#deprecated).
- **readme_gen:** if you want to use the [`readme-gen`](https://gitlab.com/nodiscc/xsrv/-/tree/master/roles/readme_gen) command, make sure that your project's `README.md` contains the markers `<!-- BEGIN/END AUTOMATICALLY GENERATED CONTENT - README_GEN ROLE -->`
- `xsrv deploy` to apply changes

**Added:**
- add [`matrix`](https://gitlab.com/nodiscc/xsrv/-/tree/master/roles/matrix) role - real-time, secure communication server and web client
- add [`readme-gen`](https://gitlab.com/nodiscc/xsrv/-/tree/master/roles/readme_gen) command and role - generate a markdown inventory in the project's README.md
- netdata: needrestart: add an option to reboot the OS periodically if needed after Linux kernel upgrades ([`needrestart_autorestart_cron`](https://gitlab.com/nodiscc/xsrv/-/blob/master/roles/monitoring_netdata/defaults/main.yml))
- gitea: allow enabling repository indexing/global code search ([`gitea_repo_indexer_enabled, gitea_repo_indexer_exclude`](https://gitlab.com/nodiscc/xsrv/-/blob/master/roles/gitea/defaults/main.yml))
- common: make the timeout for interactive bash sessions configurable ([`bash_timeout`](https://gitlab.com/nodiscc/xsrv/-/blob/master/roles/common/defaults/main.yml), default 900s)
- common: add [bash-completion](https://packages.debian.org/bullseye/bash-completion) to the list of default packages to install ([`packages_install`](https://gitlab.com/nodiscc/xsrv/-/blob/master/roles/common/defaults/main.yml))

**Removed:**
- rocketchat: remove role, [archive](https://gitlab.com/nodiscc/toolbox/-/tree/master/ARCHIVE/ANSIBLE-COLLECTION) it to separate repository
- rss_bridge: remove role, [archive](https://gitlab.com/nodiscc/toolbox/-/tree/master/ARCHIVE/ANSIBLE-COLLECTION) it to separate repository
- remove ansible tag `firewalld` (use `firewall` instead)

**Changed:**
- nextcloud: enable clean URLs
- nextcloud: remove obsolete/unsupported `files_videoplayer` app [[1]](https://github.com/nextcloud/files_videoplayer)
- monitoring_utils: lynis: only report warnings by default, not suggestion or manual checklist items ([`lynis_report_regex`](https://gitlab.com/nodiscc/xsrv/-/blob/master/roles/monitoring_utils/defaults/main.yml))
- common: ensure `/var/log/wtmp` does not become world-readable again after log rotation
- nextcloud: upgrade to v25.0.4 [[1]](https://nextcloud.com/blog/announcing-nextcloud-hub-3-brand-new-design-and-photos-2-0-with-editor-and-ai/) [[2]](https://nextcloud.com/changelog/#latest25)
- gitea: update to v1.18.2 [[1]](https://github.com/go-gitea/gitea/releases/tag/v1.17.4) [[2]](https://github.com/go-gitea/gitea/releases/tag/v1.18.0) [[3]](https://github.com/go-gitea/gitea/releases/tag/v1.18.1) [[4]](https://github.com/go-gitea/gitea/releases/tag/v1.18.2)
- openldap: update ldap-account-manager to [v8.2](https://github.com/LDAPAccountManager/lam/releases/tag/lam_8_2)
- xsrv: update ansible to [v7.1.0](https://github.com/ansible-community/ansible-build-data/blob/main/7/CHANGELOG-v7.rst)
- update ansible tags (see `xsrv help-tags`)
- update test tooling
- update documentation

**Fixed:**
- jitsi: fix jitsi meet/jicofo unable to authenticate to XMPP server (`Unfortunately something went wrong. We're trying to fix this. Reconnecting in...`)
- apache: fix default virtualhost/direct IP access not redirecting to error 403 page
- common: fix [`kernel_proc_hidepid`](https://gitlab.com/nodiscc/xsrv/-/blob/master/roles/openldap/defaults/main.yml) changes not being applied unless the host is rebooted
- libvirt: fix libvirtd service not properly reloaded after updating firewall/port forwarding rules
- gitea: fix configuration file templating failures in `check` mode
- jitsi: prevent debsums warnings about modified `interface_config.js`
- graylog: prevent incorrect debsums reports about missing files in `mongodb-database-tools`
- gitea: fix incorrect default value for `gitea_db_password`
- gitea/gotty: fix systemd services automatic restart limits in case of failure
- gitea: fixes slow browsing that may be experienced in particular cases

[Full changes since v1.10.0](https://gitlab.com/nodiscc/xsrv/-/compare/1.10.0...1.11.0)

-------------------------------

#### [v1.10.0](https://gitlab.com/nodiscc/xsrv/-/releases#1.10.0) - 2022-11-19

**Upgrade procedure:**
- `xsrv upgrade` to upgrade roles/ansible environments to the latest release
- move the `public_keys/` directory from the root of your project directory, under the `data/` directory.
- if it exists, move the `certificates/` directory from the root of your project directory, under the `data/` directory.
- **common:** if you had changed the variable `os_security_kernel_enable_core_dump` from its default value in your hosts/groups configuration, rename it to [`kernel_enable_core_dump`]((https://gitlab.com/nodiscc/xsrv/-/blob/master/roles/common/defaults/main.yml))
- **graylog/monitoring_rsyslog:** move the `*-graylog-ca.crt` file from the `public_keys/` directory to the `data/certificates/` directory (create it if it does not exist)
- **openldap: self-sevice-password:** if you had changed the variable [`self_service_password_allowed_hosts`](https://gitlab.com/nodiscc/xsrv/-/blob/master/roles/openldap/defaults/main.yml) from its default value in your host/groups configuration, update it to the new format (YAML list instead of a list of addresses separated by spaces):

```yaml
# old format
self_service_password_allowed_hosts: "10.0.0.0/8 192.168.0.0/16 172.16.0.0/12"
# new format
self_service_password_allowed_hosts:
  - 10.0.0.0/8
  - 192.168.0.0/16
  - 172.16.0.0/12
```

**Added:**
- add [jitsi](https://gitlab.com/nodiscc/xsrv/-/tree/master/roles/jitsi) role - video conferencing solution
- add [libvirt](https://gitlab.com/nodiscc/xsrv/-/tree/master/roles/libvirt) role - libvirt virtualization toolkit
- xsrv: add [`xsrv open`](https://xsrv.readthedocs.io/en/latest/usage.html#command-line-usage) command (open the project directory in the default file manager)
- xsrv: `init-vm`: add [`--dump`](https://xsrv.readthedocs.io/en/latest/usage.html#provision-hosts) option (display the VM XML definition after creation)
- apache: automatically load new Let's Encrypt certificates every minute, manually reloading the server is no longer needed
- nextcloud: allow configuration of nextcloud log level, default app on login ([`nextcloud_loglevel`/`nextcloud_defaultapp`](https://gitlab.com/nodiscc/xsrv/-/blob/master/roles/nextcloud/defaults/main.yml))
- common: kernel: hardening: allow hiding processes from other users ([`kernel_proc_hidepid: no/yes`](https://gitlab.com/nodiscc/xsrv/-/blob/master/roles/common/defaults/main.yml))
- shaarli: add ability to install the python API client ([`shaarli_setup_python_client: no/yes`](https://gitlab.com/nodiscc/xsrv/-/blob/master/roles/shaarli/defaults/main.yml)) and export all shaarli data to a JSON file every hour
- wireguard: add ability to enable/disable the wireguard server service ([`wireguard_enable_service: yes/no`](https://gitlab.com/nodiscc/xsrv/-/blob/master/roles/wireguard/defaults/main.yml))
- monitoring/netdata: allow disabling notifications for ping check alarms ([`netdata_fping_alarms_silent: yes/no`](https://gitlab.com/nodiscc/xsrv/-/blob/master/roles/monitoring_netdata/defaults/main.yml))
- apache/monitoring: netdata: monitor state of the php-fpm service and alert in case of failure
- apache: start/stop the php7.4-fpm service alongside the apache service depending on `apache_enable_service: yes/no`
- shaarli: add required packages for LDAP authentication
- monitoring_netdata: add `utils-autorestart` tag (reboot hosts if required after a kernel update, will only run if the `utils-autorestart` tag is explicitly called)
- samba: add `utils-samba-listusers` tag (list samba users)
- common: install hardware true random number generator (TRNG) support packages on hosts where the CPU supports [RDRAND](https://en.wikipedia.org/wiki/RDRAND)

**Removed:**
- tt_rss: remove installation of custom plugins/themes

**Changed:**
- nextcloud: no longer disable accessibility app by default
- nextcloud: disable the web updater
- nextcloud: disable link to https://nextcloud.com/signup/ on public pages
- nextcloud: backup: add `config.php` to the list of files to backup (may contain the encryption secret if encryption was enabled by the admin)
- openldap: self-service-password: update format of [`self_service_password_allowed_hosts`](https://gitlab.com/nodiscc/xsrv/-/blob/master/roles/openldap/defaults/main.yml) (use a YAML list instead of space-separated list)
- common: kernel: rename variable `os_security_kernel_enable_core_dump` -> [`kernel_enable_core_dump`](https://gitlab.com/nodiscc/xsrv/-/blob/master/roles/common/defaults/main.yml)
- common: kernel/sysctl: ensure ipv4/ipv6 configuration is applied to all new/future interfaces as well
- common: kernel/sysctl: don't disable USB storage, audio input/output, USB MIDI, bluetooth and camera modules by default
- common: kernel/sysctl: don't disable audio input/output module by default
- common: kernel/sysctl: don't disable bluetooth modules by default
- common: kernel/sysctl: don't disable camera modules by default
- common: kernel/sysctl: don't disable `vfat` `squashfs` filesystems module by default
- common/graylog: apt: use HTTPS to access APT packages repositories
- common: dns: check that valid IP addresses are specified in [`dns_nameservers`](https://gitlab.com/nodiscc/xsrv/-/blob/master/roles/common/defaults/main.yml)
- common: kernel/sysctl: load all sysctl variables, not just those in `custom.conf`
- common: users: configure bash to terminate idle sessions after 15 minutes
- common: packages: always install haveged entropy source on KVM/VMware VMs
- common: packages: remove haveged from the default list of packages to install everywhere
- wireguard: firewalld: setup firewall to allow blocking/allowing traffic from VPN clients to services on the host, independently
- monitoring_utils: lynis: whitelist suggestion to disable USB storage
- monitoring_utils: lynis: whitelist suggestion to install sysstat, when netdata is installed
- tt_rss: run the web application (php-fpm pool) un der a dedicated user account
- xsrv: `init-vm-template`: make the `--template` option optional, default to `debian11-base`
- xsrv: `init-vm-template`: make the `--sudo-user` option optional, default to `deploy`
- xsrv: `init-vm/init-vm-template`: clarify use of units `M` or `G` for `--memory` option
- nextcloud: update to v24.0.7 [[1]](https://nextcloud.com/blog/maintenance-releases-24-0-6-and-23-0-10-are-out-plus-5th-beta-of-our-upcoming-release/) [[2]](https://nextcloud.com/changelog/)
- gitea: update to [v1.17.3](https://github.com/go-gitea/gitea/releases/tag/v1.17.3)
- openldap: update self-service-password to [v1.5.2](https://github.com/ltb-project/self-service-password/releases/tag/v1.5.2)
- openldap: ldap-account-manager: upgrade to [v8.1](https://github.com/LDAPAccountManager/lam/releases/tag/lam_8_1)
- graylog: update mongodb to v4.4
- rocketchat: upgrade to [v3.18.7](https://raw.githubusercontent.com/RocketChat/Rocket.Chat/develop/HISTORY.md)
- cleanup: replace deprecated `apt_key/apt_repository` modules, install all APT keys in `/usr/share/keyrings/`
- xsrv: update ansible to [v6.6.0](https://github.com/ansible-community/ansible-build-data/blob/main/6/CHANGELOG-v6.rst)
- postgresql: update pgmetrics to [v1.14.0](https://github.com/rapidloop/pgmetrics/releases/tag/v1.14.0)
- general cleanup and maintenance, remove deprecated ansible modules
- update ansible tags
- update documentation
- update/improve test tooling

**Fixed:**
- shaarli: fix shaarli unable to save thumbnails to disk
- shaarli: fix broken link (HTTP 403) to documentation
- jellyfin: fix jellyfin unable to upgrade on machines migrated from Debian 10 -> 11
- common: kernel/sysctl: don't disable `vfat` module required by EFI boot
- graylog: fix installation of elasticsearch packages
- graylog: prevent incorrect debsums reports about missing files in `mongodb-database-tools`
- monitoring/netdata: fix individual alarms for failed systemd services
- common: firewalld: add all addresses from `192.168.0.0/16` to the `internal` zone by default, not just `192.168.0.0/24`
- xsrv: `init-vm-template`: fix non-working options `--sudo-password, --root-password, --sudo-user, --nameservers`
- xsrv: `init-vm`: fix an issue where VMs would be created with 1MB of memory when `--memory 1024` was used
- xsrv: fix `init-vm-template` command not working unless `xsrv self-upgrade` had already been run

**Security:**
- jellyfin: only allow connections from LAN (RFC1918) IP addresses by default ([`jellyfin_allowed_hosts`](https://gitlab.com/nodiscc/xsrv/-/blob/master/roles/jellyfin/defaults/main.yml))
- common: fix [`kernel_enable_core_dump`](https://gitlab.com/nodiscc/xsrv/-/blob/master/roles/common/defaults/main.yml) not having any effect

[Full changes since v1.9.0](https://gitlab.com/nodiscc/xsrv/-/compare/1.9.0...1.10.0)

-------------------------------

#### [v1.9.0](https://gitlab.com/nodiscc/xsrv/-/releases#1.9.0) - 2022-09-18

**Upgrade procedure:**
- `xsrv self-upgrade` to upgrade the xsrv script
- `xsrv upgrade` to upgrade roles/ansible environments to the latest release
- **gitea:** if you rely on custom git hooks for your projects, set `gitea_enable_git_hooks: yes` in the host configuration/vars file (`xsrv edit-host`)
- `xsrv deploy` to apply changes

**Added:**
- xsrv: add [`xsrv init-vm-template`](https://xsrv.readthedocs.io/en/latest/usage.html#provision-hosts) command (create a libvirt Debian VM template, unattended using a preconfiguration file)
- add [wireguard](https://gitlab.com/nodiscc/xsrv/-/tree/master/roles/wireguard) role - fast and modern VPN server
- nextcloud: enable [group folders](https://apps.nextcloud.com/apps/groupfolders) app by default
- common: allow setting up [apt-listbugs](https://packages.debian.org/bullseye/apt-listbugs) to prevent installation of packages with known serious bugs ([`apt_listbugs: yes/no`](https://gitlab.com/nodiscc/xsrv/-/blob/master/roles/common/defaults/main.yml))
- common: allow specifying a list of packages to install/remove ([`packages_install/remove`](https://gitlab.com/nodiscc/xsrv/-/blob/master/roles/common/defaults/main.yml))
- gitea: allow enabling/disabling git hooks and webhooks features globally ([`gitea_enable_git_hooks/webhooks`](https://gitlab.com/nodiscc/xsrv/-/blob/master/roles/gitea/defaults/main.yml))
- gitea: allow configuring the list of hosts that can be called from webhooks ([`gitea_webhook_allowed_hosts`](https://gitlab.com/nodiscc/xsrv/-/blob/master/roles/gitea/defaults/main.yml))
- gitea: allow configuring the SSH port exposed in the clone URL ([`gitea_ssh_url_port`](https://gitlab.com/nodiscc/xsrv/-/blob/master/roles/gitea/defaults/main.yml))

**Removed:**
- common: remove `setup_cli_utils` and `setup_haveged` variables. Use [`packages_install/remove`](https://gitlab.com/nodiscc/xsrv/-/blob/master/roles/common/defaults/main.yml) instead.

**Changed:**
- gitea: disable git hooks by default
- gitea: upgrade to v1.17.2 [[1]](https://github.com/go-gitea/gitea/releases/tag/v1.16.9) [[2]](https://github.com/go-gitea/gitea/releases/tag/v1.17.0) [[3]](https://github.com/go-gitea/gitea/releases/tag/v1.17.1) [[4]](https://github.com/go-gitea/gitea/releases/tag/v1.17.2)
- openldap: update self-service-password to v1.5.1 [[1]](https://github.com/ltb-project/self-service-password/releases/tag/v1.5.0) [[2]](https://github.com/ltb-project/self-service-password/releases/tag/v1.5.1)
- nextcloud: upgrade to v24.0.5 [[1]](https://nextcloud.com/blog/maintenance-releases-24-0-3-23-0-7-and-22-2-10-are-out-update/) [[2]](https://nextcloud.com/changelog/#latest24)
- postgresql: update pgmetrics to [v1.13.1](https://github.com/rapidloop/pgmetrics/releases/tag/v1.13.1)
- shaarli: hardening: run shaarli under a dedicated `shaarli` user account (don't use the default shared `www-data` user)
- xsrv: upgrade ansible to [v6.4.0](https://github.com/ansible-community/ansible-build-data/blob/main/6/CHANGELOG-v6.rst)
- nextcloud/netdata: mitigate frequent httpckeck alarms on the nextcloud web service response time (`httpcheck_web_service_unreachable`), increase the timeout of the check to 3s
- common: sysctl: automatically reboot the host after 60 seconds in case of kernel panic
- common: hardening: ensure `/var/log/wtmp` is not world-readable
- common: login/ssh: hardening: kill user processes when an interactive user logs out (except for root). Lock idle login sessions after 15 minutes of inactivity.
- common: ssh: hardening: replace the server's default 2048 bits RSA keypair with 4096 bits keypair
- common: sudo: hardening: configure sudo to run processes in a pseudo-terminal
- common: users/pam: hardening: increase the number of rounds for hashing group passwords
- common: sysctl: hardening: only allow root/users with CAP_SYS_PTRACE to use ptrace
- common: sysctl: hardening: disable more kernel modules by default (bluetooth, audio I/O, USB storage, USB MIDI, UVC/V4L2/CPIA2 video devices, thunderbolt, floppy, PC speaker beep)
- common: sysctl: hardening: restrict loading TTY line disciplines to the CAP_SYS_MODULE capability
- common: sysctl: hardening: protect against unintentional writes to an attacker-controlled FIFO
- common: sysctl: hardening: prevent even the root user from reading kernel memory maps
- common: sysctl: hardening: enable BPF JIT hardening
- common: sysctl: hardening: disable ICMP redirect support for IPv6
- all roles: require `ansible-core>=2.12/ansible>=6.0.0`
- common: improve check mode support before first deployment
- tools/tests: improve/simplify test tools

**Fixed:**
- common: users: fix errors during creation of `sftponly` user accounts when no groups are defined in the user definition

[Full changes since v1.8.1](https://gitlab.com/nodiscc/xsrv/-/compare/1.8.1...1.9.0)

-------------------------------

#### [v1.8.1](https://gitlab.com/nodiscc/xsrv/-/releases#1.8.0) - 2022-07-10

**Upgrade procedure:**
- `xsrv upgrade` to upgrade roles/ansible environments to the latest release
- `xsrv deploy` to apply changes

**Fixed:**
- backup/rsnapshot: fix rsnapshot installation, always install from Debian repositories

[Full changes since v1.8.0](https://gitlab.com/nodiscc/xsrv/-/compare/1.8.0...1.8.1)

-------------------------------

#### [v1.8.0](https://gitlab.com/nodiscc/xsrv/-/releases#1.8.0) - 2022-07-04

**Upgrade procedure:**
- `xsrv self-upgrade` to upgrade the xsrv script
- `xsrv upgrade` to upgrade roles/ansible environments to the latest release
- **gitea/gotty/graylog/homepage/jellyfin/nextcloud/openldap/rocketchat/rss_bridge/shaarli/transmission/tt_rss:** ensure the `apache` role or equivalent is explicitly deployed to the host *before* deploying any of these roles.
- **jellyfin/samba:** if both jellyfin and samba roles are deployed on the same host, ensure `samba` is deployed before `jellyfin` ([`xsrv edit-playbook`](https://xsrv.readthedocs.io/en/latest/usage.html#xsrv-edit-playbook))
- **valheim_server:** if you are using the [`valheim_server`](https://gitlab.com/nodiscc/xsrv/-/tree/1.7.0/roles/valheim_server) role, update `requirements.yml` ([`xsrv edit-requirements`](https://xsrv.readthedocs.io/en/latest/usage.html#xsrv-edit-requirements)) and `playbook.yml` ([`xsrv edit-playbook`](https://xsrv.readthedocs.io/en/latest/usage.html#xsrv-edit-playbook)) to use the archived [`nodiscc.toolbox.valheim_server`](https://gitlab.com/nodiscc/toolbox/-/tree/master/ARCHIVE/ANSIBLE-COLLECTION) role instead.
- `xsrv deploy` to apply changes

**Added:**
- add [`mail_dovecot`](https://gitlab.com/nodiscc/xsrv/-/tree/master/roles/mail_dovecot) role - IMAP mailbox server
- monitoring: netdata: allow streaming charts data/alarms to/from other netdata nodes ([`netdata_streaming_*`](https://gitlab.com/nodiscc/xsrv/-/blob/master/roles/monitoring_netdata/defaults/main.yml))
- monitoring: netdata: enable monitoring of hard drives SMART status
- xsrv: add [`xsrv ssh`](https://xsrv.readthedocs.io/en/latest/usage.html#command-line-usage) subcommand (alias for `shell`)
- openldap: allow secure LDAP communication over SSL/TLS on port 636/tcp (use a self-signed certificate)
- common: allow disabling PAM/user accounts configuration tasks ([`setup_users: yes/no`](https://gitlab.com/nodiscc/xsrv/-/blob/master/roles/common/defaults/main.yml))
- common: allow blacklisting unused/potentially insecure kernel modules ([`kernel_modules_blacklist`](https://gitlab.com/nodiscc/xsrv/-/blob/master/roles/common/defaults/main.yml)), disable unused network/firewire modules by default
- common: automatically remove (purge) configuration files of removed packages, nightly, enabled by default ([`apt_purge_nightly: yes/no`](https://gitlab.com/nodiscc/xsrv/-/blob/master/roles/common/defaults/main.yml))
- common: attempt to automatically repair (fsck) failed filesystems on boot
- docker: allow enabling automatic firewall/iptables rules setup by Docker ([`docker_iptables: no/yes`](https://gitlab.com/nodiscc/xsrv/-/blob/1.17.0/roles/docker/defaults/main.yml))
- docker: install requirements for logging in to private docker registries
- openldap: self-service-password/ldap-account-manager: make LDAP server URI configurable ([`*_ldap_url`](https://gitlab.com/nodiscc/xsrv/-/blob/master/roles/openldap/defaults/main.yml))
- openldap: ldap-account-manager: allow specifying a trusted LDAPS server certificate ([`ldap_account_manager_ldaps_cert`](https://gitlab.com/nodiscc/xsrv/-/blob/master/roles/openldap/defaults/main.yml))
- samba: make events logged by full_audit configurable ([`samba_log_full_audit_success_events`](https://gitlab.com/nodiscc/xsrv/-/blob/master/roles/samba/defaults/main.yml))
- shaarli: add an option to configure thumbnail generation mode ([`shaarli_thumbnails_mode`](https://gitlab.com/nodiscc/xsrv/-/blob/master/roles/shaarli/defaults/main.yml)) and default number of links per page (`shaarli_links_per_page`, default 30)
- postgresql: download pgmetrics report to the controller when running `TAGS=utils-pgmetrics`
- all roles: checks: add an info message pointing to roles documentation when one or more variables are not correctly defined
- xsrv: [`xsrv help-tags`](https://xsrv.readthedocs.io/en/latest/usage.html#command-line-usage) will now parse tag descriptions from custom roles in `roles/` in addition to collections
- monitoring: utils: add `iputils-ping` package (ping utility)

**Removed:**
- common: firewalld/mail/msmtp: drop compatibility with Debian 10
- valheim_server: remove role, [archive](https://gitlab.com/nodiscc/toolbox/-/tree/master/ARCHIVE/ANSIBLE-COLLECTION) it to separate repository (installs non-free components)

**Changed:**
- netdata: needrestart: don't send e-mail notifications for needrestart alarms
- netdata: debsecan: refresh debsecan reports every 6 hours instead of every hour
- netdata: disable metrics gathering for `/dev` and `/dev/shm` virtual filesystems
- all roles: checks all variables values *before* failing, when one or more variables are not correctly defined
- tt_rss: don't send feed update errors by mail, log them to syslog
- xsrv: always use the first host/group in alphabetical order when no host/group is specified
- xsrv: upgrade ansible to [v5.10.0](https://github.com/ansible-community/ansible-build-data/blob/main/5/CHANGELOG-v5.rst)
- apache/proxmox: only setup fail2ban when it is marked as managed by ansible through ansible local facts
- common: ssh: increase the frequency of "client alive" messages to 1 every 5 minutes
- common: ssh/users: don't allow login for users without an existing home directory
- apache: rsyslog: prefix apache access logs with `apache-access:` in syslog when [`apache_access_log_to_syslog: yes`](https://gitlab.com/nodiscc/xsrv/-/blob/master/roles/apache/defaults/main.yml)
- homepage: improve homepage styling/layout, link directly to `ssh://` and `sftp://` URIs
- homepage: reword default [`homepage_message`](https://gitlab.com/nodiscc/xsrv/-/blob/master/roles/homepage/defaults/main.yml)
- shaarli: default to generating thumbnails only for common media hosts
- transmission: firewall: always allow bittorrent peer traffic from the public zone
- monitoring_utils: lynis: review and whitelist unapplicable "suggestion" level report items ([`lynis_skip_tests`](https://gitlab.com/nodiscc/xsrv/-/blob/master/roles/monitoring_utils/defaults/main.yml))
- nextcloud: upgrade to v24.0.1 [[1]](https://nextcloud.com/blog/nextcloud-hub-24-is-here/) [[2]](https://nextcloud.com/blog/maintenance-releases-24-0-1-23-0-5-and-22-2-8-are-out-update/) [[3]](https://nextcloud.com/changelog/#latest23)
- gitea: upgrade to v1.16.8 [[1]](https://github.com/go-gitea/gitea/releases/tag/v1.16.6) [[2]](https://github.com/go-gitea/gitea/releases/tag/v1.16.7) [[3]](https://github.com/go-gitea/gitea/releases/tag/v1.16.8)
- openldap: ldap-account-manager: upgrade to [v7.9.1](https://www.ldap-account-manager.org/lamcms/node/446)
- rss_bridge: upgrade to [v2022-06-14](https://github.com/RSS-Bridge/rss-bridge/releases/tag/2022-06-14)
- postgresql: update pgmetrics to [v1.13.0](https://github.com/rapidloop/pgmetrics/releases/tag/v1.13.0)
- gitea/gotty/graylog/homepage/jellyfin/nextcloud/openldap/rocketchat/rss_bridge/shaarli/transmission/tt_rss: remove hard dependency on apache role
- cleanup: proxmox: use a single file to configure proxmox APT repositories
- cleanup: apache: ensure no leftover mod-php installations are present
- cleanup: common: users: move PAM configuration to the main `limits.conf` configuration file
- cleanup/tools: improve `check` mode support, standardize task names, remove unused template files, make usage of ansible_facts consistent in all roles, clarify xsrv script, reorder functions by purpose/component, automate documentation generation, improve tests/release procedure, automate initial check mode/deployment/idempotence tests
- update documentation

**Fixed:**
- xsrv: `init-project`: fix inventory not correctly initialized
- xsrv: fix `xsrv shell/fetch-backups` when a non-default `XSRV_PROJECTS_DIR` is specified by the user
- common: ssh: fix confusion between `AcceptEnv` and `PermitUserEnvironment` settings
- all roles: monitoring/netdata: fix systemd services health checks not loaded by netdata
- apache: monitoring/rsyslog: fix rsyslog config installation when running with only `--tags=monitoring`
- graylog: fix elasticsearch/graylog unable to start caused by too strict permissions on configuration files
- openldap: ldap-account-manager: fix access to tree view
- homepage: fix homepage generation when the mumble role was deployed from a different play
- jellyfin/samba: fix jellyfin [samba share](https://gitlab.com/nodiscc/xsrv/-/blob/master/roles/jellyfin/defaults/main.yml) creation when samba role is not part of the same play
- samba: fix [`samba_passdb_backend: ldapsam`](https://gitlab.com/nodiscc/xsrv/-/blob/master/roles/samba/defaults/main.yml#L39) mode when openldap role is not part of the same play
- xsrv: [`fetch-backups`](https://xsrv.readthedocs.io/en/latest/usage.html#command-line-usage): use the first host in alphabetical order, when no host is specified
- monitoring: rsyslog: add correctness checks for `syslog_retention_days` variable
- monitoring: netdata/needrestart: fix `needrestart_autorestart_services` value not taken into account when true
- shaarli/transmission: fix `*_https_mode` variable checks
- doc: fix broken links

**Security:**
- proxmox: fail2ban: fix detection of failed login attempts

[Full changes since v1.7.0](https://gitlab.com/nodiscc/xsrv/-/compare/1.7.0...1.8.0)

-------------------------------

#### [v1.7.0](https://gitlab.com/nodiscc/xsrv/-/releases#1.7.0) - 2022-04-22

**Upgrade procedure:**
- `xsrv self-upgrade` to upgrade the xsrv script
- `xsrv upgrade` to upgrade roles/ansible environments to the latest release
- this upgrade will cause Nextcloud instances to go down for a few minutes, depending on the number of files in their data directory

**Added:**
- xsrv: add [`init-vm`](https://xsrv.readthedocs.io/en/latest/usage.html#command-line-usage) command (initialize a ready-to-deploy libvirt VM from a template)
- xsrv: add [`edit-group-vault`](https://xsrv.readthedocs.io/en/latest/usage.html#command-line-usage) command (edit encrypted group variables file)
- common: make cron jobs log level configurable ([`cron_log_level`](https://gitlab.com/nodiscc/xsrv/-/blob/master/roles/common/defaults/main.yml))
- common: apt: clean downloaded package archives every 7 days by default ([`apt_clean_days`](https://gitlab.com/nodiscc/xsrv/-/blob/master/roles/common/defaults/main.yml))
- netdata: allow configuring the [fping](https://learn.netdata.cloud/docs/agent/collectors/fping.plugin) plugin (ping hosts/measure loss/latency) ([`netdata_fping_*`](https://gitlab.com/nodiscc/xsrv/-/blob/master/roles/monitoring_netdata/defaults/main.yml))
- netdata: make netdata filechecks configurable ([`netdata_file_checks`](https://gitlab.com/nodiscc/xsrv/-/blob/master/roles/monitoring_netdata/defaults/main.yml))
- transmission/gotty/jellyfin/docker: monitoring/netdata: raise alarms when corresponding systemd services are in the failed state (and the `monitoring_netdata` role is deployed)
- homepage: add rss-bridge to the homepage when the rss_bridge role is deployed on the host
- add ansible [tags](https://xsrv.readthedocs.io/en/latest/usage.html#command-line-usage): `netdata-modules`, `netdata-needrestart`, `netdata-debsecan`, `netdata-logcount`, `netdata-config`

**Changed:**
- common: sysctl/security: disable potentially exploitable unprivileged BPF and user namespaces
- gitea: limit systemd service automatic restart attempts to 4 in 10 seconds
- gitea: update to v1.16.5 [[1]](https://github.com/go-gitea/gitea/releases/tag/v1.16.1) [[2]](https://github.com/go-gitea/gitea/releases/tag/v1.16.2) [[3]](https://github.com/go-gitea/gitea/releases/tag/v1.16.3) [[4]](https://github.com/go-gitea/gitea/releases/tag/v1.16.4) [[5]](https://github.com/go-gitea/gitea/releases/tag/v1.16.5)
- gotty: attempt to restart the systemd service every 2 seconds in case of failure, for a maximum of 4 times in 10 seconds
- netdata: disable more internal monitoring charts (plugin execution time, webserver threads CPU)
- netdata: re-add default netdata alarms for the `systemdunits` module
- nextcloud: update to v23.0.3 [[1]](https://nextcloud.com/blog/update-now-23-0-2-22-2-5-and-21-0-9/) [[2]](https://nextcloud.com/blog/nextcloud-23-0-3-and-22-2-6-are-out-bringing-a-series-of-bug-fixes-and-improvements/)
- nextcloud: run nextcloud PHP processes under a dedicated `nextcloud` user, if an older installation owned by `www-data` is found, it will be migrated to the new user automatically
- openldap: update LDAP Account Manager to [v8.0.1](https://github.com/LDAPAccountManager/lam/releases)
- rocketchat: update to [v3.18.4](https://github.com/RocketChat/Rocket.Chat/releases)
- apache/fail2ban/nextcloud: remove obsolete workaround for nextcloud [desktop client issue](https://github.com/nextcloud/server/issues/15688)
- xsrv: store group_vars files under `group_vars/$group_name/` (allows multiple vars files per group). If a `group_vars/$group_name.yml` file is found, it will be moved to the subdirectory automatically.
- xsrv: update ansible to [v5.5.0](https://github.com/ansible-community/ansible-build-data/blob/main/5/CHANGELOG-v5.rst)
- cleanup: make netdata assembled configuration more readable (add blank line delimiters)
- cleanup: standardize file names
- all roles: check that variables are correctly defined before running roles
- tests: ansible-lint: ignore `fqcn-bultins,truthy,braces,line-length` rules
- tests: remove broken jinja2 syntax test
- tests: remove obsolete `ansible-playbook --syntax-check` and `yamllint` tests, replaced by ansible-lint
- tests: automate tests for `init-vm`, `xsrv check`, `xsrv deploy`
- doc: update documentation, default playbook README, Gitlab CI example


**Fixed:**
- all roles: ensure `check` mode doesn't fail when running it before before first deployment
- common: ssh/users: fix SFTP-only user accounts creation (set permissions _after_ creating user accounts)
- all roles: firewall: fix 'reload firewall/fail2ban/apache' handlers failures when called from other roles
- openldap: fix ldap-ccount-manager installation on Debian 11 (php package name changes)
- graylog: fix graylog service not starting/incorrect permissions on configuration files
- graylog/mumble: monitoring/netdata: fix healthcheck/alarm not returning correct status when systemd services are in the failed state
- netdata: fix location for needrestart module configuration file
- netdata: fix/standardize indentation in configuration files produced by `to_nice_yaml`
- homepage: fix homepage templating when the homepage role is not part of the same play as related roles
- shaarli: explicitly use php 7.4 packages, fix possible installation problems on Debian 11
- tests: fix and speed up `ansible-lint` tests, fix ansible-lint warnings

[Full changes since v1.6.0](https://gitlab.com/nodiscc/xsrv/-/compare/1.6.0...1.7.0)

-------------------------------

#### [v1.6.0](https://gitlab.com/nodiscc/xsrv/-/releases#1.6.0) - 2022-03-17

**Upgrade procedure:**
- `xsrv self-upgrade` to upgrade the xsrv script
- `xsrv upgrade` to upgrade roles in your playbook to the latest release

**Added:**
- add [rss_bridge](https://gitlab.com/nodiscc/xsrv/-/tree/master/roles/rss_bridge) role - the RSS feed for websites missing it
- monitoring_utils: install [debsums](https://packages.debian.org/sid/debsums) utility for the verification of packages with known good database (by default, run weekly)
- common: cron: allow disabling cron setup (`setup_cron: yes/no`)
- monitoring_netdata: allow configuring netdata notification downtime periods (start/end)
- tests: automate basic testing of the xsrv command-line tool (`xsrv init-project xsrv-test my.example.org`)

**Changed:**
- common: cron: include the FDQN in subject when sending mail
- common: cron: log beginning and end of cron jobs
- all roles: replace netdata process checks/alarms with more accurate systemd unit checks, raise alarms/notifications when a service is in the failed state
- cleanup: standardize task names
- xsrv: init-project: allow adding a first host directly using `xsrv init-project [project] [host]`

**Fixed:**
- fix `check` mode support for self-signed certificate generation tasks/netdata configuration
- apt: fix automatic upgrades for packages installed from Debian Backports
- xsrv: fix error on new project creation/`init-playbook` - missing playbook directory
- xsrv: fix support for `XSRV_PROJECTS_DIR` environment variable

[Full changes since v1.5.0](https://gitlab.com/nodiscc/xsrv/-/compare/1.5.0...1.6.0)

-------------------------------

#### [v1.5.0](https://gitlab.com/nodiscc/xsrv/-/releases#1.5.0) - 2022-02-25

**Upgrade procedure:**
- `xsrv self-upgrade` to upgrade the xsrv script
- `xsrv upgrade` to upgrade roles in your playbook to the latest release
- `TAGS=utils-debian10to11 xsrv deploy` to upgrade your host's distribution from Debian 10 "Buster" to [Debian 11 "Bullseye"](https://www.debian.org/News/2021/20210814.html). Debian 10 compatibility will not be maintained after this release.
- **common/firewall:** remove `firehol_*` variables from your configuration. Roles from the `xsrv` collection will automatically insert their own rules, if firewalld is deployed. If you had custom firewall rules in place/not related to xsrv roles, please port them to the new [`firewalld` configuration](https://gitlab.com/nodiscc/xsrv/-/blob/master/roles/common/defaults/main.yml#L74))
- **common/hosts:** if the `hosts:` variable (hosts file entries) is used in your `host/group_vars`, rename it to  `hosts_file_entries`. If `setup_hosts` is used in your `host/group_vars`, rename it to `setup_hosts_file`.
- **mariadb:** if you had the `nodiscc.xsrv.mariadb` role enabled, migrate to PostgreSQL, or use the [archived `nodiscc.toolbox.mariadb` role](https://gitlab.com/nodiscc/toolbox/-/tree/master/ARCHIVE/ANSIBLE-COLLECTION).
- **gitea/nextcloud/tt_rss:** if any of these roles is listed in your playbook, ensure `nodiscc.xsrv.postgresql` is explicitly deployed before it.
- **jellyfin/proxmox/docker:** remove `jellyfin_auto_upgrade`, `proxmox_auto_upgrade` or `docker_auto_upgrade` variables from your configuration, if you changed the defaults. These settings are now controlled by the [`apt_unattended_upgrades_origins_patterns`](https://gitlab.com/nodiscc/xsrv/-/blob/master/roles/common/defaults/main.yml#L48) list, automatic upgrades are enabled by default for these components.
- **jellyfin/samba:** if you have both the `samba` and `jellyfin` roles enabled on a host, and want to keep using the jellyfin samba share for media storage, explicitly set `jellyfin_samba_share: yes` in the host's configuration variables.
- **monitoring:** remove `setup_monitoring_cli_utils: yes/no` and `setup_rsyslog: yes/no` variables from your configuration, if you changed the defaults. If you don't want monitoring utilities or rsyslog set up, enable individual `monitoring_netdata/rsyslog/utils` roles, instead of the global `monitoring` role.
- (optional) `xsrv check` to simulate changes.
- `xsrv deploy` to apply changes.

**Added:**
- add [dnsmasq](https://gitlab.com/nodiscc/xsrv/-/tree/master/roles/dnsmasq) lightweight DNS server role
- common: add [firewalld](https://firewalld.org/) firewall management tool
- common: apt: allow configuration of allowed origins for unattended-upgrades
- common: packages: add `at` task scheduler
- monitoring: netdata: allow disabling specific plugins (`netdata_disabled_plugins`), disable `ebpf` plugin by default
- monitoring: lynis: enable lynis installation and daily reports by default
- common: ssh: fix lynis warning FILE-7524 (ensure `/root/.ssh` is mode 0700)
- common: mail/msmtp: allow disabling SMTP authentication/LOGIN (`msmtp_auth_enabled`), allow disabling SMTP server TLS certificate verification completely (`msmtp_tls_certcheck: yes/no`)
- common: mail/msmtp: allow disabling TLS (`msmtp_tls_enabled`)
- monitoring: netdata: automate testing netdata mail notifications (`TAGS=utils-netdata-test-notifications xsrv deploy`)
- monitoring: netdata: monitor systemd units state (timers/services/sockets)
- docker: add a nightly cleanup of unused docker images/containers/networks/build cache, allow disabling it through `docker_prune_nighlty: no`
- xsrv: add [`xsrv help-tags`](https://xsrv.readthedocs.io/en/latest/usage.html#command-line-usage) subcommand (show the list of ansible tags in the play and their descriptions)
- install ansible local fact files for each deployed role/component

**Removed:**
- common: remove [firehol](https://firehol.org/) firewall management tool, remove `firehol_*` configuration variables
- common: firewall: remove ability to filter outgoing traffic, will be re-added later
- drop compatibility with Debian 9
- monitoring: remove `setup_monitoring_cli_utils: yes/no` and `setup_rsyslog: yes/no` variables
- common: fail2ban: remove `fail2ban_destemail` variable, always send mail to root
- mariadb: remove role, [archive](https://gitlab.com/nodiscc/toolbox/-/tree/master/ARCHIVE/ANSIBLE-COLLECTION) it to separate repository
- remove ansible tags `certificates lamp valheim valheim-server`

**Changed:**
- make all roles compatible with Debian 11
- common/firewall/all roles: let roles manage their own firewall rules if the `nodiscc.xsrv.firewalld` role is deployed
- all roles: refactor/performance: only flush handlers once, unless required otherwise, refactor service start/stop/enable/disable tasks
- common: fail2ban: ban offenders on all ports
- jellyfin: the jellyfin samba share automatic setup is now disabled by default (`jellyfin_samba_share_enabled: no`)
- apache/tt_rss/shaarli/nextcloud: make roles compatible with Debian 11 (PHP 7.4))
- jellyfin/proxmox/docker: remove `jellyfin_auto_upgrade`, `proxmox_auto_upgrade`, `docker_auto_upgrade` variables, add these origins to the default list of `apt_unattended_upgrades_origins_patterns`
- monitoring: split role to smaller `monitoring_rsyslog`/`monitoring_netdata`/`monitoring_utils` roles, make the `monitoring` role an alias for these 3 roles
- common: apt: explicitly install aptitude
- common: apt: remove unused packages after automatic upgrades
- common: apt: automatically remove unused dependency packages on every install/upgrade/remove operation
- common: fail2ban: increase maximum IP/attempts count retention to 1 year
- common: ssh: decrease SFTP logs verbosity to INFO by default
- common/graylog: apt: enable automatic upgrades for graylog/mongodb/elasticsearch packages by default ([`apt_unattended_upgrades_origins_patterns`](https://gitlab.com/nodiscc/xsrv/-/blob/master/roles/common/defaults/main.yml#L48))
- gitea: upgrade to v1.16.0 [[1]](https://github.com/go-gitea/gitea/releases/tag/v1.15.8), [[2]](https://github.com/go-gitea/gitea/releases/tag/v1.15.9), [[3]](https://github.com/go-gitea/gitea/releases/tag/v1.15.10), [[4]](https://github.com/go-gitea/gitea/releases/tag/v1.15.11), [[5]](https://github.com/go-gitea/gitea/releases/tag/v1.16.0)
- xsrv: upgrade ansible to [5.2.0](https://github.com/ansible-community/ansible-build-data/blob/main/5/CHANGELOG-v5.rst)
- gitea: cleanup/maintenance: update config file comments/ordering to reduce diff with upstream example file
- apache: relax permissions on apache virtualhost config files (make them world-readable)
- nextcloud: upgrade to [23.0.1](https://nextcloud.com/changelog/#latest23) [[1]](https://nextcloud.com/blog/nextcloud-hub-2-brings-major-overhaul-introducing-nextcloud-office-p2p-backup-and-more/)
- nextcloud: add [Nextcloud Bookmarks](https://apps.nextcloud.com/apps/bookmarks) to the default list of apps (default disabled)
- xsrv/tools/doc: don't install python3-cryptography from pip, install from OS packages
- gitea/nextcloud/tt_rss: remove hard dependency on postgresql role
- openldap: remove hard dependency on common role
- transmission: log/show diff on configuration file changes
- netdata/docker: move `netdata_min/max_running_docker_containers` configuration variables to the `docker` role
- netdata: no longer install `python3-mysqldb`/mysql support packages
- mumble: force superuser password change task to *never* return "changed" (instead of always)
- doc: update documentation, document all ansible tags, refactor command-line usage doc
- refactoring: move fail2ban/samba/rsyslog/netdata/... tasks to separate task files inside each role
- tags: add `ssl` tag to all ssl-related tasks, add `rsnapshot-ssh-key` tag to all ssh-key-related tasks
- cleanup: remove unused tasks/improve deployment times

**Fixed:**
- fix integration between roles when roles are part of different plays: use ansible local facts installed by other roles to detect installed components, instead of checking the list of roles in the current play
- proxmox: fix missing ansible fact file template
- proxmox: fix APT configuration on Debian 10/11
- fix `check` mode compatibility issues, fix ansible-lint warnings
- common: ssh: fix creation of SFTP-only accounts (`bad ownership or modes for chroot directory`)
- common: ssh: ssh: fix root ssh logins when `ssh_permit_root_login: without-password/prohibit-password/forced-commands-only`
- monitoring: netdata: fix chart values incorrectly increased by 1 in debsecan module
- backup: fix mode/idempotence for `/root/.ssh` directory creation
- graylog: fix configuration file templating always returning changed in check mode
- default playbook/xsrv: fix invalid `"%%ANSIBLE_HOST%%"` value set by `xsrv init-host`
- common: hosts: fix warning: Found variable using reserved name: hosts

[Full changes since v1.4.0](https://gitlab.com/nodiscc/xsrv/-/compare/1.4.0...1.5.0)

-------------------------

#### [v1.4.0](https://gitlab.com/nodiscc/xsrv/-/releases#1.4.0) - 2021-12-17

**Upgrade procedure:**
- `xsrv self-upgrade` to upgrade the xsrv script
- `xsrv upgrade` to upgrade roles in your playbook to the latest release
- `xsrv deploy` to apply changes
- (optional) `TAGS=debian10to11 xsrv deploy` to upgrade your host's distribution from Debian 10 "Buster" to [Debian 11 "Bullseye"](https://www.debian.org/News/2021/20210814.html)
- (optional) remove custom `netdata_modtime_checks` from your configuration, if any (the [modtime](https://github.com/nodiscc/netdata-modtime) module was removed, use the [filecheck](https://learn.netdata.cloud/docs/agent/collectors/go.d.plugin/modules/filecheck) module instead)


**Added:**
- add [proxmox](roles/proxmox) role (basic Proxmox VE hypervisor setup)
- add [valheim_server](roles/valheim_server) role (Valheim multiplayer game server)
- gitea: make number of issues per page configurable (`gitea_issue_paging_num` , increase to 20 by default)
- shaarli: make `hide_timestamp,header_link,debug,formatter` [settings](https://shaarli.readthedocs.io/en/master/Shaarli-configuration/) configurable
- monitoring: add [lynis](https://cisofy.com/lynis/) security audit tool (optional, default disabled), schedule a daily report
- monitoring/postgresql: allow netdata to monitor postgresql server
- docker: allow enabling unattended upgrades of docker engine packages (`docker_auto_upgrade: yes/no`)
- common: apt: allow enabling `contrib` and `non-free` software sections (`apt_enable_nonfree`)
- common: allow disabling hostname setup (`setup_hostname: yes/no`)
- common, monitoring: make roles compatible with Debian 11 "Bullseye"
- homepage: add link to graylog instance (when graylog role is enabled)
- monitoring: allow configuration of syslog retention duration, default to 186 days instead of 7
- monitoring: allow defining a number of maximum expected running docker containers (`netdata_max_running_docker_containers`)
- monitoring: add [logwatch](https://packages.debian.org/bullseye/logwatch) log analyzer, disable scheduled execution
- monitoring: install requirements for postgresql monitoring
- postgresql: add ability to enable/disable the service and enforce started/stopped/enabled/disabled state
- backup: make rsnapshot verbosity configurable
- backup: download rsnapshot's/root SSH public key to the controller (public_keys/ directory)
- common: allow configuring the list of users allowed to use `crontab` (`linux_users_crontab_allow`)
- common: add an procedure for Debian 10 -> 11 upgrades
- common: add ability to add/remove entries from the hosts (`/etc/hosts`) file

**Changed:**
- nextcloud: upgrade to [22.2.3](https://nextcloud.com/changelog/#latest22)
- nextcloud: silence cron/background tasks output to prevent mail notification spam
- nextcloud: allow installation of [ONLYOFFICE](https://nextcloud.com/onlyoffice/) realtime collaborative document edition tools
- gitea: upgrade to [1.15.7](https://github.com/go-gitea/gitea/releases)
- gitea update fail2ban [login failure detection](https://docs.gitea.io/en-us/fail2ban-setup/) for gitea v1.15+
- common: sysctl: disable IP source routing for IPv6 (was already disabled for IPv4)
- common: msmtp: check that configuration variables have correct values/types when `msmtp_setup: yes`
- monitoring: increate netdata charts retention duration to ~7 days
- monitoring: allow disabling needrestart/logcount/debsecan modules installation
- monitoring: decrease alarm sensitivity for logcount module (warning on 10 alarms/min, critical on 100 errors/min)
- monitoring: disable lynis checks AUTH-9283 and FIRE-4512 by default (false positives)
- monitoring: only enable "number of running docker container" checks when the nodiscc.xsrv.docker role is enabled
- monitoring: update configuration for netdata > 1.30
- backup, monitoring: replace custom [modtime](https://github.com/nodiscc/netdata-modtime) module with built-in netdata [filecheck](https://learn.netdata.cloud/docs/agent/collectors/go.d.plugin/modules/filecheck) module
- xsrv: rename top-level directory concept (playbook -> project)
- xsrv: logs: don't ask for sudo password if syslog is readable without it
- xsrv: switch to ansible "distribution" versioning, upgrade to [4.9.0](https://github.com/ansible-community/ansible-build-data/blob/main/4/CHANGELOG-v4.rst) ([ansible-core](https://github.com/ansible/ansible) 2.11.6), update playbook for compatibility
- xsrv: store virtualenv inside the project directory, improve startup time
- homepage: update theme (use light theme), use web safe fonts
- apache: make role compatible with Debian 11 "Bullseye"
- backup: make dependency on monitoring role optional
- backup: ensure only `root` can read the rsnapshot configuration file
- backup: re-schedule monthly backups at 04:01 on the first day of the month
- all roles/monitoring: apply role-specific netdata/rsyslog configuration immediately after installing it
- default playbook: .gitignore data/ and cache/ directories
- doc: update/refactor documentation and roles metadata
- tools: improve automatic documentation generation
- refactor: refactor integration between roles (use ansible_local facts, fix integration when roles are not part of the same play)

**Removed:**
- nextcloud: disable [deck](https://apps.nextcloud.com/apps/deck) app by default

**Fixed:**
- homepage: really update page title from `homepage_title` variable
- jellyfin: use `samba_shares_path` variable to determine samba shares path
- nextcloud: fix upgrade procedure order (upgrade incompatible apps)
- nextcloud: fix `check` mode on upgrades
- graylog: respect `elasticsearch_timeout_start_sec` value
- monitoring: netdata: enable gzip compression on web server responses, fix empty dashboard
- monitoring: fix netdata modtime module installation, remove obsolete tasks file
- monitoring: rsyslog: ensure that requirements for self-signed certificates generation are installed
- monitoring: ensure requirements for self-signed certificate generation are installed
- monitoring: also allow access to netdata.conf from `netdata_allow_connections_from` addresses
- monitoring: fix APT package manager logs aggregation to syslog
- tt_rss: fix permission denied errors when updating feeds
- homepage: fix grid responsiveness on mobile devices
- transmission: don't attempt to reload the service when it is disabled in host configuration
- don't ignore expected errors when not running in check mode

**Security:**
- nextcloud: fail2ban: fix log file location/login failures not detected by fail2ban
- common: automatically apply security updates for packages installed from Debian Backports

[Full changes since v1.3.1](https://gitlab.com/nodiscc/xsrv/-/compare/1.3.1...1.4.0)

------------------------

#### [v1.3.1](https://gitlab.com/nodiscc/xsrv/-/releases#1.3.1) - 2021-06-24

**Upgrade procedure:**
- `xsrv upgrade` to upgrade roles in your playbook to the latest release
- `xsrv deploy` to apply changes

**Fixed:**
- common: msmtp: fix msmtp unable to read /etc/aliases (`/etc/aliases: line 1: invalid address`)
- common: msmtp: fix unreadable /etc/msmtprc configuration for un privileged users
- nextcloud/apache/php: fix path to PHP APCU configuration file (really fix `cannot allocate memory` errors on nextcloud upgrades)
- tt_rss: fix/automate initial database population and schema upgrades, update documentation

**Added:**
- common: msmtp: allow disabling STARTTLS (`msmtp_starttls: yes/no`)
- backup: rsnapshot: don't update timestamp file after weekly/monthly backups (monitoring only measures time since the last successful **daily** backup)

**Changed:**
- nextcloud: upgrade to 20.0.10
- update documentation (virt-manager/add basic VM provisioning procedure)

[Full changes since v1.3.0](https://gitlab.com/nodiscc/xsrv/-/compare/1.3.0...1.3.1)

----------------------------

#### [v1.3.0](https://gitlab.com/nodiscc/xsrv/-/releases#1.3.0) - 2021-06-08

**Upgrade procedure:**
- `xsrv self-upgrade` to upgrade the xsrv script to the latest release
- `xsrv upgrade` to upgrade roles in your playbook to the latest release
- if you had defined custom `netdata_http_checks`, port them to the new [`netdata_http_checks`/`netdata_x509_checks`](https://gitlab.com/nodiscc/xsrv/-/blob/master/roles/monitoring/defaults/main.yml#L64) syntax
- (optional/cleanup) `xsrv edit-vault`: remove all `vault_` prefixes from encrypted host variables; `xsrv edit-host`: remove all variables that are just `variable_name: {{ vault_variable_name }}` references
- (optional/cleanup) remove previous hardcoded/default `netdata_modtime_checks` and `netdata_process_checks` from your host variables
- (optional) `xsrv check` to simulate and review changes
- `xsrv deploy` to apply changes

**Removed:**
- default playbook: remove hardcoded `netdata_modtime_checks` and `netdata_process_checks` (roles will automatically configure relevant checks)
- default playbook/all roles: remove `variable_name: {{ vault_variable_name }}` indirections/references
- monitoring/netdata: remove ability to configure netdata modules git clone URLs (`netdata_*_git_url` variables), always clone from upstream
- monitoring/netdata: remove support for `check_x509` parameter in `netdata_httpchecks`
- monitoring/rsyslog: remove hardcoded, service-specific configuration

**Added:**
- add [graylog](https://gitlab.com/nodiscc/xsrv/-/tree/master/roles/graylog) log analyzer role
- add [gotty](https://gitlab.com/nodiscc/xsrv/-/tree/master/roles/gotty) role
- monitoring/rsyslog: add ability forward logs to a remote syslog/graylog server over TCP/SSL/TLS (add [`rsyslog_enable_forwarding`, `rsyslog_forward_to_hostname` and `rsyslog_forward_to_port`]([`apt_unattended_upgrades_origins_patterns`](https://gitlab.com/nodiscc/xsrv/-/blob/master/roles/monitoring_rsyslog/defaults/main.yml)) variables)
- jellyfin/common/apt: enable automatic upgrades for jellyfin by default ([`apt_unattended_upgrades_origins_patterns`](https://gitlab.com/nodiscc/xsrv/-/blob/master/roles/common/defaults/main.yml#L48))
- monitoring: support all [httpcheck](https://github.com/netdata/go.d.plugin/blob/master/config/go.d/httpcheck.conf) parameters in [`netdata_http_checks`](https://gitlab.com/nodiscc/xsrv/-/blob/master/roles/monitoring_netdata/defaults/main.yml)
- monitoring/netdata: add [`netdata_x509_checks`](https://gitlab.com/nodiscc/xsrv/-/blob/master/roles/monitoring_netdata/defaults/main.yml) (list of x509 certificate checks, supports all [x509check](https://github.com/netdata/go.d.plugin/blob/master/config/go.d/x509check.conf) parameters)
- rocketchat: allow disabling rocketchat/mongodb services (`rocketchat_enable_service: yes/no`)
- xsrv: add [`xsrv edit-group`](https://xsrv.readthedocs.io/en/latest/usage.html#command-line-usage) subcommand (edit group variables - default group: `all`)
- xsrv: add [`xsrv ls`](https://xsrv.readthedocs.io/en/latest/usage.html#command-line-usage) subcommand (list files in the playbooks directory - accepts a path)
- xsrv: add [`xsrv edit-requirements`](https://xsrv.readthedocs.io/en/latest/usage.html#xsrv-edit-requirements) subcommand (edit ansible collections/requirements)
- xsrv: add [`xsrv edit-cfg`](https://xsrv.readthedocs.io/en/latest/usage.html#command-line-usage) subcommand (edit ansible configuration/`ansible.cfg`)
- xsrv: add syntax highlighting to default text editor/pager (nano - requires manual installation of yaml syntax highlighting file), improve display
- homepage: add favicon
- common: msmtp: make outgoing mail port configurable (`msmtp_port`, default `587`)

**Changed:**
- gitea: enable API by default (`gitea_enable_api`)
- gitea: upgrade gitea to 1.14.2
- openldap: upgrade ldap-account-manager to 7.5
- nextcloud: upgrade nextcloud to 21.0.2
- rocketchat: update rocket.chat to 3.15.0
- homepage: switch to a responsive grid layout
- monitoring: decrease logcount warning alarm sensitivity, warn when error rate >= 10/min
- monitoring/all roles: let roles install their own syslog aggregation settings, if the `nodiscc.xsrv.monitoring` role is enabled.
- monitoring/needrestart: by default, automatically restart services that require it after a security update (`needrestart_autorestart_services: yes`)
- monitoring/netdata/default playbook: let roles install their own HTTP/x509/modtime/port checks under `/etc/netdata/{python,go}.d/$module_name.conf.d/*.conf`, if the `nodiscc.xsrv.monitoring` role is enabled
- apache/common/mail: forward all local mail from `www-data` to `root` - allows `root` to receive webserver cron jobs output
- apache/monitoring: disable aggregation of access logs to syslog by default, add variable allowing to enable it (`apache_access_log_to_syslog`)
- common: cron: ensure only root can access cron job files and directories (CIS 5.1.2 - 5.1.7)
- common: ssh: lower maximum concurrent unauthenticated connections to 60
- common/mail: don't overwrite `/etc/aliases`, ensure `root` mail is forwarded to the configured user (set to `ansible_user` by default)
- docker: speed up role execution - don't force APT cache update when not necessary
- transmission: disable automatic backups of the downloads directory by default, add `transmission_backup_downloads: yes/no` variable allowing to enable it
- rocketchat/monitoring: disable HTTP check when rocketchat service is explicitly disabled in the configuration
- mumble/checks: ensure that `mumble_welcome_text` is set
- transmission/jellyfin: allow jellyfin to read/write transmission downloads directory
- tools: add Pull Request template, speed up Gitlab CI test suite (prebuild an image with required tools)
- update ansible tags
- update roles metadata, remove coupling/dependencies between roles unless strictly required, make `nodiscc.xsrv.common` role mostly optional
- xsrv: cleanup/reorder/DRY/refactoring, make `self-upgrade` safer
- doc: update documentation/formatting, fix manual backup command, fix ssh-copy-id instructions


**Fixed:**
- jellyfin: fix automatic samba share creation
- common: fix `linux_users` creation when no `authorized_ssh_keys`/`sudo_nopasswd_commands` are defined
- common: users: allow creation of `linux_users` without a password (login to these user accounts will be denied, SSH login with authorized keys are still possible if the user is in the `ssh` group)
- samba: fix error on LDAP domain creation
- nextcloud: fix condition for dependency on postgresql role
- nextcloud: fix `allowed memory size exhausted` during nextcloud upgrades
- openldap: fix condition for dependency on apache role
- rsyslog: fix automatic aggregation of fail2ban logs to syslog
- rocketchat: fix automatic backups when the service is disabled
- samba/rsnapshot/gitea: fix role when running in 'check' mode, fix idempotence
- tools: fix release procedure/ansible-galaxy collection publication
- xsrv: fix wrong inventory formatting after running `xsrv init-host`
- remove unused/duplicate/leftover task files
- fix typos

**Security:**
- common: fail2ban: fix bantime for ssh jail (~49 days)

[Full changes since v1.2.2](https://gitlab.com/nodiscc/xsrv/-/compare/1.2.2...1.3.0)

-------------------------------

#### [v1.2.2](https://gitlab.com/nodiscc/xsrv/-/releases#1.2.2) - 2021-04-01

Upgrade procedure: `xsrv upgrade` to upgrade roles in your playbook to the latest release

**Fixed:**
 - samba: fix nscd default log level, update samba default log level

[Full changes since v1.2.1](https://gitlab.com/nodiscc/xsrv/-/compare/1.2.1...1.2.2)

---------------------------

#### [v1.2.1](https://gitlab.com/nodiscc/xsrv/-/releases#1.2.1) - 2021-04-01

Upgrade procedure: `xsrv upgrade` to upgrade roles in your playbook to the latest release

**Fixed:**
 - tt_rss: fix initial tt-rss schema installation (file has moved)

samba: fix nscd default log level, update samba default log level

[Full changes since v1.2.0](https://gitlab.com/nodiscc/xsrv/-/compare/1.2.0...1.2.1)

-------------------------------

#### [v1.2.0](https://gitlab.com/nodiscc/xsrv/-/releases#1.2.0) - 2021-03-27

**Added:**
- homepage: add configurable message/paragraph to homepage (homepage_message)
- add ability to configure multiple aliases/valid domain names for the homepage virtualhost (homepage_vhost_aliases: [])
- nextcloud: improve performance (auto-add missing primary keys/indices in database, convert columns to bigint)

**Removed:**
- openldap: remove `self_service_password_keyphrase` variable (unused since tokens/SMS/question based password resets are disabled)
- common: ssh: cleanup/remove unused `MatchGroup rsyncasroot` directive

**Changed:**
- common: sysctl: enable logging of martian packets
- common: sysctl: ensure sysctl settings also apply to all network interfaces added in the future
- common: ssh: set loglevel to VERBOSE by default
- samba: increase log level, enable detailed authentication success/failure logs, clarify log prefix
- update documentation

**Fixed:**
- rocketchat: fix role idempotence (ownership of data directories)

**Security:**
- rocketchat: fix port 3001 exposed on 0.0.0.0 instead of localhost-only/firewall bypass
- gitea: update to v1.13.6

[Full changes since v1.1.0](https://gitlab.com/nodiscc/xsrv/-/compare/1.1.0...1.2.0)

-------------------------------

#### [v1.1.0](https://gitlab.com/nodiscc/xsrv/-/releases#1.1.0) - 2021-03-14

**Added:**
- xsrv: add self-upgrade command
- monitoring: add [netdata-debsecan](https://gitlab.com/nodiscc/netdata-debsecan) module
- common: ensure NTP service is started
- common: make timezone configurable (default to not touching the timezone)
- openldap: add [Self Service Password](https://ltb-project.org/documentation/self-service-password) password reset tool (fixes #401)
  - requires manual configuration of `self_service_password_fqdn` and `vault_self_service_password_keyphrase`
  - auto-configure apache and `selfsigned` or `letsencrypt` certificates + php-fpm.
  - by default only allow access from LAN/private addresses in `self_service_password_allowed_hosts`
  - when samba role is enabled, use the LDAP admin DN to access the directory (required to be able to change `sambaNtPassword` attribute)
  - make various settings configurable, add correctness checks for all variables
- openldap: make log level configurable
- homepage: add jellyfin/self-service-password links (when relevant roles/variables are enabled)
- jellyfin: add LDAP authentication documentation
- jellyfin: add fail2ban configuration/bruteforce prevention on jellyfin login attempts
- jellyfin/backup: add automatic backups (only backup db/metadata/configuration by default, allow enabling media directory backups with `jellyfin_enable_media_backups`)
- jellyfin: create subdirectories for each library type under the default media directory/jellyfin samba share
- samba/backup: allow disabling automatic backups of samba shares (`samba_enable_backups`)
- shaarli/monitoring: aggregate data/log.txt to syslog using the imfile module

**Changed:**
- update documentation (upgrade procedure, example playbook, mirrors, TOC, links, ansible-collection installation, list of all variables, ansible.cfg, sysctl settings...)
- openldap: upgrade ldap-account-manager to v7.4 (https://www.ldap-account-manager.org/lamcms/changelog)
- openldap: prevent LDAP lookups for local user accounts
- openldap: decrease log verbosity
- gitea: upgrade to 1.13.3 - https://github.com/go-gitea/gitea/releases
- nextcloud: upgrade to 20.0.8 - https://nextcloud.com/changelog/

**Fixed:**
- xsrv: fix show-defaults command (by default display all role defaults for the default playbook)
- homepage: fix mumble and ldap-account-manager links
- samba: fix duplicate execution of the openldap role when samba uses LDAP passdb backend
- rocketchat: fix variable checks not being run before applying the role
- rocketchat: fix permissions/ownership of mongodb/rocketchat data directories
- tt_rss: fix error 'Please set SELF_URL_PATH to the correct value detected for your server'
- samba/jellyfin: fix automatic jellyfin samba share creation, fix permissions on jellyfin samba share
- monitoring: fix ansible --check mode when netdata is not installed yet
- shaarli: set apache directoryindex to index.php, prevent error messages in logs at every page access

**Tools/maintenance:**
- Makefile: add a make changelog target (print commits since last tag)
- Makefile: automate release procedure `make release`
- tt-rss: cleanup/grouping
- roles/*/defaults/main.yml: add header for all defaults files
- upgrade ansible to 2.10.7 - https://pypi.org/project/ansible/#history
- move TODOs to issues

[Full changes since v1.0.0](https://gitlab.com/nodiscc/xsrv/-/compare/1.0.0...1.1.0)

-------------------------------


#### [v1.0.0](https://gitlab.com/nodiscc/xsrv/-/releases#1.0.0) - 2021-02-12

This is a major rewrite of https://github.com/nodiscc/srv01. To upgrade/migrate from previous releases, you must redeploy services to a new instance, and restore user data from backups/exports.

This releases improves usability, portability, standards compliance, separation of concerns, performance, documentation, security, simplifies installation and usage, and adds new features to all roles/components. A summary of changes is included below. See [README.md](README.md) for more information.

**xsrv command-line tool**
- improve/simplify command-line usage, see `xsrv help`
- refactor main script/simplify/cleanup
- use pwgen (optional) to generate random passwords during host creation
- make installation to $PATH and use of sudo optional
- use ansible-galaxy collections for role upgrades method


**example playbook: refactor:**
- add examples for playbook, inventory, group_vars and host_vars (cleartext and vaulted) files
- disable all but essential roles by default. Additional roles should be enabled manually by the admin
- firewall: by default, allow incoming traffic for netdata dashboard from LAN (monitoring role is enabled by default)
- firewall: by default, allow incoming SSH from anywhere (key-based authentication is enabled so this is reasonably secure)
- firewall: by default, allow HTTP/HTTPS access from anywhere (required for let's encrypt http-01 challenge, and apache role is enabled by default)
- firewall: change the default policy for the 'global' firehol_network definition to RETURN (changes nothing in the default configuration, makes adding other network definitions easier)
- doc: add firewall examples for all services (only from LAN by default)
- doc: add example .gitlab-ci.yml
- ansible/all roles: use ansible-vault as default storage for sensitive values
- ansible: use .ansible-vault-password as vault password file
- ansible: speed up ansible SSH operations using controlmaster and pipelining SSH options
- host_vars: add a netdata check for successful daily backups
- host_vars: add netdata process checks for ssh, fail2ban, ntp, httpd, sql
- host_vars: auto-restart services by default when needrestart detects a restart is required
- remove unused directories, cleanup


**common: refactor role:**
- import from https://gitlab.com/nodiscc/ansible-xsrv-common
- unattended-upgrades: allow automatic upgrades from stable-updates repository
- unattended-upgrades: install apt-listchanges (mail with a summary of changes will be sent to the server admin)
- add ansible_user_allow_sudo_rsync_nopasswd option (allow ansible user to run sudo rsync without password)
- msmtp: require manual configuration of msmtp host/username/password (if msmtp installation is enabled)
- dns: add ability to configure multiple DNS nameservers in /etc/resolv.conf
- packages: enable haveged installation by default
- packages: don't install pwgen/secure-delete/autojump by default, add man package
- sshd: remove deprecated UsePrivilegeSeparation option
- sshd: make ssh server log level, PasswordAuthentication, AllowTcpForwarding and PermitRootLogin options configurable
- sshd: fix accepted environment variables LANG,LC_* accepted from the client
- sshd: explicitly deny AllowTcpForwarding, AllowAgentForwarding, GatewayPorts and X11Forwarding for the sftponly group
- sshd: add curve25519-sha256@libssh.org KexAlgorithm
- firewall: add an option to generate firewall rules compatible with docker swarm routing/port forwarding
- firewall: allow outgoing mail submission/port 587 by default
- firewall: make firewall config file only readable by root
- firewall: use an alias/variable to define LAN IP networks, templatize
- firewall/fail2ban: prevent firehol from overwriting fail2Ban rules, remove interaction/integration between services, split firewall/fail2ban configuration tasks, add ability to disable both
- fail2ban: make more settings configurable (destination e-mail, default findtime/maxretry/bantime)
- users: simplify management, remove *remotebackup* options/special remotebackup user/tasks
- users: linux_users is now compatible with ansible users module syntax, with added ssh_authorized_keys and sudo_nopasswd_commands parameters
- users: fix user password generation (use random salt, make task idempotent by setting update_password: on_create by default)
- users: ensure ansible user home is not world-readable


**monitoring: refactor role:**
- import from https://gitlab.com/nodiscc/ansible-xsrv-monitoring
- netdata: add ssl/x509 expiration checks, make http check timeout value optional, default to 1s)
- netdata: allow installation from deb packages/packagecloud APT repository, make it the default
- netdata: decrease frequency of apache status checks to 10 seconds (decrease log spam)
- netdata: disable access logs and debug logs by default (performance), add netdata_disable_*_log variables to configure it
- netdata: disable cloud/SaaS features by default, add netdata_cloud_enabled variable to configure it
- netdata: disable web server gzip compression since we only use ssl
- netdata: install and configure https://gitlab.com/nodiscc/netdata-logcountmodule, disable notifications by default
- netdata: install and configure https://gitlab.com/nodiscc/netdata-modtime module
- netdata: make dbengine disk space size and memory page cache size configurable
- netdata: monitor mysql server if mariadb role is enabled (add netdata mysql user)
- netdata: add default configuration for health notifications
- netdata: upgrade to latest stable release
- rsyslog: aggregate all log messages to `/var/log/syslog` by default
- rsyslog: monitor samba, gitea, mumble-server, openldap, nextcloud, unattended-upgrades and rsnapshot log files with imfile module (when corresponding roles are enabled)
- rsyslog: make aggregation of apache access logs to syslog optional, disable by default
- rsyslog: disable aggregation of netdata logs to syslog by default (very noisy, many false-positive ERROR messages)
- rsyslog: discard apache access logs caused by netdata apache monitoring
- needrestart: don't auto-restart services by default
- extend list of command-line monitoring tools (lsof/strace)
- various fixes, reorder, cleanup, update documentation, fix role/certificate generation idempotence, make more components optional


**backup role**
- import from https://gitlab.com/nodiscc/ansible-xsrv-backup
- auto-load rsnapshot configuration from /etc/rsnapshot.d/*.conf, remove hardcoded xsrv* roles integration
- check rsnapshot configuration after copying files
- restrict access to backups directory to root only
- redirect cron job stdout to /dev/null, only send errors by mail
- write rsnapshot last success time to file (allows monitoring the time since last successful backup)
- store ssh public key to ansible facts (this will allow generating a human readable document/dashboard with hosts information)

**lamp role: refactor:**
- import from https://gitlab.com/nodiscc/ansible-xsrv-lamp
- split lamp role to separate apache and mariadb roles


**apache role:**
- import/refactor/split role from https://gitlab.com/nodiscc/ansible-xsrv-lamp
- use apache mod-md for Let's Encrypt certificate generation, remove certbot and associated ansible tasks
- switch to php-fpm interpreter, remove mod_php
- switch to mpm_event, disable mpm_worker
- switch to HTTP2
- remove ability to create custom virtualhosts
- remove automatic homepage generation feature (will be split to separate role)
- enforce fail2ban bans on HTTP basic auth failures
- set the default log format to `vhost_combined` (all vhosts to a single file)
- rename cert_mode variable to https_mode
- don't enable mod-deflate by default
- add variable apache_allow_robots (allow/disabllow robots globally, default no)
- add hard dependency on common role
- update doc, cleanup, formatting, add screenshot
- require manual configuration of the letsencrypt admin email address
- disable X-Frame-Options header as Content-Security-Policy frame-ancestors replaces/obsoletes it
- disable setting a default Content-Security-Policy, each application is responsible for setting an appropriate CSP
- mark HTTP->HTTPS redirects as permanent (HTTP code 301)
- exclude /server-status from automatic HTTP -> HTTPS redirects
- ensure the default/fallback vhost is always the first in load order, raise HTTP error 403 and autoindex:error when accessing the default vhost


**nextcloud: refactor role:**
- import from https://gitlab.com/nodiscc/ansible-xsrv-nextcloud
- determine appropriate setup procedure depending on whether nextcloud is already installed or not, installed version and current role version (installation/upgrades are now idempotent)
- add support for let's encrypt certificates (use mod_md when nextcloud_rss_https_mode: letsencrypt. else generate self-signed certificates)
- use ansible local fact file to store nextcloud installed version
- ensure correct/restrictive permissions are set
- support postgresql as database engine, make it the default
- move apache configuration steps to separate file, add full automatic virtualhost configuration for nextcloud
- reorder setup procedure (setup apache last)
- enable additional php modules https://docs.nextcloud.com/server/16/admin_manual/installation/source_installation.html#apache-web-server-configuration
- reload apache instead of restarting when possible
- make basic settings configurable through ansible (FQDN, install directory, full URL, share_folder...)
- require manual configuration of nextcloud FQDN
- enforce fail2ban bans on nextcloud login failures
- upgrade nextcloud to latest stable version (https://nextcloud.com/changelog)
- upgrade all nextcloud apps to latest compatible versions
- make installed/enabled applications configurable
- enable APCu memcache
- gallery app replaced with photos app
- optional integration with backup role, delegate database backups to the respective database role (mariadb/postgresql)
- add deck, notes, admin_audit and maps apps
- add php-fpm configuration
- run background jobs via cron every 5 minutes

**Migrating Nextcloud data to Postgresql from a MySQL-based installation:**

```bash
# migration is manual
# files: login nextcloud desktop client to your account on the old server, wait for complete file synchronization (eg. to ~/Nextcloud)
#        deploy the new server, create equivalent accounts
#        from nextcloud desktop, login a new/secondary account to the new server, synchronize to another directory (eg. ~/Nextcloud2)
#        from desktop, move files from ~/Nextcloud to ~/Nextcloud2
# calendar/tasks: from the old server's https://old.EXAMPLE.org/nextcloud/index.php/apps/calendar/, export calendars as ICS from the "..." menu
#                 from the new server's https://cloud.EXAMPLE.org/index.php/apps/calendar/, import ICS file from the "Import" menu
# contacts: from the old server's https://old.EXAMPLE.org/nextcloud/index.php/apps/contacts/, export contacts as VCF from the "..." menu
#           from the new server's https://cloud.EXAMPLE.org/index.php/apps/contacts/, import VCF file from the "Import" menu > Local file
# update all desktop/mobile clients to use the new URL/account (DAVx5, thunderbird...)
```

**tt-rss: refactor role:**
- import from https://gitlab.com/nodiscc/ansible-xsrv-tt-rss
- add support for postgresql databases, make it the default (config variable tt_rss_db_type)
- add support for postgresql backups/dumps
- make backup role fully optional, check rsnapshot configuration after copying config file
- delegate database backups to the respective database role (mariadb/postgresql)
- add support for let's encrypt certificates (use mod_md when tt_rss_https_mode: letsencrypt)
- make log destination configurable, default to blank/PHP/webserver logs
- update config.php template (remove deprecated feed_crypt_key setting)
- require manual configuration of admin username and tt-rss FQDN/URL
- standardize component installation order (backups/fail2ban/database first)
- simplify ansible_local.tt_rss.db_imported, always set to true
- do not use a temporary file to store admin user credentials, run mysql command directly from tasks
- add support for letsencrypt certificates/virtualhost configuration (mod_md). add tt_rss_https_mode: selfsigned/letsencrypt, move tasks to separate files
- mark plugins/themes setup tasks as unmaintained, move to separate yml files
- simplify file permissions setup/make idempotent
- update documentation
- simplify domain name/install directory/full URL templating
- rename role to `tt_rss`
- add php-fpm configuration
- various fixes, cleanup, reordering

**Migrating tt-rss data to Postgresql from a MySQL-based installation:**

```bash

# on the original machine
# OPML import/export (including filters and some settings). Must be done before data_migration plugin if you want to keep feed categories
sudo mkdir /var/www/tt-rss/export
sudo chown -R www-data:www-data /var/www/tt-rss/export/
sudo -u www-data php /var/www/tt-rss/update.php --opml-export "MYUSERNAME /var/www/tt-rss/export/export-2020-08-07.opml" # export feeds OPML
# migrate all articles from mysql to postgresql
git clone https://git.tt-rss.org/fox/ttrss-data-migration
sudo chown -R root:www-data ttrss-data-migration/
sudo mv ttrss-data-migration/ /var/www/tt-rss/plugins.local/data_migration
sudo nano /var/www/tt-rss/config.php # enable data_migration in the PLUGINS array
sudo -u www-data php /var/www/tt-rss/update.php --data_user MYUSERNAME --data_export /var/www/tt-rss/export/export-2020-08-07.zip # export articles to database-agnostic format

# on a client
xsrv deploy # deploy tt-rss role
rsync -avP my.original.machine.org:/var/www/tt-rss/export/export-2020-08-07.zip ./ # download zip export
rsync -avP export-2020-08-07.zip my.new.machine.org: # upload zip export
rsync -avP my.original.machine.org:/var/www/tt-rss/export/export-2020-08-07.opml ./ # download opml export
# login to the new tt-rss instance from a browser, go to Preferences > Feeds, import OPML file

# on the target machine
git clone https://git.tt-rss.org/fox/ttrss-data-migration
sudo chown -R root:www-data ttrss-data-migration/
sudo mv ttrss-data-migration/ /var/www/rss.example.org/plugins.local/data_migration
sudo nano /var/www/rss.example.org/config.php # enable data_migration in the PLUGINS array
sudo mkdir /var/www/rss.example.org/export
sudo mv export-2020-08-07.zip /var/www/rss.example.org/export
sudo chown -R root:www-data /var/www/rss.example.org/export
sudo chmod -R g+rX /var/www/rss.example.org/export/
sudo -u www-data php /var/www/rss.example.org/update.php --data_user MYUSERNAME --data_import /var/www/rss.example.org/export/export-2020-08-07.zip # it can take a while
sudo rm -r /var/www/rss.example.org/export/ # cleanup

```

**gitea:**
- add gitea self-hosted software forge role (https://gitea.io/en-us/)
- import from https://gitlab.com/nodiscc/ansible-xsrv-gitea
- make backup role fully optional, check rsnapshot configuration after copying config file
- delegate database backups to the respective database role (mariadb/postgresql)
- make common settings configurable through ansible variables
- simplify domain name/location/root URL templating
- require manual configuration of gitea instance FQDN/URL, JWT secrets and internal token
- LFS JWT secret must not contain /+= characters
- only configure a subset of gitea settings in the configuration file, let gitea use default values for other settings
- disable displaying gitea version in footer
- upgrade gitea to latest stable version (https://github.com/go-gitea/gitea/releases)
- download binary from github.com instea of gitea.io
- download uncompressed binary to avoid handling xz decompression
- update configuration file template
- add support for self-signed and let's encrypt certificates through gitea_https_mode variable
- update documentation

**Migrating gitea data to Postgresql from a MySQL-based installation**

```bash
# To save some backup/restoration time and if you don't care about keeping system notices,
# Access https://$OLD_DOMAIN/gitea/admin/notices and 'Delete all notices'
# on the original machine, do a backup, and upgrade gitea to the target version
# if source and target versions do not match you will have to correct the database
# dump by hand to match the expected schema...

# download the binary from github
wget https://github.com/go-gitea/gitea/releases/download/v1.12.4/gitea-1.12.4-linux-amd64
# stop gitea
sudo systemctl stop gitea
# replace the gitea binary with the new version
sudo mv gitea-1.12.4-linux-amd64 /usr/local/bin/gitea
sudo chmod a+x /usr/local/bin/gitea
# run migrations
sudo -u gitea gitea -c /etc/gitea/app.ini convert
sudo -u gitea gitea -c /etc/gitea/app.ini migrate

# the dump command must be run from gitea's home directory
sudo su
export TMPDIR=/var/backups/gitea/
cd /var/backups/gitea/
# remove any old dumps
rm -rf gitea-dump*zip
# backup gitea data + database as postgresql dump
sudo -u gitea gitea dump -d postgres --tempdir /var/backups/gitea/ -c /etc/gitea/app.ini
# ensure your normal user account can read the backup file
chown $MY_USER /var/backups/gitea/gitea-dump-*.zip
```

```bash
# on the ansible controller
# download the backup file
rsync -avP $OLD_MACHINE:/var/backups/gitea/gitea-dump-*.zip ./
# upload the zip to the new machine
rsync -avP gitea-dump-*.zip $NEW_MACHINE:
# make sure gitea is deployed to the new machine
TAGS=gitea xsrv deploy
```

```bash
# on the new machine
# stop gitea
sudo systemctl stop gitea

# unarchive the backup zip to gitea's directory
sudo mkdir /var/lib/gitea/dump
sudo unzip gitea-dump-*.zip -d /var/lib/gitea/dump/
sudo chown -R gitea:gitea /var/lib/gitea/dump

# make the database dump in a directory readable by postgresql user
sudo mv /var/lib/gitea/dump/gitea-db.sql /var/lib/postgresql/
sudo chown postgres /var/lib/postgresql/gitea-db.sql

# edit the db dump to skip index creations when they already exist
sudo sed -i 's/CREATE INDEX/CREATE INDEX IF NOT EXISTS/g' /var/lib/postgresql/gitea-db.sql
sudo sed -i 's/CREATE UNIQUE INDEX/CREATE UNIQUE INDEX IF NOT EXISTS/g' /var/lib/postgresql/gitea-db.sql

# delete the gitea admin user created by ansible
# since it will conflict with the admin user from the database dump
sudo -u gitea psql --command="delete from public.user where name = '$gitea_admin_username';"
# must return DELETE 1

# restore the database dump
sudo -u postgres psql --echo-all --set ON_ERROR_STOP=on gitea < /var/lib/postgresql/gitea-db.sql

# fix sequence values
# https://github.com/go-gitea/gitea/issues/740
# https://github.com/go-gitea/gitea/issues/12511
# get a list of tables
sudo -u gitea psql -c '\dt' | cut -d " " -f 4
echo $tables # check that the list is correct
for table in $tables; do sudo -u gitea psql --echo-all -c "SELECT setval('${table}_id_seq', COALESCE((SELECT MAX(id) FROM \"$table\"), 0) + 1, false);"; done

# extract repositories zip file
sudo -u gitea bash -c ' \
  cd /var/lib/gitea/dump && \
  unzip gitea-repo.zip && \
  mv repos/* /var/lib/gitea/repos/'
sudo chown -R gitea:gitea /var/lib/gitea/repos/

# remove the backup zip, psql dump, and temporary extraction directory
sudo rm -r gitea-dump-*.zip /var/lib/postgresql/gitea-db.sql /var/lib/gitea/dump

# regenerate hooks
sudo -u gitea gitea admin regenerate hooks -c /etc/gitea/app.ini

# start gitea and watch logs until it has finished starting up
sudo systemctl start gitea
sudo lnav /var/log/syslog
```

```bash
# on the controller
# log in to the new instance with your old admin account
# go to https://$NEW_DOMAIN/user/settings/ ->
#   change username and e-mail address to match values provided by ansible (gitea_admin_username/e-mail)
# go to https://$NEW_DOMAIN/user/settings/account
#   change password to match value provided by ansible (gitea_admin_password)

# re-apply the playbook and check that it finishes without error
TAGS=gitea xsrv deploy

# Check that all gitea functionality works
```


**shaarli: refactor role:**
- detect installed version from ansible fact file and appropriate install/upgrade procedure depending on installed version
- add apache configuration for shaarli, including Content-Security Policy and SSL/TLS certificate management with mod_md
- allow generation of sel-signed certificates
- make shaarli fqdn and installation directory configurable
- harden file permissions
- add rsnapshot configuration for shaarli backups
- auto-configure shaarli from ansible variables (name/user/password/timezone) + compute hash during installation
- by default, don't overwrite shaarli config when it already exists (rely on configuration from the web interface) (idempotence)
- require manual generation of shaarli password salt (40 character string)
- add documentation, add backup restoration procedure
- add role to example playbook (disabled by default)
- add php-fpm configuration
- upgrade shaarli to latest stable release (https://github.com/shaarli/Shaarli/releases)

**Migrating Shaarli data to a new installation**

```bash
# deploy shaarli
make deploy
# access https://old.CHANGEME.org/links/?do=export and export ALL links as HTML (without prepending instance URL to notes)
# access the new instance at https://links.CHANGEME.org/?do=import and import your HTML file
# you can also resynchronize thumbnails a https://links.CHANGEME.org/?do=thumbs_update
```

**transmission: refactor role:**
- install and configure transmission (most settings are left to their defaults)
- add ansible variables for username/password, service status, download directory, FQDN
- only let transmission web interface listen on 127.0.0.1
- settings.json is updates by the daemon on exit with current/user-defined settings, hence the role is not always idempotent
- configure an apache virtualhost for transmission
- add transmission_https_mode variable to configure SSL certificate generation (selfsigned/letsencrypt)
- add checks for required variables
- delegate HTTP basic auth to apache, pass credentials to the backend transmission service (proxy-chain-auth)
- add rsnapshot configuration (backup transmission downloads and torrents cache)


**mumble: refactor role:**
- setup mumble-server (murmur)
- make server password, superuser password, allowping, max users, max bandwidth per client, server port and welcome text and service state configurable through ansible variables
- update documentation, add screenshot
- add rsnapshot configuration for automatic backups of mumble server data
- add fail2ban configuration for failed mumble logins


**postgresql role:**
- add basic postgresql role
- add optional integration with the backup role (automatic database backups)


**samba role:**
 - add samba file sharing server role (standalone mode)
 - make log level configurable
 - add support for internal (tdbsam) and LDAP user/group/password backends
 - make shares configurable through samba_shares variable
 - make tdbsam users configurable through samba_users variable
 - add rsnapshot backup configuration for samba
 - make shares available/browseable state configurable (default to yes)
 - update documentation

**docker role:**
 - add docker role (install and configure Docker container platform)
 - add ability to configure a docker swarm orchestrator (default to initialize a new swarm)

**homepage role:**
 - add a role to generate a basic webserver homepage listing URLs/commands to access deployed services
 - automatic apache virtualhost configuration and let's encrypt/self-signed certificate generation

**rocketchat role:**
 - add a role to deploy the rocket.chat instant messaging/communication software
 - deploy rocket.chat as a stack of docker swarm services
 - add apache configuration to proxy traffic from the host's apache instance, add let's encrypt/self-signed certificate generation tasks

**openldap role:**
 - add a role to install openldap server and optionally ldap-account-manager
 - preconfigure base DN, users and groups OUs,
 - add rsnapshot backup configuration
 - add apache configuration/host for ldap-account-managaer, add let's encrypt/self-signed certificate generation tasks
 - make ldap-account-manager configuration read-only (must be configured through ansible)
 - only allow access to ldap-account-manager from private IP addresses by default
 - add optional support for Samba domain/users/groups

**jellyfin role:**
- add a role to install the jellyfin media server
- require manual configuration of admin username/password and initial media directory
- create a default media directory in /var/lib/jellyfin/media + symlink from home directory to media directory

**tools, documentation, misc:**
- refactor and update documentation (clarify/cleanup/update/reorder/reword/simplify/deduplicate/move), add screenshots, add full setup guide
- manage all components from a single git repository
- publish roles and default playbook as ansible collection (https://galaxy.ansible.com/nodiscc/xsrv - use make publish_collection to build)
- add automated tests (ansible-lint, yamllint, shellcheck) for all roles, add ansible-playbook --syntax-check test
- add a test suite, add automatic tests with Gitlab CI (https://gitlab.com/nodiscc/xsrv/-/pipelines)
- remove pip install requirements (performed by xsrv script)
- change release/branching model to 'release" (latest stable release), 'X.Y.Z' (semantic versioning), 'master' (development version)
- automate TODO.md updates and version headers updates
- fully working ansible-playbook --check mode
- add checks for all mandatory variables
- explicitly define file permissions for all file copy/templating tasks
- add checks/assertions for all mandatory variables
- remove .gitignore, clean files generated by tests using 'make clean'
- improve/clarify logging, program output and help messages
- generate HTML documentation with sphinx+recommonmark, host on https://xsrv.readthedocs.io
- various fixes, cleanup, formatting
- update roles metadata
- upgrade ansible to latest stable version (https://github.com/ansible/ansible/blob/stable-2.10/changelogs/CHANGELOG-v2.10.rst)
