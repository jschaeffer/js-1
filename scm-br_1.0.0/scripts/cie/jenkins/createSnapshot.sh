#!/bin/bash

if [[ -z ${4} ]]; then
	echo "Need to pass in (project name) (project root) (lod) (build_number)."
	exit 1
else
	PROJECT_NAME=${1}
	PROJECT_ROOT=${2}
	LOD=${3}
        BUILD_NUMBER=${4}
fi

ssh cvbuild@10.13.18.168 "bash -c \"source ~/.bash_profile && cd /opt/build/scm/scripts/buildServer/groovy/bin && ./createSnapshot.sh ${PROJECT_NAME} ${PROJECT_ROOT} ${LOD} ${BUILD_NUMBER} \" "
STATUS=${?}
exit ${STATUS}
