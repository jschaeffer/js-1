#!/bin/bash

# Examples of command line params

if [[ ${#} != "1" ]]; then
    echo "Invalid number of arguments."
    echo "Syntax:"
    echo "${0} (workspace)"
    echo "Example:"
    echo "${0} /opt/cie/jenkins/jobs/canoe-ux-compile-0.3.4/workspace"
    exit 1
fi

PROJECT_WORKSPACE=${1}
echo "Project workspace = ${PROJECT_WORKSPACE}"

pushd ${PROJECT_WORKSPACE} >/dev/null

# check to see if the version setting has SNAPSHOT or not
versionString=$( cat *.groovy | grep "version =" | awk -F"=" ' { print $2 } ' | tr -d '"' | tr -d ' ' )
#echo "version = ${versionString}"

echo "${versionString}" | grep SNAPSHOT >/dev/null
if [[ ${?} == 1 ]]; then # SNAPSHOT is not in name, therefore this is a release build and we should create a tag based on the version
    echo "This is a release version without the -SNAPSHOT suffix, so we will create a tag in git...."
    # get the numeric portion of version string
    git tag ${versionString}
    git push origin ${versionString} 
fi

popd >/dev/null
