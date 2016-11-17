#!/bin/bash

if [[ -z ${2} ]]; then
	echo "Need to pass in required parameters: (tcServer host) (tcServer instance name) (start|stop|status)."
	exit 1
else
    hostEnv="${1}"
    action="${2}"
fi

ssh cvbuild@10.13.18.168 "bash -c \"source ~/.bash_profile && cd /opt/build/scm/scripts/buildServer/groovy/bin && ./roottcServerAdmin.sh ${hostEnv} ${action} \" "
#ssh pzimmerman@192.168.211.24 "bash -c \"source ~/.bash_profile && source ~/bin/wp.sh && cd /opt/build/scm/scripts/buildServer/groovy/bin && ./createWebPortalRelease.sh ${PROJECT} ${LOD} \" "
STATUS=${?}
exit ${STATUS}
