#!/bin/bash

fnAssignInfo() {
# Function to assign the variables used in deployment to the info parsed from the system array in fnZayos_Sys
  export APPSERVER_IP="$(echo ${inar[$k]} | cut -f1 -d:)"
  export INSTANCE="$(echo ${inar[$k]} | cut -f2 -d:)"
  export WEBAPPS="$(echo ${inar[$k]} | cut -f3 -d:)"
  export APP="$(echo ${inar[$k]} | cut -f4 -d:)"
  export DB_USER="$(echo ${inar[$k]} | cut -f5 -d:)"
  export DB_PASS="$(echo ${inar[$k]} | cut -f6 -d:)"
  export LiqBaOPTS="$(echo ${inar[$k]} | cut -f7 -d:)"
  export MSDSN="$(echo ${inar[$k]} | cut -f2 -d:)"
  export MSDBUSR="$(echo ${inar[$k]} | cut -f3 -d:)"
  export MSDBPWD="$(echo ${inar[$k]} | cut -f4 -d:)"
}

fnZayos_Sys() {
###########################
# Array of system info  
###########################
# Field description:
# #1 APPSERVER_IP
# #2 INSTANCE
# #3 WEBAPPS
# #4 APP
# #5 DB_USER
# #6 DB_PASS
# #7 LiqBaOPTS

case $Comp in
  Dynamic-Ad-Insertion-engine)
  inar[0]=cv-pfdec_eng01.cv.perf:PF_DECENG_01:ads:ads
  inar[1]=cv-pfdec_eng02.cv.perf:PF_DECENG_02:ads:ads
  inar[2]=cv-pfdec_eng03.cv.perf:PF_DECENG_03:ads-1.2.0:ads
  inar[3]=cv-pfdec_eng04.cv.perf:PF_DECENG_04:ads-1.2.0:ads
  inar[4]=cv-pfdec_eng05.cv.perf:PF_DECENG_05:ads:ads
  inar[5]=cv-pfdec_eng06.cv.perf:PF_DECENG_06:ads:ads
  inar[6]=cv-pfde_ciping01.cv.perf:PF_CIPING_01:ads:ads
  inar[7]=cv-pfde_ciping02.cv.perf:PF_CIPING_02:ads:ads
  inar[8]=cv-pfde_ciping03.cv.perf:PF_CIPING_03:ads-1.2.0:ads
  inar[9]=cv-pfde_ciping04.cv.perf:PF_CIPING_04:ads-1.2.0:ads
  inar[10]=cv-pfcluster01.cv.perf:PF_CIS_01:cis:cis
 ;;
 Dynamic-Ad-Insertion-cm)
  inar[0]=cv-pfcluster03.cv.perf:PF_CM_01:Dynamic-Ad-Insertion-cm:Dynamic-Ad-Insertion-cm
 ;;
 dmp-config)
  inar[0]=cv-pfcluster01.cv.perf:PF_DMP:dmp-config:dmp-config
 ;;
 request-mgr)
  inar[0]=cv-pfrqman01.cv.perf:PF_REQMAN_01:request-manager:request-manager:REQMAN:REQMAN
  inar[1]=cv-pfrqman02.cv.perf:PF_REQMAN_02:request-manager:request-manager
  inar[2]=cv-pfrqman03.cv.perf:PF_REQMAN_03:request-manager:request-manager
  inar[3]=cv-pfrqman04.cv.perf:PF_REQMAN_04:request-manager:request-manager
  inar[4]=cv-pfrqman05.cv.perf:PF_REQMAN_05:request-manager:request-manager
 ;;
 dai-cip-feedback)
  inar[0]=cv-pfcip_feedbk01.cv.perf:PF_FBN_01:cip-feedback:cip-server
  inar[1]=cv-pfcip_feedbk02.cv.perf:PF_FBN_02:cip-feedback:cip-server
 ;;
 Pgmr-Cpgn-Int)
  inar[0]=cv-pfpci01.cv.perf:PF_PCI_01:pci:pci:PCI_PERF:PCI_PERF
  inar[1]=cv-pfpci02.cv.perf:PF_PCI_02:pci:pci
  inar[2]=cv-pfpci03.cv.perf:PF_PCI_03:pci:pci
 ;;
 metadata-publisher)
  inar[0]=cv-pfcluster02.cv.perf:PF_METAPUB_01:publisher:publisher
 ;;
 smsi-publisher)
  inar[0]=cv-pfsmsi_pub01.cv.perf:PF_SMSIPUB_01:smsi-pub:smsi-publisher:SMSI_PUB:SMSI_PUB
  inar[1]=cv-pfsmsi_pub02.cv.perf:PF_SMSIPUB_02:smsi-pub:smsi-publisher:SMSI_PUB_02:SMSI_PUB_02
  inar[2]=cv-pfsmsi_pub03.cv.perf:PF_SMSIPUB_03:smsi-pub:smsi-publisher:SMSI_PUB_03:SMSI_PUB_03
  inar[3]=cv-pfsmsi_pub04.cv.perf:PF_SMSIPUB_04:smsi-pub:smsi-publisher
 ;;
 dai-smsi)
  inar[0]=cv-pfsmsi_ing01.cv.perf:PF_SMSI_01:smsi:safi-smsi-server
  inar[1]=cv-pfsmsi_ing02.cv.perf:PF_SMSI_02:smsi:safi-smsi-server
  inar[2]=cv-pfsmsi_ing03.cv.perf:PF_SMSI_03:smsi:safi-smsi-server
  inar[3]=cv-pfsmsi_ing04.cv.perf:PF_SMSI_04:smsi:safi-smsi-server
 ;;
 SDC-session-collector)
  inar[0]=cv-pfscol01.cv.perf:PF_SESCOL_01:sdc-session-collector-server:sdc-session-collector-server
  inar[1]=cv-pfscol02.cv.perf:PF_SESCOL_02:sdc-session-collector-server:sdc-session-collector-server
  inar[2]=cv-pfscol03.cv.perf:PF_SESCOL_03:sdc-session-collector-server:sdc-session-collector-server
  inar[3]=cv-pfscol04.cv.perf:PF_SESCOL_04:sdc-session-collector-server:sdc-session-collector-server
  inar[4]=cv-pfscol05.cv.perf:PF_SESCOL_05:sdc-session-collector-server:sdc-session-collector-server
 ;;
 dai-smsi-relay)
  inar[0]=cv-pfsmsi_relay01.cv.perf:PF_SMSIREL_01:smsi-relay:smsi-relay-client:SMSI_RELAY_01:SMSI_RELAY_01:-DCAMPAIGN_SCHEMA_NAME=CAAS_CORE
  inar[1]=cv-pfsmsi_relay02.cv.perf:PF_SMSIREL_02:smsi-relay:smsi-relay-client:SMSI_RELAY_02:SMSI_RELAY_02:-DCAMPAIGN_SCHEMA_NAME=CAAS_CORE
  inar[2]=cv-pfsmsi_relay03.cv.perf:PF_SMSIREL_03:smsi-relay:smsi-relay-client:SMSI_RELAY_03:SMSI_RELAY_03:-DCAMPAIGN_SCHEMA_NAME=CAAS_CORE
  inar[3]=cv-pfsmsi_relay04.cv.perf:PF_SMSIREL_04:smsi-relay:smsi-relay-client
  inar[4]=cv-pfsmsi_relay05.cv.perf:PF_SMSIREL_05:smsi-relay:smsi-relay-client
  inar[5]=cv-pfsmsi_relay06.cv.perf:PF_SMSIREL_06:smsi-relay:smsi-relay-client
  inar[6]=cv-pfsmsi-relay07.cv.perf:PF_SMSIREL_07:smsi-relay:smsi-relay-client:SMSI_RELAY_04:SMSI_RELAY_04:-DCAMPAIGN_SCHEMA_NAME=CAAS_CORE
  inar[7]=cv-pfsmsi-relay08.cv.perf:PF_SMSIREL_08:smsi-relay:smsi-relay-client
 ;;
 smsi-msp-relay)
  inar[0]=cv-pfsmsi_relay01.cv.perf:MSP_RELAY01:smsi-relay:smsi-relay-msp
  inar[1]=cv-pfsmsi_relay02.cv.perf:MSP_RELAY02:smsi-relay:smsi-relay-msp
  inar[2]=cv-pfsmsi_relay03.cv.perf:MSP_RELAY03:smsi-relay:smsi-relay-msp
  inar[3]=cv-pfsmsi_relay04.cv.perf:MSP_RELAY04:smsi-relay:smsi-relay-msp
  inar[4]=cv-pfsmsi_relay05.cv.perf:MSP_RELAY05:smsi-relay:smsi-relay-msp
  inar[5]=cv-pfsmsi_relay06.cv.perf:MSP_RELAY06:smsi-relay:smsi-relay-msp
  inar[6]=cv-pfsmsi-relay07.cv.perf:MSP_RELAY07:smsi-relay:smsi-relay-msp
  inar[7]=cv-pfsmsi-relay08.cv.perf:MSP_RELAY08:smsi-relay:smsi-relay-msp
 ;;
 int-test-support)
  inar[0]=cv-pffeeder02.cv.perf:mocksvr01:int-test-support:int-test-support
 ;;
 ad-load-manager)
  inar[0]=cv-pfcluster03.cv.perf:PF_ALM_01:ad-load-manager:alm-server:ALM:ALM
 ;;
 dai-dce)
  inar[0]=cv-pfdce.cv.perf:PF_DCE_01:dai-dce-server:dai-dce-server:DAIDCE:DAIDCE
 ;;
 dai-national-cis)
  inar[0]=cv-pfcluster01.cv.perf:PF_NCIS_01:nCisClient:nCisClient:NCIS:NCIS:-DCAAS_SCHEMA_NAME=CAAS_CORE
 ;;
 POIS)
  inar[0]=cv-pfpois01.cv.perf:PF_POIS_01:pois:pois
  inar[1]=cv-pfpois02.cv.perf:PF_POIS_02:pois:pois
 ;;
 impression_collector)
  inar[0]=cv-pfimp_coll01.cv.perf:PF_IMPCOL_01:impression_collector_server:impression_collector_server
  inar[1]=cv-pfimp_coll02.cv.perf:PF_IMPCOL_02:impression_collector_server:impression_collector_server
 ;;
 dai-cip)
  inar[0]=cv-pfcluster03.cv.perf:pf_dai_cip
 ;;
 acp)
  inar[0]=cv-pfcluster02.cv.perf:pf_acp
 ;;
 MicroDev)
  inar[0]=cv-pfmicrostrat01.cv.perf:Performance_TEST:Administrator:Perf_test01
