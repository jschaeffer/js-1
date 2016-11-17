#!/bin/bash

if [[ ${#} != "3" ]]; then
    echo "Invalid number of arguments."
    echo "Syntax:"
    echo "${0} (remote tcserver host) (remote tcserver instance name) (start|stop|status)"
    echo "Example:"
    echo "${0} dvappdai01 dai_dev stop"
    exit 1
fi

tcserverHostEnv="${1}"
tcserverInstanceName="${2}"
tcserverAction="${3}"

tcserverBase="/opt/tcserver/vfabric-tc-server-standard-2.9.5.RELEASE"
tcserverAdminScript="tcruntime-ctl.sh"

tcserverCmd="${tcserverBase}/${tcserverAdminScript} ${tcserverInstanceName} ${tcserverAction}"
echo "tcserverCmd = ${tcserverCmd}"

ssh tcserver@${tcserverHostEnv} "bash -c \"$tcserverCmd\""
