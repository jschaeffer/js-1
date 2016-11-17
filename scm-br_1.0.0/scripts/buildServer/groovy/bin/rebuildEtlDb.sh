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

#  BAR_SCHEMA_NAME

mvn -Pdb2 clean liquibase:update -DCAMPAIGN_SCHEMA_NAME=DI_CORE -DBAR_SCHEMA_NAME=DI_OSS_BAR -Djdbc.url=jdbc:oracle:thin:@10.13.18.111:1522:dev003 -Djdbc.adminuser=cm_system -Djdbc.adminpass=oracle123 -Dmigrate.prompt.remote=false -Djdbc.username=DI_REPORTING_ODS -Djdbc.password=DI_REPORTING_ODS -Djdbc.schema=DI_REPORTING_ODS

STATUS=${?}

popd >/dev/null

exit ${STATUS}
