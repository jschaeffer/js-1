#!/bin/bash

tagName=${1}
projectDir=${2}

pathToProject="/opt/checkouts"
passPhrase="Dltdbgyd1"
#passPhrase="myP@55w0rd"
echo "Tag name = ${tagName}"

pushd ${pathToProject}/${projectDir} > /dev/null

expect - << EndCmd
spawn git tag -F RELNOTES.txt -s ${tagName}
expect passphrase:
send ${passPhrase}\r
expect closed
EndCmd

git tag -l | grep ${tagName}
STATUS=${?}
if [[ ${STATUS} != 0 ]]; then
    echo "ERROR: there was a problem creating the signed tag for tag name: ${tagName}"
fi
echo "SUCCESS: created signed tag for tag name: ${tagName}"
popd
