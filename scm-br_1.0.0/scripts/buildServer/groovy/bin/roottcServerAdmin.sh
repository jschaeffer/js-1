#!/bin/bash

if [[ ${#} != "2" ]]; then
    echo "Invalid number of arguments."
    echo "Syntax:"
    echo "${0} (remote tcserver host) (start|stop|status)"
    echo "Example:"
    echo "${0} dvappdai01 stop"
    exit 1
fi

tcserverHostEnv="${1}"
tcserverAction="${2}"

tcserverBase="/opt/tcserver/vfabric-tc-server-standard-2.6.4.RELEASE"
tcserverAdminScript="tcruntime-ctl.sh"
instCmd="sudo /sbin/service tcserver"

tcserverCmd="${instCmd} ${tcserverAction}"
echo "tcserverCmd = ${tcserverCmd}"

ssh tcserver@${tcserverHostEnv} "bash -c \"$tcserverCmd\""
