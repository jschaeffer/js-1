#!/bin/bash

passPhrase="build"

today=$(date +"%m-%d-%Y")
sonarBackupDir="/opt/tools/sonar/dumps"

pushd ${sonarBackupDir} > /dev/null

echo "
spawn /bin/bash
send \"mysqldump -u root -p sonar\r\"
expect \"password:\"
send \"${passPhrase}\r\"
expect \"$ \"
" | expect > sonar_dump_${today}.sql

STATUS=${?}
if [[ ${STATUS} != 0 ]]; then
    echo "ERROR: there was a problem creating the dump of the sonar mysql database."
    exit ${STATUS}
fi
echo "SUCCESS: sonar mysql database was backed up successfully!"

# prune old dump files
find . -mtime +2 | grep sonar_dump | xargs rm

STATUS=${?}
if [[ ${STATUS} != 0 ]]; then
    echo "ERROR: there was a problem removing the old sonar mysql dump files."
    exit ${STATUS}
fi
echo "Successfully removed old sonar mysql dump files."
popd
