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

ssh cvbuild@10.13.18.168 "bash -c \"source ~/.bash_profile && cd /opt/build/scm/scripts/buildServer/groovy/bin && ./deployRelease.sh ${PROJECT} ${SNAPSHOT} ${ENVIRONMENT} ${PROJECT_ROOT} \" "
#ssh pzimmerman@192.168.211.35 "bash -c \"source ~/.bash_profile && cd /opt/build/scm/scripts/buildServer/groovy/bin && ./deployDaiEngineLatest.sh ${PROJECT} ${ENVIRONMENT} ${PROJECT_ROOT} \" "
STATUS=${?}
exit ${STATUS}
