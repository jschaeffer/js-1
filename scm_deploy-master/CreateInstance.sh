#!/bin/bash 


#############
# Usage message
#############
usage() {
    cat << EOF
usage: $0 options

This script deploys an application to a specified environment.

OPTIONS:
  -h   Show this message
  -c   Required. Instance name. ex. Some_Application
  -s   Required.  Target deployment Suite. ex. Scrum1
  -t   Required for L2L/perf. Target Location. ex. somehost-cluster2.
  -a   Required for L2L/perf. Application name for war file. ex. sm_app
  -p   Optional. Ability to use specific port if desired. ex. 9600
  -v   Verbose
EOF
}

######################################################################
#                       Main script
######################################################################

VERBOSE=${VERBOSE-0}

while getopts "hc:c:t:s:a:p:v" OPTION
do
    case $OPTION in
      c)
        export Instance=${OPTARG}
        ;;
      h)
        usage
        exit 1
        ;;
      t)
        export DeployTarg=${OPTARG}
        ;;
      s)
        export Suite=${OPTARG}
        ;;
      p)
        export PortNum=${OPTARG}
        ;;
      a)
        export App=${OPTARG}
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
if [ -z ${Instance} -o -z ${Suite} ] ; then
    usage
    exit 1
fi
if [ ${Suite} = "Lab-To-Lab" ] || [ ${Suite} = "Performance" ]; then
  if [ -z ${DeployTarg} -o -z ${App} ]; then
    usage
    exit 1
  fi
fi

echo "Gathering System Info"
if [[ $Suite = "Lab-To-Lab" ]]; then
  source /opt/build/scripts/zayos_sys_L2L.sh
elif [[ $Suite = "Performance" ]]; then
  source /opt/build/scripts/zayos_sys_Perf.sh
elif [[ $Suite = scrum* ]] || [[ $Suite = "devint" ]]; then
  DeployTarg="${Suite}"
  source /opt/build/scripts/ZayoSCMSysVars.sh
  DeployTarg="${targname}"
  #This is idiotic. I'll clean it up.
fi

echo "Instance=${Instance}"
echo "App=${App}"
echo "Suite=${Suite}"
echo "DeployTarg=${DeployTarg}"
echo "targname = ${targname}"
echo "PortNum=${PortNum}"

#########################################
###   PORT NUMBER CHECKING SECTION.   ###
#########################################

echo "Checking port numbers"

#If a specific port is given checks to ensure that port is available on the target system. All cases.
if [[ -n $PortNum ]]; then
  echo "Checking supplied Port number ${PortNum}."
  PortChk=`ssh tcserver@$DeployTarg "grep -R ${PortNum} instances/*/conf/catalina.properties"`
  if [[ -n $PortChk ]]; then
    echo "Specified port number already in use on target system!"
    exit 1
  fi
#If the creation is on scrum/devint (Redundant?) ichecks to ensure that the specified port number matches the port number of any existing indentical app on devint (Vulnerable to misspellings).
  if [[ $Suite = "devint" ]] || [[ $Suite = scrum* ]]; then
    DevintPort=`ssh tcserver@cv-devint.cv.scrum "grep bio.http.port instances/$Instance/conf/catalina.properties | cut -d = -f 2 | tr -d ' '  | tr -d '\r'"`
    if [[ -n $DevintPort ]] && [[ $PortNum != $DevintPort ]]; then
      echo "Inconsistent port numbers!"
      echo "Port number of existing app on Devint = ${DevintPort} vs Supplied port = ${PortNum}!"
      exit 1
    fi
  fi
  echo "Specified port number available."
fi
#If a port is not specified and the creation is taking place on devint/scrum it gathers one from an existing app on devint, then cross checks the gathered port number from devint to ensure it's not in use on the target system.
if [[ $Suite = "devint" ]] || [[ $Suite = scrum* ]]; then
  if [[ -z $PortNum ]]; then
    echo "Gathering Port Number from devint"
    PortNum=`ssh tcserver@cv-devint.cv.scrum "grep bio.http.port instances/$Instance/conf/catalina.properties | cut -d = -f 2 | tr -d ' '  | tr -d '\r'"`
    PortChk=`ssh tcserver@$DeployTarg "grep -R ${PortNum} instances/*/conf/catalina.properties"`
    if [[ -n $PortChk ]]; then
      echo "Port number gathered from devint already in use on target system!"
      exit 1
    fi
  fi
fi
#If a port number is not provided goes out to target location and searches for an available port.
  if [[ -z $PortNum ]]; then
    echo "No Port Number on Devint to refrence. Searching for available port"
    PortNum="9600"
    PortChk="something"
    while [[ -n $PortChk ]]; do
      if [[ $Suite = "devint" ]] || [[ $Suite = scrum* ]]; then
        PortNum=$((PortNum-10))
      elif [[ $Suite = "Lab-To-Lab" ]] || [[ $Suite = "Performance" ]]; then
        PortNum=$((PortNum+10))
      fi
      PortChk=`ssh tcserver@$DeployTarg "grep -R ${PortNum} instances/*/conf/catalina.properties"`
      if [[ $PortNum -lt "9300" ]] || [[ $PortNum -gt "9900" ]]; then
        echo "Passed port number threshold. This error message should be virtually impossible."
        exit
      fi
    done
  fi
echo "Available Port Number found!"
echo "Port Number = ${PortNum}"

#########################################
###   INSTANCE   CREATION  SECTION.   ###
#########################################

echo "Creating instance ${Instance} on ${PortNum}."
  ssh tcserver@$DeployTarg "sh create-instance.s $Instance $PortNum base"

echo "Instance created."

#########################################
###    POST CREATION EDITS SECTION.   ###
#########################################

echo "Editing catalina.properties"
#Sets port adjustment variable to base creation port number (9600) minus the port number used for creation then creats variables to adjust the other ports to be in line with the used port number.
((PortAdj = 9600 - $PortNum))
((jmx = 6969 - $PortAdj ))
((https = 8443 - $PortAdj ))
((ajp = 8009 - $PortAdj ))

#Uses the variables just created to replace the improper version numbers.
ssh tcserver@$DeployTarg "sed -i -e 's/6969/$jmx/g' instances/$Instance/conf/catalina.properties"
ssh tcserver@$DeployTarg "sed -i -e 's/8443/$https/g' instances/$Instance/conf/catalina.properties"
ssh tcserver@$DeployTarg "sed -i -e 's/8009/$ajp/g' instances/$Instance/conf/catalina.properties"

#Additional steps for l2l and perf.
if [[ $Suite = "Lab-To-Lab" || $Suite = "Performance" ]]; then

  echo "Creating war directory for Lab-To-Lab/Performance."
  ssh tcserver@$DeployTarg "cd instances/$Instance; mkdir war"

  echo "Editing server.xml"
  ssh tcserver@$DeployTarg "sed -i '40i                 <Context path=\"/${Instance}\" docBase=\"../war/${App}.war\" />' instances/$Instance/conf/server.xml"
  echo "Adjusting privileges for war directory."
  ssh tcserver@$DeployTarg "chmod +x instances/$Instance/war"
fi

#Give access to logs/war directories

echo "Adjusting privileges for logs directory."
ssh tcserver@$DeployTarg "chmod +x instances/$Instance/logs"
