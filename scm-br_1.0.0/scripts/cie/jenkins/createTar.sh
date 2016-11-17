#!/bin/bash

if [[ -z ${2} ]]; then
	echo "Need to pass in (project name)(lod)."
	exit 1
else
	PROJECT_NAME=${1}
	LOD=${2}
fi

ssh cvbuild@10.13.18.168 "bash -c \"source ~/.bash_profile && cd /opt/build/scm/scripts/buildServer/groovy/bin && ./createTar.sh ${PROJECT_NAME} ${LOD}\" "
STATUS=${?}
exit ${STATUS}
