#!/bin/ksh 

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

##############
# Execute a command. Do not fail on exit.
##############
executeCommandNoFailNoPrint() {

    if [ ${VERBOSE} -eq 1 ] ; then
        print Executing : $1
    fi

    RESULT=`eval "$1"`
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
  -w   Required. Webapps directory name. ex ads-1.2.0
  -v   Verbose
EOF
}

######################################################################
#                       Main script
######################################################################

VERBOSE=${VERBOSE-0}

while getopts "ha:t:r:w:e:j:k:l:m:n:v" OPTION
do
    case $OPTION in
      a)
        export APP=${OPTARG}
        ;;
      t)
        export TAR=${OPTARG}
        ;;
      h)
        usage
        exit 1
        ;;
      r)
        export VERSION=${OPTARG}
        ;;
      w)
        export WEBAPPS=${OPTARG}
        ;;
      e)
        export APPSERVER_IP=${OPTARG}
        ;;
      j)
        export JarDirect=${OPTARG}
        ;;
      k)
        export JarName1=${OPTARG}
        ;;
      l)
        export JarName2=${OPTARG}
        ;;
      m)
        export JarLoc1=${OPTARG}
        ;;
      n)
        export JarLoc2=${OPTARG}
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


export APP_INSTALLED="/opt/tcserver"
export APP_HOME="${APP_INSTALLED}/${JarDirect}"
export WORKING_DIR="${APP_INSTALLED}/App_Files"

       if [[ ${APP} = "dai-cip" ]]; then
         executeCommand "cd ${APP_HOME}${JarLoc1}; tar -xvf ${WORKING_DIR}/${TAR}_${VERSION}.tar ${JarName1}.jar"
         executeCommand "cd ${APP_HOME}${JarLoc2}; tar -xvf ${WORKING_DIR}/${TAR}_${VERSION}.tar ${JarName2}.jar"
       else
         executeCommand "cd ${APP_HOME}; tar -xvf ${WORKING_DIR}/${TAR}_${VERSION}.tar ${JarName1}.jar"
       fi

echo "---------------------------------------------------------------------------------"
echo "[Jar Date/Time]"; ls -alR ${APP_HOME} | grep .jar ; echo ""
exit
