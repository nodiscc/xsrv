FROM python:3
RUN echo 'Apt::Install-Recommends "false";' >> /etc/apt/apt.conf.d/99-norecommends && apt update && apt -y install git bash python3-venv python3-pip python3-cryptography openssh-client pwgen wget
RUN wget -O /usr/local/bin/xsrv https://gitlab.com/nodiscc/xsrv/-/raw/release/xsrv
RUN chmod a+x /usr/local/bin/xsrv
