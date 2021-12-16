#!/usr/bin/env bash
# Encoding : UTF-8
# CS import priority taxa script.
set -eo pipefail

# DESC: Usage help
# ARGS: None
# OUTS: None
function printScriptUsage() {
    cat << EOF
Usage: ./$(basename $BASH_SOURCE) [options]

     -h | --help: display this help
     -v | --verbose: display more information on what script is doing
     -x | --debug: enable Bash mode debug
     -c | --config: path to config file to use (default : config/settings.ini)
     -d | --delete: delete all imported territories
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
            "--delete") set -- "${@}" "-d" ;;
            "--"*) exitScript "ERROR : parameter '${arg}' invalid ! Use -h option to know more." 1 ;;
            *) set -- "${@}" "${arg}"
        esac
    done

    while getopts "hvxdc:" option; do
        case "${option}" in
            "h") printScriptUsage ;;
            "v") readonly verbose=true ;;
            "x") readonly debug=true; set -x ;;
            "c") setting_file_path="${OPTARG}" ;;
            "d") action="delete" ;;
            *) exitScript "ERROR : parameter invalid ! Use -h option to know more." 1 ;;
        esac
    done
}

# DESC: Main control flow
# ARGS: $@ (optional): Arguments provided to the script
# OUTS: None
function main() {
    #+----------------------------------------------------------------------------------------------------------+
    # Define global constants and variables
    action="import"

    #+----------------------------------------------------------------------------------------------------------+
    # Load utils
    source "$(dirname "${BASH_SOURCE[0]}")/utils.bash"

    #+----------------------------------------------------------------------------------------------------------+
    # Init script
    initScript "${@}"
    parseScriptOptions "${@}"
    loadScriptConfig "${setting_file_path-}"
    redirectOutput "${taxons_import_log}"

    checkSuperuser
    commands=("psql" "csvtool")
    checkBinary "${commands[@]}"

    #+----------------------------------------------------------------------------------------------------------+
    # Start script
    printInfo "Prority taxa import script started at: ${fmt_time_start}"

    if [[ -n ${verbose-} ]]; then
        readonly psql_verbosity="${psql_verbose_opts-}"
    else
        readonly psql_verbosity="${psql_quiet_opts-}"
        readonly tasks_count="$(($(csvtool height "${taxa_csv_path}") - 1))"
        tasks_done=0
    fi

    copyTaxa
    if [[ "${action}" = "import" ]]; then
        importTaxa
    elif [[ "${action}" = "delete" ]]; then
        deleteTaxa
    fi

    #+----------------------------------------------------------------------------------------------------------+
    # Show time elapsed
    displayTimeElapsed
}

function copyTaxa() {
    printMsg "Import taxa list into « ${module_schema}.${taxa_table_temp} »"
    header_line=$(head -n1 "${taxa_csv_path}")
    csv_columns="${header_line//$'\t'/, }"
        sed "s/\${columns}/${csv_columns}/g" "${data_dir}/taxa_copy.sql" | \
        sudo -n -u "${pg_admin_name}" -s \
        psql -d "${db_name}" ${psql_verbosity-} \
            -v moduleSchema="${module_schema}" \
            -v tmpTable="${taxa_table_temp}" \
            -v gnDbOwner="${user_pg}" \
            -v csvFilePath="${taxa_csv_path}" \
            -f -
}

function importTaxa() {
    printMsg "Insert taxa list into « ${module_schema}.t_priority_taxon »"
    export PGPASSWORD="${user_pg_pass}"; \
        psql -h "${db_host}" -U "${user_pg}" -d "${db_name}" ${psql_verbosity-} \
            -v moduleSchema="${module_schema}" \
            -v tmpTable="${taxa_table_temp}" \
            -f "${data_dir}/taxa_insert.sql"
}

function deleteTaxa() {
    printMsg "Delete taxa listed in CSV file from  « ${module_schema}.t_priority_taxon »"
    export PGPASSWORD="${user_pg_pass}"; \
        psql -h "${db_host}" -U "${user_pg}" -d "${db_name}" ${psql_verbosity-} \
            -v moduleSchema="${module_schema}" \
            -v tmpTable="${taxa_table_temp}" \
            -f "${data_dir}/taxa_delete.sql"
}

main "${@}"
