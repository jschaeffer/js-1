#!/bin/bash

set -x

if [[ ${#} != "2" ]]; then
    echo "Invalid number of arguments."
    echo "Syntax:"
    echo "${0} (group name) (archive name)"
    echo "Example:"
    echo "${0} com.canoeventures.dai core-model"
    exit 1
fi

IVY_DIR=${IVY_CACHE}
GROUP=${1}
ARCHIVE=${2}

if [ -d "${IVY_DIR}" ]; then
    # remove archive from ivy cache
    rm -rf ${IVY_DIR}/${GROUP}/${ARCHIVE}
fi
