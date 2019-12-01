#!/usr/bin/env make
SHELL := '/bin/bash'

tests: shellcheck check_jinja2 ansible_lint yamllint

# Install dev tools in virtualenv
venv:
	python3 -m venv .venv && \
	source .venv/bin/activate && \
	pip3 install isort ansible-lint yamllint ansible==2.8.0

# download/update roles from ansible-galaxy
galaxy: venv
	source .venv/bin/activate
	ansible-galaxy install -f -r requirements.yml

# Static syntax checker for shell scripts
# install shellcheck before use: sudo apt install shellcheck
shellcheck:
	# ignore 'Can't follow non-constant source' warnings
	shellcheck -e SC1090 xsrv

# Ansible linter
ansible_lint: venv galaxy
	source .venv/bin/activate && \
	ansible-lint srv01-playbook.yml.dist || exit 0

# YAML syntax check and linter
yamllint: venv galaxy
	source .venv/bin/activate && \
	find ./ -iname "*.yml" -exec yamllint -c tests/.yamllint '{}' \;

check_jinja2: venv galaxy
	source .venv/bin/activate && \
	j2_files=$$(find roles/ -name "*.j2") && \
	for i in $$j2_files; do \
	echo "[INFO] checking syntax for $$i"; \
	./tests/check-jinja2.py "$$i"; \
	done
