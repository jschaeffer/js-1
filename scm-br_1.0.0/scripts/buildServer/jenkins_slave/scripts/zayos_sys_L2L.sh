#!/bin/bash

fnAssignInfo() {
# Function to assign the variables used in deployment to the info parsed from the system array in fnZayos_Sys
  export Suite="$(echo ${inar[$k]} | cut -f1 -d:)"
  export APPSERVER_IP="$(echo ${inar[$k]} | cut -f2 -d:)"
  export INSTANCE="$(echo ${inar[$k]} | cut -f3 -d:)"
  export WEBAPPS="$(echo ${inar[$k]} | cut -f4 -d:)"
  export APP="$(echo ${inar[$k]} | cut -f5 -d:)"
  export DB_USER="$(echo ${inar[$k]} | cut -f6 -d:)"
  export DB_PASS="$(echo ${inar[$k]} | cut -f7 -d:)"
  export LiqBaOPTS="$(echo ${inar[$k]} | cut -f8 -d:)"
  echo "Suite-> $Suite APPSERVER_IP-> $APPSERVER_IP INSTANCE-> $INSTANCE WEBAPPS-> $WEBAPPS APP-> $APP DB_USER-> $DB_USER DB_PASS-> $DB_PASS LiqBaOPTS-> $LiqBaOPTS"
}

fnGetSysList() {
if [[ $Suite = "Base" ]]; then
  export Syslist="cv-l2lcmc-clstr1 cv-l2lcmc-clstr2 cv-l2ltwc-clstr5 cv-l2lcmc-clstr2 cv-l2lcmc-clstr1 cv-l2lcmc-clstr3 cv-l2ltwc-clstr4 cv-l2lcmc-clstr3 cv-l2lcmc-clstr1 cv-l2lcmc-clstr4 cv-l2ltwc-clstr4"
  export VApp="base"
 elif [[ $Suite = "FW" ]]; then
  export Syslist="cv-l2lfw-clstr2 cv-l2lfw-clstr2 cv-l2lfw-clstr3 cv-l2lfw-clstr1 cv-l2lfw-clstr4 cv-l2lfw-clstr2 cv-l2lfw-clstr1 cv-l2lfw-clstr3 cv-l2lfw-clstr4 cv-l2lfw-clstr3 cv-l2lfw-clstr1 cv-l2lfw-clstr4"
  export VApp="fw"
 elif [[ $Suite = "Google" ]]; then
  export Syslist="cv-l2lggl-clstr2 cv-l2lggl-clstr2 cv-l2lggl-clstr3 cv-l2lggl-clstr1 cv-l2lggl-clstr2 cv-l2lggl-clstr1 cv-l2lggl-clstr3 cv-l2lggl-clstr3 cv-l2lggl-clstr1 cv-l2lggl-clstr4"
  export VApp="ggl"
 elif [[ $Suite = "Cox" ]]; then
  export Syslist="cv-l2lcox-clstr1 cv-l2lcox-clstr2 cv-l2lcox-clstr5 cv-l2lcox-clstr2 cv-l2lcox-clstr3 cv-l2lcox-clstr5 cv-l2lcox-clstr3 cv-l2lcox-clstr1 cv-l2lcox-clstr4"
  export VApp="cox"
 elif [[ $Suite = "Broadway" ]]; then
  export Syslist="cv-l2lbrd-clstr2 cv-l2lbrd-clstr3 cv-l2lbrd-clstr1 cv-l2lbrd-clstr4"
  export VApp="brd"
 elif [[ $Suite = "Rentrak" ]]; then
  export Syslist="cv-l2lrtk-clstr2 cv-l2lrtk-clstr3 cv-l2lrtk-clstr1 cv-l2lrtk-clstr4"
  export VApp="rtk"
fi
echo "System List -> $Syslist"

}

