#!/bin/bash -x

#./RelComp.sh $Component $vVersion $pVersion $Metadata $BUILD_TAG
cd /opt/checkouts/${Component}
git pull
pwd

if [[ -z $pVersion ]]; then
# export pVersion=$PriorVersion
  git tag -l > aTag.txt  #Send git versions to list
  grep ^r_* aTag.txt | sed -e 's/r_//g' > bTag.txt #send all r_ versions to list and remove r_
  sort -t. -k 1,1n -k 2,2n -k 3,3n -k 4,4n bTag.txt > cTag.txt #sort to ensure major version are ordered
  Ver=`cat cTag.txt | tail -1` #set Ver to be the bottom (Highest) majro version we have
  cat cTag.txt 
  echo "$Ver" > dTag.txt #set Ver to be the only entry in dTag
  cut -d'_' -f1 dTag.txt #this isn't need anymore will test and remove
  MajVer=`cat dTag.txt | cut -d'_' -f1` #set the major version as variable and remove minor version
  grep ^"$MajVer"* bTag.txt > eTag.txt #grep for all entries within primary listing with highest MajorVer LSAH 1/13/25
  sort -n -r eTag.txt 
  PriorVersion=`cat eTag.txt | head -1`
  cat eTag.txt
  echo "$PriorVersion"
  rm aTag.txt
  rm bTag.txt
  rm fTag.txt
else
  #JWS Next line to be used only where the sort routine isn't working properly
  #JWS For those situations, comment out the above PriorVersion var and uncomment the following one.  Identify the pVersion in
  #JWS the Jenkins GenRelease job
  PriorVersion=${pVersion}
  echo "$PriorVersion"
fi

echo "*********$PriorVersion********"

echo "<u>Scrum Metadata :</u>&nbsp<b>&nbsp<pre><font face="verdana" size="2">${Metadata}</b></font></pre>" >> /opt/build/scm/scripts/buildServer/log/${BUILD_TAG}.log
echo "#### Scrum Metadata : ${Metadata}" >> /tmp/$vVersion.txt

######################################
# diff section

#Create Bucket files (Will be burnt at the end)
touch ConChg.txt
touch DBChg.txt

#Setup directories for delivery
mkdir /var/www/html/confloc/${Component}_${vVersion}
#mkdir /var/www/html/confloc/${Component}_${vVersion}/config

#Runs the diff command, searches for only scrum related changes and pipes them to bucket locations
export confchgs=`git diff --name-only v_${PriorVersion}..${vVersion} | grep scrum`
if [[ -z $confchgs ]]; then echo "&nbsp- No Config Changes<br>" >> /opt/build/scm/scripts/buildServer/log/${BUILD_TAG}.log; else echo "&nbsp- Conf chgs<br>" >>/opt/build/scm/scripts/buildServer/log/${BUILD_TAG}.log; echo "$confchgs" | tee ConChg.txt; 
for i in `cat ConChg.txt`;do
  echo "&nbsp&nbsp&nbsp<a href=confloc/${Component}_${vVersion}/diff.txt>${Component}_${vVersion}/$i.txt</a><br>" >> /opt/build/scm/scripts/buildServer/log/${BUILD_TAG}.log
  git diff v_${PriorVersion}..${vVersion} $i >> /var/www/html/confloc/${Component}_${vVersion}/diff.txt
done
fi
echo "<p>" >> /opt/build/scm/scripts/buildServer/log/${BUILD_TAG}.log
export dbchgs=`git diff --name-only v_${PriorVersion}..${vVersion} | grep liquibase`
if [[ -z $dbchgs ]]; then echo "&nbsp- No DB Changes <br>" >> /opt/build/scm/scripts/buildServer/log/${BUILD_TAG}.log; else echo "&nbsp- DB chgs<pre>$dbchgs</pre>" >> /opt/build/scm/scripts/buildServer/log/${BUILD_TAG}.log; fi
echo "<p>" >> /opt/build/scm/scripts/buildServer/log/${BUILD_TAG}.log
#Clean up. Destroys buckets 
rm ConChg.txt
rm DBChg.txt

#######################################
echo "<u>Commit summaries since last version :</u> <b>$PriorVersion</b></u><br>" >> /opt/build/scm/scripts/buildServer/log/${BUILD_TAG}.log
echo "#### Commit summaries since last version : $vVersion" >> /tmp/$vVersion.txt

# Working but boring:  git log --graph --pretty=format:'%h -%d %s (%cr) <%an> <br>' --abbrev-commit ${pVersion}..${vVersion} >> /opt/build/scm/scripts/buildServer/log/${BUILD_TAG}.log

echo "<pre>" >> /opt/build/scm/scripts/buildServer/log/${BUILD_TAG}.log

git log --graph --abbrev-commit --decorate --format=format:'<font color=blue>%h</font>-<font color=green>(%ad)</font><font color=black><b>%s</b></font><font color=grey>- (%an)</font><font color=red>%d</font>' --date=short v_${PriorVersion}..${vVersion} >> /opt/build/scm/scripts/buildServer/log/${BUILD_TAG}.log

git log --graph --pretty=format:'%h %ad %d %s (%an)' --abbrev-commit --date=short v_${PriorVersion}..${vVersion} >>/tmp/$vVersion.txt

echo "</pre>" >> /opt/build/scm/scripts/buildServer/log/${BUILD_TAG}.log
echo "<hr>" >> /opt/build/scm/scripts/buildServer/log/${BUILD_TAG}.log

echo "<p>" >> /opt/build/scm/scripts/buildServer/log/${BUILD_TAG}.log

if [ $Tag = "Yes" ] ; then
    echo "Tagging Release r_${Version}"
   git tag -a r_${Version} ${vVersion} -m"Release tag.  See the SCM Site for content"
   git push origin r_${Version}
fi

exit
