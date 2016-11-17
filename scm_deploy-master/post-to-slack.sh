#!/bin/bash -x
export ToURL="https://hooks.slack.com/services/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"
export channel="#scm"

#export postCmd="curl -X POST --data-urlencode 'payload={"channel": "#scm", "username": "SCMUpdMgr", "text": "4th post to #scm.", "icon_emoji": ":loudspeaker:"}' ${ToURL}"

`curl -X POST --data-urlencode 'payload={"channel": "#scm", "username": "SCMUpdMgr", "text": "4th post to #scm.", "icon_emoji": ":loudspeaker:"}' ${ToURL}`

