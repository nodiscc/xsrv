#!/usr/bin/env make
SHELL := '/bin/bash'
LAST_TAG := $(shell git describe --tags --abbrev=0)

all: tests

##### AUTOMATIC (CI) TESTS #####

.PHONY: tests # run all tests
tests: test_shellcheck test_ansible_lint test_command_line

.PHONY: test_shellcheck # static syntax checker for shell scripts
test_shellcheck:
	# ignore 'Can't follow non-constant source' warnings
	shellcheck -e SC1090 xsrv

.PHONY: venv # install dev tools in virtualenv
venv:
	python3 -m venv .venv && \
	source .venv/bin/activate && \
	pip3 install wheel && \
	pip3 install isort ansible-lint==6.0.2 yamllint ansible==5.5.0

.PHONY: build_collection # build the ansible collection tar.gz
build_collection: venv
	source .venv/bin/activate && \
	ansible-galaxy collection build --force

.PHONY: install_collection # prepare the test environment/install the collection
install_collection: venv build_collection
	source .venv/bin/activate && \
	ansible-galaxy  -vvv collection install --collections-path ./ nodiscc-xsrv-$(LAST_TAG).tar.gz

.PHONY: test_ansible_lint # ansible syntax linter
test_ansible_lint: venv
	source .venv/bin/activate && \
	ANSIBLE_ROLES_PATH=./roles ansible-lint -v -x fqcn-builtins,truthy,braces,line-length tests/playbook.yml

.PHONY: test_command_line # test correct execution of xsrv commands
test_command_line:
	rm -rf ~/playbooks/xsrv-test
	XSRV_UPGRADE_CHANNEL=master EDITOR=cat ./xsrv init-project xsrv-test my.example.org
	EDITOR=cat ./xsrv edit-group-vault xsrv-test all && grep ANSIBLE_VAULT ~/playbooks/xsrv-test/group_vars/all/all.vault.yml

##### MANUAL TESTS #####
# requirements: libvirt libguestfs-tools, prebuilt debian VM template, host configuration initialized with xsrv init-host
# usage: make test_init_vm SUDO_PASSWORD=CHANGEME ROOT_PASSWORD=CHANGEME
TEMPLATE_NAME = debian11-base
VM_NAME = my.example.test
VM_IP = 10.0.0.223
VM_NETMASK = 24
VM_GATEWAY = 10.0.0.1
VM_MEM = 7G
VM_VCPUS = 4
SUDO_USER = deploy
SSH_PUBKEY = 'ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDJKlvXZ7snonbBj2xmRfzQi+/5iXLWiD8Eq9atICCvp4jF/ocdem13wGHkForElqsqMHbOWFJskQDS6lVTvORdMpgSiJmkR0wI9VD/AeInPCesWVxO1pyF2xqsnd8OhnaK9+igioz6iG0iE318lX2LmxN5JpauVx8cesoOVp0b2LKpSiXaoyxr4Sd8dQjT5GiUBz8mlDQPVdMOZRnXdr9y1tQt6kNvfRMesJ5594cOBY6nMtbQB6/rnbn77LLkq1am1y4XBwTPQ/3DJFuxyaixq/A3+SfiFOlFHcijq/mfw0O2pI4K4vFPVl3n5bHXgJJ57QIQdkYQW2Tir/Mv1zDj4c+lhScX4jNNxmde/nZ2TE+ynW2OapiodXlCjBTVysOMgizSA96HZcHNwNhSdodqOJxGW+U9FIF4K8RUXbUkrWmoWDGmlDHkjkNszdKBieGT4tjuzB3NN9J93CDdwqlEIPg0xRUImCkc4zeTwTWVgFW1TD9o/CBz3l+hlF2wV8wvCzBfx42cTjeEMrWMb/8CSz9VK+Q6R2l27MqhLJUmOnlWEqiQaponAoPUpocBd703oOnJGnX3anJjY+LNeqlye++T2iTr0SwIWXohX9NzVgJZIDmEIRd7ThjTvdWoebR7pKpox4x48LR6f4K6p/tnG7BM9O+7MkglSdFj0tn5NQ=='
SUDO_PASSWORD = CHANGEME
ROOT_PASSWORD = CHANGEME

