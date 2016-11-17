#!/bin/bash

JENKINS_WAR=/opt/cie/jenkins.war
JENKINS_LOG=/opt/cie/jenkins.log
cat /dev/null > ${JENKINS_LOG}
export JAVA_HOME=/opt/tools/jre1.6.0_24
export PATH=${JAVA_HOME}/bin:${PATH}

nohup java -jar ${JENKINS_WAR} --httpPort=7001 >${JENKINS_LOG} 2>&1 &
