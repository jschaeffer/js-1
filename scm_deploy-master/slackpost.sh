#!/bin/bash -x

export Component="Dynamic-Ad-Insertion-cm"
export Version="5.14.0_11"
export DeployTarg="devint"
export DeployUser="jschaeffer"
export ToURL='https://hooks.slack.com/services/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'
`curl -X POST --data-urlencode 'payload={"channel": "#scm", "username": "SCMUpdMgr", "text": "'${Component}' at version '${VERSION}' deployed to '${DeployTarg}' by '${DeployUser}'\n-URL for console output: <http://cvbuild.cv.infra:7001/job/'${JOB_NAME}'/'${BUILD_NUMBER}'/console|here>", "icon_emoji": ":mega:"}' https://hooks.slack.com/services/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`


#!/bin/bash

# Usage: slackpost "<webhook_url>" "<channel>" "<username>" "<message>"

# ------------
webhook_url=$1
if [[ $webhook_url == "" ]]
then
        echo "No webhook_url specified"
        exit 1
fi

# ------------
shift
channel=$1
if [[ $channel == "" ]]
then
        echo "No channel specified"
        exit 1
fi

# ------------
shift
username=$1
if [[ $username == "" ]]
then
        echo "No username specified"
        exit 1
fi

# ------------
shift

text=$*

if [[ $text == "" ]]
then
        echo "No text specified"
        exit 1
fi

escapedText=$(echo $text | sed 's/"/\"/g' | sed "s/'/\'/g" )

json="{\"channel\": \"$channel\", \"username\":\"$username\", \"icon_emoji\":\"ghost\", \"attachments\":[{\"color\":\"danger\" , \"text\": \"$escapedText\"}]}"

curl -s -d "payload=$json" "$webhook_url"
