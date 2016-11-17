#!/bin/bash

if [[ ${#} != "3" ]]; then
    echo "Invalid number of arguments."
    echo "Syntax:"
    echo "${0} (project to deploy) (environment to deploy to) (project root)"
    echo "Example:"
    echo "${0} alph_asset_mgr [dev, cie, local, qa, stage, prod ] /opt/cie/jenkins/jobs/jobName/workspace"
    exit 1
fi

PROJECT=${1}
ENVIRONMENT=${2}
PROJECT_ROOT=${3}

RELATIVE_BASEDIR=$( dirname ${0} )
pushd ${RELATIVE_BASEDIR} >/dev/null
BASEDIR=$( pwd )
popd >/dev/null
pushd ${BASEDIR}/.. >/dev/null
echo "BASEDIR = ${BASEDIR}"

PATH_TO_PROJECT="/opt/checkouts"

COMMAND="${BASEDIR}/eval.sh groovy ${BASEDIR}/../scm.groovy \
        -c DeployLatestRelease \
        --log_level=debug \
        --project=${PROJECT} \
        --path_to_project=${PATH_TO_PROJECT} \
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


