#!/bin/bash
# Description: bash completion script for xsrv
# https://xsrv.readthedocs.io/en/latest/usage.html#command-line-usage

_xsrv_completion() {
    local cur=${COMP_WORDS[COMP_CWORD]}
    local prev=${COMP_WORDS[COMP_CWORD-1]}
    if [[ "$COMP_CWORD" == "1" ]]; then
        # shellcheck disable=SC2207
        COMPREPLY=($(compgen -W "edit-inventory edit-playbook edit-requirements edit-cfg edit-host edit-vault edit-group edit-group-vault init-host init-project check deploy fetch-backups shell logs ls open show-defaults upgrade self-upgrade scan init-vm-template init-vm readme-gen nmap help help-tags" "$cur"))
    elif [[ "$COMP_CWORD" == "2" ]]; then
        case "$prev" in
            edit-*|"init-host"|"check"|"deploy"|"fetch-backups"|"shell"|"scan"|"logs"|"open"|"show-defaults"|"upgrade"|"readme-gen"|"nmap"|"help-tags")
                # only works with GNU find
                # shellcheck disable=SC1117
                dirs=$(find -L  ~/playbooks/ -maxdepth 1 -mindepth 1 -type d -printf "%f\n")
                # works with coreutils find but calls an external executable
                #dirs=$(find -L  ~/playbooks/ -maxdepth 1 -mindepth 1 -type d -exec basename '{}' \;)
                # shellcheck disable=SC2207
                COMPREPLY=($(compgen -W "$dirs" "$cur"));;
        esac
    elif [[ "$COMP_CWORD" == "3" ]]; then
        local command=${COMP_WORDS[COMP_CWORD-2]}
        case "$command" in
            "edit-host"|"edit-vault"|"fetch-backups"|"shell"|"logs")
                # shellcheck disable=SC1117
                dirs=$(find -L  ~/playbooks/"$prev"/host_vars -maxdepth 1 -mindepth 1 -type d -printf "%f\n");
                # shellcheck disable=SC2207
                COMPREPLY=($(compgen -W "$dirs" "$cur"));;
            "edit-group"|"edit-group-vault")
                # shellcheck disable=SC1117
                dirs=$(find -L  ~/playbooks/"$prev"/group_vars -maxdepth 1 -mindepth 1 -type d -printf "%f\n");
                # shellcheck disable=SC2207
                COMPREPLY=($(compgen -W "$dirs" "$cur"));;
            "deploy"|"check")
                # shellcheck disable=SC1117
                dirs=$(find -L  ~/playbooks/"$prev"/host_vars ~/playbooks/"$prev"/group_vars -maxdepth 1 -mindepth 1 -type d -printf "%f\n");
                # shellcheck disable=SC2207
                COMPREPLY=($(compgen -W "$dirs" "$cur"));;
            "show-defaults")
                # shellcheck disable=SC1117
                dirs=$(find -L  ~/playbooks/"$prev"/ansible_collections/*/*/roles ~/playbooks/"$prev"/roles -maxdepth 1 -mindepth 1 -type d -printf "%f\n" 2>/dev/null);
                # shellcheck disable=SC2207
                COMPREPLY=($(compgen -W "$dirs" "$cur"));;
        esac
    fi
}

complete -F _xsrv_completion xsrv
