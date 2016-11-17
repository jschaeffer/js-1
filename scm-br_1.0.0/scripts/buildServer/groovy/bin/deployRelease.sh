#!/bin/bash

if [[ ${#} < "3" ]]; then
    echo "Invalid number of arguments."
    echo "Syntax:"
    echo "${0} (project to deploy) (snapshot release to deploy) (environment to deploy to)"
    echo "Example:"
    echo "${0} alph_asset_mgr 1.2.0_4 [dev, cie, local, qa, stage, prod ] (/opt/checkouts/)"
    exit 1
fi

PROJECT=${1}
SNAPSHOT=${2}
ENVIRONMENT=${3}
PROJECT_ROOT=""

if [[ ${#} == "4" ]]; then
    PROJECT_ROOT=${4}
fi

RELATIVE_BASEDIR=$( dirname ${0} )
pushd ${RELATIVE_BASEDIR} >/dev/null
BASEDIR=$( pwd )
popd >/dev/null
pushd ${BASEDIR}/.. >/dev/null
echo "BASEDIR = ${BASEDIR}"

PATH_TO_PROJECT="/opt/checkouts"

COMMAND="${BASEDIR}/eval.sh groovy ${BASEDIR}/../scm.groovy \
        -c DeployRelease \
        --log_level=debug \
        --project=${PROJECT} \
        --path_to_project=${PATH_TO_PROJECT} \
        --release_tars_dir=/opt/build/releaseTars \
        --snapshot=${SNAPSHOT} \
        --project_root=${PROJECT_ROOT} \
        --env=${ENVIRONMENT} \
        ${OPTIONS}"

echo "COMMAND = ${COMMAND}"

if [[ ${LOGLEVEL} == "DEBUG" ]]; then
    echo "COMMAND: \"${COMMAND}\""
fi
${COMMAND}
status=${?}
popd >/dev/null
exit ${status}


