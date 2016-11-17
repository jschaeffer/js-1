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

BuildNo=`more $HUDSON_HOME/jobs/$CAAS_JOB/next* | awk '{print "_"--$1}'`
CAAS_Pkg=$CAAS_JOB$BuildNo
echo "####### Creating CAAS Package for $CAAS_Pkg #########"
tar -cvzf $CAAS_Pkg.tar.gz $CAAS_JOB
rm -rf ./$CAAS_JOB
if [ ! -e "$RELTAR/$CAAS_Pkg" ]; then
    mkdir $RELTAR/$CAAS_Pkg
    cp $CAAS_Pkg.tar.gz /tmp
    cp $CAAS_Pkg.tar.gz $RELTAR/$CAAS_Pkg
    cp /opt/build/scm/caas/install.pl $RELTAR/$CAAS_Pkg
    cp $HUDSON_HOME/jobs/$CAAS_JOB/workspace/deploy.txt $RELTAR/$CAAS_Pkg
fi
cd ../
rm -rf $WRKDIR
echo "Complete";
echo "Moved package to CM staging area";
echo "$RELTAR/$CAAS_Pkg";
ls -al $RELTAR/$CAAS_Pkg
echo "If no package there, check to ensure the right versions are being called.  Using  prior version id for CAAS will fail to move a package";
