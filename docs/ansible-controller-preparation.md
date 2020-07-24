### Anisble controller preparation

```bash
# install requirements (example for debian-based systems)
sudo apt update && sudo apt install git bash python3-pip openssl ssh

# authorize your SSH key on the server
ssh-copy-id myusername@my.example.org

# clone the repository
sudo git clone -b release https://gitlab.com/nodiscc/xsrv /opt/xsrv # latest release
sudo git clone -b 1.0 https://gitlab.com/nodiscc/xsrv /opt/xsrv # OR specific release
sudo git clone -b master https://gitlab.com/nodiscc/xsrv /opt/xsrv # OR development version

# (optional) install the command line tool to your $PATH
sudo cp /opt/xsrv/xsrv /usr/local/bin/
```

You can use `xsrv` to manage your ansible environments, or use components through standard `ansible-*` [command-line tools](https://docs.ansible.com/ansible/latest/user_guide/command_line_tools.html) directly (for example, case add `/opt/xsrv/roles` to your ansible [roles path](https://docs.ansible.com/ansible/latest/reference_appendices/config.html), or get the collection using `ansible-galaxy collection install nodiscc.xsrv`).
