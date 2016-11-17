#!/bin/bash

export targs=$1

for i in $targs; do

case $i in
  devint)
     export envname="devint"
     export targname="dvappdai01"
     echo "Restarting ${targs}" >/tmp/restart.log;;
  scrum1)
     export envname="scrum1"
     export targname="dvappdai02"
     echo "Restarting ${targs}" >/tmp/restart.log;;
  scrum2)
     export envname="scrum2"
     export targname="dvappdai03"
     echo "Restarting ${targs}" >/tmp/restart.log;;
  scrum3)
     export envname="scrum3"
     export targname="dvappdai04"
     echo "Restarting ${targs}" >/tmp/restart.log;;
  scrum4)
     export envname="scrum4"
     export targname="dvappdai05"
     echo "Restarting ${targs}" >/tmp/restart.log;;
  Marley)
     export envname="Marley"
     export targname="itappdai01"
     echo "Restarting ${targs}" >/tmp/restart.log;;
esac
echo `date | awk '{print $1,$2,$3,$4}'`>/var/www/html/$envname/dtupd.txt
for x in $i; do

echo ""
echo ""
echo "configuring targ=$i targname=$targname"
echo ""
echo ""

cd /opt/build/scripts

## Changing to Component and targenv for all pieces

Component="dai-billing"
Version=`ssh tcserver@${targname} "grep Implementation-Version /opt/tcserver/instances/billing/webapps/dai-billing/META-INF/MANIFEST.MF | cut -d : -f 2 | tr -d ' '  | tr -d '\r'"`

if [[ -z "$Version" || ${Version} == *select* ]]; then
echo "Not Present" | tee /var/www/html/$x/$Component.txt
  else
echo "${Version}" | tee /var/www/html/$x/$Component.txt
  fi

Component="Dynamic-Ad-Insertion-cm"
Version=`ssh tcserver@${targname} "grep Implementation-Version /opt/tcserver/instances/cm/webapps/Dynamic-Ad-Insertion-cm*/META-INF/MANIFEST.MF | cut -d : -f 2 | tr -d ' '  | tr -d '\r'"`
if [[ -z "$Version" || ${Version} == *select* ]]; then
echo "Not Present" | tee /var/www/html/$x/$Component.txt
  else
echo "${Version}" | tee /var/www/html/$x/$Component.txt
  fi

Component="Dynamic-Ad-Insertion-engine"
Version=`ssh tcserver@${targname} "grep Implementation-Version /opt/tcserver/instances/ads/webapps/ads*/META-INF/MANIFEST.MF | cut -d : -f 2 | tr -d ' '  | tr -d '\r'"`
if [[ -z "$Version" || ${Version} == *select* ]]; then
echo "Not Present" | tee /var/www/html/$x/$Component.txt
  else
echo "${Version}" | tee /var/www/html/$x/$Component.txt
  fi  
  
Component="dai-cip-feedback"
Version=`ssh tcserver@${targname} "grep Implementation-Version /opt/tcserver/instances/cip/webapps/cip-server*/META-INF/MANIFEST.MF | cut -d : -f 2 | tr -d ' '  | tr -d '\r'"`
if [[ -z "$Version" || ${Version} == *select* ]]; then
echo "Not Present" | tee /var/www/html/$x/$Component.txt 
  else
echo "${Version}" | tee /var/www/html/$x/$Component.txt 
  fi
  
Component="dai-cip"
Version=`ssh tcserver@${targname} "cd /opt/tcserver/dai-cip/cip-batch; jar xf dai-cip-batch.jar META-INF/MANIFEST.MF; grep Implementation-Version META-INF/MANIFEST.MF | cut -d : -f 2 | tr -d ' '  | tr -d '\r'; rm -fR META-INF"`
if [[ -z "$Version" || ${Version} == *select* ]]; then
echo "Not Present" | tee /var/www/html/$x/$Component.txt
  else
echo "${Version}" | tee /var/www/html/$x/$Component.txt
  fi
  
Component="caas-admin"
Version=`ssh tcserver@${targname} "grep Implementation-Version /opt/tcserver/instances/caas-admin/webapps/caas-admin/META-INF/MANIFEST.MF | cut -d : -f 2 | tr -d ' '  | tr -d '\r'"`
if [[ -z "$Version" || ${Version} == *select* ]]; then
echo "Not Present" | tee /var/www/html/$x/$Component.txt
  else
echo "${Version}" | tee /var/www/html/$x/$Component.txt
  fi

