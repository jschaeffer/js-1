#!/bin/bash

export WRKDIR=$$
export HUDSON_HOME='/opt/cie/jenkins'
export RELTAR='/opt/build/releaseTars/caas'
export CAAS_JOB='CAAS'$1
export CAASWS_JOB='CAASWS'$2
export CAAS_BATCH_JOB='CAASBATCH'$3
echo "Using CAAS_JOB $CAAS_JOB"
echo "Using CAASWS_JOB $CAASWS_JOB"
echo "Using CAASBATCH_JOB $CAAS_BATCH_JOB"
if [ ! -e "$HUDSON_HOME/jobs/$CAAS_JOB" ]; then
echo "Unknown project $CAAS_JOB"
    exit -1
fi

mkdir $WRKDIR
cd $WRKDIR
cp -p "$HUDSON_HOME/jobs/$CAAS_JOB/lastSuccessful/archive/target/Canoe.war" ./
if [ -e "$HUDSON_HOME/jobs/$CAAS_JOB/lastSuccessful/archive/target/caas_db.tar.gz" ]; then
cp -p "$HUDSON_HOME/jobs/$CAAS_JOB/lastSuccessful/archive/target/caas_db.tar.gz" ./
fi
cp -p "$HUDSON_HOME/jobs/$CAASWS_JOB/lastSuccessful/archive/build/libs/caasws-forward-1.0.0.war" ./caasws.war
if [ ! -e "Canoe.war" ]; then
echo "Failed to copy artifact Canoe.war. Unrecoverable error...exiting."
        exit -1
fi
if [ ! -e "caasws.war" ]; then
echo "Failed to copy artifact caasws.war. Unrecoverable error...exiting."
        exit -1
fi

mkdir stage
cd stage
mkdir bin
mkdir server
mkdir server/default
mkdir server/default/deploy
mkdir server/default/lib
mkdir server/default/conf

serverDefaultProps="server/default/conf/props"
if [ ! -d $serverDefaultProps ]; then
mkdir -p $serverDefaultProps
fi

mv ../Canoe.war server/default/deploy
mv ../caasws.war server/default/deploy
cd server/default/deploy
md5sum Canoe.war > Canoe.war.md5
md5sum caasws.war > caasws.war.md5
cd ../../../

jar cvfM ../caas.jar *
cd ..
# batch

ARCHIVE="smsi-1.0"
cp -p $HUDSON_HOME/jobs/$CAAS_BATCH_JOB/lastSuccessful/archive/build/distributions/$ARCHIVE.zip ./
if [ ! -e "$ARCHIVE.zip" ]; then
	echo "Failed to copy artifact. Unrecoverable error...exiting."
        exit -1
fi
if [ -e "smsi.conf" ]; then
	rm smsi.conf
fi
mkdir "$CAAS_JOB"
mv caas.jar ./"$CAAS_JOB"/
rm -Rf stage
mv $ARCHIVE.zip ./"$CAAS_JOB"/
tar -cvzf $CAAS_JOB.tar.gz $CAAS_JOB
rm -rf ./$CAAS_JOB

BuildNo=`more $HUDSON_HOME/jobs/$CAAS_JOB/next* | awk '{print "_"--$1}'`
#BuildNo = `cat $HUDSON_HOME/jobs/$CAAS_JOB/nextBuildNumber`
#echo "$BuildNo" 

echo "####### Creating CAAS Package for $1$BuildNo #########"

if [ ! -e "$RELTAR/$1$BuildNo" ]; then
mkdir $RELTAR/$1$BuildNo
    cp $CAAS_JOB.tar.gz $RELTAR/$1$BuildNo
    cp /opt/build/scm/caas/install.pl $RELTAR/$1$BuildNo
    cp $HUDSON_HOME/jobs/$CAAS_JOB/workspace/deploy.txt $RELTAR/$1$BuildNo
    cp $HUDSON_HOME/jobs/$CAAS_JOB/workspace/src/sql/* $RELTAR/$1$BuildNo
fi
cd ../
rm -rf $WRKDIR
echo "Complete";
echo "Moved package to CM staging area";
echo "$RELTAR/$1$BuildNo";
ls -al $RELTAR/$1$BuildNo
echo "If no package there, check to ensure the right versions are being called. Using prior version id for CAAS will fail to move a package";
