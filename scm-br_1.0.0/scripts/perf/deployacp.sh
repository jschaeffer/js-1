#!/bin/ksh -x

##############
# Execute a command and exit on failure.
##############
executeCommand() {
    
    if [ ${VERBOSE} -eq 1 ] ; then
        print Executing : $1
    fi
    
    eval $1
    
    if [ $? -ne 0 ] ; then
        print ERROR: Error executing $1
        exit 1
    fi
}

##############
# Execute a command. Do not fail on exit.
##############
executeCommandNoFail() {

    if [ ${VERBOSE} -eq 1 ] ; then
        print Executing : $1
    fi

    RESULT=`eval "$1"`

    if [ ${VERBOSE} -eq 1 ] ; then
        print Result : $RESULT
    fi
}

#############
# Usage message
#############
usage() {
    cat << EOF
usage: $0 options

This script deploys an application to a specified environment.

OPTIONS:
  -h   Show this message
  -a   Required. Application name. ex. oss_bar
  -t   Required.  Application tar file name
  -r   Required. Application version. ex. 2.0.0_2
  -i   Required.  Instance name to deploy to
  -v   Verbose
EOF
}

######################################################################
#                       Main script
######################################################################

VERBOSE=${VERBOSE-0}

while getopts "ha:t:r:i:s:v" OPTION
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
      i)
        INSTANCE=${OPTARG}
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


echo "APP - $APP"
export DESTBASE="/opt/tcserver/acp"
export WORKING_DIR="/tmp/deploymentWorkArea/${TAR}/${VERSION}"

cd ${WORKING_DIR}/config

REPTARG=".${TARGENV}"
export REPTARG

#for base in *${TARGENV}*; do new=`echo $base | sed 's/'${REPTARG}'//g'`; echo "Renaming $base to $new and copying to ${DESTBASE}/config"; cp $base ${DESTBASE}/config/$new; done

exit 0
