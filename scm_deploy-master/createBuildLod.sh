#!/bin/bash

if [[ ${#} != "3" ]]; then
    echo "Invalid number of arguments."
    echo "Syntax:"
    echo "${0} (Module location in git) (existing LOD name) (new LOD name)"
    echo "Example:"
    echo "${0} project br_1.0.0 br_1.1.0"
    exit 1
else
   PROJECT=${1}
   LOD_SRC=${2}
   LOD_NEW=${3}
fi

ssh cvbuild@cvbuild.cv.infra "bash -c \"source ~/.bash_profile && cd /opt/build/scm/scripts/buildServer/groovy/bin && ./createBuildLod.sh ${PROJECT} ${LOD_SRC} ${LOD_NEW} \" "
STATUS=${?}
exit ${STATUS}



