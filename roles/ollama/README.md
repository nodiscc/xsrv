# xsrv.ollama

This role will install [ollama](https://ollama.com/), a tool to run [Large Language Models](https://en.wikipedia.org/wiki/Large_language_model) locally, and [ollama-ui](https://github.com/ollama-ui/ollama-ui), a simple web interface for ollama.

[![](https://gitlab.com/nodiscc/toolbox/-/raw/master/DOC/SCREENSHOTS/ollama-ui.png)](https://gitlab.com/nodiscc/toolbox/-/raw/master/DOC/SCREENSHOTS/ollama-ui.png)


## Requirements/dependencies/example playbook

See [meta/main.yml](meta/main.yml)

```yaml
# playbook.yml
- hosts: my.CHANGEME.org
  roles:
    - nodiscc.xsrv.common # (optional) base server setup, hardening, firewall, bruteforce prevention
    - nodiscc.xsrv.monitoring # (optional) server monitoring
    - nodiscc.xsrv.apache # (required in the default configuration) webserver/reverse proxy, SSL certificates
    - nodiscc.xsrv.ollama

# required variables
# host_vars/my.CHANGEME.org/my.CHANGEME.org.yml
ollama_ui_fqdn: "llm.CHANGEME.org"

# ansible-vault edit host_vars/my.CHANGEME.org/my.CHANGEME.org.vault.yml
ollama_username: "CHANGEME"
ollama_password: "CHANGEME"
```

See [defaults/main.yml](defaults/main.yml) for all configuration variables.


## Usage

Access the web interface at `https://{{ ollama_ui_fqdn }}` and connect the web interface to the ollama server instance, by setting the `Hostname` value to `https://{{ ollama_ui_fqdn }}/api/`. Access to the web interface is protected by the [`ollama_username`/`ollama_password`](defaults/main.yml) credentials.

You can also use the command-line interface by SSHing (`xsrv shell`) to the server and running `ollama run MODEL_NAME`.

Models can be downloaded from the [ollama library](https://ollama.com/library). Set the [`ollama_models`](defaults/main.yml) configuration variable and deploy the role to pull models, or run `ollama pull MODEL_NAME` from the command line. The `orca-mini` model is pulled by default and should run with acceptable performance on a medium-sized machine (4GB RAM, 4vCPU). More advanced models require more resources to run with decent performance. See the [ollama README](https://github.com/ollama/ollama?tab=readme-ov-file#model-library) for more information.


### Backups

See the included [rsnapshot configuration](templates/etc_rsnapshot.d_ollama.conf.j2) for the [backup role](../backup) and the [`ollama_backup_models`](defaults/main.yml) configuration variable. By default, automatic backups of downloaded models are disabled.


## Tags

<!--BEGIN TAGS LIST-->
```
ollama - setup ollama Large Language Model server
ollama-ui - setup ollama-ui web interface for ollama
```
<!--END TAGS LIST-->


## License

[GNU GPLv3](../../LICENSE)


## References

- https://stdout.root.sx/links/?searchterm=ollama
- https://stdout.root.sx/links/?searchtags=ai
