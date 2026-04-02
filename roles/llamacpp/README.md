# nodiscc.llamacpp

This role will install [llamacpp](https://github.com/ggml-org/llama.cpp), a tool to run [Large Language Models](https://en.wikipedia.org/wiki/Large_language_model) locally.

[![](https://github.com/nodiscc/toolbox/raw/master/DOC/SCREENSHOTS/llamacpp.png)](https://github.com/nodiscc/toolbox/raw/master/DOC/SCREENSHOTS/llamacpp.png)


## Requirements/dependencies/example playbook

See [meta/main.yml](meta/main.yml)

```yaml
# playbook.yml
- hosts: my.CHANGEME.org
  roles:
    - nodiscc.xsrv.common # (optional) base server setup, hardening, firewall, bruteforce prevention
    - nodiscc.xsrv.llamacpp
```

See [defaults/main.yml](defaults/main.yml) for all configuration variables.


## Usage

Access the web interface at `http://127.0.0.1:8033` (local access only).

You can also use the command-line interface by SSHing (`xsrv shell`) to the server and running `llamacpp-download-models` to manage models.

**Check that llamacpp is running on GPU:** Larger models require a GPU to provide acceptable quality/speeds (measured in tokens/second). Deploy the role to a bare-metal server equipped with a GPU with a proper ROCM (AMD) or CUDA (NVIDIA) setup, or if running in a VM, setup GPU passthrough from the host to the VM. How to set up ROCM/CUDA is out of scope for this role.

**Note:** This role currently does not integrate with the reverse proxy functionality of xsrv (Apache). The role has only been tested locally on desktop hardware with a 16GB VRAM GPU. Such hardware is likely to only be available on desktop machines, not headless servers. Reverse proxy integration might be added later.


### Backups

Automated backups via rsnapshot are **not configured** for the llamacpp role. Model files are very large (several GB each), and backing them up would consume significant additional disk space.

If you wish to preserve models for disaster recovery, manually copy the `/var/lib/llamacpp/models` directory to external storage:

```bash
rsync -av /var/lib/llamacpp/models/ /path/to/backup/
```

To restore, copy the models back and restart the service:
```bash
rsync -av /path/to/backup/models/ /var/lib/llamacpp/models/
sudo systemctl restart llamacpp
```


## Tags

<!--BEGIN TAGS LIST-->
```

```
<!--END TAGS LIST-->


## License

[GNU GPLv3](../../LICENSE)


## References

- https://stdout.root.sx/links/?searchterm=llamacpp
- https://stdout.root.sx/links/?searchtags=ai