fnGetCompList() {
if [[ $Suite = "Base" ]]; then
  export Component="Dynamic-Ad-Insertion-engine Dynamic-Ad-Insertion-cm request-mgr dai-cip-feedback smsi-publisher dai-smsi SDC-session-collector impression_collector"

 elif [[ $Suite = "FW" ]]; then
  export Component="Dynamic-Ad-Insertion-engine Dynamic-Ad-Insertion-cm dai-cip-feedback Pgmr-Cpgn-Int metadata-publisher smsi-publisher dai-smsi dai-smsi-relay dai-national-cis impression_collector"

 elif [[ $Suite = "Google" ]]; then
  export Component="Dynamic-Ad-Insertion-engine Dynamic-Ad-Insertion-cm dai-cip-feedback Pgmr-Cpgn-Int smsi-publisher dai-smsi dai-smsi-relay impression_collector"

 elif [[ $Suite = "Cox" ]]; then
  export Component="Dynamic-Ad-Insertion-engine Dynamic-Ad-Insertion-cm dai-cip-feedback smsi-publisher dai-smsi ad-load-manager impression_collector POIS"

 elif [[ $Suite = "Broadway" ]]; then
  export Component="Dynamic-Ad-Insertion-engine Dynamic-Ad-Insertion-cm dai-cip-feedback Pgmr-Cpgn-Int smsi-publisher dai-smsi dai-smsi-relay impression_collector"
 elif [[ $Suite = "Rentrak" ]]; then
  export Component="Dynamic-Ad-Insertion-engine Dynamic-Ad-Insertion-cm dai-cip-feedback Pgmr-Cpgn-Int smsi-publisher dai-smsi smsi-msp-relay dmp-config impression_collector"
fi
echo "Component List -> $Component"
}

fnGetCompListJar() {
if [[ $Suite = "Base" ]]; then
  export Component="dai-cip acp"
 elif [[ $Suite = "FW" ]]; then
  export Component="dai-cip"
 elif [[ $Suite = "Google" ]]; then
  export Component="dai-cip"
 elif [[ $Suite = "Cox" ]]; then
  export Component="dai-cip"
 elif [[ $Suite = "Broadway" ]]; then
  export Component="dai-cip"
 elif [[ $Suite = "Rentrak" ]]; then
  export Component="dai-cip"
fi
echo "Component List -> $Component"
}

