#!/bin/bash

if [[ -z ${2} ]]; then
	echo "Need to pass in (project) (lod)."
	exit 1
else
	PROJECT=${1}
	LOD=${2}
fi

ssh cvbuild@10.13.18.168 "bash -c \"source ~/.bash_profile && cd /opt/build/scm/scripts/buildServer/groovy/bin && ./getLatestRelease.sh ${PROJECT} ${LOD} \" "
#ssh pzimmerman@192.168.211.24 "bash -c \"source ~/.bash_profile && source ~/bin/wp.sh && cd /opt/build/scm/scripts/buildServer/groovy/bin && ./createWebPortalRelease.sh ${PROJECT} ${LOD} \" "
STATUS=${?}
exit ${STATUS}
