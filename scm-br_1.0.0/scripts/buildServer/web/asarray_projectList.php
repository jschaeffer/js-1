<?php
// The Components array consists of 
//  Col0 - Real Component Name
//  Col1 - Common name with capitalization
//  Col2 - PackageDeploy location for changes link
//  Col3 - TCServer Instance names on Scrum systems
//  Col4 - Endpoint/Login link
//  Col5 - Button Text
$tab="&nbsp;&nbsp;&nbsp;&nbsp;&nbsp";
$components = array
   (
   array("caas-core","CAAS Core DB","caas-core-PackageDeploy-5.1.0","NA","NA"),
   array("Dynamic-Ad-Insertion-cm","$tab;Campaign Mgr","DAI-CampaignMgmt-PackageDeploy-5.9.0","cm","9600/Dynamic-Ad-Insertion-cm", "Login"),
   array("dai-cip","$tab;CIP Sender","dai-cip-PackageDeploy-5.0.0","NA","NA"),
   array("dai-cip-feedback","$tab;CIP Feedback","dai-cip-feedback-PackageDeploy-4.0.0","cip","9300/cip-server","URL"),
   array("acp","$tab;Asset CIP Publisher","acp-PackageDeploy-5.0.0","NA","NA"),
   array("Pgmr-Cpgn-Int","$tab;PCI","Pgmr-Cpgn-Int-PackageDeploy-5.0.0","Pgmr-Cpgn-Int","9591/pci/pci","URL"),
   array("dai-dce","$tab;DAI DCE","dai-dce-PackageDeploy-5.0.0","dai-dce","NA","NA"),
   array("metadata-publisher","$tab;MetaData Publisher","metadata-publisher_PackageDeploy-4.0.0","metadata-publisher","NA","NA"),
   array("dai-etl-feeder","ETL Feeder DB","dai-etl-feeder-PackageDeploy-4.0.0","NA","NA"),
   array("smsi_reporting","SMSI Reporting","smsi_reporting-PackageDeploy-5.0.0","NA","NA"),
   array("MicroDev","$tab;MicroStrategy","MicroStrategy-PackageDeploy-4.0.0","NA","NA"),
   array("dai-smsi","$tab;SMSI Ingester","dai-smsi-PackageDeploy-4.0.0","smsi","9640/safi-smsi-server","URL"),
   array("dai-smsi-relay","$tab;SMSI Relay","dai-smsi-relay-PackageDeploy-5.0.0","dai-smsi-relay","NA","NA"),
   array("smsi-msp-relay","smsi-msp-relay","smsi-msp-relay-PackageDeploy-5.0.0","smsi-msp-relay","NA","NA"),
   array("ads-core","ADS Core DB","ads-core-PackageDeploy-4.0.0","NA","NA"),
   array("Dynamic-Ad-Insertion-engine","$tab;Decision Engine","DAI-DecisionEngine-PackageDeploy-4.0.0","ads","9610/ads","URL"),
   array("smsi-publisher","SMSI Publisher","smsi-publisher-PackageDeploy-5.0.0","smsipub","9520/smsi-publisher/smsipub","URL"),
   array("dai-national-cis","NCIS","DAI-national-cis-PackageDeploy-4.0.0","dai-national-cis","9575/nCisClient","Login"),
   array("dai-metadata-ingestion","DAI MetaData Ingestion","dai-metadata-ingestion-PackageDeploy-5.0.0","NA","NA"),
   array("impression_collector","Impression Collector","impression_collector-PackageDeploy-4.0.0","impression_collector","NA","NA"),
   array("ad-load-manager","Ad Load Manager","ad-load-manager-PackageDeploy-4.0.0","ad-load-manager","NA","NA"),
   array("request-mgr","Request Manager","request-mgr-PackageDeploy-5.0.0","request-mgr","NA","NA"),
   array("SDC-session-collector","SDC Session Collector","SDC-session-collector-PackageDeploy-5.0.0","SDC-session-collector","NA","NA"),
   array("ops-dce-metadata-agent","BAS Metadata Agent","ops-dce-metadata-agent-PackageDeploy-1.0.0","dce-mdata","NA","NA"),
   array("POIS","POIS","POIS-PackageDeploy-5.0.0","POIS","NA","NA"),
   array("int-test-support","Mock Server","int-test-support-PackageDeploy-1.0.0","mock_svr","NA","NA"),
   array("dmp-config","dmp-config","dmp-config-PackageDeploy-5.0.0","dmp-config","NA","NA")
   );