fnZayos_Sys() {
#  Adding DB info
  export SIDTarg="pro001"
  export DBIP="dbrac03.cv.dr"
  export JDBC_URL="jdbc:oracle:thin:@dbrac03.cv.dr:1521:pro001"
###########################
# Array of system info  
###########################
# Field description:
# #1 Suite
# #2 APPSERVER_IP
# #3 INSTANCE
# #4 WEBAPPS
# #5 APP
# #6 DB_USER
# #7 DB_PASS
# #8 LiqBaOPTS

case $Comp in
  Dynamic-Ad-Insertion-engine)
 if [[ $Suite = "Base" ]]; then
  inar[0]=Base:cv-l2lcmc-clstr1:CMC_DE01:ads:ads
  inar[1]=Base:cv-l2lcmc-clstr2:CMC_DE02:ads:ads
  inar[2]=Base:cv-l2ltwc-clstr1:TWC_DE01:ads-1.2.0:ads
  inar[3]=Base:cv-l2ltwc-clstr2:TWC_DE02:ads-1.2.0:ads
  inar[4]=Base:cv-l2ltwc-clstr4:TWC_CIS:cis:cis
 elif [[ $Suite = "FW" ]]; then
  inar[0]=FW:cv-l2lfw-clstr2:FW_DE01:ads:ads
 elif [[ $Suite = "Google" ]]; then
  inar[0]=Google:cv-l2lggl-clstr2:GGL_DE01:ads:ads
 elif [[ $Suite = "Cox" ]]; then
  inar[0]=Cox:cv-l2lcox-clstr1:COX_DE01:ads-cox:ads
  inar[1]=Cox:cv-l2lcox-clstr2:COX_DE02:ads-cox:ads
  inar[2]=Cox:cv-l2lcox-clstr4:COX_CIS:cis:cis
 elif [[ $Suite = "Broadway" ]]; then
  inar[0]=Broadway:cv-l2lbrd-clstr2:BRD_DE01:ads:ads
 elif [[ $Suite = "Rentrak" ]]; then
  inar[0]=Rentrak:cv-l2lrtk-clstr2:RTK_DE01:ads:ads
 fi
 ;;
 Dynamic-Ad-Insertion-cm)
 if [[ $Suite = "Base" ]]; then
  inar[0]=Base:cv-l2lcmc-clstr2:CMC_CM:Dynamic-Ad-Insertion-cm:Dynamic-Ad-Insertion-cm
  inar[1]=Base:cv-l2ltwc-clstr2:TWC_CM:Dynamic-Ad-Insertion-cm:Dynamic-Ad-Insertion-cm
 elif [[ $Suite = "FW" ]]; then
  inar[0]=FW:cv-l2lfw-clstr2:FW_CM:Dynamic-Ad-Insertion-cm:Dynamic-Ad-Insertion-cm
 elif [[ $Suite = "Google" ]]; then
  inar[0]=Google:cv-l2lggl-clstr2:GGL_CM:Dynamic-Ad-Insertion-cm:Dynamic-Ad-Insertion-cm
 elif [[ $Suite = "Cox" ]]; then
  inar[0]=Cox:cv-l2lcox-clstr2:COX_CM:Dynamic-Ad-Insertion-cm:Dynamic-Ad-Insertion-cm
 elif [[ $Suite = "Broadway" ]]; then
  inar[0]=Broadway:cv-l2lbrd-clstr2:BRD_CM:Dynamic-Ad-Insertion-cm:Dynamic-Ad-Insertion-cm
 elif [[ $Suite = "Rentrak" ]]; then
  inar[0]=Rentrak:cv-l2lrtk-clstr2:RTK_CM:Dynamic-Ad-Insertion-cm:Dynamic-Ad-Insertion-cm
 fi
 ;;
 request-mgr)
 if [[ $Suite = "Base" ]]; then
  inar[0]=Base:cv-l2ltwc-clstr5:TWC_REQMAN:request-manager:request-manager:REQMAN:REQMAN
 elif [[ $Suite = "FW" ]]; then
  echo "No $Comp installation for FW"
  exit
 elif [[ $Suite = "Cox" ]]; then
  echo "No $Comp installation for Cox"
  exit
 elif [[ $Suite = "Google" ]]; then
  echo "No $Comp installation for Google"
  exit
 elif [[ $Suite = "Broadway" ]]; then
  echo "No $Comp installation for Broadway"
  exit
 elif [[ $Suite = "Rentrak" ]]; then
  echo "No $Comp installation for Rentrak"
  exit
 fi
 ;;
 ad-load-manager)
 if [[ $Suite = "Base" ]]; then
  echo "No $Comp installation for Base"
  exit
 elif [[ $Suite = "FW" ]]; then
  echo "No $Comp installation for FW"
  exit
 elif [[ $Suite = "Cox" ]]; then
  inar[0]=Cox:cv-l2lcox-clstr5:COX_ALM:ad-load-manager:alm-server:ALM_COX:ALM_COX
 elif [[ $Suite = "Google" ]]; then
  echo "No $Comp installation for $Suite"
  exit
 elif [[ $Suite = "Broadway" ]]; then
  echo "No $Comp installation for $Suite"
  exit
 elif [[ $Suite = "Rentrak" ]]; then
  echo "No $Comp installation for Rentrak"
  exit
 fi
 ;;
 dai-cip-feedback)
 if [[ $Suite = "Base" ]]; then
  inar[0]=Base:cv-l2lcmc-clstr2:CMC_FN:cip-feedback:cip-server
  inar[1]=Base:cv-l2ltwc-clstr2:TWC_FN:cip-feedback:cip-server
 elif [[ $Suite = "FW" ]]; then
  inar[0]=FW:cv-l2lfw-clstr3:FW_FN:cip-feedback:cip-server
 elif [[ $Suite = "Cox" ]]; then
  inar[0]=Cox:cv-l2lcox-clstr2:COX_FN:cip-feedback:cip-server
 elif [[ $Suite = "Google" ]]; then
  inar[0]=Google:cv-l2lggl-clstr3:GGL_FN:cip-feedback:cip-server
 elif [[ $Suite = "Broadway" ]]; then
  inar[0]=Broadway:cv-l2lbrd-clstr3:BRD_FN:cip-feedback:cip-server
