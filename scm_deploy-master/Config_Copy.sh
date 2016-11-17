#!/bin/bash

echo "Config Copy script."
echo "I'm echoing this because I can't read the blue text"
echo "Step one: Get the old configs from the old L2L and save them to a local directory on the old build box Rename them to add Base, FW, Etc to the end of the file name"
echo "Step two: Copy the contents of Old L2L config dir to the new build box"
echo "Step three: Using an if statement to check for the type of config (Component) and the target suite scp the config to its target location. This will most likely require a case statement of all the locations and insstance names."

case $Comp in
  Dynamic-Ad-Insertion-engine)
 if [[ $Suite = "Base" ]]; then
  inar[0]=Base:cv-l2lcmc-clstr1:CMC_DE01
  inar[1]=Base:cv-l2lcmc-clstr2:CMC_DE02
  inar[2]=Base:cv-l2ltwc-clstr1:TWC_DE01
  inar[3]=Base:cv-l2ltwc-clstr2:TWC_DE02
 elif [[ $Suite = "FW" ]]; then
  inar[0]=FW:cv-l2lfw-clstr2:FW_DE01
 elif [[ $Suite = "Google" ]]; then
  inar[0]=Google:cv-l2lggl-clstr2:GGL_DE01
 elif [[ $Suite = "Cox" ]]; then
  inar[0]=Cox:cv-l2lcox-clstr1:COX_DE01
  inar[1]=Cox:cv-l2lcox-clstr2:COX_DE02
 elif [[ $Suite = "Broadway" ]]; then
  inar[0]=Broadway:cv-l2lbrd-clstr2:BRD_DE01
 fi
 ;;
 Dynamic-Ad-Insertion-cm)
 if [[ $Suite = "Base" ]]; then
  inar[0]=Base:cv-l2lcmc-clstr2:CMC_CM
  inar[1]=Base:cv-l2ltwc-clstr2:TWC_CM
 elif [[ $Suite = "FW" ]]; then
  inar[0]=FW:cv-l2lfw-clstr2:FW_CM
 elif [[ $Suite = "Google" ]]; then
  inar[0]=Google:cv-l2lggl-clstr2:GGL_CM
 elif [[ $Suite = "Cox" ]]; then
  inar[0]=Cox:cv-l2lcox-clstr2:COX_CM
 elif [[ $Suite = "Broadway" ]]; then
  inar[0]=Broadway:cv-l2lbrd-clstr2:BRD_CM
 fi
 ;;
 request-mgr)
  inar[0]=cv-l2ltwc-clstr5:TWC_REQMAN
 ;;
 dai-cip-feedback)
 if [[ $Suite = "Base" ]]; then
  inar[0]=Base:cv-l2lcmc-clstr2:CMC_FN
  inar[1]=Base:cv-l2ltwc-clstr2:TWC_FN
 elif [[ $Suite = "Google" ]]; then
  inar[0]=Google:cv-l2lggl-clstr3:GGL_FN
 fi
 ;;
 Pgmr-Cpgn-Int)
 if [[ $Suite = "FW" ]]; then
  inar[0]=FW:cv-l2lfw-clstr1:FW_PCI
 elif [[ $Suite = "Google" ]]; then
  inar[0]=Google:cv-l2lggl-clstr1:GGL_PCI
 elif [[ $Suite = "Broadway" ]]; then
  inar[0]=Broadway:cv-l2lbrd-clstr1:BRD_PCI
fi
 ;;
 metadata-publisher)
  inar[0]=FW:cv-l2lfw-clstr4:FW_META_PUB
 ;;
 smsi-publisher)
 if [[ $Suite = "Base" ]]; then
  inar[0]=Base:cv-l2lcmc-clstr1:CMC_SMSI_PUB
  inar[1]=Base:cv-l2ltwc-clstr1:TWC_SMSI_PUB
 elif [[ $Suite = "FW" ]]; then
  inar[0]=FW:cv-l2lfw-clstr2:FW_SMSI_PUB
 elif [[ $Suite = "Google" ]]; then
  inar[0]=Google:cv-l2lggl-clstr2:GGL_SMSI_PUB
 elif [[ $Suite = "Cox" ]]; then
  inar[0]=Cox:cv-l2lcox-clstr1:COX_SMSI_PUB
 elif [[ $Suite = "Broadway" ]]; then
  inar[0]=Broadway:cv-l2lbrd-clstr2:BRD_SMSI_PUB
fi
 ;;
 dai-smsi)
 if [[ $Suite = "Base" ]]; then
  inar[0]=Base:cv-l2lcmc-clstr3:CMC_SMSI
  inar[1]=Base:cv-l2ltwc-clstr3:TWC_SMSI
 elif [[ $Suite = "FW" ]]; then
  inar[0]=FW:cv-l2lfw-clstr1:FW_SMSI
 elif [[ $Suite = "Google" ]]; then
  inar[0]=Google:cv-l2lggl-clstr1:GGL_SMSI
 elif [[ $Suite = "Cox" ]]; then
  inar[0]=Cox:cv-l2lcox-clstr3:COX_SMSI
 elif [[ $Suite = "Broadway" ]]; then
  inar[0]=Broadway:cv-l2lbrd-clstr1:BRD_SMSI
fi
 ;;
 SDC-session-collector)
  inar[0]=
  inar[1]=
  inar[2]=
  inar[3]=
  inar[4]=
 ;;
 dai-smsi-relay)
 if [[ $Suite = "FW" ]]; then
  inar[0]=FW:cv-l2lfw-clstr3:FW_SMSI_RELAY
 elif [[ $Suite = "Google" ]]; then
  inar[0]=Google:cv-l2lggl-clstr3:GGL_SMSI_RELAY
 elif [[ $Suite = "Broadway" ]]; then
  inar[0]=Broadway:cv-l2lbrd-clstr3:BRD_SMSI_RELAY
fi
 ;;
 int-test-support)
  inar[0]=
 ;;
 ad-load-manager)
  inar[0]=Cox:cv-l2lcox-clstr5:COX_ALM
 ;;
 dai-dce)
  inar[0]=
 ;;
 dai-national-cis)
  inar[0]=FW:cv-l2lfw-clstr4:FW_NCIS
 ;;
 POIS)
  inar[0]=Cox:cv-l2lcox-clstr5:COX_POIS
 ;;
 impression_collector)
 if [[ $Suite = "Base" ]]; then
  inar[0]=Base:cv-l2lcmc-clstr3:CMC_IMPCOL
  inar[1]=Base:cv-l2ltwc-clstr3:TWC_IMPCOL
 elif [[ $Suite = "FW" ]]; then
  inar[0]=FW:cv-l2lfw-clstr3:FW_IMPCOL
 elif [[ $Suite = "Google" ]]; then
  inar[0]=Google:cv-l2lggl-clstr3:GGL_IMPCOL
 elif [[ $Suite = "Cox" ]]; then
  inar[0]=Cox:cv-l2lcox-clstr3:COX_IMPCOL
 elif [[ $Suite = "Broadway" ]]; then
  inar[0]=Broadway:cv-l2lbrd-clstr3:BRD_IMPCOL
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
fi
 ;;
 acp)
  inar[0]=Base:cv-l2lcmc-clstr4:acp
 ;;

esac

cd /opt/build/scripts/lab2lab/config/l2lconfigs 

for i in $Components

ls $Suite.*.$App* > TMP.txt
Conf=`cat TMP.txt`
export APPSERVER_IP="$(echo ${Conf} | cut -f2 -d:)"
export APPSERVER_IP="$(echo ${inar[$k]} | cut -f1 -d:)"

