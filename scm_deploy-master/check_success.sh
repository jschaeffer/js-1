#!/bin/sh
#set the vars

#Obfuscation.
fnObfuscate() {

echo "cd /opt/cie/jenkins/jobs/${JOB_NAME}/builds/${BUILD_NUMBER}"
export DB_USER=lyam

cd /opt/cie/jenkins/jobs/${JOB_NAME}/builds/${BUILD_NUMBER}

sed -i "s/--username=${DB_USER}/--username=XXXXX/g" log
#sed -i "s/--password=${DB_PASS}/--password=XXXXX/g" log
}

#jobname="/opt/cie/jenkins/jobs/dai_scm-PackageDeploy-4.0.0/builds/103/log"
JOB_NAME=$1
BUILD_NUMBER=$2
#while :;do
#	chkcomp=`grep "Finished: SUCCESS"  /opt/cie/jenkins/jobs/${JOB_NAME}/builds/${BUILD_NUMBER}/log` 
#	if [ -z "$chkcomp" ]; then
#           echo "not done"
#	else echo $chkcomp 
           fnObfuscate
#	fi
#done