elif [[ $Suite = "Rentrak" ]]; then
 inar[0]=Rentrak:cv-l2lrtk-clstr3:RTK_FN:cip-feedback:cip-server
 fi
 ;;
 Pgmr-Cpgn-Int)
 if [[ $Suite = "FW" ]]; then
  inar[0]=FW:cv-l2lfw-clstr1:FW_PCI:fw_cip-ingest:pci:PCI_FW:PCI_FW
 elif [[ $Suite = "Base" ]]; then
  echo "No PCI installation for Base"
  exit
 elif [[ $Suite = "Google" ]]; then
  inar[0]=Google:cv-l2lggl-clstr1:GGL_PCI:gl_cip-ingest:pci:PCI_KODIAK:PCI_KODIAK
 elif [[ $Suite = "Cox" ]]; then
  echo "No PCI installation for COX"
  exit
 elif [[ $Suite = "Broadway" ]]; then
  inar[0]=Broadway:cv-l2lbrd-clstr1:BRD_PCI:brd_cip-ingest:pci:PCI_BRD:PCI_BRD
 elif [[ $Suite = "Rentrak" ]]; then
  inar[0]=Rentrak:cv-l2lrtk-clstr1:RTK_PCI:cip-ingest:pci:PCI_RTK:PCI_RTK
fi
 ;;
 metadata-publisher)
 if [[ $Suite = "Base" ]]; then
  echo "No $Comp installation for $Suite"
  exit
 elif [[ $Suite = "FW" ]]; then
  inar[0]=FW:cv-l2lfw-clstr4:FW_META_PUB:metadata-publisher:publisher
 elif [[ $Suite = "Cox" ]]; then
  echo "No $Comp installation for $Suite"
  exit
 elif [[ $Suite = "Google" ]]; then
  echo "No $Comp installation for $Suite"
  exit
 elif [[ $Suite = "Broadway" ]]; then
  echo "No $Comp installation for $Suite"
  exit
 elif [[ $Suite = "Rentrak" ]]; then
  echo "No $Comp installation for Rentrak"
  exit
 fi
 ;;
 smsi-publisher)
 if [[ $Suite = "Base" ]]; then
  inar[0]=Base:cv-l2lcmc-clstr1:CMC_SMSI_PUB:smsi-pub:smsi-publisher:SMSI_PUB_CMC:SMSI_PUB_CMC
  inar[1]=Base:cv-l2ltwc-clstr1:TWC_SMSI_PUB:smsi-pub:smsi-publisher:SMSI_PUB:SMSI_PUB
  export DependApps="Dynamic-Ad-Insertion-engine"
 elif [[ $Suite = "FW" ]]; then
  inar[0]=FW:cv-l2lfw-clstr2:FW_SMSI_PUB:smsi-pub:smsi-publisher:SMSI_PUB_FW:FREEWHEEL
  export DependApps="Dynamic-Ad-Insertion-engine"
 elif [[ $Suite = "Google" ]]; then
  inar[0]=Google:cv-l2lggl-clstr2:GGL_SMSI_PUB:smsi-pub:smsi-publisher:SMSI_PUB_TWL:KODIAK
  export DependApps="Dynamic-Ad-Insertion-engine"
 elif [[ $Suite = "Cox" ]]; then
  inar[0]=Cox:::::SMSI_PUB_COX:SMSI_PUB_COX
  export DependApps="Dynamic-Ad-Insertion-engine"
 elif [[ $Suite = "Broadway" ]]; then
  inar[0]=Broadway:cv-l2lbrd-clstr2:BRD_SMSI_PUB:smsi-pub:smsi-publisher:SMSI_PUB_BRD:SMSI_PUB_BRD
  export DependApps="Dynamic-Ad-Insertion-engine"
 elif [[ $Suite = "Rentrak" ]]; then
  inar[0]=Rentrak:cv-l2lrtk-clstr2:RTK_SMSI_PUB:smsi-pub:smsi-publisher:SMSI_PUB_RTK:SMSI_PUB_RTK
  export DependApps="Dynamic-Ad-Insertion-engine"
