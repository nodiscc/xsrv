# xsrv.gitea_act_runner

This role will install and configure [act-runner](https://docs.gitea.com/next/usage/actions/act-runner), the runner for Gitea Actions, Gitea's built-in CI/CD system, and register it on a Gitea instance.

You can configure it to run workflows in rootless [podman](../podman) containers, [docker](https://gitlab.com/nodiscc/toolbox/-/tree/master/ARCHIVE/ANSIBLE-COLLECTION/roles/docker) containers, or directly on the host.


## Requirements/dependencies/example playbook

See [meta/main.yml](meta/main.yml)

```yaml
# playbook.yml
- hosts: my.CHANGEME.org
  roles:
    - nodiscc.xsrv.podman # if using gitea_act_runner_container_engine: "podman" (the default)
    - nodiscc.xsrv.docker # if using gitea_act_runner_container_engine: "docker"
    - nodiscc.xsrv.gitea # (optional) gitea git service (can also be deployed to a different host)
    - nodiscc.xsrv.gitea_act_runner

# required variables
# host_vars/my.CHANGEME.org/my.CHANGEME.org.yml
gitea_act_runner_gitea_instance_fqdn: "git.CHANGEME.org" # required if the runner and gitea instance are on different hosts
gitea_act_runner_gitea_instance_hostname: "my2.CHANGEME.org" # required if the runner and gitea instance are on different hosts
```

See [defaults/main.yml](defaults/main.yml) for all configuration variables.

The gitea instance you want to register the runner on, must be managed by the same ansible playbook/project - at least, the hostname must be present in the inventory, and its `become` credentials in the corresponding host_vars/vault file, as they are used for automatically creating the runner token and register it on the instance.


## Usage

See [Gitea actions quickstart](https://docs.gitea.com/next/usage/actions/quickstart). Gitea actions use the same workflow syntax as [Github actions](https://docs.github.com/en/actions/using-workflows/workflow-syntax-for-github-actions).

Note that base images/environments in which Gitea actions are run are [different](https://docs.gitea.com/next/usage/actions/act-runner#labels) from Github actions environments. Getting Github actions workflows to run in Gitea actions may require some adjustments.

To force re-registering the runner, open a shell on the host (`xsrv shell default my.example.org`) and run `sudo rm /var/lib/act-runner/.runner` before re-running the playbook/`gitea_act_runner` role/tag.

### Backups

There is no data worth backing up.


## Tags

<!--BEGIN TAGS LIST-->
```
gitea_act_runner - setup gitea CI/CD runner (act-runner)
```
<!--END TAGS LIST-->


## License

[GNU GPLv3](../../LICENSE)


## References

- https://stdout.root.sx/links/?searchtags=cicd
- https://stdout.root.sx/links/?searchterm=gitea
