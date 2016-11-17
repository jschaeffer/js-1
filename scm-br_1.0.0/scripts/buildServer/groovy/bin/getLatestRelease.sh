#!/bin/bash

# get latest snapshot for a given lod of a given project

if [[ ${#} != "2" ]]; then
    echo "Invalid number of arguments."
    echo "Syntax:"
    echo "${0} (Module name in git) (LOD name)"
    echo "Example:"
    echo "${0} webportal br_1.0.0"
    exit 1
fi

PROJECT=${1}
LOD=${2}

RELATIVE_BASEDIR=$( dirname ${0} )
pushd ${RELATIVE_BASEDIR} >/dev/null
BASEDIR=$( pwd )
popd >/dev/null
pushd ${BASEDIR}/.. >/dev/null
echo "BASEDIR = ${BASEDIR}"

OPTIONS="${OPTIONS} ${DEFAULT_OPTIONS}"
echo "after options declaration"

PATH_TO_PROJECT="/opt/checkouts"

COMMAND="${BASEDIR}/eval.sh groovy ${BASEDIR}/../scm.groovy \
        -c GetLatestRelease \
        --log_level=debug \
        --lod=${LOD} \
        --project=${PROJECT} \
        --path_to_project=${PATH_TO_PROJECT} \
        ${OPTIONS}"

echo "COMMAND = ${COMMAND}"

if [[ ${LOGLEVEL} == "DEBUG" ]]; then
    echo "COMMAND: \"${COMMAND}\""
fi

${COMMAND}
status=${?}
popd >/dev/null
exit ${status}
