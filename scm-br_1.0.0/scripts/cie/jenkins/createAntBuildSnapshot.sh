#!/bin/bash

if [[ -z ${3} ]]; then
	echo "Need to pass in (project name) (project root) (lod)."
	exit 1
else
	PROJECT_NAME=${1}
	PROJECT_ROOT=${2}
	LOD=${3}
fi

ssh cvbuild@10.13.18.168 "bash -c \"source ~/.bash_profile && cd /opt/build/scm/scripts/buildServer/groovy/bin && ./createAntBuildSnapshot.sh ${PROJECT_NAME} ${PROJECT_ROOT} ${LOD} \" "
#ssh pzimmerman@192.168.211.24 "bash -c \"source ~/.bash_profile && source ~/bin/wp.sh && cd /opt/build/scm/scripts/buildServer/groovy/bin && ./createWebPortalRelease.sh ${PROJECT} ${LOD} \" "
STATUS=${?}
exit ${STATUS}