fi
 ;;
 dai-smsi)
 if [[ $Suite = "Base" ]]; then
  inar[0]=Base:cv-l2lcmc-clstr3:CMC_SMSI:smsi:safi-smsi-server
  inar[1]=Base:cv-l2ltwc-clstr3:TWC_SMSI:smsi:safi-smsi-server
 elif [[ $Suite = "FW" ]]; then
  inar[0]=FW:cv-l2lfw-clstr1:FW_SMSI:smsi:safi-smsi-server
 elif [[ $Suite = "Google" ]]; then
  inar[0]=Google:cv-l2lggl-clstr1:GGL_SMSI:smsi:safi-smsi-server
 elif [[ $Suite = "Cox" ]]; then
  inar[0]=Cox:cv-l2lcox-clstr3:COX_SMSI:smsi:safi-smsi-server
 elif [[ $Suite = "Broadway" ]]; then
  inar[0]=Broadway:cv-l2lbrd-clstr1:BRD_SMSI:smsi:safi-smsi-server
 elif [[ $Suite = "Rentrak" ]]; then
  inar[0]=Rentrak:cv-l2lrtk-clstr1:RTK_SMSI:smsi:safi-smsi-server
fi
 ;;
 SDC-session-collector)
 if [[ $Suite = "Base" ]]; then
  inar[0]=Base:cv-l2ltwc-clstr4:TWC_SESCOL:sdc-session-collector-server:sdc-session-collector-server
 elif [[ $Suite = "FW" ]]; then
  echo "No $Comp installation for $Suite"
  exit
 elif [[ $Suite = "Cox" ]]; then
  echo "No $Comp installation for $Suite"
  exit
 elif [[ $Suite = "Google" ]]; then
  echo "No $Comp installation for $Suite"
  exit
 elif [[ $Suite = "Broadway" ]]; then
  echo "No $Comp installation for $Suite"
  exit
 elif [[ $Suite = "Rentrak" ]]; then
  echo "No $Comp installation for Rentrak"
  exit
 fi
 ;;
 smsi-msp-relay)
 if [[ $Suite = "Base" ]]; then
  echo "No $Comp installation for $Suite"
  exit
 elif [[ $Suite = "FW" ]]; then
  echo "No $Comp installation for $Suite"
  exit
 elif [[ $Suite = "Cox" ]]; then
  echo "No $Comp installation for $Suite"
  exit
 elif [[ $Suite = "Google" ]]; then
  echo "No $Comp installation for $Suite"
  exit
 elif [[ $Suite = "Broadway" ]]; then
  echo "No $Comp installation for $Suite"
  exit
 elif [[ $Suite = "Rentrak" ]]; then
  inar[0]=Rentrak:cv-l2lrtk-clstr3:RTK_SMSI_RELAY:smsi-relay:smsi-relay-msp
fi
 ;;
 dai-smsi-relay)
 if [[ $Suite = "Base" ]]; then
  echo "No $Comp installation for $Suite"
  exit
 elif [[ $Suite = "FW" ]]; then
  inar[0]=FW:cv-l2lfw-clstr3:FW_SMSI_RELAY:smsi-relay:smsi-relay-client:SMSI_RELAY_FW:SMSI_RELAY_FW:-DCAMPAIGN_SCHEMA_NAME=CAAS_CORE_FW
 elif [[ $Suite = "Cox" ]]; then
  echo "No $Comp installation for $Suite"
  exit
 elif [[ $Suite = "Google" ]]; then
  inar[0]=Google:cv-l2lggl-clstr3:GGL_SMSI_RELAY:smsi-relay:smsi-relay-client:SMSI_RELAY_GL:SMSI_RELAY_GL:-DCAMPAIGN_SCHEMA_NAME=CAAS_LOCAL
 elif [[ $Suite = "Broadway" ]]; then
  inar[0]=Broadway:cv-l2lbrd-clstr3:BRD_SMSI_RELAY:smsi-relay:smsi-relay-client:SMSI_RELAY_BRD:SMSI_RELAY_BRD:-DCAMPAIGN_SCHEMA_NAME=CAAS_CORE_BRD
 elif [[ $Suite = "Rentrak" ]]; then
  echo "No $Comp installation for $Suite"
  exit
