# toolbox.ollama

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
    - nodiscc.toolbox.ollama

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

You can also use the command-line interface by SSHing (`xsrv shell`) to the server and running `ollama run MODEL_NAME:VERSION`. Any model name and version from https://ollama.com/search can be used directly.

Models can be downloaded from the [ollama library](https://ollama.com/library). Edit (`xsrv edithost/edit-group`) the [`ollama_models`](defaults/main.yml) configuration variable and deploy the role to automaticall pull models during deployment, or run `ollama pull MODEL_NAME` from the command line.

The `orca-mini` model is pulled by default and should run with acceptable performance (but mediocre results) on a medium-sized machine (4GB RAM, 4vCPU) without GPU. More advanced models require more resources to run with decent performance. See the [ollama README](https://github.com/ollama/ollama?tab=readme-ov-file#model-library) for more information.

Run `ollama help` to show all available CLI commands.

**Check that ollama is running on GPU:** Larger models require a GPU to provide decent quality results at tolerable speeds (a few tokens/second). For NVidia GPUs, you can check that ollama is running on GPU by running the `nvidia-smi` command, and cheking if the `CUDA Version:` field is present in th output. You should also install `nvidia-cuda-toolkit`. If `no compatible GPUs were discovered` is present in the ollama startup logs (`xsrv logs`), then  your GPU is not being used, and ollama will fall back to using the CPU.

**Run on a desktop computer:** If your server does not have a GPU, this role should still be usable on a desktop computer. You probably want to keep `ollama_ui: no` on computers without a web server installed, and use Ollama through `ollama run` and/or IDE extensions such as [Continue](https://ollama.com/blog/continue-code-assistant)


### Backups

See the included [rsnapshot configuration](templates/etc_rsnapshot.d_ollama.conf.j2) for the [backup role](../backup) and the [`ollama_backup_models`](defaults/main.yml) configuration variable. By default, automatic backups of downloaded models are disabled.

### Uninstallation

```bash
sudo systemctl disable --now ollama-ui ollama
sudo rm -rf /etc/apache2/ollama-passwd /etc/apache2/sites-available/ollama.conf /etc/apache2/sites-enabled/ollama.conf /etc/rsnapshot.d/ollama.conf /etc/ansible/facts.d/ollama.fact /var/lib/ollama-ui /etc/systemd/system/ollama-ui.service /usr/local/bin/ollama /usr/local/lib/ollama /var/lib/ollama /etc/systemd/system/ollama.service
sudo deluser ollama
sudo systemctl daemon-reload
sudo systemctl restart apache2
```

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
