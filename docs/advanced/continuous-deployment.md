### Continuous deployment

For production systems, it is strongly recommended to run the playbook and evaluate changes against a testing/staging environment first (eg. create separate `testing`,`prod` groups in `inventory.yml`, deploy changes to the `testing` environmnent with `xsrv deploy PLAYBOOK_NAME testing`). 

You can further automate deployment procedures using a CI/CD pipeline. See the example [`.gitlab-ci.yml`](playbooks/xsrv/.gitlab-ci.yml) to get started.