fi
 ;;
 int-test-support)
  echo "No $Comp installation for $Suite"
  exit
 ;;
 dai-dce)
  echo "No dai-dce installations in Lab2Lab yet"
  exit
 ;;
 dai-national-cis)
 if [[ $Suite = "Base" ]]; then
  echo "No $Comp installation for $Suite"
  exit
 elif [[ $Suite = "FW" ]]; then
  inar[0]=FW:cv-l2lfw-clstr4:FW_NCIS:dai-national-cis:nCisClient:NCIS_FW:FREEWHEEL:-DCAAS_SCHEMA_NAME=CAAS_CORE_FW
 elif [[ $Suite = "Cox" ]]; then
  echo "No $Comp installation for $Suite"
  exit
 elif [[ $Suite = "Google" ]]; then
  echo "No $Comp installation for $Suite"
  exit
 elif [[ $Suite = "Broadway" ]]; then
  echo "No $Comp installation for $Suite"
  exit
 elif [[ $Suite = "Rentrak" ]]; then
  echo "No $Comp installation for Rentrak"
  exit
 fi
 ;;
 POIS)
 if [[ $Suite = "Base" ]]; then
  echo "No $Comp installation for $Suite"
  exit
 elif [[ $Suite = "FW" ]]; then
  echo "No $Comp installation for $Suite"
  exit
 elif [[ $Suite = "Cox" ]]; then
  inar[0]=Cox:cv-l2lcox-clstr5:COX_POIS:POIS:pois
 elif [[ $Suite = "Google" ]]; then
  echo "No $Comp installation for $Suite"
  exit
 elif [[ $Suite = "Broadway" ]]; then
  echo "No $Comp installation for $Suite"
  exit
 elif [[ $Suite = "Rentrak" ]]; then
  echo "No $Comp installation for Rentrak"
  exit
 fi
 ;;
 impression_collector)
 if [[ $Suite = "Base" ]]; then
  inar[0]=Base:cv-l2lcmc-clstr3:CMC_IMPCOL:impression_collector_server:impression_collector_server
  inar[1]=Base:cv-l2ltwc-clstr3:TWC_IMPCOL:impression_collector_server:impression_collector_server
 elif [[ $Suite = "FW" ]]; then
  inar[0]=FW:cv-l2lfw-clstr3:FW_IMPCOL:impression_collector_server:impression_collector_server
 elif [[ $Suite = "Google" ]]; then
  inar[0]=Google:cv-l2lggl-clstr3:GGL_IMPCOL:impression_collector_server:impression_collector_server
 elif [[ $Suite = "Cox" ]]; then
  inar[0]=Cox:cv-l2lcox-clstr3:COX_IMPCOL:impression_collector_server:impression_collector_server
 elif [[ $Suite = "Broadway" ]]; then
  inar[0]=Broadway:cv-l2lbrd-clstr3:BRD_IMPCOL:impression_collector_server:impression_collector_server
 elif [[ $Suite = "Rentrak" ]]; then
  inar[0]=Rentrak:cv-l2lrtk-clstr3:RTK_IMPCOL:impression_collector_server:impression_collector_server
fi
 ;;
 dmp-config)
 if [[ $Suite = "Rentrak" ]]; then
  inar[0]=Rentrak:cv-l2lrtk-clstr4:RTK_DMP:dmp-config:dmp-config
 fi
 ;;
 dai-cip)
 if [[ $Suite = "Base" ]]; then
  inar[0]=Base:cv-l2lcmc-clstr1:dai_cip
  inar[1]=Base:cv-l2ltwc-clstr1:dai_cip
 elif [[ $Suite = "FW" ]]; then
  inar[0]=FW:cv-l2lfw-clstr1:dai_cip
 elif [[ $Suite = "Google" ]]; then
  inar[0]=Google:cv-l2lggl-clstr1:dai_cip
 elif [[ $Suite = "Cox" ]]; then
  inar[0]=Cox:cv-l2lcox-clstr1:dai_cip
 elif [[ $Suite = "Broadway" ]]; then
  inar[0]=Broadway:cv-l2lbrd-clstr1:dai_cip
 elif [[ $Suite = "Rentrak" ]]; then
  inar[0]=Rentrak:cv-l2lrtk-clstr1:dai_cip