Component="dai-lincoln"
Version=`ssh tcserver@${targname} "cd /opt/tcserver/log_splitter; jar xf lincoln-1.2.0.jar META-INF/MANIFEST.MF; grep Implementation-Version META-INF/MANIFEST.MF | cut -d : -f 2 | tr -d ' '  | tr -d '\r'; rm -fR META-INF"`
if [[ -z "$Version" || ${Version} == *select* ]]; then
echo "Not Present" | tee /var/www/html/$x/$i/$Component.txt
  else
echo "${Version}" | tee /var/www/html/$x/$Component.txt
  fi

Component="dai-smsi"
Version=`ssh tcserver@${targname} "grep Implementation-Version /opt/tcserver/instances/smsi/webapps/safi-smsi-server*/META-INF/MANIFEST.MF | cut -d : -f 2 | tr -d ' '  | tr -d '\r'"`
if [[ -z "$Version" || ${Version} == *select* ]]; then
echo "Not Present" | tee /var/www/html/$x/$Component.txt
  else
echo "${Version}" | tee /var/www/html/$x/$Component.txt
  fi

Component="int-test-support"
Version=`ssh tcserver@${targname} "grep Implementation-Version /opt/tcserver/instances/mock_svr/webapps/int-test-support/META-INF/MANIFEST.MF | cut -d : -f 2 | tr -d ' '  | tr -d '\r'"` 
if [[ -z "$Version" || ${Version} == *select* ]]; then
echo "Not Present" | tee /var/www/html/$x/$Component.txt
  else
echo "${Version}" | tee /var/www/html/$x/$Component.txt
  fi

Component="Pgmr-Cpgn-Int"
Version=`ssh tcserver@${targname} "grep Implementation-Version /opt/tcserver/instances/Pgmr-Cpgn-Int/webapps/pci/META-INF/MANIFEST.MF | cut -d : -f 2 | tr -d ' '  | tr -d '\r'"` 
if [[ -z "$Version" || ${Version} == *select* ]]; then
echo "Not Present" | tee /var/www/html/$x/$Component.txt
  else
echo "${Version}" | tee /var/www/html/$x/$Component.txt
  fi
  
Component="ops-dce-scte-cfa-reporting-agent"
Version=`ssh tcserver@${targname} "grep Implementation-Version /opt/tcserver/instances/dce-agent-001/webapps/ops-dce-scte-cfa-reporting-agent/META-INF/MANIFEST.MF | cut -d : -f 2 | tr -d ' '  | tr -d '\r'"`
if [[ -z "$Version" || ${Version} == *select* ]]; then
echo "Not Present" | tee /var/www/html/$x/$Component.txt
  else
echo "${Version}" | tee /var/www/html/$x/$Component.txt
  fi

Component="ops-dce-safi-reporting-agent"
Version=`ssh tcserver@${targname} "grep Implementation-Version /opt/tcserver/instances/dce-agent-002/webapps/ops-dce-safi-reporting-agent/META-INF/MANIFEST.MF | cut -d : -f 2 | tr -d ' '  | tr -d '\r'"`
if [[ -z "$Version" || ${Version} == *select* ]]; then
echo "Not Present" | tee /var/www/html/$x/$Component.txt
  else
echo "${Version}" | tee /var/www/html/$x/$Component.txt
  fi
  
Component="ops-dt"
Version=`ssh tcserver@${targname} "grep Implementation-Version /opt/tcserver/instances/ops-dt/webapps/ops-dt/META-INF/MANIFEST.MF | cut -d : -f 2 | tr -d ' '  | tr -d '\r'"`
if [[ -z "$Version" || ${Version} == *select* ]]; then
echo "Not Present" | tee /var/www/html/$x/$Component.txt
  else
echo "${Version}" | tee /var/www/html/$x/$Component.txt
  fi
            
#oss_bar
Version=`ssh tcserver@${targname} "grep Implementation-Version /opt/tcserver/instances/oss_bar/webapps/oss_bar/META-INF/MANIFEST.MF | cut -d : -f 2 | tr -d ' '  | tr -d '\r'"`
if [[ -z "$Version" || ${Version} == *select* ]]; then
echo "Not Present" | tee /var/www/html/$x/oss_bar.txt
  else
echo "${Version}" | tee /var/www/html/$x/oss_bar.txt
  fi
  
