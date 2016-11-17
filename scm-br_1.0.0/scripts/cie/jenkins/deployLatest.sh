#!/bin/bash

if [[ -z ${3} ]]; then
	echo "Need to pass in (project) (environment) (project root)."
	exit 1
else
	PROJECT=${1}
	ENVIRONMENT=${2}
    PROJECT_ROOT=${3}
fi

ssh cvbuild@10.13.18.168 "bash -c \"source ~/.bash_profile && cd /opt/build/scm/scripts/buildServer/groovy/bin && ./deployLatest.sh ${PROJECT} ${ENVIRONMENT} ${PROJECT_ROOT} \" "
#ssh pzimmerman@192.168.211.35 "bash -c \"source ~/.bash_profile && cd /opt/build/scm/scripts/buildServer/groovy/bin && ./deployDaiEngineLatest.sh ${PROJECT} ${ENVIRONMENT} ${PROJECT_ROOT} \" "
STATUS=${?}
exit ${STATUS}