esac
}

fnZayos_Sys $Component
fnAssignInfo

echo $APPSERVER_IP
echo $INSTANCE
echo $WEBAPPS
echo $APP
echo $DB_USER
echo $DB_PASS
echo $LiqBaOPTS


fnZayos_start_all() {
# Not called at every use.  This is just a support funtion in case the Perfance team wants a full restart
export Components="Dynamic-Ad-Insertion-cm metadata-publisher int-test-support ad-load-manager dai-dce dai-national-cis dai-cip acp POIS impression_collector dai-cip-feedback Pgmr-Cpgn-Int smsi-publisher dai-smsi dai-smsi-relay smsi-msp-relay  Dynamic-Ad-Insertion-engine" 

for Comp in $Components; do
 export k=0
 fnZayos_Sys $Comp
 for i in ${inar[@]}; do
    export System="$(echo ${inar[$k]} | cut -f1 -d:)"
    export Instance="$(echo ${inar[$k]} | cut -f2 -d:)"
    export Webapps="$(echo ${inar[$k]} | cut -f3 -d:)"

  if [[ $Comp = dai-cip || $Comp = acp ]]; then
    echo "Starting $Comp processes on System-> $System   Instance->$Instance"
    ssh tcserver@$System "cd $Instance; ./launcher.sh start"
    k=$((k+1))

  else
    echo "Starting tcerver processes for $Comp   System-> $System   Instance->$Instance  Webapps->$Webapps"
    /opt/build/scripts/tcServerAdmin.sh ${System} ${Instance} start
    k=$((k+1))

  fi

 done
done
}


