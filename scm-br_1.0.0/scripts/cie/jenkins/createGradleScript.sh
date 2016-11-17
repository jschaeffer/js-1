#! /bin/bash

APP_WORKSPACE=${1}
# get the grails app name
pushd ${APP_WORKSPACE} >/dev/null
GRAILS_APP_NAME=$( cat application.properties | awk -F "=" ' $1 == "app.name" { print $2 } ' )
GRAILS_APP_VERSION=$( cat *.groovy | grep "def version" | awk -F "\"" ' { print $2 } ' )

if [[ -f "build.gradle.tokenized" ]]; then
    cp build.gradle.tokenized build.gradle
    /bin/ex - +%s/\%grails.app.version\%/${GRAILS_APP_VERSION}/\|x build.gradle
    /bin/ex - +%s/\%grails.app.name\%/${GRAILS_APP_NAME}/\|x build.gradle
fi
popd >/dev/null
