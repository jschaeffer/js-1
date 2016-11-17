#!/bin/bash

# Examples of command line params

if [[ ${#} != "3" ]]; then
    echo "Invalid number of arguments."
    echo "Syntax:"
    echo "${0} (Module location in git) (existing LOD name) (new LOD name)"
    echo "Example:"
    echo "${0} webportal br_1.0.0 br_1.1.0"
    exit 1
fi

PROJECT=${1}
LOD_SRC=${2}
LOD_NEW=${3}

RELATIVE_BASEDIR=$( dirname ${0} )
pushd ${RELATIVE_BASEDIR} >/dev/null
BASEDIR=$( pwd )
popd >/dev/null
pushd ${BASEDIR}/.. >/dev/null
echo "BASEDIR = ${BASEDIR}"

#java -version >/dev/null 2>&1
#JAVA_STATUS=${?}
#if [[ ${JAVA_STATUS} != "0" ]]; then
#    echo "Please load a project-specific profile, by typing either wp or sa"
#    exit 1
#fi

OPTIONS="${OPTIONS} ${DEFAULT_OPTIONS}"
echo "after options declaration"

PATH_TO_PROJECT="/opt/checkouts"

COMMAND="${BASEDIR}/eval.sh groovy ${BASEDIR}/../scm.groovy \
        -c CreateLodCie \
        --log_level=INFO \
        --lod_src=${LOD_SRC} \
        --lod_new=${LOD_NEW} \
        --project=${PROJECT} \
        --path_to_project=${PATH_TO_PROJECT}
        ${OPTIONS}"

echo "COMMAND = ${COMMAND}"

if [[ ${LOGLEVEL} == "DEBUG" ]]; then
    echo "COMMAND: \"${COMMAND}\""
fi
${COMMAND}
status=${?}
popd >/dev/null
exit ${status}
