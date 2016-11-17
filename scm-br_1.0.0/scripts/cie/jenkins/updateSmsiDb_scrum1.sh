#!/bin/bash

if [[ -z ${1} ]]; then
	echo "Need to pass in (local workspace)."
	exit 1
else
	LOCAL_WORKSPACE=${1}
fi

ssh cvbuild@10.13.18.168 "bash -c \"source ~/.bash_profile && cd /opt/build/scm/scripts/buildServer/groovy/bin && ./updateSmsiDb_scrum1.sh ${LOCAL_WORKSPACE} \" "
#ssh pzimmerman@192.168.211.24 "bash -c \"source ~/.bash_profile && source ~/bin/wp.sh && cd /opt/build/scm/scripts/buildServer/groovy/bin && ./createWebPortalRelease.sh ${PROJECT} ${LOD} \" "
STATUS=${?}
exit ${STATUS}