// The Perf_Components array consists of
//  Col1 - Real Component Name
//  Col2 - Common name with capitalization
//  Col3 - PackageDeploy location for changes link
//  Col4 - Number of Application instances per component
//  Col4 - TCServer Instance names on Scrum systems
//  Col5 - Endpoint/Login link
$performance_components = array
   (
   array("caas-core","CAAS Core","caas-core-PackageDeploy-5.1.0","NA","NA","NA"),
   array("Dynamic-Ad-Insertion-cm","$tab;Campaign Mgr","DAI-CampaignMgmt-PackageDeploy-5.11.0","2","9600/Dynamic-Ad-Insertion-cm/login/auth"),
   array("dai-cip","$tab;CIP Sender","dai-cip-PackageDeploy-5.0.0","1","NA"),
   array("dai-cip-feedback","$tab;CIP Feedback","dai-cip-feedback-PackageDeploy-4.0.0","2","9300/cip-server"),
   array("acp","$tab;(ACP) Asset CIP Publisher","acp-PackageDeploy-5.0.0","1","NA"),
   array("metadata-publisher","$tab;MetaData Publisher","metadata-publisher_PackageDeploy-4.0.0","1","NA","NA"),
   array("dai-etl-feeder","ETL Feeder","dai-etl-feeder-PackageDeploy-4.0.0","NA","NA"),
   array("MicroDev","$tab;MicroStrategy","MicroStrategy-PackageDeploy-4.0.0","NA","NA"),
   array("smsi_reporting","SMSI Reporting","smsi_reporting-PackageDeploy-5.0.0","NA","NA"),
   array("dai-smsi","$tab;SMSI Ingester","dai-smsi-PackageDeploy-4.0.0","2","9640/safi-smsi-server"),
   array("smsi-msp-relay","$tab;SMSI-MSP-RELAY","smsi-msp-relay-PackageDeploy-5.0.0","2","NA","NA"),
   array("dai-smsi-relay","$tab;SMSI Relay","dai-smsi-relay-PackageDeploy-5.0.0","2","NA","NA"),
   array("ads-core","ADS Core","ads-core-PackageDeploy-4.0.0","NA","NA","NA"),
   array("Dynamic-Ad-Insertion-engine","$tab;Decision Engine","DAI-DecisionEngine-PackageDeploy-4.0.0","5","9610/ads"),
   array("ad-load-manager","Ad Load Manager","ad-load-manager-PackageDeploy-4.0.0","1","NA"),
   array("smsi-publisher","SMSI Publisher","smsi-publisher-PackageDeploy-5.0.0","2","9520/smsi-publisher/smsipub"),
   array("dai-national-cis","NCIS","DAI-national-cis-PackageDeploy-4.0.0","1","9600/nCisClient","Login"),
   array("Pgmr-Cpgn-Int","(PCI) Programmers Campaign Interface","Pgmr-Cpgn-Int-PackageDeploy-5.0.0","2","NA"),
   array("POIS","POIS","POIS-PackageDeploy-5.0.0","2","NA"),
   array("impression_collector","Impression Collector","impression_collector-PackageDeploy-4.0.0","2","NA","NA"),
   array("request-mgr","Request Manager","request-mgr-PackageDeploy-5.0.0","5","NA","NA"),
   array("SDC-session-collector","SDC Session Collector","SDC-session-collector-PackageDeploy-5.0.0","5","NA","NA"),
   array("dai-dce","dai-dce","dai-dce-PackageDeploy-5.0.0","1","NA"),
   array("int-test-support","Mock Server","int-test-support-PackageDeploy-1.0.0","1","NA")
   );

