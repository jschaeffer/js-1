#!/bin/bash

export WRKDIR=$$
export HUDSON_HOME='/opt/cie/jenkins'
export CAAS_JOB='CAAS'$2
export CAASWS_JOB='CAASWS'$3
export CAAS_BATCH_JOB='CAASBATCH'$4
echo "Using CAAS_JOB $CAAS_JOB"
echo "Using CAASWS_JOB $CAASWS_JOB"
echo "Using CAASBATCH_JOB $CAAS_BATCH_JOB"
if [ ! -e "$HUDSON_HOME/jobs/$CAAS_JOB" ]; then
    echo "Unknown project $CAAS_JOB"
    exit -1
fi

#Dev config
export MACHINES="10.13.18.50"
export DS="jdbc\:oracle\:thin\:\@10\.13\.18\.67\:1522\:caasit02"
export PASSCODE="09"

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
scp ../install.sh jboss@${MACHINES}:./
scp ../install.pl jboss@${MACHINES}:./
scp $CAAS_JOB.tar.gz jboss@${MACHINES}:./
ssh jboss@${MACHINES} "/bin/sh kill_jboss.sh"
ssh jboss@${MACHINES} "/bin/sh install.sh $CAAS_JOB.tar.gz start nobackup novalidate"
rm $CAAS_JOB.tar.gz
cd ../
rm -rf $WRKDIR
echo "Complete";
