#!/bin/bash

set -x

if [[ ${#} != "1" ]]; then
    echo "Invalid number of arguments."
    echo "Syntax:"
    echo "${0} (project name)"
    echo "Example:"
    echo "${0} alphyn_etvs_mgr-compile"
    exit 1
fi

PROJECT=${1}

# remove alph-cdm-model plugin from grails cache
rm -rf ~/.grails/1.3.7/projects/${PROJECT}/alph-cdm-model*

# remove alph-cdm-model plugin from ivy cache
#rm -rf ~/.ivy2/cache/org.grails.plugins/alph-cdm-model