$zayo_perf_components = array
   (
   array("caas-core","CAAS Core","caas-core-PackageDeploy-5.1.0","NA","NA","NA"),
   array("Dynamic-Ad-Insertion-cm","$tab;Campaign Mgr","DAI-CampaignMgmt-PackageDeploy-5.11.0","2","9600/Dynamic-Ad-Insertion-cm/login/auth"),
   array("dai-cip","$tab;CIP Sender","dai-cip-PackageDeploy-5.0.0","1","NA"),
   array("dai-cip-feedback","$tab;CIP Feedback","dai-cip-feedback-PackageDeploy-4.0.0","2","9300/cip-server"),
   array("acp","$tab;(ACP) Asset CIP Publisher","acp-PackageDeploy-5.0.0","1","NA"),
   array("metadata-publisher","$tab;MetaData Publisher","metadata-publisher_PackageDeploy-4.0.0","1","NA","NA"),
   array("dai-etl-feeder","ETL Feeder","dai-etl-feeder-PackageDeploy-4.0.0","NA","NA"),
   array("MicroDev","$tab;MicroStrategy","MicroStrategy-PackageDeploy-4.0.0","NA","NA"),
   array("smsi_reporting","SMSI Reporting","smsi_reporting-PackageDeploy-5.0.0","NA","NA"),
   array("dai-smsi","$tab;SMSI Ingester","dai-smsi-PackageDeploy-4.0.0","2","9640/safi-smsi-server"),
   array("smsi-msp-relay","$tab;SMSI-MSP-Relay","smsi-msp-relay-PackageDeploy-5.0.0","2","NA","NA"),
   array("dai-smsi-relay","$tab;SMSI Relay","dai-smsi-relay-PackageDeploy-5.0.0","2","NA","NA"),
   array("ads-core","ADS Core","ads-core-PackageDeploy-4.0.0","NA","NA","NA"),
   array("Dynamic-Ad-Insertion-engine","$tab;Decision Engine","DAI-DecisionEngine-PackageDeploy-4.0.0","5","9610/ads"),
   array("ad-load-manager","Ad Load Manager","ad-load-manager-PackageDeploy-4.0.0","1","NA"),
   array("smsi-publisher","SMSI Publisher","smsi-publisher-PackageDeploy-5.0.0","4",""),
   array("rema-publisher","REMA Publisher (temporary naming smsi-publisher)","smsi-publisher-PackageDeploy-5.0.0","4",""),
   array("dai-national-cis","NCIS","DAI-national-cis-PackageDeploy-4.0.0","1","9600/nCisClient","Login"),
   array("Pgmr-Cpgn-Int","(PCI) Programmers Campaign Interface","Pgmr-Cpgn-Int-PackageDeploy-5.0.0","2","NA"),
   array("POIS","POIS","POIS-PackageDeploy-5.0.0","2","NA"),
   array("impression_collector","Impression Collector","impression_collector-PackageDeploy-4.0.0","2","NA","NA"),
   array("request-mgr","Request Manager","request-mgr-PackageDeploy-5.0.0","5","NA","NA"),
   array("SDC-session-collector","SDC Session Collector","SDC-session-collector-PackageDeploy-5.0.0","5","NA","NA"),
   array("dai-dce","dai-dce","dai-dce-PackageDeploy-5.0.0","1","NA"),
   array("dmp-config","dmp-config","dmp-config-PackageDeploy-5.0.0","dmp-config","NA","NA"),
   array("int-test-support","Mock Server","int-test-support-PackageDeploy-1.0.0","1","NA")
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
   array("caas-core","CAAS Core","caas-core-PackageDeploy-4.2.0","NA","NA","NA"),
   array("Dynamic-Ad-Insertion-cm","$tab;Campaign Mgr","DAI-CampaignMgmt-PackageDeploy-5.4.0","2","9600/Dynamic-Ad-Insertion-cm/login/auth"),
   array("dai-cip","$tab;CIP Sender","dai-cip-PackageDeploy-5.0.0","1","NA"),
   array("dai-cip-feedback","$tab;CIP Feedback","dai-cip-feedback-PackageDeploy-4.0.0","2","9300/cip-server"),
   array("acp","$tab;Asset CIP Publisher","acp-PackageDeploy-4.0.0","1","NA"),
   array("Pgmr-Cpgn-Int","Programmers Campaign Interface","Pgmr-Cpgn-Int-PackageDeploy-4.0.0","3","NA"),
   array("metadata-publisher","$tab;MetaData Publisher","metadata-publisher_PackageDeploy-4.0.0","1","NA"),
   array("dai-etl-feeder","ETL Feeder","dai-etl-feeder-PackageDeploy-4.0.0","NA","NA"),
   array("MicroDev","$tab;MicroStrategy","MicroStrategy-PackageDeploy-4.0.0","NA","NA"),
   array("dai-smsi","$tab;SMSI Ingester","dai-smsi-PackageDeploy-4.0.0","2","9640/safi-smsi-server"),
   array("dai-smsi-relay","$tab;SMSI Relay","dai-smsi-relay-PackageDeploy-4.0.0","2","NA","NA"),
   array("smsi-msp-relay","$tab;SMSI MSP Relay","smsi-msp-relay-PackageDeploy-5.0.0","1","NA","NA"),
   array("dmp-config","$tab;DMP Config","dmp-config-PackageDeploy-5.0.0","1","NA","NA"),
   array("ads-core","ADS Core","ads-core-PackageDeploy-4.0.0","NA","NA","NA"),
   array("Dynamic-Ad-Insertion-engine","$tab;Decision Engine","DAI-DecisionEngine-PackageDeploy-4.0.0","5","9610/ads"),
   array("smsi-publisher","SMSI Publisher","smsi-publisher-PackageDeploy-4.0.0","2","9520/smsi-publisher/smsipub"),
   array("dai-national-cis","National CIS","DAI-national-cis-PackageDeploy-4.0.0","1","9575/nCisClient/"),
   array("POIS","POIS","POIS-PackageDeploy-5.0.0","1","NA","NA"),
   array("ad-load-manager","Ad Load Manager","ad-load-manager-PackageDeploy-4.0.0","1","NA","NA"),
   array("dai-metadata-ingestion","DAI MetaData Ingestion","dai-metadata-ingestion-PackageDeploy-4.0.0","2","NA"),
   array("request-mgr","Request Mgr","request-mgr-PackageDeploy-5.0.0","1","NA"),
   array("SDC-session-collector","SDC Session Collector","SDC-session-collector-PackageDeploy-5.0.0","1","NA"),
   array("impression_collector","Impression Collector","impression_collector-PackageDeploy-4.0.0","2","NA","NA")
   );

