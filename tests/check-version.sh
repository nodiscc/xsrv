#!/bin/bash
# Check that pypi versions in nvchecker.toml match versions defined in Makefile and xsrv
set -euo pipefail

NVCHECKER="$(pwd)/.venv/bin/nvchecker"

# --- Extract current versions ---
ansible_make_version=$(grep 'ansible==' Makefile | head -1 | sed 's/.*ansible==//;s/ .*//')
ansible_xsrv_version=$(grep '^ansible_version=' xsrv | head -1 | sed 's/.*ansible_version="//;s/".*//')
ansible_lint_make_version=$(grep 'ansible-lint==' Makefile | head -1 | sed 's/.*ansible-lint==//;s/ .*//')
grafana_version=$(grep 'grafana_version:' roles/monitoring/grafana/defaults/main.yml | head -1 | sed 's/.*grafana_version: "//;s/".*//')

# --- Compare against PyPI ---
ERRORS=0

for pypi_package in $(awk -F' = ' '/^\[.*\]$/{entry=$1; gsub(/[\[\]]/, "", entry); print entry}' tests/nvchecker.toml); do
    echo "[INFO] version check for $pypi_package ..."
    latest_version=$($NVCHECKER --file tests/nvchecker.toml --logger json --entry "$pypi_package" | jq -r .version)

    case "$pypi_package" in
        ansible)
            if [ "$ansible_make_version" != "$latest_version" ]; then
                echo "ERROR: $pypi_package: Makefile has $ansible_make_version, pypi has $latest_version"
                ERRORS=1
            fi
            if [ "$ansible_xsrv_version" != "$latest_version" ]; then
                echo "ERROR: $pypi_package: xsrv has $ansible_xsrv_version, pypi has $latest_version"
                ERRORS=1
            fi
            ;;
        ansible-lint)
            if [ "$ansible_lint_make_version" != "$latest_version" ]; then
                echo "ERROR: $pypi_package: Makefile has $ansible_lint_make_version, pypi has $latest_version"
                ERRORS=1
            fi
            ;;
        grafana)
            if [ "$grafana_version" != "$latest_version" ]; then
                echo "ERROR: $pypi_package: defaults/main.yml has $grafana_version, pypi has $latest_version"
                ERRORS=1
            fi
            ;;
    esac
done

exit $ERRORS
