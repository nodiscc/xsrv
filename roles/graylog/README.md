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

_Note: the [SSPL license](https://www.graylog.org/post/graylog-v4-0-licensing-sspl) used by Graylog and MongoDB is [not recognized as an Open-Source license](https://blog.opensource.org/the-sspl-is-not-an-open-source-license/) by the Open-Source Initiative. Make sure you understand the license before offering a publicly available Graylog-as-a-service instance._

[![](https://gitlab.com/nodiscc/toolbox/-/raw/master/DOC/SCREENSHOTS/tC4G9mQm.png)](https://gitlab.com/nodiscc/toolbox/-/raw/master/DOC/SCREENSHOTS/tC4G9mQ.png)
[![](https://gitlab.com/nodiscc/toolbox/-/raw/master/DOC/SCREENSHOTS/eGCL45L.jpg)](https://gitlab.com/nodiscc/toolbox/-/raw/master/DOC/SCREENSHOTS/6Zu7YKy.png)


## Requirements/dependencies/example playbook

- See [meta/main.yml](meta/main.yml)
- Graylog/ElasticSearch requires at least 4GB of RAM to run with acceptable performance in a basic setup [[1](https://community.graylog.org/t/graylog2-system-requirement/2752/2)]. Fast disks are recommended.
- Firewall/NAT rules allowing connections on TCP port 5140, from clients that send their logs to the graylog instance

```yaml
# playbook.yml
- hosts: my.CHANGEME.org
  roles:
    - nodiscc.xsrv.common # (optional) base server setup, hardening, firewall, bruteforce prevention
    - nodiscc.xsrv.monitoring # (optional) server health and performance monitoring
    - nodiscc.xsrv.backup # (optional) automatic backups
    - nodiscc.xsrv.apache # (required in the standard configuration) reverse proxy and SSL/TLS certificates
    - nodiscc.xsrv.graylog

# required variables:
# host_vars/my.CHANGEME.org/my.CHANGEME.org.yml
graylog_fqdn: "logs.CHANGEME.org"
# ansible-vault edit host_vars/my.CHANGEME.org/my.CHANGEME.org.vault.yml
graylog_root_username: "CHANGEME"
graylog_root_password: "CHANGEME20"
graylog_secret_key: "CHANGEME96"
mongodb_admin_password: "CHANGEME20"
graylog_mongodb_password: "CHANGEME20"
```

See [defaults/main.yml](defaults/main.yml) for all configuration variables

## Usage

### Clients

Remote hosts must be configured to send their logs to the graylog instance. For example with the [monitoring](../monitoring) role:

```yaml
### LOGGING (RSYSLOG) ###
rsyslog_enable_forwarding: yes
rsyslog_forward_to_hostname: "my.CHANGEME.org"
rsyslog_forward_to_port: 5140
```

### Basic setup

#### Inputs

Login to your graylog instance and configure a basic **[input](https://go2docs.graylog.org/5-1/getting_in_log_data/getting_in_log_data.html)** to accept syslog messages on TCP port 5140 (using TLS):

- Title: `Syslog/TLS/TCP`
- Port: `5140`
- TLS cert file: `/etc/ssl/graylog/ca.crt` (the default, self-signed cert)
- TLS private key: `/etc/ssl/graylog/ca.key` (the default, self-signed cert)
- [x] Enable TLS
- TLS client authentication: `disabled` (not implemented yet)
- TLS client auth trusted certs: `/etc/ssl/graylog/ca.crt`
- [x] Allow overriding date?
- Save

---------------

#### Streams

Create **[streams](https://go2docs.graylog.org/5-1/making_sense_of_your_log_data/streams.html)** to route messages into categories in realtime while they are processed, based on conditions (message contents, source input...). Select whether to cut or copy messages from the `All messages` default stream. Queries in a smaller, pre-filtered stream will run faster than queries in a large unfiltered `All messages` stream.

---------------

#### Search and filter

Start using Graylog to [search and filter](https://go2docs.graylog.org/5-1/making_sense_of_your_log_data/writing_search_queries.html) through messages, edit table fields, create aggregations (bar/area/line/pie charts, tables...) and progressively build useful **[dashboards](https://docs.graylog.org/en/latest/pages/dashboards.html)** showing important indicators for your specific setup.

![](https://gitlab.com/nodiscc/toolbox/-/raw/master/DOC/SCREENSHOTS/0OCFJlx.png)

---------------

#### Authentication and roles

Setup [authentication and roles](https://go2docs.graylog.org/5-1/setting_up_graylog/permission_management.html) to grand read or write access to specific users/groups. LDAP is supported.

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

#### Extractors

Extractors are deprecated and [Pipelines and rules](#pipelines-and-rules) are now the preferred method to extract Graylog fields from unstructured log data.

<details>

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

Given this example message:

```
[20731.854936] FINAL_REJECT: IN=ens3 OUT= MAC= SRC=10.0.10.101 DST=239.255.255.250 LEN=174 TOS=0x00 PREC=0x00 TTL=4 ID=63089 DF PROTO=UDP SPT=35084 DPT=1900 LEN=154
```

The following Grok expression will generate new fields `action`, `in_interface`, `source_ip`, `destination_ip`, `packet_length`, `ttl`, `connection_id`, `protocol`, `source_port`, `destination_port` which can be used in your queries and custom widgets/dashboards:

```
\[%{SPACE}?%{INT:UNWANTED}.%{INT:UNWANTED}\] %{WORD:action}: IN=%{WORD:in_interface} OUT=%{WORD:out_interface}? MAC=%{NOTSPACE:mac_address}? SRC=%{IPV4:source_ip} DST=%{IPV4:destination_ip} LEN=%{INT:packet_length} TOS=%{BASE16NUM:UNWANTED} PREC=%{BASE16NUM:UNWANTED} TTL=%{INT:ttl} ID=%{INT:connection_id} (DF )?PROTO=%{WORD:protocol} SPT=%{INT:source_port} DPT=%{INT:destination_port} (WINDOW=%{INT:window_size} )?(RES=0x00 )?(SYN )?(URGP=0 )?(LEN=%{INT:packet_length})?
```

The graylog pattern editor provides a set of premade patterns to extract common data formats (dates, usernames, words, numbers, ...). You can find other examples [here](https://github.com/hpcugent/logstash-patterns/blob/master/files/grok-patterns) and experiment with the [Grok Debugger](https://grokdebugger.com/).

</details>

---------------

#### Pipelines and rules

[Pipelines](https://go2docs.graylog.org/5-1/making_sense_of_your_log_data/pipelines.html) and [Rules](https://go2docs.graylog.org/5-1/making_sense_of_your_log_data/rules.html) are used to extract meaningful data fields (addresses, processes, status...) from incoming, unstructured log messages. They are now the preferred way to process raw log data, as they are able to process messages in parallel and generally consume less resources than [extractors](https://archivedocs.graylog.org/en/latest/pages/extractors.html).


##### Nextcloud logs

This example shows how to setup a pipeline to extract fields from JSON-formatted log messages sent by [nextcloud](../nextcloud/). Given this example message:

```
{"reqId":"1iDjNtFdkmJyxQ0q6BKU","level":1,"time":"2023-03-24T17:55:17+00:00","remoteAddr":"192.168.0.24","user":"ncuser","app":"admin_audit","method":"PROPFIND","url":"/remote.php/dav/addressbooks/users/ncuser/contacts/","message":"Login successful: \"ncuser\"","userAgent":"DAVx5/4.3-ose (2023/02/11; dav4jvm; okhttp/4.10.0) Android/10","version":"25.0.5.1","data":{"app":"admin_audit"}}
```

- Click `System > Pipelines`
- Click the `Manage rules` tab
- Click `Create rule`
- Enter description: `Extract fields from Nextcloud JSON logs`
- Enter the rule source:

```bash
rule "nextcloud logs processing"
when
to_string($message.application_name) == "nextcloud"
then
let msg = parse_json(to_string($message.message));
set_fields(to_map(msg), "nextcloud_");
end
```

- Click `Update rule & close`
- Click the `Manage pipelines` tab
- CLick `Add new pipeline`
- Enter title: `Field extraction`
- Enter description: `Extract fields from received messages`
- Click `Edit connections` and select the `All messages` stream, then click `Update connections`
- In front of `Stage 0`, click `Edit`
- In `Stage rules`, select `nextcloud logs processing` and click `Update stage`

Graylog will now create `nextcloud_reqId`, `nextcloud_level`, `nextcloud_time`, `nextcloud_remoteAddr`, `nextcloud_user` `nextcloud_app`, `nextcloud_method`, `nextcloud_url` and `nextcloud_message` fields which you can then use in your [search queries and filters](#search-and-filter) and dashboards.

![](https://gitlab.com/nodiscc/toolbox/-/raw/master/DOC/SCREENSHOTS/fY3pJgh.png)


##### Ansible logs

Given this example message:

```
Invoked with append=True groups=['ssh'] name=deploy state=present non_unique=False force=False remove=False create_home=True system=False move_home=False ssh_key_bits=0 ssh_key_type=rsa ssh_key_comment=ansible-generated on home.lambdacore.network update_password=always uid=None group=None comment=None home=None shell=None password=NOT_LOGGING_PARAMETER login_class=None password_expire_max=None password_expire_min=None hidden=None seuser=None skeleton=None generate_ssh_key=None ssh_key_file=None ssh_key_passphrase=NOT_LOGGING_PARAMETER expires=None password_lock=None local=None profile=None authorization=None role=None umask=None
```

This rule will process all log messages from `ansible` modules, and map each `key=value` pair to a Graylog field whose name is prefixed by `ansible_` (hence create fields named `ansible_append`, `ansible_groups`, `ansible_name`, `ansible_state`...):

```bash
rule "Map Ansible log message fields to Graylog fields"
when
    starts_with(to_string($message.application_name), "ansible")
then
    set_fields(key_value(to_string($message.message)), "ansible_");
end
```

##### Apache access logs

Given this example message:

```
cloud.example.org:443 192.168.1.20 - - [08/May/2023:13:22:38 +0200] "PROPFIND /remote.php/dav/files/user/ HTTP/1.1" 207 3463 "-" "Mozilla/5.0 (Linux) mirall/3.1.1-2+deb11u1 (Nextcloud)"
```

This rule will process apache access log messages and extract its components as Graylog fields (`bytes`, `clientip`, `httpversion`, `ident`, `referrer`, `request`, `response`, `verb`...):


```bash
rule "Extract apache access log fields"
when
  $message.application_name == "apache-access"
then
  let fields = grok(pattern: "%{COMBINEDAPACHELOG}", value: to_string($message.message), only_named_captures: true);
  set_fields(fields);
end
```

##### Firewalld logs

Given this example message:

```
[20731.854936] FINAL_REJECT: IN=ens3 OUT= MAC= SRC=10.0.10.101 DST=239.255.255.250 LEN=174 TOS=0x00 PREC=0x00 TTL=4 ID=63089 DF PROTO=UDP SPT=35084 DPT=1900 LEN=154
```

The following rule will set values for the fields `action`, `in_interface`, `source_ip`, `destination_ip`, `packet_length`, `ttl`, `connection_id`, `protocol`, `source_port`, `destination_port` which can be used in your queries and custom widgets/dashboards:

```bash
rule "Extract firewalld message fields"
when
  $message.application_name == "kernel" AND contains(to_string($message.message), "PROTO")
then
  let fields = grok(
    pattern: "\\[%{SPACE}?%{INT:UNWANTED}.%{INT:UNWANTED}\\] %{WORD:action}: IN=%{WORD:in_interface} OUT=%{WORD:out_interface}? MAC=%{NOTSPACE:mac_address}? SRC=%{IPV4:source_ip} DST=%{IPV4:destination_ip} LEN=%{INT:packet_length} TOS=%{BASE16NUM:UNWANTED} PREC=%{BASE16NUM:UNWANTED} TTL=%{INT:ttl} ID=%{INT:connection_id} (DF )?PROTO=%{WORD:protocol} SPT=%{INT:source_port} DPT=%{INT:destination_port} (WINDOW=%{INT:window_size} )?(RES=0x00 )?(SYN )?(URGP=0 )?(LEN=%{INT:packet_length})?",
    value: to_string($message.message)
    );
  set_fields(fields);
  set_field("level", 5); // lower the severity to 5/INFO
  set_field("label", "firewalld"); // add a custom label to this message
end
```

![](https://gitlab.com/nodiscc/toolbox/-/raw/master/DOC/SCREENSHOTS/7Ntq4gl.png)

![](https://gitlab.com/nodiscc/toolbox/-/raw/master/DOC/SCREENSHOTS/IemwLaz.png)


---------------

## Backups

See the included [rsnapshot configuration](templates/etc_rsnapshot.d_graylog.conf.j2) for the [backup](../backup/README.md) role.

Currently, only graylog configuration is backed up, log data stored in Elasticsearch is not backed up.

You may use [`bsondump`](https://www.mongodb.com/docs/database-tools/bsondump/) to read and manipulate mongodb backups.

**Restoring backups:**

Place a copy of your mongodb backups in `~/mongodb/` on the host on which the data will be restored. The directory structure should look like this:

```
~/mongodb/
├── admin
│   ├── system.version.bson
│   └── system.version.metadata.json
└── graylog
    ├── access_tokens.bson
    ├── access_tokens.metadata.json
    ├── alarmcallbackconfigurations.bson
    ├── alarmcallbackconfigurations.metadata.json
    ...
```

```bash
# deploy the graylog role on the host on which the data will be restored
TAGS=graylog xsrv deploy default graylog.EXAMPLE.org
# access the host over SSH
xsrv shell graylog.EXAMPLE.org
# stop the graylog service
sudo systemctl stop graylog-server
# restore the mongodb database
# MONGODB_ADMIN_PASSWORD is the value of mongodb_admin_password in the host configuration (xsrv edit-vault)
mongorestore --drop --uri mongodb://admin:MONGODB_ADMIN_PASSWORD@127.0.0.1:27017/ ~/mongodb
# start graylog
sudo systemctl start graylog
```

If you get an error message `No such index` in graylog queries after restoring a dump, you may need to access `System > Indices > Default Index Set > Maintenance > Recalculate index ranges`

---------------

## Uninstallation

```bash
sudo systemctl stop elasticsearch graylog-server mongod
sudo apt purge elasticsearch graylog-4.0-repository  graylog-server mongodb-org
sudo firewall-cmd --remove-service=graylog-tcp --zone internal --permanent
sudo rm -rf /etc/apache2/sites-available/graylog.conf /etc/apache2/sites-enabled/graylog.conf /usr/share/keyrings/elasticsearch.gpg /usr/share/keyrings/mongodb.gpg  /etc/systemd/system/elasticsearch.service.d/ /etc/elasticsearch /etc/ansible/facts.d/graylog.fact /etc/firewalld/services/graylog-tcp.xml /etc/graylog/ /etc/apt/sources.list.d/elasticsearch.list /etc/apt/sources.list.d/graylog.list /etc/apt/sources.list.d/mongodb.list /etc/rsyslog.d/graylog.conf /var/log/mongodb/ /var/log/elasticsearch/ /var/log/graylog-server/ /var/log/graylog /var/lib/elasticsearch /etc/rsnapshot.d/graylog.conf /var/lib/mongodb /etc/mongod.conf
sudo systemctl daemon-reload
sudo systemctl reload apache2 firewalld
sudo systemctl restart rsyslog
```

--------------

## Tags

<!--BEGIN TAGS LIST-->
```
graylog - setup graylog log analyzer
mongodb - setup mongodb database
```
<!--END TAGS LIST-->


## References

- https://stdout.root.sx/links/?searchterms=graylog
