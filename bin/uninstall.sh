#!/usr/bin/env bash
# Encoding : UTF-8
# SFT module UNinstall Database script.
# WARNING : all DATA and structure will be removed.
#
# Documentation : https://github.com/PnX-SI/gn_module_suivi_flore_territoire
set -eo pipefail

# DESC: Usage help
# ARGS: None
# OUTS: None
function printScriptUsage() {
    cat << EOF
Usage: ./$(basename $BASH_SOURCE) [options]
     -h | --help: display this help
     -v | --verbose: display more infos
     -x | --debug: display debug script infos
     -c | --config: path to config file to use (default : config/settings.ini)
EOF
    exit 0
}

# DESC: Parameter parser
# ARGS: $@ (optional): Arguments provided to the script
# OUTS: Variables indicating command-line parameters and options
function parseScriptOptions() {
    # Transform long options to short ones
    for arg in "${@}"; do
        shift
        case "${arg}" in
            "--help") set -- "${@}" "-h" ;;
            "--verbose") set -- "${@}" "-v" ;;
            "--debug") set -- "${@}" "-x" ;;
            "--config") set -- "${@}" "-c" ;;
            "--"*) exitScript "ERROR : parameter '${arg}' invalid ! Use -h option to know more." 1 ;;
            *) set -- "${@}" "${arg}"
        esac
    done

    while getopts "hvxc:" option; do
        case "${option}" in
            "h") printScriptUsage ;;
            "v") readonly verbose=true ;;
            "x") readonly debug=true; set -x ;;
            "c") setting_file_path="${OPTARG}" ;;
            *) exitScript "ERROR : parameter invalid ! Use -h option to know more." 1 ;;
        esac
    done
}

# DESC: Main control flow
# ARGS: $@ (optional): Arguments provided to the script
# OUTS: None
function main() {
    #+----------------------------------------------------------------------------------------------------------+
    # Load utils
    source "$(dirname "${BASH_SOURCE[0]}")/utils.bash"

    #+----------------------------------------------------------------------------------------------------------+
    # Init script
    initScript "${@}"
    parseScriptOptions "${@}"
    loadScriptConfig "${setting_file_path-}"
    redirectOutput "${uninstall_log}"

    checkSuperuser
    commands=("psql")
    checkBinary "${commands[@]}"

    #+----------------------------------------------------------------------------------------------------------+
    # Start script
    printInfo "Module UNinstall DB script started at: ${fmt_time_start}"

    #+----------------------------------------------------------------------------------------------------------+
    printPretty "${Red}ALL data, tables and schema will be destroy. Are you sure to uninstall ${module_code^^} module? ('Y' or 'N')"
    read -r reply
    echo # Move to a new line
    if [[ ! "${reply}" =~ ^[Yy]$ ]];then
        [[ "${0}" = "${BASH_SOURCE}" ]] && exit 1 || return 1 # handle exits from shell or function but don't exit interactive shell
    fi

    #+----------------------------------------------------------------------------------------------------------+
    printMsg "Delete module schema and all data linked from GeoNature database"
    export PGPASSWORD="${user_pg_pass}"; \
        psql -h "${db_host}" -U "${user_pg}" -d "${db_name}" \
            -v moduleSchema="${module_schema}" \
            -v moduleCode="${module_code}" \
            -f "${data_dir}/uninstall.sql"

    #+----------------------------------------------------------------------------------------------------------+
    printMsg "Remove GeoNature external link to this module"
    local gn_config_dir="${geonature_settings_path%/*}"
    local gn_dir="${gn_config_dir%/*}"
    local gn_el_dir="${gn_dir}/external_modules"
    cd "${gn_el_dir}"
    rm -f "${module_code}"

    #+----------------------------------------------------------------------------------------------------------+
    printMsg "Update GeoNature Frontend: tsconfig.app.json, app/tsconfig.app.json and config"
    cd "${gn_dir}/backend"
    . venv/bin/activate
    geonature generate_frontend_tsconfig
    geonature generate_frontend_tsconfig_app
    geonature generate_frontend_modules_route
    geonature generate_frontend_config --build=false
    printPretty "${Blink}${Red}WARNING: ${RCol}${Whi} If mode='production', you must rebuild GeoNature to apply change !${RCol}"
    
    #+----------------------------------------------------------------------------------------------------------+
    displayTimeElapsed
}

main "${@}"
