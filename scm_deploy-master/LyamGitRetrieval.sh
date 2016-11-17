#!/bin/bash

#A script to push local repos back up to a git hub repository.

#############
# Usage message
#############
usage() {
    cat << EOF
usage: $0 options

This script deploys an application to a specified environment.

OPTIONS:
  -h   Show this message
  -n   Required. Application Name. ex. ads-core
  -b   Required.  Application Branch. ex. 4.0.0 or master
  -v   Verbose
EOF
}

######################################################################
#                       Main script
######################################################################

VERBOSE=${VERBOSE-0}

while getopts "hn:b:v" OPTION
do
    case $OPTION in
      h)
        usage
        exit 1
        ;;
      n)
        export GitName=${OPTARG}
        ;;
      b)
        export GitBranch=${OPTARG}
        ;;
      v)
        VERBOSE=1
        ;;
      ?)
        usage
        exit
        ;;
    esac
done

# Ensure required parameters are entered
if [ -z ${GitName} -o -z ${GitBranch} ] ; then
    usage
    exit 1
fi


cd /opt/checkouts/${GitName}

if [[ $GitBranch = "master" ]]; then
  git checkout master
else
  git checkout br_${GitBranch}
fi

git add .
#git remote add origin git@github.com:CanoeVentures/${GitBranch}.git
git push origin

exit 0
