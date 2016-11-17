<?php
// The Components array consists of 
//  Col1 - Real Component Name
//  Col2 - Common name with capitalization
//  Col3 - PackageDeploy location for changes link
//  Col4 - TCServer Instance names on Scrum systems
//  Col5 - Endpoint/Login link
$components = array
   (
   array("caas-core","CAAS Core","caas-core-PackageDeploy-4.0.0","NA","NA"),
   array("Dynamic-Ad-Insertion-cm","&nbsp;&nbsp;&nbsp;Campaign Mgr","DAI-CampaignMgmt-PackageDeploy-4.0.0","cm","9600/Dynamic-Ad-Insertion-cm/login/auth"),
   array("dai-cip","&nbsp;&nbsp;&nbsp;CIP Sender","dai-cip-PackageDeploy-4.0.0","NA","NA"),
   array("dai-cip-feedback","&nbsp;&nbsp;&nbsp;CIP Feedback","dai-cip-feedback-PackageDeploy-4.0.0","cip","9300/cip-server"),
   array("caas-admin","&nbsp;&nbsp;&nbsp;CAAS Admin","caas-admin-PackageDeploy-4.0.0","caas-admin","9475/caas-admin/login/auth"),
   array("dai_amm","&nbsp;&nbsp;&nbsp;Ad Map Mgr","dai_amm-PackageDeploy-4.0.0","dai_amm","9525/dai_amm/login/auth"),
   array("ops-dt","&nbsp;&nbsp;&nbsp;Ops DT","ops-dt-PackageDeploy-1.0.0","ops-dt","9510/ops-dt/login/auth"),
   array("ops-dce-safi-reporting-agent","&nbsp;&nbsp;&nbsp;SAFI Reporting Agent","ops-dce-safi-reporting-agent-PackageDeploy-1.0.0","dce-agent-002","NA"),
   array("ops-dce-scte-cfa-reporting-agent","&nbsp;&nbsp;&nbsp;SCTE Reporting Agent","ops-dce-scte-cfa-reporting-agent-PackageDeploy-1.0.0","dce-agent-001","NA"),
   array("dai-etl-feeder","ETL Feeder","dai-etl-feeder-PackageDeploy-4.0.0","NA","NA"),
   array("MicroDev","&nbsp;&nbsp;&nbsp;MicroStrategy","MicroStrategy-PackageDeploy-4.0.0","NA","NA"),
   array("dai-smsi","&nbsp;&nbsp;&nbsp;SMSI Sender","dai-smsi-PackageDeploy-4.0.0","smsi","9640/safi-smsi-server"),
   array("dai-smsi-relay","&nbsp;&nbsp;&nbsp;SMSI Relay","dai-smsi-relay-PackageDeploy-4.0.0","dai-smsi-relay","NA","NA"),
   array("dai-billing","&nbsp;&nbsp;&nbsp;DAI Billing","dai-billing-PackageDeploy-4.0.0","billing","9545/dai-billing"),
   array("smsi-admin","&nbsp;&nbsp;&nbsp;SMSI Admin","smsi-admin-PackageDeploy-4.0.0","smsi-admin","9440/smsi-admin/login/auth"),
   array("smsi-publisher","&nbsp;&nbsp;&nbsp;SMSI Publisher","smsi-publisher-PackageDeploy-4.0.0","smsipub","9520/smsi-publisher/smsipub"),
   array("ads-core","ADS Core","ads-core-PackageDeploy-4.0.0","NA","NA"),
   array("Dynamic-Ad-Insertion-engine","&nbsp;&nbsp;&nbsp;Decision Engine","DAI-DecisionEngine-PackageDeploy-4.0.0","ads","9610/ads"),
   array("Pgmr-Cpgn-Int","Programmers Campaign Interface","Pgmr-Cpgn-Int-PackageDeploy-4.0.0","Pgrm-Cpgn-Int","NA"),
   array("ops-dt-domain","DT Domain DB","ops-dt-domain-PackageDeploy-1.0.0","NA","NA"),
   array("ops-dce-metadata-agent","DCE Metadata Agent","ops-dce-metadata-agent-PackageDeploy-1.0.0","dce-mdata","NA"),
   array("dai-lincoln","DAI Lincoln","dai-lincoln-PackageDeploy-1.0.0","NA","NA"),
   array("crypt","EnCrypt","crypt","NA","NA"),
   array("oss_bar","OSS Bar","oss_bar-PackageDeploy-3.0.0","oss_bar","NA"),
   );

global $arrlength;
$arrlength = count($components);

//  The Envs array consists of
//  Col1 - The directory name of the system.  Used to point the SCM Web for information.
//  Col2 - The url link to the base system
//$envs = array
//    (
//    array("devint","http://10.13.18.113:.$components[$x][5]"),
//    array("scrum1","http://10.13.18.115:.$components[$x][5]"),
//    array("scrum2","http://10.13.18.115:.$components[$x][5]"),
//    array("scrum3","http://10.13.18.115:.$components[$x][5]"), 
//    array("Marley","http://10.13.18.115:.$components[$x][5]")
//    );
//    array("performance1, 
//    array("performance2, 
//    array("lab2lab, 
//    array("production
//    );
$envs = array(scrum1, scrum2, scrum3, Marley, performance, Lab2Lab, devint);
$aft_envs = array(performance, lab2lab, production);

//for ($x=0; $x<$arrlength; $x++)
//{
//echo "Component: ".$components[$x][0]."<br>Common Name:  ".$components[$x][1]."<br>  PackageDeploy Job:  ".$components[$x][2]."<p>";
//$targ="scrum1";
//echo "$comp_dir=${targ}/".$components[$x][0]."<br>";

//}


?>

