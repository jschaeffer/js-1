<?php
// The Components array consists of 
//  Col1 - Real Component Name
//  Col2 - Common name with capitalization
//  Col3 - PackageDeploy location for changes link
//  Col4 - TCServer Instance names on Scrum systems
//  Col5 - Endpoint/Login link
$tab="&nbsp;&nbsp;&nbsp;&nbsp;&nbsp";
$components = array
   (
   array("caas-core","CAAS Core DB","caas-core-PackageDeploy-4.0.0","NA","NA"),
   array("Dynamic-Ad-Insertion-cm","$tab;Campaign Mgr","DAI-CampaignMgmt-PackageDeploy-4.0.0","cm","9600/Dynamic-Ad-Insertion-cm/login/auth"),
   array("dai-cip","$tab;CIP Sender","dai-cip-PackageDeploy-4.0.0","NA","NA"),
   array("dai-cip-feedback","$tab;CIP Feedback","dai-cip-feedback-PackageDeploy-4.0.0","cip","9300/cip-server"),
   array("caas-admin","$tab;CAAS Admin","caas-admin-PackageDeploy-4.0.0","caas-admin","9475/caas-admin/login/auth"),
   array("dai_amm","$tab;Ad Map Mgr","dai_amm-PackageDeploy-4.0.0","dai_amm","9525/dai_amm/login/auth"),
   array("dai_amm_publisher","$tab;Ad Map Publisher","dai_amm_publisher-PackageDeploy-4.0.0","dai_amm","9505/dai_amm_publisher/login/auth"),
   array("acp","$tab;Asset CIP Publisher","acp-PackageDeploy-4.0.0","NA","NA"),
   array("ops-dt","$tab;Ops DT","ops-dt-PackageDeploy-1.0.0","ops-dt","9510/ops-dt/login/auth"),
   array("ops-dce-safi-reporting-agent","$tab;Ops SAFI Reporting Agent","ops-dce-safi-reporting-agent-PackageDeploy-1.0.0","dce-agent-002","NA"),
   array("ops-dce-scte-cfa-reporting-agent","$tab;Ops SCTE Reporting Agent","ops-dce-scte-cfa-reporting-agent-PackageDeploy-1.0.0","dce-agent-001","NA"),
   array("metadata-publisher","$tab;MetaData Publisher","metadata-publisher_PackageDeploy-4.0.0","NA","NA"),
   array("dai-etl-feeder","ETL Feeder DB","dai-etl-feeder-PackageDeploy-4.0.0","NA","NA"),
   array("scte-feeder","$tab;SCTE Feeder","scte-feeder-PackageDeploy-4.0.0","NA","NA"),
   array("MicroDev","$tab;MicroStrategy","MicroStrategy-PackageDeploy-4.0.0","NA","NA"),
   array("dai-smsi","$tab;SMSI Ingester","dai-smsi-PackageDeploy-4.0.0","smsi","9640/safi-smsi-server"),
   array("dai-smsi-relay","$tab;SMSI Relay","dai-smsi-relay-PackageDeploy-4.0.0","dai-smsi-relay","NA","NA"),
   array("dai-billing","$tab;DAI Billing","dai-billing-PackageDeploy-4.0.0","billing","9545/dai-billing"),
   array("smsi-admin","$tab;SMSI Admin","smsi-admin-PackageDeploy-4.0.0","smsi-admin","9440/smsi-admin/login/auth"),
   array("ads-core","ADS Core DB","ads-core-PackageDeploy-4.0.0","NA","NA"),
   array("Dynamic-Ad-Insertion-engine","$tab;Decision Engine","DAI-DecisionEngine-PackageDeploy-4.0.0","ads","9610/ads"),
   array("smsi-publisher","SMSI Publisher","smsi-publisher-PackageDeploy-4.0.0","smsipub","9520/smsi-publisher/smsipub"),
   array("dai-national-cis","National CIS","DAI-national-cis-PackageDeploy-4.0.0","dai-national-cis","9575/nCisClient/"),
   array("dai-metadata-ingestion","DAI MetaData Ingestion","dai-metadata-ingestion-PackageDeploy-4.0.0","NA","NA"),
   array("Pgmr-Cpgn-Int","Programmers Campaign Interface","Pgmr-Cpgn-Int-PackageDeploy-4.0.0","Pgrm-Cpgn-Int","NA"),
   array("ops-dt-domain","Ops DT Domain DB","ops-dt-domain-PackageDeploy-1.0.0","NA","NA"),
   array("ops-dce-metadata-agent","Ops DCE Metadata Agent","ops-dce-metadata-agent-PackageDeploy-1.0.0","dce-mdata","NA"),
   array("int-test-support","Mock Server","int-test-support-PackageDeploy-1.0.0","mocksvr01","NA"),
   array("dai-lincoln","DAI Lincoln","dai-lincoln-PackageDeploy-1.0.0","NA","NA"),
   array("crypt","EnCrypt","crypt","NA","NA"),
   array("oss_bar","OSS Bar","oss_bar-PackageDeploy-3.0.0","oss_bar","NA")
   );

