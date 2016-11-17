#!/bin/bash

# Examples of command line params

if [[ ${#} != "3" ]]; then
    echo "Invalid number of arguments."
    echo "Syntax:"
    echo "${0} (git project name) (git project root) (LOD name)"
    echo "Examples:"
    echo "${0} alph_asset_mgr alph_asset_mgr br_1.0.0"
    echo "${0} Dynamic-Ad-Insertion-cm campaign-management br_1.0.0"
    exit 1
fi

PROJECT_NAME=${1}
PROJECT_ROOT=${2}
LOD=${3}

if [[ ${PROJECT_NAME} == ${PROJECT_ROOT} ]]; then
    PROJECT=${PROJECT_NAME}
else
    PROJECT="${PROJECT_NAME}/${PROJECT_ROOT}"
fi

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
        -c CreateAntBuildSnapshot \
        --log_level=debug \
        --lod=${LOD} \
        --project=${PROJECT} \
        --path_to_project=${PATH_TO_PROJECT}
        --build_args='grails clean -non-interactive,grails war -non-interactive' \
        --release_tars_dir=/opt/build/releaseTars \
        --release_tar_name=${PROJECT_NAME} \
        ${OPTIONS}"

echo "COMMAND = ${COMMAND}"

if [[ ${LOGLEVEL} == "DEBUG" ]]; then
    echo "COMMAND: \"${COMMAND}\""
fi
${COMMAND}
status=${?}
popd >/dev/null
exit ${status}
