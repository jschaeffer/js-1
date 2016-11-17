#!/bin/bash

JENKINS_WAR=/opt/cie/jenkins.war
JENKINS_LOG=/opt/cie/jenkins.log
cat /dev/null > ${JENKINS_LOG}
export JAVA_HOME=/opt/tools/jdk1.8.0_20
export PATH=${JAVA_HOME}/bin:${PATH}

nohup java -Xms512M -Xmx1596M -Dhudson.diyChunking=false -jar ${JENKINS_WAR} --httpPort=7001 --ajp13Port=9009 >${JENKINS_LOG} 2>&1 &
#nohup java -jar ${JENKINS_WAR} --httpPort=7001 --ajp13Port=9009 >${JENKINS_LOG} 2>&1 &



