#!/bin/bash

if [[ ${#} != "1" ]]; then
    echo "Invalid number of arguments."
    echo "Syntax:"
    echo "${0} (local git workspace)"
    echo "Example:"
    echo "${0} Dynamic-Ad-Insertion-core"
    exit 1
fi

PROJECT_WORKSPACE=${1}
echo "Project workspace = ${PROJECT_WORKSPACE}"

# cd to directory where we want to run the rebuildDb command for liquibase
pushd ${PROJECT_WORKSPACE} >/dev/null

grails -DOSS_BAR_CONFIG=/opt/cvbuild/config/oss_bar/devint_oss_bar_config.properties dbm-drop-all 

grails -DOSS_BAR_CONFIG=/opt/cvbuild/config/oss_bar/devint_oss_bar_config.properties dbm-update

STATUS=${?}

popd >/dev/null

exit ${STATUS}
