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
case $1 in
dev)
  MACHINES="10.13.1.34"
  DS="jdbc\:oracle\:thin\:\@10\.13\.1\.60\:1524\:caasdbd3"
  PASSCODE="09" ;;
int)
  MACHINES="10.13.1.50"
  DS="jdbc\:oracle\:thin\:\@10\.13\.1\.60\:1526\:caasdbt2"
  PASSCODE="09" ;;
int2)
  MACHINES="10.13.1.161"
  DS="jdbc\:oracle\:thin\:\@10\.13\.1\.62\:1523\:caasdbd4"
  PASSCODE="09" ;;
iqa)
  MACHINES="app01iqa"
  DS="jdbc\:oracle\:thin\:\@10\.13\.1\.60\:1525\:caasdbt1"
  PASSCODE="09" ;;
den-demo)
  MACHINES="10.13.16.161"
  DS="jdbc\:oracle\:thin\:\@10\.13\.18\.60\:1523\:caasdbt4"
  PASSCODE="105" ;;
den-qa)
  MACHINES="10.13.16.141"
  DS="jdbc\:oracle\:thin\:\@10\.13\.20\.67\:1522\:caasit01"
  PASSCODE="105" ;;
stage)
  MACHINES="10.13.16.151"
  DS="jdbc\:oracle\:thin\:\@10\.13\.19\.60\:1522\:caasdbt3"
  PASSCODE="105" ;;
prod)
  MACHINES="10.13.16.51"
  DS="jdbc\:oracle\:thin\:\@10\.13\.17\.60\:1522\:caasdbp1"
  PASSCODE="105" ;;
*)
  echo "You must declare a remote environment."
  exit 0 ;;
esac

mkdir $WRKDIR
cd $WRKDIR
cp -p "$HUDSON_HOME/jobs/$CAAS_JOB/lastSuccessful/archive/target/Canoe.war" ./
#cp -p "$HUDSON_HOME/jobs/$CAAS_JOB/workspace/target/Canoe.war" ./
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

cp $HUDSON_HOME/jobs/$CAAS_JOB/workspace/config/$1/run-jboss.sh bin
cp $HUDSON_HOME/jobs/$CAAS_JOB/workspace/config/properties-service.xml server/default/deploy
cp $HUDSON_HOME/jobs/$CAAS_JOB/workspace/config/$1/oracle-ds.xml server/default/deploy
sed "s/-CONN-URL-/${DS}/" $HUDSON_HOME/jobs/$CAASWS_JOB/workspace/source-ds.xml > temp-ds.xml
sed "s/-PASS-CODE-/${PASSCODE}/" temp-ds.xml > server/default/deploy/caasws-ds.xml
rm temp-ds.xml
mv ../Canoe.war server/default/deploy
mv ../caasws.war server/default/deploy
cd server/default/deploy
md5sum Canoe.war > Canoe.war.md5
md5sum caasws.war > caasws.war.md5
cd ../../../
cp $HUDSON_HOME/jobs/$CAAS_JOB/workspace/lib/ojdbc14.jar server/default/lib
cp $HUDSON_HOME/jobs/$CAAS_JOB/workspace/config/$1/caas.properties  $serverDefaultProps

#Copy the environment specific crowd configuration file to the external location
crowdPropFile="$HUDSON_HOME/jobs/$CAAS_JOB/workspace/config/$1/crowd.properties"
crowdEhCache="$HUDSON_HOME/jobs/$CAAS_JOB/workspace/config/$1/crowd-ehcache.xml"
cp -f $crowdPropFile $serverDefaultProps
cp -f $crowdEhCache $serverDefaultProps

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
sed -e "s/-CONN-URL-/${DS}/" -e "s/-PASS-CODE-/${PASSCODE}/" $HUDSON_HOME/jobs/$CAAS_BATCH_JOB/workspace/smsi.source > smsi.conf
cp $HUDSON_HOME/jobs/$CAAS_BATCH_JOB/workspace/smsi.sh ./
cp $HUDSON_HOME/jobs/$CAAS_BATCH_JOB/workspace/caas_batch.properties ./
zip -u ./$ARCHIVE.zip smsi.sh
zip -u ./$ARCHIVE.zip smsi.conf
zip -u ./$ARCHIVE.zip caas_batch.properties
rm smsi.conf
rm smsi.sh
rm caas_batch.properties
mkdir "$CAAS_JOB"
mv caas.jar ./"$CAAS_JOB"/
rm -Rf stage
mv $ARCHIVE.zip ./"$CAAS_JOB"/
tar -cvzf $CAAS_JOB.tar.gz $CAAS_JOB
rm -rf ./$CAAS_JOB
#scp ../install.sh jboss@${MACHINES}:./
#scp ../install.pl jboss@${MACHINES}:./
#scp $CAAS_JOB.tar.gz jboss@${MACHINES}:./
#ssh jboss@${MACHINES} "/bin/sh install.sh $CAAS_JOB.tar.gz start nobackup novalidate"
mv $CAAS_JOB.tar.gz ../
cd ../
rm -rf $WRKDIR
echo "Complete";
