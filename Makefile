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
	shellcheck -e SC1090,SC1091 xsrv xsrv-completion.sh roles/monitoring_netdata/files/usr_local_bin_needrestart-autorestart roles/monitoring_utils/templates/usr_local_bin_bonnie++-wrapper.j2

.PHONY: venv # install dev tools in virtualenv
venv:
	python3 -m venv .venv && \
	source .venv/bin/activate && \
	pip3 install wheel && \
	pip3 install isort ansible-lint==25.1.3 yamllint ansible==11.3.0

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
	ansible-lint -v -x fqcn[action-core],fqcn[action],name[casing],yaml[truthy],schema[meta],yaml[line-length],var-naming[no-role-prefix] roles/* docs/example-role

.PHONY: test_command_line # test correct execution of xsrv commands
test_command_line:
	rm -rf tests/playbooks/xsrv-init-playbook
	XSRV_PROJECTS_DIR="$$PWD/tests/playbooks" XSRV_UPGRADE_CHANNEL=master EDITOR=cat ./xsrv init-project xsrv-init-playbook my.example.org
	XSRV_PROJECTS_DIR="$$PWD/tests/playbooks" EDITOR=cat ./xsrv edit-group-vault xsrv-init-playbook all && grep ANSIBLE_VAULT tests/playbooks/xsrv-init-playbook/group_vars/all/all.vault.yml
	XSRV_PROJECTS_DIR="$$PWD/tests/playbooks" ./xsrv show-groups xsrv-init-playbook my.example.org

##### MANUAL TESTS #####

# usage: make test_init_vm_template NETWORK=default
.PHONY: test_init_vm_template # test correct execution of xsrv init-vm-template
test_init_vm_template:
	-virsh destroy my.template.test
	-virsh undefine my.template.test --remove-all-storage
	./xsrv init-vm-template --name my.template.test --ip 10.0.10.240 --network=$(NETWORK)

# TODO the resulting VM has no video output, access over serial console only, --graphics spice,listen=none during init-vm-template will prevent it from working, spice console must be added during init_vm
# requirements: libvirt libguestfs-tools, prebuilt debian VM template, host configuration initialized with xsrv init-host
# usage: make test_init_vm SUDO_PASSWORD=cj5Bfvv5Bm5JYNJiEEOG ROOT_PASSWORD=cj5Bfvv5Bm5JYNJiEEOG
.PHONY: test_init_vm # test correct execution of xsrv init-vm
test_init_vm:
	ssh-keygen -R my.example.test
	ssh-keygen -R 10.0.10.241
	-virsh destroy my.example.test
	-virsh undefine my.example.test --remove-all-storage
	./xsrv init-vm --template my.template.test --name my.example.test \
		--ip 10.0.10.241 \
		--sudo-user deploy --sudo-password $(SUDO_PASSWORD) --root-password $(ROOT_PASSWORD) \
		--ssh-pubkey "$$(cat ~/.ssh/id_rsa.pub)" \
		--memory 4G --vcpus 4 \
		--dumpxml my.example.test.xml

.PHONY: test_check_mode # test full playbook run (--check mode) against the host created with test_init_vm
test_check_mode:
	XSRV_PROJECTS_DIR="$$PWD/tests/playbooks" ./xsrv upgrade xsrv-test
	XSRV_PROJECTS_DIR="$$PWD/tests/playbooks" ./xsrv check xsrv-test my.example.test

.PHONY: test_idempotence # test 2 consecutive full playbook runs against the host created with test_init_vm
test_idempotence:
	XSRV_PROJECTS_DIR="$$PWD/tests/playbooks" ./xsrv upgrade xsrv-test
	XSRV_PROJECTS_DIR="$$PWD/tests/playbooks" ./xsrv deploy xsrv-test my.example.test
	XSRV_PROJECTS_DIR="$$PWD/tests/playbooks" ./xsrv deploy xsrv-test my.example.test
	# check netdata alarms count
	curl --insecure https://my.example.test:19999/api/v1/alarms

.PHONY: test_fetch_backups # test fetch-backups command against the host deployed with test_idempotence
test_fetch_backups:
	XSRV_PROJECTS_DIR="$$PWD/tests/playbooks" ./xsrv upgrade xsrv-test
	XSRV_PROJECTS_DIR="$$PWD/tests/playbooks" TAGS=utils-backup-now ./xsrv deploy xsrv-test my.example.test
	XSRV_PROJECTS_DIR="$$PWD/tests/playbooks" ./xsrv fetch-backups xsrv-test my.example.test

##### RELEASE PROCEDURE #####
# - make test_init_vm_template test_init_vm test_check_mode test_idempotence test_fetch_backups SUDO_PASSWORD=cj5Bfvv5Bm5JYNJiEEOG ROOT_PASSWORD=cj5Bfvv5Bm5JYNJiEEOG NETWORK=default
# - check test environment logs for warning/errors: ssh -t deploy@my.example.test sudo lnav /var/log/syslog
# - make clean
# - make bump_versions update_todo new_tag=$new_tag
# - update release date in CHANGELOG.md, add and commit version bumps/changelog updates with message "release v$new_tag"
# - git tag $new_tag && git push && git push --tags
# - git checkout release && git merge master && git push
# - GITLAB_PRIVATE_TOKEN=AAAbbbCCCddd make gitlab_release new_tag=$new_tag
# - GITHUB_PRIVATE_TOKEN=XXXXyyyZZZzz make github_release new_tag=$new_tag
# - touch roles/README.md && ANSIBLE_GALAXY_PRIVATE_TOKEN=AAbC make publish_collection new_tag=$new_tag
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

.PHONY: github_release # create a new github release (new_tag=X.Y.Z required, GITHUB_PRIVATE_TOKEN must be defined in the environment)
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


##### DOCUMENTATION #####

# requirements: sudo apt install git jq
#               gitea-cli config defined in ~/.config/gitearc:
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

.PHONY: doc_md # manual - generate markdown documentation
doc_md:
	# update README.md from available roles
	@roles_list_md=$$(for i in roles/*/meta/main.yml; do \
		name=$$(grep "role_name: " "$$i" | awk -F': ' '{print $$2}'); \
		description=$$(grep "description: " "$$i" | awk -F': ' '{print $$2}' | sed 's/"//g'); \
		echo "- [$$name](roles/$$name) - $$description"; \
		done) && \
		echo "$$roles_list_md" >| roles-list.tmp.md && \
		awk ' \
		BEGIN {p=1} \
		/^<!--BEGIN ROLES LIST-->/ {print;system("cat roles-list.tmp.md | sort --version-sort");p=0} \
		/^<!--END ROLES LIST-->/ {p=1} \
		p' README.md >> README.tmp.md && \
		mv README.tmp.md README.md && \
		rm roles-list.tmp.md
	# generate docs/index.md from README.md
	@cp README.md docs/index.md && \
		sed -i 's|(roles/|(https://gitlab.com/nodiscc/xsrv/-/tree/master/roles/|g' docs/index.md && \
		sed -i 's|https://xsrv.readthedocs.io/en/latest/\(.*\).html|\1.md|g' docs/index.md && \
		sed -i 's|docs/||g' docs/index.md
	# update docs/configuration-variables.md from available roles
	@roles_list_defaults_md=$$(for file in roles/*/defaults/main.yml; do echo -e "## $$(echo $$file | cut -d '/' -f 2)\n\n[$$file](https://gitlab.com/nodiscc/xsrv/-/blob/master/$$file)\n\n\`\`\`yaml\n$$(cat $$file)\n\`\`\`\n\n"; done); \
		echo "$$roles_list_defaults_md" >| roles-list-defaults.tmp.md && \
		awk ' \
		BEGIN {p=1} \
		/^<!--BEGIN ROLES LIST-->/ {print;system("cat roles-list-defaults.tmp.md");p=0} \
		/^<!--END ROLES LIST-->/ {p=1} \
		p' docs/configuration-variables.md >> docs/configuration-variables.tmp.md && \
		mv docs/configuration-variables.tmp.md docs/configuration-variables.md && \
		rm roles-list-defaults.tmp.md
	# generate tags list in roles READMEs
	@for i in roles/*; do \
		echo $$i; \
		tags_list=$$(grep '^# @' $$i/meta/main.yml); \
		echo -e "\`\`\`\n$$tags_list\n\`\`\`" | sed 's/# @tag //g'> tags.tmp.md && \
		awk ' \
			BEGIN { p=1} \
			/^<!--BEGIN TAGS LIST-->/ {print;system("cat tags.tmp.md");p=0} \
			/^<!--END TAGS LIST-->/ {p=1} \
			p' $$i/README.md >> README.tmp.md && \
		rm tags.tmp.md && \
		mv README.tmp.md $$i/README.md; \
	done
	# generate tags list in docs/tags.md
	sed -i 's/# -/-/g' tests/playbooks/xsrv-test/playbook.yml
	echo -e '# Tags\n\n```' > docs/tags.md
	XSRV_PROJECTS_DIR="$$PWD/tests/playbooks" ./xsrv upgrade xsrv-test
	XSRV_PROJECTS_DIR="$$PWD/tests/playbooks" ./xsrv help-tags xsrv-test >> docs/tags.md
	echo -e '\n```'>> docs/tags.md

SPHINXOPTS    ?=
SPHINXBUILD   ?= sphinx-build
SOURCEDIR     = docs/    # source directory (markdown)
BUILDDIR      = doc/html  # destination directory (html)
.PHONY: doc_html # manual - HTML documentation generation (sphinx-build --help)
doc_html: doc_md
	python3 -m venv .venv/ && \
	source .venv/bin/activate && \
	pip3 install sphinx myst-parser sphinx_external_toc sphinx_rtd_theme && \
	sphinx-build -c docs/ -b html docs/ docs/html

### MANUAL/UTILITY TARGETS ###

.PHONY: codespell # manual - run interactive spell checker
codespell: venv
	source .venv/bin/activate && \
    pip3 install codespell && \
	codespell --write-changes --interactive 3 --ignore-words ./tests/codespell.ignore --uri-ignore-words-list '*' \
	--skip '*.venv/*,./.git/*,./tests/playbooks/xsrv-test/ansible_collections/*'

.PHONY: test_install_test_deps # manual - install requirements for test suite
test_install_test_deps:
	apt update && apt -y install git bash python3-venv python3-pip python3-cryptography ssh pwgen shellcheck jq cloc

.PHONY: test_cloc # count SLOC with cloc
test_cloc:
	cloc --exclude-dir=tests --exclude-dir=pip-cache --exclude-dir=.venv --force-lang='Jinja Template',j2 --force-lang='Jinja Template',conf --force-lang='Jinja Template',cfg .

# can be used to establish a list of variables that need to be checked via 'assert' tasks at the beginning of the role
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

.PHONY: clean # manual - clean artifacts generated by tests
clean:
	# clean files generated by test_init_vm_template
	-virsh destroy my.template.test
	-virsh undefine my.template.test --remove-all-storage
	# clean files generated by test_init_vm
	-virsh destroy my.example.test
	-virsh undefine my.example.test --remove-all-storage
	rm -f my.example.test.xml
	rm -rf tests/playbooks/xsrv-init-playbook
	# clean files generated by venv target
	rm -rf .venv/
	# clean files generated by publish_collection target
	rm -rf nodiscc-xsrv-*.tar.gz
	# clean files generated by test_check_mode/test_idempotence
	rm -rf tests/playbooks/xsrv-test/ansible_collections/ tests/playbooks/xsrv-test/.venv/ tests/playbooks/xsrv-test/data/cache/facts/ tests/playbooks/xsrv-test/data/public_keys/root@my.example.test.pub tests/playbooks/xsrv-test/data/certificates/ tests/playbooks/xsrv-test/data/backups/daily.*
	# clean files generated by update_todo
	rm -rf gitea-cli/

.PHONY: help # generate list of targets with descriptions
help:
	@grep '^.PHONY: .* #' Makefile | sed 's/\.PHONY: \(.*\) # \(.*\)/\1	\2/' | expand -t20