.PHONY: test_init_vm # test correct execution of xsrv init-vm
test_init_vm:
	ssh-keygen -R $(VM_NAME)
	ssh-keygen -R $(VM_IP)
	if [[ -f /etc/libvirt/qemu/$(VM_NAME).xml ]]; then virsh undefine --domain $(VM_NAME) --remove-all-storage; fi
	./xsrv init-vm --template $(TEMPLATE_NAME) --name $(VM_NAME) \
	    --ip $(VM_IP) --netmask $(VM_NETMASK) --gateway $(VM_GATEWAY) \
	    --sudo-user $(SUDO_USER) --sudo-password $(SUDO_PASSWORD) --ssh-pubkey $(SSH_PUBKEY) --root-password $(ROOT_PASSWORD) \
		--memory $(VM_MEM) --vcpus $(VM_VCPUS)

.PHONY: test_idempotence # test full playbook run against the host created with test_init_vm
test_idempotence:
	# test initial check mode
	./xsrv check default $(VM_NAME)
	# test initial deployment
	./xsrv deploy default $(VM_NAME)
	# test idempotence
	./xsrv deploy default $(VM_NAME)

##### RELEASE PROCEDURE #####
# - make bump_versions update_todo changelog new_tag=$new_tag
# - update changelog.md, add and commit version bumps and changelog updates
# - git tag $new_tag && git push && git push --tags
# - git checkout release && git merge master && git push
# - GITLAB_PRIVATE_TOKEN=AAAbbbCCCddd make gitlab_release new_tag=$new_tag
# - GITHUB_PRIVATE_TOKEN=XXXXyyyZZZzz make github_release new_tag=$new_tag
# - ANSIBLE_GALAXY_PRIVATE_TOKEN=AAbC make publish_collection new_tag=$new_tag
# - update release descriptions on https://github.com/nodiscc/xsrv/releases and https://gitlab.com/nodiscc/xsrv/-/releases

.PHONY: bump_versions # manual - bump version numbers in repository files (new_tag=X.Y.Z required)
bump_versions: doc_md
ifndef new_tag
	$(error new_tag is undefined)
endif
	@sed -i "s/^version:.*/version: $(new_tag)/" galaxy.yml && \
	sed -i "s/^version=.*/version=\"$(new_tag)\"/" xsrv && \
	sed -i "s/^version =.*/version = '$(new_tag)'/" docs/conf.py && \
	sed -i "s/^release =.*/release = '$(new_tag)'/" docs/conf.py && \
	sed -i "s/latest%20release-.*-blue/latest%20release-$(new_tag)-blue/" README.md docs/index.md

.PHONY: gitlab_release # create a new gitlab release (new_tag=X.Y.Z required, GITLAB_PRIVATE_TOKEN must be defined in the environment)
gitlab_release:
ifndef new_tag
	$(error new_tag is undefined)
endif
ifndef GITLAB_PRIVATE_TOKEN
	$(error GITLAB_PRIVATE_TOKEN is undefined)
endif
	curl --header 'Content-Type: application/json' --header "PRIVATE-TOKEN: $$GITLAB_PRIVATE_TOKEN" \
	--data '{ "name": "$(new_tag)", "tag_name": "$(new_tag)" }' \
	--request POST "https://gitlab.com/api/v4/projects/14306200/releases"

.PHONY: github_release # create a new github release (new_tag=X.Y.Z required, GITHUB_PRIVATE_TOKEN must be defined in the environement)
github_release:
ifndef new_tag
	$(error new_tag is undefined)
endif
ifndef GITHUB_PRIVATE_TOKEN
	$(error GITHUB_PRIVATE_TOKEN is undefined)
endif
	curl --user nodiscc:$$GITHUB_PRIVATE_TOKEN --header "Accept: application/vnd.github.v3+json" \
	--data '{ "tag_name": "$(new_tag)", "prerelease": true }' \
	--request POST https://api.github.com/repos/nodiscc/xsrv/releases

.PHONY: publish_collection # publish the ansible collection (ANSIBLE_GALAXY_PRIVATE_TOKEN must be defined in the environment)
publish_collection: build_collection
ifndef new_tag
	$(error new_tag is undefined)
endif
ifndef ANSIBLE_GALAXY_PRIVATE_TOKEN
	$(error ANSIBLE_GALAXY_PRIVATE_TOKEN is undefined)
endif
	source .venv/bin/activate && \
	ansible-galaxy collection publish --token "$$ANSIBLE_GALAXY_PRIVATE_TOKEN" nodiscc-xsrv-$(new_tag).tar.gz


##### UTILITIES #####

.PHONY: install_deps # manual - install requirements for test suite
install_deps:
	apt update && apt -y install git bash python3-venv python3-pip python3-cryptography ssh pwgen shellcheck jq

