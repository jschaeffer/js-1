#!/bin/bash

if [[ ${#} != "1" ]]; then
    echo "Invalid number of arguments."
    echo "Syntax:"
    echo "${0} (local git workspace)"
    echo "Example:"
    echo "${0} smsi"
    exit 1
fi

PROJECT_WORKSPACE=${1}
echo "Project workspace = ${PROJECT_WORKSPACE}"

# cd to directory where we want to run the rebuildDb command for liquibase
pushd ${PROJECT_WORKSPACE}/cip-server >/dev/null

mvn -Pdb -Djdbc.drop=true liquibase:update -Djdbc.url=jdbc:oracle:thin:@10.13.18.111:1522:dev003 -Djdbc.adminuser=cm_system -Djdbc.adminpass=oracle123 -Dmigrate.prompt.remote=false -Djdbc.username=DI_CIP -Djdbc.password=DI_CIP -Djdbc.schema=DI_CIP

STATUS=${?}

popd >/dev/null

exit ${STATUS}
