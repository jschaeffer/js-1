#!/bin/bash

if [[ ${#} != "4" ]]; then
    echo "Invalid number of arguments."
    echo "Syntax:"
    echo "${0} (local git workspace)"
    echo "Example:"
    echo "${0} dai_etl 1.0.0_01 Dynamic-Ad-Insertion-core 2.1.0_02"
    exit 1
fi

PROJECT_WORKSPACE=${1}
echo "Project workarea = ${0} ${1} ${2} ${3} ${4}"

# --------------------------------------------------------------------------------------
# Core Update
# --------------------------------------------------------------------------------------

# cd to directory where we want to run the CreateDaiDb command for Core using liquibase
# pushd ${PROJECT_WORKSPACE}/core/model >/dev/null

pushd /opt/build/releaseTars/${3}/

# Extract the 'update' liquibase changelogs 
tar -xvf ${3}_${4}.tar --wildcards '*full*.sql'

# Run the mvn update command to update the Core DB
# mvn -Pdb clean -Djdbc.drop=true liquibase:update -Djdbc.url=jdbc:oracle:thin:@10.13.18.66:1521:dev002 -Djdbc.adminuser=dai -Djdbc.adminpass=secret -Dmigrate.prompt.remote=false


# --------------------------------------------------------------------------------------
# ETL Update
# --------------------------------------------------------------------------------------

# cd to directory where we want to run the CreateDaiDb command for ETL using liquibase

pushd /opt/build/releaseTars/${1}/

# Extract the 'update' liquibase changelogs
echo "tar -xvf ${1}_${2}.tar --wildcards \'*full*.sql\'"

# Run the mvn update command to update the ETL DB
# mvn -Pdb clean -Djdbc.drop=true liquibase:update -Djdbc.url=jdbc:oracle:thin:@10.13.18.66:1521:dev002 -Djdbc.adminuser=dai -Djdbc. adminpass=secret -Dmigrate.prompt.remote=false


STATUS=${?}

popd >/dev/null
echo "${0}"

exit ${STATUS}

