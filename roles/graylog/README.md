# xsrv.graylog

This role will install and configure [Graylog](https://github.com/Graylog2/graylog2-server), an open source log management, capture and analysis platform.

Features:
- Collect log data from multiple sources/formats
- Organize and process data using extractors, streams, pipeline rules, lookup tables...
- Search data using a powerful search engine
- Create custom search/visualization dashboards
- Build alerts based on events or relationships between events
- REST API
- Long-term archiving
- LDAP authentication support
- And [more](https://www.graylog.org/features)

_Note: the [SSPL license](https://www.graylog.org/post/graylog-v4-0-licensing-sspl) used by Graylog and MongoDB is [not recognized as an Open-Source license](https://opensource.org/node/1099) by the Open-Source Initiative. Make sure you understand the license before offering a publicly available Graylog-as-a-service instance._

[![](https://i.imgur.com/tC4G9mQm.png)](https://i.imgur.com/tC4G9mQ.png)
[![](https://i.imgur.com/eGCL45L.jpg)](https://i.imgur.com/6Zu7YKy.png)


## Requirements/dependencies/example playbook

- See [meta/main.yml](meta/main.yml)
- Graylog/ElasticSearch requires at least 4GB of RAM to run with acceptable performance in a basic setup [[1](https://community.graylog.org/t/graylog2-system-requirement/2752/2)]. Fast disks are recommended.

```yaml
# playbook.yml
- hosts: my.CHANGEME.org
  roles:
     - nodiscc.xsrv.common # (optional) base server setup, hardening, firewall, bruteforce prevention
     - nodiscc.xsrv.monitoring # (optional) server health and performance monitoring
     - nodiscc.xsrv.apache # (required) reverse proxy and SSL/TLS certificates
     - nodiscc.xsrv.graylog

# required variables:
# host_vars/my.CHANGEME.org/my.CHANGEME.org.yml
graylog_fqdn: "logs.CHANGEME.org"
# ansible-vault edit host_vars/my.CHANGEME.org/my.CHANGEME.org.vault.yml
graylog_root_username: "CHANGEME"
graylog_root_password: "CHANGEME20"
graylog_secret_key: "CHANGEME96"
```

See [defaults/main.yml](defaults/main.yml) for all configuration variables


Remote hosts must be configured to send their logs to the graylog instance. For example with the [monitoring](../monitoring) role:

```yaml
### LOGGING (RSYSLOG) ###
rsyslog_enable_forwarding: yes
rsyslog_forward_to_hostname: "my.CHANGEME.org"
rsyslog_forward_to_port: 5140
```


## Usage

### Basic setup

Login to your graylog instance and configure a basic **[input](https://docs.graylog.org/en/latest/pages/sending_data.html)** to accept syslog messages on TCP port 5140 (using TLS):

- Title: `Syslog/TLS/TCP`
- Port: `5140`
- TLS cert file: `/etc/graylog/ssl/graylog-ca.crt` (the default, self-signed cert)
- TLS private key: `/etc/graylog/ssl/graylog-ca.key` (the default, self-signed cert)
- TLS client authentication: `disabled` (not implemented yet)
- TLS client auth trusted certs: `/etc/graylog/ssl/graylog-ca.crt`
- [x] Allow overriding date?
- Save

-----------------

Add **[Extractors](https://docs.graylog.org/en/4.0/pages/extractors.html)** to the input to build meaningful data fields (addresses, processes, status...) from incoming, unstructured log messages (using regex or _Grok patterns_).

- Go to the main `Search` page and confirm log messages are being ingested (click the `> Not updating` button to display new messages as they arrive)
- Select a message from which you wish to extract data/fields
- Click `Copy ID`
- Go back to  `System > Inputs`, next to the `Input` you just created, click `Manage extractors`
- Click `Get Started`
- Select the `Message ID` tab
- Paste the ID in the `Message ID` field, enter `graylog_0` (the name of Graylog's default index) in the `Index` field
- Click `Load Message`, the selected message should appear with some pre-extracted fields. For example, for logs received from syslog inputs, `application_name`, `facility`, `level`...  should be detected automatically
- Next to the `message` field, click `Select extractor type > Grok pattern`
- In the `Grok pattern` field, enter the _Grok expression_ that will be used to extract fields from the message (see below)
- Click `Try against example` and verify that relevant fields are correctly extracted from the message. Edit your Grok pattern and repeat until you are satisfied with the result.
- (Recommended) Check `Only attempt extraction if field contains string` and enter a string that is constant across all relevant messages (i.e. not variable/present/absent depending on the particular message). This can significantly decrease CPU usage as Graylog will not attempt to parse messages that don't contain the string.
- Set a unique name for the extractor (e.g. `Firewall messages`)
- Click `Create Extractor`

Example: given this message:

```
[20731.854936] FINAL_REJECT: IN=ens3 OUT= MAC= SRC=10.0.10.101 DST=239.255.255.250 LEN=174 TOS=0x00 PREC=0x00 TTL=4 ID=63089 DF PROTO=UDP SPT=35084 DPT=1900 LEN=154
```

The following Grok expression will generate new fields `action`, `in_interface`, `source_ip`, `destination_ip`, `packet_length`, `ttl`, `connection_id`, `protocol`, `source_port`, `destination_port` which can be used in your queries and custom widgets/dashboards:

```
\[%{SPACE}?%{INT:UNWANTED}.%{INT:UNWANTED}\] %{WORD:action}: IN=%{WORD:in_interface} OUT=%{WORD:out_interface}? MAC=%{NOTSPACE:mac_address}? SRC=%{IPV4:source_ip} DST=%{IPV4:destination_ip} LEN=%{INT:packet_length} TOS=0x%{INT:UNWANTED} PREC=0x00 TTL=%{INT:ttl} ID=%{INT:connection_id} DF PROTO=%{WORD:protocol} SPT=%{INT:source_port} DPT=%{INT:destination_port} (WINDOW=%{INT:window_size} )?(RES=0x00 )?(SYN )?(URGP=0 )?(LEN=%{INT:packet_length})?
```

The graylog pattern editor provides a set of premade patterns to extract common data formats (dates, usernames, words, numbers, ...). You can find other examples [here](https://github.com/hpcugent/logstash-patterns/blob/master/files/grok-patterns) and expermiment with the [Grok Debugger](https://grokdebugger.com/).

![](https://i.imgur.com/7Ntq4gl.png)

![](https://i.imgur.com/IemwLaz.png)

---------------

Create **[streams](https://docs.graylog.org/en/latest/pages/streams.html)** to route messages into categories in realtime while they are processed, based on conditions (message contents, source input...). Select wether to cut or copy messages from the `All messages` default stream. Queries in a smaller, pre-filtered stream will run faster than queries in a large unfiltered `All messages` stream.

<!-- TODO ADD EXAMPLE STREAM SETUP -->

--------------

Start using Graylog to [search and filter](https://docs.graylog.org/en/4.0/pages/searching/query_language.html) through messages, edit table fields, create aggregations (bar/area/line/pie charts, tables...) and progressively build useful **[dashboards](https://docs.graylog.org/en/latest/pages/dashboards.html)** showing important indicators for your specific setup.

![](https://i.imgur.com/0OCFJlx.png)

-------------

Setup [authentication](https://docs.graylog.org/en/latest/pages/permission_management.htmln#authentication) and [roles](https://docs.graylog.org/en/latest/pages/permission_management.html#roles) settings allow granting read or write access to specific users/groups. LDAP is supported.

**LDAP authentication:** This example is given for [openldap](../openldap) server:
- Open the `System > Authentication` menu (https://logs.CHANGEME.org/system/authentication/services/create)
- Select a service: `LDAP` -> `Get started`
- Server address: `ldap.CHANGEME.org`, port `636` (SSL/TLS) or `389`
- `TLS` or `None` - if the certificate is self-signed, uncheck `Verify Certificates`
- System User DN: `cn=bind,ou=system,dc=CHANGEME,dc=org`
- System password: the value of `openldap_bind_password` (unprivileged LDAP user)
- `Next: User synchronisation`
- Search Base DN: `ou=users,dc=CHANGEME,dc=org`
- Search pattern: `(&(uid={0})(objectClass=inetOrgPerson))`
- Name Attribute: `uid`
- Full Name Attribute: `cn`
- ID Attribute: `entryUUID`
- Default Roles: `Reader` or any other graylog [role](#roles)
- `Next: Group synchronization`
- `Finish & Save Service`
- In the Configured AUthentication Services list, `Activate` the LDAP service

---------------

**Uninstallation:**
```bash
sudo systemctl stop elasticsearch graylog-server mongod
sudo apt purge elasticsearch graylog-4.0-repository  graylog-server mongodb-org
sudo rm -rf /etc/apache2/sites-available/graylog.conf /etc/apache2/sites-enabled/graylog.conf /usr/share/keyrings/elasticsearch.gpg /etc/apt/sources.list.d/elasticsearch.list /etc/systemd/system/elasticsearch.service.d/ /etc/elasticsearch /etc/ansible/facts.d/graylog.fact /etc/firewalld/services/graylog-tcp.xml /etc/graylog/ /usr/share/keyrings/mongodb.gpg /etc/apt/sources.list.d/mongodb.list /etc/netdata/go.d/httpcheck.conf.d/graylog.conf /etc/netdata/health.d/processes.conf.d/graylog.conf /etc/rsyslog.d/graylog.conf /var/log/mongodb/ /var/log/elasticsearch/ /var/log/graylog-server/ /var/lib/elasticsearch
sudo firewall-cmd --remove-service=graylog-tcp --zone internal --permanent
sudo systemctl daemon-reload
sudo systemctl reload apache2 firewalld
sudo systemctl restart rsyslog
```

--------------

## Backups

TODO

<!--
See the included [rsnapshot configuration](templates/etc_rsnapshot.d_graylog.conf.j2)
There are no backups of log data. Use `bsondump` from the `mongo-tools` package to manipulate mongodb backups.
-->


## Tags

<!--BEGIN TAGS LIST-->
```
graylog - setup graylog log analyzer
```
<!--END TAGS LIST-->


## References

- https://stdout.root.sx/links/?searchterms=graylog
