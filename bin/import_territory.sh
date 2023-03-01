#!/usr/bin/env bash
# Encoding : UTF-8
# CS import territories script.
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
    redirectOutput "${territory_import_log}"

    checkSuperuser
    commands=("psql" "csvtool")
    checkBinary "${commands[@]}"

    #+----------------------------------------------------------------------------------------------------------+
    # Start script
    printInfo "Territories import script started at: ${fmt_time_start}"

    if [[ -n ${verbose-} ]]; then
        readonly psql_verbosity="${psql_verbose_opts-}"
    else
        readonly psql_verbosity="${psql_quiet_opts-}"
        readonly tasks_count="$(($(csvtool height "${territory_csv_path}") - 1))"
        tasks_done=0
    fi

    if [[ "${action}" = "import" ]]; then
        importTerritories
    elif [[ "${action}" = "delete" ]]; then
        deleteTerritories
    fi

    #+----------------------------------------------------------------------------------------------------------+
    # Show time elapsed
    displayTimeElapsed
}

function importTerritories() {
    printMsg "Import territories list into « ${module_schema}.t_territory »"

    local head="$(csvtool -t TAB -u TAB head 1 "${territory_csv_path}")"
    stdbuf -oL csvtool drop 1 "${territory_csv_path}"  |
        while IFS= read -r line; do
            local label="$(printf "${head}\n${line}" | csvtool -t TAB namedcol label - | sed 1d | sed -e 's/^"//' -e 's/"$//')"
            local code="$(printf "${head}\n${line}" | csvtool -t TAB namedcol code - | sed 1d | sed -e 's/^"//' -e 's/"$//')"
            local area_type="$(printf "${head}\n${line}" | csvtool -t TAB namedcol area_type - | sed 1d | sed -e 's/^"//' -e 's/"$//')"
            local code_parent="$(printf "${head}\n${line}" | csvtool -t TAB namedcol code_parent - | sed 1d | sed -e 's/^"//' -e 's/"$//')"
            local surface="$(printf "${head}\n${line}" | csvtool -t TAB namedcol surface - | sed 1d | sed -e 's/^"//' -e 's/"$//')"
            local meshes_total="$(printf "${head}\n${line}" | csvtool -t TAB namedcol meshes_total - | sed 1d | sed -e 's/^"//' -e 's/"$//')"

            printVerbose "Inserting territory: '${label}' (${code})"
            export PGPASSWORD="${user_pg_pass}"; \
                psql -h "${db_host}" -U "${user_pg}" -d "${db_name}" ${psql_verbosity-} \
                    -v label="${label}" \
                    -v code="${code}" \
                    -v areaType="${area_type}" \
                    -v codeParent="${code_parent}" \
                    -v surface="${surface}" \
                    -v meshesTotal="${meshes_total}" \
                    -v moduleSchema="${module_schema}" \
                    -f "${data_dir}/territory_import.sql"

            if ! [[ -n ${verbose-} ]]; then
                (( tasks_done += 1 ))
                displayProgressBar ${tasks_count} ${tasks_done} "inserting"
            fi
        done
    echo
}

function deleteTerritories() {
    printMsg "Delete territories listed in CSV file from  « ${module_schema}.t_territory »"

    local head="$(csvtool -t TAB -u TAB head 1 "${territory_csv_path}")"
    stdbuf -oL csvtool drop 1 "${territory_csv_path}"  |
        while IFS= read -r line; do
            local label="$(printf "${head}\n${line}" | csvtool -t TAB namedcol label - | sed 1d | sed -e 's/^"//' -e 's/"$//')"
            local code="$(printf "${head}\n${line}" | csvtool -t TAB namedcol code - | sed 1d | sed -e 's/^"//' -e 's/"$//')"

            printVerbose "Deleting territory: '${code}' (${label})"
            export PGPASSWORD="${user_pg_pass}"; \
            psql -h "${db_host}" -U "${user_pg}" -d "${db_name}" ${psql_verbosity-} \
                -v code="${code}" \
                -v moduleSchema="${module_schema}" \
                -f "${data_dir}/territory_delete.sql"

            if ! [[ -n ${verbose-} ]]; then
                (( tasks_done += 1 ))
                displayProgressBar ${tasks_count} ${tasks_done} "deleting"
            fi
        done
    echo
}

main "${@}"