// The production_components array consists of
//  Col1 - Real Component Name
//  Col2 - Common name with capitalization
//  Col3 - PackageDeploy location for changes link
//  Col4 - Number of Application instances per component
//  Col4 - TCServer Instance names on Scrum systems
//  Col5 - Endpoint/Login link
$production_components = array
   (
   array("caas-core","CAAS Core","caas-core-PackageDeploy-4.0.0","NA","NA","NA"),
   array("Dynamic-Ad-Insertion-cm","$tab;Campaign Mgr","DAI-CampaignMgmt-PackageDeploy-4.0.0","1","9600/Dynamic-Ad-Insertion-cm/login/auth"),
   array("dai-cip","$tab;CIP Sender","dai-cip-PackageDeploy-4.0.0","NA","NA"),
   array("dai-cip-feedback","$tab;CIP Feedback","dai-cip-feedback-PackageDeploy-4.0.0","1","9300/cip-server"),
   array("acp","$tab;ACP","acp-PackageDeploy-4.0.0","1",""),
   array("Pgmr-Cpgn-Int","Programmers Campaign Interface","Pgmr-Cpgn-Int-PackageDeploy-4.0.0","1","NA"),
   array("metadata-publisher","$tab;MetaData Publisher","metadata-publisher_PackageDeploy-4.0.0","NA","NA"),
   array("dai-etl-feeder","ETL Feeder","dai-etl-feeder-PackageDeploy-4.0.0","NA","NA"),
   array("smsi_reporting","SMSI Reporting","smsi_reporting-PackageDeploy-5.0.0","NA","NA"),
   array("MicroDev","$tab;MicroStrategy","MicroStrategy-PackageDeploy-4.0.0","NA","NA"),
   array("dai-smsi","$tab;SMSI Ingester","dai-smsi-PackageDeploy-4.0.0","2","9640/safi-smsi-server"),
   array("dai-smsi-relay","$tab;SMSI Relay","dai-smsi-relay-PackageDeploy-4.0.0","2","NA","NA"),
   array("ads-core","ADS Core","ads-core-PackageDeploy-4.0.0","NA","NA","NA"),
   array("Dynamic-Ad-Insertion-engine","$tab;Decision Engine","DAI-DecisionEngine-PackageDeploy-4.0.0","5","9610/ads"),
   array("smsi-publisher","SMSI Publisher","smsi-publisher-PackageDeploy-4.0.0","2","9520/smsi-publisher/smsipub"),
   array("dai-national-cis","National CIS","DAI-national-cis-PackageDeploy-4.0.0","dai-national-cis","9575/nCisClient/"),
   array("impression-collector","Impression Collector","impression-collector-PackageDeploy-4.0.0","impression-collector",""),
   array("POIS","POIS","POIS-PackageDeploy-5.0.0","POIS",""),
   array("ad-load-manager","Ad Load Manager","ad-load-manager-PackageDeploy-4.0.0","ad-load-manager",""),
   array("dai-metadata-ingestion","DAI MetaData Ingestion","dai-metadata-ingestion-PackageDeploy-4.0.0","NA","NA")
   );