// The Perf_Components array consists of
//  Col1 - Real Component Name
//  Col2 - Common name with capitalization
//  Col3 - PackageDeploy location for changes link
//  Col4 - Number of Application instances per component
//  Col4 - TCServer Instance names on Scrum systems
//  Col5 - Endpoint/Login link
$perf_components = array
   (
   array("caas-core","CAAS Core","caas-core-PackageDeploy-4.0.0","NA","NA","NA"),
   array("Dynamic-Ad-Insertion-cm","$tab;Campaign Mgr","DAI-CampaignMgmt-PackageDeploy-4.0.0","1","9600/Dynamic-Ad-Insertion-cm/login/auth"),
   array("dai-cip","$tab;CIP Sender","dai-cip-PackageDeploy-4.0.0","NA","NA"),
   array("dai-cip-feedback","$tab;CIP Feedback","dai-cip-feedback-PackageDeploy-4.0.0","1","9300/cip-server"),
   array("caas-admin","$tab;CAAS Admin","caas-admin-PackageDeploy-4.0.0","1","9475/caas-admin/login/auth"),
   array("dai-etl-feeder","ETL Feeder","dai-etl-feeder-PackageDeploy-4.0.0","NA","NA"),
   array("MicroDev","$tab;MicroStrategy","MicroStrategy-PackageDeploy-4.0.0","NA","NA"),
   array("dai-smsi","$tab;SMSI Ingester","dai-smsi-PackageDeploy-4.0.0","2","9640/safi-smsi-server"),
   array("dai-smsi-relay","$tab;SMSI Relay","dai-smsi-relay-PackageDeploy-4.0.0","2","NA","NA"),
   array("ads-core","ADS Core","ads-core-PackageDeploy-4.0.0","NA","NA","NA"),
   array("Dynamic-Ad-Insertion-engine","$tab;Decision Engine","DAI-DecisionEngine-PackageDeploy-4.0.0","5","9610/ads"),
   array("smsi-publisher","SMSI Publisher","smsi-publisher-PackageDeploy-4.0.0","2","9520/smsi-publisher/smsipub"),
   array("Pgmr-Cpgn-Int","Programmers Campaign Interface","Pgmr-Cpgn-Int-PackageDeploy-4.0.0","1","NA"),
   array("int-test-support","Mock Server","int-test-support-PackageDeploy-1.0.0","1","NA"),
   );

// The lab2lab_Components array consists of
//  Col1 - Real Component Name
//  Col2 - Common name with capitalization
//  Col3 - PackageDeploy location for changes link
//  Col4 - Number of Application instances per component
//  Col4 - TCServer Instance names on Scrum systems
//  Col5 - Endpoint/Login link
$lab2lab_components = array
   (
   array("caas-core","CAAS Core","caas-core-PackageDeploy-4.0.0","NA","NA","NA"),
   array("Dynamic-Ad-Insertion-cm","$tab;Campaign Mgr","DAI-CampaignMgmt-PackageDeploy-4.0.0","1","9600/Dynamic-Ad-Insertion-cm/login/auth"),
   array("dai-cip","$tab;CIP Sender","dai-cip-PackageDeploy-4.0.0","NA","NA"),
   array("dai-cip-feedback","$tab;CIP Feedback","dai-cip-feedback-PackageDeploy-4.0.0","1","9300/cip-server"),
   array("caas-admin","$tab;CAAS Admin","caas-admin-PackageDeploy-4.0.0","1","9475/caas-admin/login/auth"),
   array("dai-etl-feeder","ETL Feeder","dai-etl-feeder-PackageDeploy-4.0.0","NA","NA"),
   array("MicroDev","$tab;MicroStrategy","MicroStrategy-PackageDeploy-4.0.0","NA","NA"),
   array("dai-smsi","$tab;SMSI Ingester","dai-smsi-PackageDeploy-4.0.0","2","9640/safi-smsi-server"),
   array("dai-smsi-relay","$tab;SMSI Relay","dai-smsi-relay-PackageDeploy-4.0.0","2","NA","NA"),
   array("ads-core","ADS Core","ads-core-PackageDeploy-4.0.0","NA","NA","NA"),
   array("Dynamic-Ad-Insertion-engine","$tab;Decision Engine","DAI-DecisionEngine-PackageDeploy-4.0.0","5","9610/ads"),
   array("smsi-publisher","SMSI Publisher","smsi-publisher-PackageDeploy-4.0.0","2","9520/smsi-publisher/smsipub"),
   array("Pgmr-Cpgn-Int","Programmers Campaign Interface","Pgmr-Cpgn-Int-PackageDeploy-4.0.0","1","NA")
   );

global $arrlength;
$arrlength = count($components);
global $perf_arrlength;
$perf_arrlength = count($perf_components);
global $l2l_arrlength;
$l2l_arrlength = count($lab2lab_components);

//  The Envs array consists of
//  Col1 - The directory name of the system.  Used to point the SCM Web for information.
//  Col2 - The url link to the base system
//$envs = array
//    (
//    array("devint","http://10.13.18.113:.$components[$x][5]"),
//    array("scrum1","http://10.13.18.115:.$components[$x][5]"),
//    array("scrum2","http://10.13.18.116:.$components[$x][5]"),
//    array("scrum3","http://10.13.18.117:.$components[$x][5]"), 
//    array("scrum4","http://10.13.18.122:.$components[$x][5]"),
//    array("Marley","http://10.13.18.118:.$components[$x][5]")
//    );
//    array("performance1, 
//    array("performance2, 
//    array("lab2lab, 
//    array("production
//    );
$envs = array(scrum1, scrum2, scrum3, scrum4, devint);
$post_envs = array(Marley);
$perf_envs = array(performance);
$lab_envs = array(base,fw,kodiak);
$prod_envs = array(comcast,twc);

//for ($x=0; $x<$arrlength; $x++)
//{
//echo "Component: ".$components[$x][0]."<br>Common Name:  ".$components[$x][1]."<br>  PackageDeploy Job:  ".$components[$x][2]."<p>";
//$targ="scrum1";
//echo "$comp_dir=${targ}/".$components[$x][0]."<br>";

//}

?>
