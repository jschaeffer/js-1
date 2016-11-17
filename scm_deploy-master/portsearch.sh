#!/bin/ksh

#Lyam Hassell:/09/26/14
#Short script used to search all application port numbers and send them to a list

#LH: 07/07/16
#Two years ago lyam was lazy, weak, cowardly, and inept. He wrote inferior scripting. Present Lyam is bolstering this badboy the F up. ALL HAIL FUTURE LYAM!
#Hope to have it read each specific type of portnum into a set of seperate arrays, cut them down to component name and number only, read them to portNum.txt, the sort to find duplicates. requires additional sciencing
#DO NOT USE THIS SCRIPT. It ain't workin yet and you will get mountains of errors and potentially a really really big .txt file filled with junk.

cd /opt/tcserver/instances
applist=`ls`

 for i in $applist; do
  echo "*********************" >> portNum.txt
  echo "$i" >> portNum.txt
  echo "*********************" >> portNum.txt
  tail $i/conf/catalina.properties >> portNum.txt
  sed -i /xml-apis.jar/d portNum.txt
  sed -i /xmlParserAPIs.jar/d portNum.txt
  sed -i /xpp3_min/d portNum.txt
  sed -i /xstream-/d portNum.txt
  sed -i /zipfs.jar/d portNum.txt
  sed -i /base.shutdown.port/d portNum.txt
 done

k=0
for i in $applist; do
  tail -5 $i/conf/catalina.properties > PortTmp.txt
  Num=`sed -i /base.jmx.port=/d PortTmp.txt`
  JMX="${i}${Num}"
  JMXar[$k]=$JMX
  #echo $JMX >> JMXNum.txt
  Num=`sed -i /bio.http.port=/d PortTmp.txt`
  HTTP="${i}${Num}"
  HTTPar[$k]=$HTTP
  #echo $HTTP >> HTTPNum.txt
  Num=`sed -i /bio.https.port=/d PortTmp.txt`
  HTTPS="${i}${Num}"
  HTTPSar[$k]=$HTTPS
  #echo $HTTPS >> HTTPSNum.txt
  Num=`sed -i /ajp.http.port=/d PortTmp.txt`
  AJP="${i}${Num}"
  AJPar[$k]=$AJP
  #echo $AJP >> AJPNum.txt
  k=$((k+1))
done

echo "*********BASE JMX*********" >> PortNum.txt
for k in $JMXar; do
echo $JMXar[$k] >> PortNum.txt
k=$((k+1))
done
echo "*********BASE HTTP*********" >> PortNum.txt
for k in $HTTPar; do
echo $HTTPar[$k] >> PortNum.txt
k=$((k+1))
done
echo "*********BASE HTTPS*********" >> PortNum.txt
for k in $HTTPSar; do
echo $HTTPSar[$k] >> PortNum.txt
k=$((k+1))
done
echo "*********BASE AJP*********" >> PortNum.txt
for k in $AJPar; do
echo $AJPar[$k] >> PortNum.txt
k=$((k+1))
done
