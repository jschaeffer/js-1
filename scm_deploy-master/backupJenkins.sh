#!/bin/bash

ls /opt/cie/jenkins/*.xml /opt/cie/jenkins/*/*.xml /opt/cie/jenkins/*/*/*.xml > jenkins.backup.files
echo "/opt/cie/bin" >> jenkins.backup.files

tar -cvf /var/tmp/jenkins-cie-backup.tar -T jenkins.backup.files

cp /var/tmp/jenkins-cie-backup.tar /opt/cie/canoeRepoJenkinsBackup/jenkins-cie-backup.tar

cd /opt/cie/canoeRepoJenkinsBackup
cp ~/.bash_profile .
cp ~/.profile .
cp ~/.bashrc .
cp ~/.m2/settings.xml .

tar -xf jenkins-cie-backup.tar
git add .
git commit -m"Daily backup of Jenkins config"
git push origin

# at some point we may want to check this tar into git
