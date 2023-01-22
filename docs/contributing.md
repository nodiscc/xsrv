# Contributing

- Check the [Planned features/work in progress](TODO.md) [[1](https://stdout.root.sx/xsrv/xsrv/issues)]
- Please report any problem on the [Gitlab issue tracker](https://gitlab.com/nodiscc/xsrv/issues) - include the following information:
  - Expected results, steps to reproduce the problem, observed results
  - Relevant technical information (configuration, logs, versions...)
  - If reporting a security issue, please check the `This issue is confidential` checkbox
- Please send patches by [Merge request](https://gitlab.com/nodiscc/xsrv/-/merge_requests) or attached to your bug reports
  - Patches must pass CI checks, include relevant documentation, and be split in a meaningful way
  - Any substantial changes/additions/removals must be added to the [changelog](https://gitlab.com/nodiscc/xsrv/-/blob/master/CHANGELOG.md). Changes that require actions from the user must be added to **Upgrade procedure** in the changelog section for the affected version.
  - Changes introducing new functionality should include relevant tests.sanity checks (e.g. new configuration variables)
  - You can find an example role which can be used as a template to develop new roles [here](https://gitlab.com/nodiscc/xsrv/-/tree/master/docs/example-role). See [this commit](https://gitlab.com/nodiscc/xsrv/-/commit/09ba2a429231dd75d86d15343a192c93280f1529) for an example.
- Please contribute to upstream projects and report issues on relevant bug trackers

