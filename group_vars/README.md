### group_vars/

Files in this directory hold group-level configuration variables.

File names must match a group in `inventory.yml`, with a `.yml` file extension. The default/global group is `all`.

Review `defaults/main.yml` in each role for a list of configuration variables.

Variables in `host_vars/*.yml` can override the ones defined here, host by host.