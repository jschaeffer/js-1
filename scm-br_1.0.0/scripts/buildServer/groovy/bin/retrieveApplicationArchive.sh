#!/bin/bash

##############
# Execute a command and exit on failure.
##############
executeCommand() {
    
    if [ ${VERBOSE} -eq 1 ] ; then
        echo "Executing : $1"
    fi
    
    eval $1
    
    if [ $? -ne 0 ] ; then
        echo "ERROR: Error executing $1"
        exit 1
    fi
}

#############
# Usage message
#############
usage() {
    cat << EOF
usage: $0 options

This script retrieves an application archive and explodes it in the working directory.

OPTIONS:
  -h   Show this message
  -a   Required. Application name. ex. oss_bar
  -r   Required. Application version. ex. 2.0.0_2
  -v   Verbose
EOF
}

######################################################################
#                       Main script
######################################################################

VERBOSE=${VERBOSE-0}

while getopts "a:t:hr:s:v" OPTION
do
    case $OPTION in
      a)
        APP=${OPTARG}
        ;;
      t)
        TAR=${OPTARG}
        ;;
      h)
        usage
        exit 1
        ;;
      r)
        VERSION=${OPTARG}
        ;;
      s)
        TARGENV=${OPTARG}
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
if [ -z ${APP} -o -z ${TAR} -o -z ${VERSION} ] ; then
    usage
    exit 1
fi

#WORKING_DIR=${WORKING_DIR-"/tmp/deploymentWorkArea"}
export WORKING_DIR=${WORKING_DIR-"/tmp/deploymentWorkArea/${TAR}/${VERSION}"}

# Initialize the working directory.
if [ -d ${WORKING_DIR} ] ; then
  executeCommand "rm -rf ${WORKING_DIR}"
fi
executeCommand "mkdir -p ${WORKING_DIR}"
executeCommand "cd ${WORKING_DIR}"
echo "TARGENV = ${TARGENV}"

# Retrieve the application archive
ARCHIVE="${TAR}_${VERSION}.tar"
executeCommand "curl http://cvbuild.cv.infra/releaseTars/${TAR}/${ARCHIVE} > ${ARCHIVE}"

# Explode the archive
executeCommand "tar xf ${ARCHIVE}"

#for base in *${TARGENV}*; do new=`echo $base | sed 's/.devint//g'`; cp $base /tmp/$new; ls -al /tmp/$new; done
#echo "for base in *${TARGENV}*; do new=`echo $base | sed 's/.devint//g'`; export new; cp $base $new; done"

exit 0