Component="smsi-admin"
Version=`ssh tcserver@${targname} "grep Implementation-Version /opt/tcserver/instances/smsi-admin/webapps/smsi-admin/META-INF/MANIFEST.MF | cut -d : -f 2 | tr -d ' '  | tr -d '\r'"`
if [[ -z "$Version" || ${Version} == *select* ]]; then
echo "Not Present" | tee /var/www/html/$x/$Component.txt
  else
echo "${Version}" | tee /var/www/html/$x/$Component.txt
  fi

Component="dai_amm"
Version=`ssh tcserver@${targname} "grep Implementation-Version /opt/tcserver/instances/dai_amm/webapps/dai_amm*/META-INF/MANIFEST.MF | cut -d : -f 2 | tr -d ' '  | tr -d '\r'"`
if [[ -z "$Version" || ${Version} == *select* ]]; then
echo "Not Present" | tee /var/www/html/$x/$Component.txt
  else
echo "${Version}" | tee /var/www/html/$x/$Component.txt
  fi
  
Component="smsi-publisher"
Version=`ssh tcserver@${targname} "grep Implementation-Version /opt/tcserver/instances/smsipub/webapps/smsi-publisher*/META-INF/MANIFEST.MF | cut -d : -f 2 | tr -d ' '  | tr -d '\r'"`
if [[ -z "$Version" || ${Version} == *select* ]]; then
echo "Not Present" | tee /var/www/html/$x/$Component.txt
  else
echo "${Version}" | tee /var/www/html/$x/$Component.txt
  fi

Component="dai-smsi-relay"
Version=`ssh tcserver@${targname} "grep Implementation-Version /opt/tcserver/instances/dai-smsi-relay/webapps/smsi-relay*/META-INF/MANIFEST.MF | cut -d : -f 2 | tr -d ' '  | tr -d '\r'"`
if [[ -z "$Version" || ${Version} == *select* ]]; then
echo "Not Present" | tee /var/www/html/$x/$Component.txt
  else
echo "${Version}" | tee /var/www/html/$x/$Component.txt
  fi

Component="ops-dce-metadata-agent"
Version=`ssh tcserver@${targname} "grep Implementation-Version /opt/tcserver/instances/dce-mdata/webapps/ops-dce-metadata-agent/META-INF/MANIFEST.MF | cut -d : -f 2 | tr -d ' '  | tr -d '\r'"`
if [[ -z "$Version" || ${Version} == *select* ]]; then
echo "Not Present" | tee /var/www/html/$x/$Component.txt
  else
echo "${Version}" | tee /var/www/html/$x/$Component.txt
  fi

Component="caas-core"
Version=`./check_dbversions.sh -a caas-core -e ${envname}`
if [[ -z "$Version" || ${Version} == *select* ]]; then
echo "Not Present" | tee /var/www/html/$x/$Component.txt
  else
echo "${Version}" | tee /var/www/html/$x/$Component.txt
  fi
  
Component="ads-core"
Version=`./check_dbversions.sh -a ads-core -e ${envname}`
if [[ -z "$Version" || ${Version} == *select* ]]; then
echo "Not Present" | tee /var/www/html/$x/$Component.txt
  else
echo "${Version}" | tee /var/www/html/$x/$Component.txt
  fi

Component="dai-etl-feeder (DB)"
Version=`./check_dbversions.sh -a dai-etl-feeder -e ${envname}`
if [[ -z "$Version" || ${Version} == *select* ]]; then
echo "Not Present" | tee /var/www/html/$xt/ETL_Report_DB.txt
  else
echo "${Version}" | tee /var/www/html/$x/ETL_Report_DB.txt
  fi


Component="ops-dt-domain"
Version=`./check_dbversions.sh -a ops-dt-domain -e ${envname}`
if [[ -z "$Version" || ${Version} == *select* ]]; then
echo "Not Present" | tee /var/www/html/$x/$Component.txt
  else
echo "${Version}" | tee /var/www/html/$x/$Component.txt
  fi


Component="smsi-publisher"
Version=`./check_dbversions.sh -a smsi-publisher -e ${envname}`
if [[ -z "$Version" || ${Version} == *select* ]]; then
echo "Not Present" | tee /var/www/html/$x/$Component.txt
  else
echo "${Version}" | tee /var/www/html/$x/$Component.txt
  fi


Component="ops-dce-metadata-agent"
Version=`./check_dbversions.sh -a dce-mdata -e ${envname}`
if [[ -z "$Version" || ${Version} == *select* ]]; then
echo "Not Present" | tee /var/www/html/$x/$Component.txt
  else
echo "${Version}" | tee /var/www/html/$x/$Component.txt

  fi
  done
done