# can be used to establish a list of variables that need to be checked via 'assert' tasks at the beginnning of the role
.PHONY: list_default_variables # manual - list all variables names from role defaults
list_default_variables:
	for i in roles/*; do \
	echo -e "\n#### $$i #####\n"; \
	grep --no-filename -E --only-matching "^(# )?[a-z\_]*:" $$i/defaults/main.yml | sed 's/# //' | sort -u ; \
	done

.PHONY: get_build_status # manual - get build status of the current commit/branch (GITLAB_PRIVATE_TOKEN must be defined in the environment)
get_build_status:
ifndef GITLAB_PRIVATE_TOKEN
	$(error GITLAB_PRIVATE_TOKEN is undefined)
endif
	@branch=$$(git rev-parse --abbrev-ref HEAD) && \
	commit=$$(git rev-parse HEAD) && \
	curl --silent --header "PRIVATE-TOKEN: $$GITLAB_PRIVATE_TOKEN" "https://gitlab.com/api/v4/projects/nodiscc%2Fxsrv/repository/commits/$$commit/statuses?ref=$$branch" | jq  .[].status

# requires gitea-cli configuration in ~/.config/gitearc:
# export GITEA_API_TOKEN="AAAbbbCCCdddZZ"
# gitea.issues() {
# 	split_repo "$1"
# 	auth curl --silent --insecure "https://gitea.example.org/api/v1/repos/$REPLY/issues?limit=1000"
# }
.PHONY: update_todo # manual - Update TODO.md by fetching issues from the main gitea instance API
update_todo:
	git clone https://github.com/bashup/gitea-cli gitea-cli
	echo '<!-- This file is automatically generated by "make update_todo" -->' >| docs/TODO.md
	echo -e "\n### xsrv/xsrv\n" >> docs/TODO.md; \
	./gitea-cli/bin/gitea issues xsrv/xsrv | jq -r '.[] | "- #\(.number) - \(.title) - **`\(.milestone.title // "-")`** `\(.labels | map(.name) | join(","))`"'  | sed 's/ - `null`//' >> docs/TODO.md
	rm -rf gitea-cli

.PHONY: changelog # manual - establish a changelog since the last git tag
changelog:
	@echo "[INFO] changes since last tag $(LAST_TAG)" && \
	git log --oneline $(LAST_TAG)...HEAD | cat

.PHONY: doc_md # manual - generate docs/index.md from README.md
doc_md:
	@roles_list_md=$$(for i in roles/*/meta/main.yml; do \
		name=$$(grep "role_name: " "$$i" | awk -F': ' '{print $$2}'); \
		description=$$(grep "description: " "$$i" | awk -F': ' '{print $$2}' | sed 's/"//g'); \
		echo "- [$$name](roles/$$name) - $$description"; \
		done) && \
		echo "$$roles_list_md" >| roles-list.tmp.md
	@awk ' \
		BEGIN {p=1} \
		/^<!--BEGIN ROLES LIST-->/ {print;system("cat roles-list.tmp.md | sort --version-sort");p=0} \
		/^<!--END ROLES LIST-->/ {p=1} \
		p' README.md >> README.tmp.md
	@rm roles-list.tmp.md
	@mv README.tmp.md README.md
	@cp README.md docs/index.md
	@sed -i 's|(roles/|(https://gitlab.com/nodiscc/xsrv/-/tree/master/roles/|g' docs/index.md
	@sed -i 's|https://xsrv.readthedocs.io/en/latest/\(.*\).html|\1.md|g' docs/index.md
	@sed -i 's|docs/||g' docs/index.md

SPHINXOPTS    ?=
SPHINXBUILD   ?= sphinx-build
SOURCEDIR     = docs/    # source directory (markdown)
BUILDDIR      = doc/html  # destination directory (html)
.PHONY: doc_html # manual - HTML documentation generation (sphinx-build --help)
doc_html: doc_md
	python3 -m venv .venv/ && \
	source .venv/bin/activate && \
	pip3 install sphinx recommonmark sphinx_rtd_theme && \
	sphinx-build -c docs/ -b html docs/ docs/html

.PHONY: clean # manual - clean artifacts generated by make tests
clean:
	-rm -rf .venv/ nodiscc-xsrv-*.tar.gz gitea-cli/ .venv/ ansible_collections/ .cache/

.PHONY: help # generate list of targets with descriptions
help:
	@grep '^.PHONY: .* #' Makefile | sed 's/\.PHONY: \(.*\) # \(.*\)/\1	\2/' | expand -t20