fi
 ;;
 acp)
 if [[ $Suite = "Base" ]]; then
  inar[0]=Base:cv-l2lcmc-clstr4:acp:bin:acp
 elif [[ $Suite = "FW" ]]; then
  echo "No $Comp installation for $Suite"
  exit
 elif [[ $Suite = "Cox" ]]; then
  echo "No $Comp installation for $Suite"
  exit
 elif [[ $Suite = "Google" ]]; then
  echo "No $Comp installation for $Suite"
  exit
 elif [[ $Suite = "Broadway" ]]; then
  echo "No $Comp installation for $Suite"
  exit
 elif [[ $Suite = "Rentrak" ]]; then
  echo "No $Comp installation for Rentrak"
  exit
 fi
 ;;
 dai-metadata-ingestion)
 if [[ $Suite = "Base" ]]; then
  inar[0]=Base:cv-l2ltwc-clstr4:ingester
  inar[1]=Base:cv-l2lcmc-clstr4:ingester
 elif [[ $Suite = "FW" ]]; then
  inar[0]=FW:cv-l2lfw-clstr4:ingester
 elif [[ $Suite = "Google" ]]; then
  inar[0]=Google:cv-l2lggl-clstr4:ingester
 elif [[ $Suite = "Cox" ]]; then
  inar[0]=Cox:cv-l2lcox-clstr4:ingester
 elif [[ $Suite = "Broadway" ]]; then
  inar[0]=Broadway:cv-l2lbrd-clstr4:ingester
 elif [[ $Suite = "Rentrak" ]]; then
  inar[0]=Rentrak:cv-l2lrtk-clstr4:ingester
fi
 ;;
  caas-core)
 if [[ $Suite = "Base" ]]; then
  inar[0]=Base:::::CAAS40:CAAS40:-DADS_SCHEMA_NAME=ADS_CORE_COM
  export DependApps="acp dai-cip-feedback dai-smsi dai-cip Dynamic-Ad-Insertion-cm"
 elif [[ $Suite = "FW" ]]; then
  inar[0]=FW:::::CAAS_CORE_FW:FREEWHEEL:-DADS_SCHEMA_NAME=ADS_CORE_FW
  export DependApps="dai-cip-feedback dai-smsi-relay dai-smsi dai-cip Dynamic-Ad-Insertion-cm metadata-publisher Pgmr-Cpgn-Int dai-national-cis"
 elif [[ $Suite = "Google" ]]; then
  inar[0]=Google:::::CAAS_LOCAL:KODIAK:-DADS_SCHEMA_NAME=ADS_CORE_TWC_L
  export DependApps="dai-cip-feedback dai-smsi-relay dai-smsi dai-cip Dynamic-Ad-Insertion-cm"
 elif [[ $Suite = "Cox" ]]; then
  inar[0]=Cox:::::CAAS_CORE_COX:CAAS_CORE_COX:-DADS_SCHEMA_NAME=ADS_CORE_COX
  export DependApps="dai-cip-feedback ad-load-manager dai-smsi dai-cip Dynamic-Ad-Insertion-cm"
 elif [[ $Suite = "Broadway" ]]; then
  inar[0]=Broadway:::::CAAS_CORE_BRD:BROADWAY:-DADS_SCHEMA_NAME=ADS_CORE_BRD
  export DependApps="dai-cip-feedback dai-smsi-relay dai-smsi dai-cip Dynamic-Ad-Insertion-cm Pgmr-Cpgn-Int"
 elif [[ $Suite = "Rentrak" ]]; then
  inar[0]=Rentrak:::::CAAS_CORE_RTK:CAAS_CORE_RTK:-DADS_SCHEMA_NAME=ADS_CORE_RTK
  export DependApps="dai-cip-feedback dai-smsi dai-cip Dynamic-Ad-Insertion-cm Pgmr-Cpgn-Int"