global $arrlength;
$arrlength = count($components);
global $performance_arrlength;
$performance_arrlength = count($performance_components);
global $zayo_perf_arrlength;
$zayo_perf_arrlength = count($zayo_perf_components);
global $l2l_arrlength;
$l2l_arrlength = count($lab2lab_components);
global $prod_arrlength;
$production_arrlength = count($production_components);

//  The Envs array consists of
//  Col1 - The directory name of the system.  Used to point the SCM Web for information.
//  Col2 - The url link to the base system
$envs = array
   (
    array("scrum1","http://cv-scrum01.cv.scrum"),
    array("scrum2","http://cv-scrum02.cv.scrum"),
    array("scrum3","http://cv-scrum03.cv.scrum"), 
    array("scrum4","http://cv-scrum04.cv.scrum"),
    array("devint","http://cv-devint.cv.scrum"),
//    array("rh65","http://10.13.18.19"),
);

//$envs = array(scrum1, scrum2, scrum3, scrum4, devint);
$grid_envs = array(devint, scrum1, scrum2, scrum3, scrum4, performance, base, fw, kodiak, coxlab, broadway, rentrak, production);
$rcr_envs = array(base, fw, kodiak, coxlab, broadway, rentrak);
$zayo_perf_envs = array(performance);
$lab_envs = array(base,fw,kodiak,coxlab,broadway,rentrak);
$prod_envs = array(production);
global $envlength;
$envlength = count($envs);

//for ($x=0; $x<$arrlength; $x++)
//{
//echo "Component: ".$components[$x][0]."<br>Common Name:  ".$components[$x][1]."<br>  PackageDeploy Job:  ".$components[$x][2]."<p>";
//$targ="scrum1";
//echo "$comp_dir=${targ}/".$components[$x][0]."<br>";

//}

?>