fi
 ;;
  ads-core)
 if [[ $Suite = "Base" ]]; then
  inar[0]=Base:::::ADS_CORE_TWC:ADS_CORE_TWC:"-DCAAS_SCHEMA_NAME=CAAS40 -Denvironment=prod"
  inar[1]=Base:::::ADS_CORE_COM:ADS_CORE_COM:"-DCAAS_SCHEMA_NAME=CAAS40 -Denvironment=dev"
 elif [[ $Suite = "FW" ]]; then
  inar[0]=FW:::::ADS_CORE_FW:FREEWHEEL:"-DCAAS_SCHEMA_NAME=CAAS_CORE_FW -Denvironment=prod"
 elif [[ $Suite = "Google" ]]; then
  inar[0]=Google:::::ADS_CORE_TWC_L:KODIAK:"-DCAAS_SCHEMA_NAME=CAAS_LOCAL -Denvironment=prod"
 elif [[ $Suite = "Cox" ]]; then
  inar[0]=Cox:::::ADS_CORE_COX:ADS_CORE_COX:"-DCAAS_SCHEMA_NAME=CAAS_CORE_COX -Denvironment=prod"
 elif [[ $Suite = "Broadway" ]]; then
  inar[0]=Broadway:::::ADS_CORE_BRD:BROADWAY:"-DCAAS_SCHEMA_NAME=CAAS_CORE_BRD -Denvironment=prod"
 elif [[ $Suite = "Rentrak" ]]; then
  inar[0]=Rentrak:::::ADS_CORE_RTK:ADS_CORE_RTK:"-DCAAS_SCHEMA_NAME=CAAS_CORE_RTK -Denvironment=prod"
fi
 ;;
  dai-etl-feeder)
 if [[ $Suite = "Base" ]]; then
  inar[0]=Base:::::DAI_REPORTING_SAFI:DAI_REPORTING_SAFI:"-DCAMPAIGN_SCHEMA_NAME=CAAS40 -DREPORTING_SCHEMA_NAME=DAI_REPORTING_SAFI"
  export DependApps="dai-smsi"
 elif [[ $Suite = "FW" ]]; then
  inar[0]=FW:::::DAI_REPORTING_SAFI_FW:FREEWHEEL:"-DCAMPAIGN_SCHEMA_NAME=CAAS_CORE_FW -DREPORTING_SCHEMA_NAME=DAI_REPORTING_SAFI_FW"
  export DependApps="dai-smsi dai-smsi-relay"
 elif [[ $Suite = "Google" ]]; then
  inar[0]=Google:::::DAI_REPORTING_SAFI_TWL:KODIAK:"-DCAMPAIGN_SCHEMA_NAME=CAAS_LOCAL -DREPORTING_SCHEMA_NAME=DAI_REPORTING_SAFI_TWL"
  export DependApps="dai-smsi dai-smsi-relay"
 elif [[ $Suite = "Cox" ]]; then
  echo "No $Comp on $Suite suite"
  exit
 elif [[ $Suite = "Broadway" ]]; then
  inar[0]=Broadway:::::DAI_REPORTING_SAFI_BRD:DAI_REPORTING_SAFI_BRD:"-DCAMPAIGN_SCHEMA_NAME=CAAS_CORE_BRD -DREPORTING_SCHEMA_NAME=DAI_REPORTING_SAFI_BRD"
  export DependApps="dai-smsi dai-smsi-relay"
 elif [[ $Suite = "Rentrak" ]]; then
  inar[0]=Rentrak:::::DAI_REPORTING_SAFI_RTK:DAI_REPORTING_SAFI_RTK:"-DCAMPAIGN_SCHEMA_NAME=CAAS_CORE_RTK -DREPORTING_SCHEMA_NAME=DAI_REPORTING_SAFI_RTK"
  export DependApps="dai-smsi dai-smsi-relay"
 fi
 ;;
  smsi_reporting)
 if [[ $Suite = "Base" ]]; then
  echo "No $Comp on $Suite suite"
  exit
 elif [[ $Suite = "FW" ]]; then
  echo "No $Comp on $Suite suite"
  exit
 elif [[ $Suite = "Google" ]]; then
  inar[0]=Google:::::L2L_SMSI_RPTG:L2L_SMSI_RPTG:"-DCAMPAIGN_SCHEMA_NAME=CAAS_LOCAL -DINGEST_SCHEMA_NAME=DAI_REPORTING_SAFI_TWL"
   echo "No $Comp on $Suite suite"
   exit
 elif [[ $Suite = "Cox" ]]; then
  echo "No $Comp on $Suite suite"
  exit
 elif [[ $Suite = "Broadway" ]]; then
  echo "No $Comp on $Suite suite"
  exit
 elif [[ $Suite = "Rentrak" ]]; then
  echo "No $Comp installation for Rentrak"
  exit
 fi
 ;;
esac
}

#fnZayos_Sys $Component
#fnAssignInfo

