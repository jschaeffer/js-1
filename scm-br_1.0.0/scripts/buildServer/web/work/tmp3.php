<!DOCTYPE html>
<html>
<body>

<?php
// Two-dimensional arrays to capture information about the environment and components


$components = array
   (
   array("caas-core","CAAS Core","caas-core-PackageDeploy-4.0.0"),
   array("Dynamic-Ad-Insertion-cm","Campaign Mgr","DAI-CampaignMgmt-PackageDeploy-4.0.0"),
   array("dai-smsi-relay","DAI-SMSI-Relay","dai-smsi-relay-PackageDeploy-4.0.0"),
   array("ads-core","ADS Core","ads-core-PackageDeploy-4.0.0"), 
   array("oss_bar","OSS Bar","oss_bar-PackageDeploy-3.0.0"), 
   array("dai_amm","Ad Map Mgr","dai_amm-PackageDeploy-4.0.0"), 
   array("dai-billing","DAI Billing","dai-billing-PackageDeploy-4.0.0"), 
   array("dai-etl-feeder","ETL Feeder","dai-etl-feeder-PackageDeploy-4.0.0"), 
   array("dai-cip","CIP Sender","dai-cip-PackageDeploy-4.0.0"), 
   array("dai-cip-feedback","CIP Feedback","dai-cip-feedback-PackageDeploy-4.0.0"), 
   array("dai-smsi","SMSI Sender","dai-smsi-PackageDeploy-4.0.0"), 
   array("dai-lincoln","DAI Lincoln","dai-lincoln-PackageDeploy-1.0.0"), 
   array("smsi-admin","SMSI Admin","smsi-admin-PackageDeploy-4.0.0"), 
   array("smsi-publisher",SMSI Publisher","smsi-publisher-PackageDeploy-4.0.0"), 
   array("crypt",",EnCrypt",""), 
   array("Dynamic-Ad-Insertion-engine","Decision Engine","DAI-DecisionEngine-PackageDeploy-4.0.0"), 
   array("ops-dt","Ops DT","ops-dt-PackageDeploy-1.0.0"), 
   array("ops-dt-domain","DT Domain DB","ops-dt-domain-PackageDeploy-1.0.0"), 
   array("ops-dce-safi-reporting-agent","SAFI Reporting Agent","ops-dce-safi-reporting-agent-PackageDeploy-1.0.0"), 
   array("ops-dce-scte-cfa-reporting-agent","SCTE Reporting Agent","ops-dce-scte-cfa-reporting-agent-PackageDeploy-1.0.0"), 
   array("ops-dce-metadata-agent","DCE Metadata Agent","ops-dce-metadata-agent-PackageDeploy-1.0.0"), 
   array("caas-admin","CAAS Admin","caas-admin-PackageDeploy-4.0.0"), 
   array("Pgmr-Cpgn-Int","Programmers Campaign Interface","Pgmr-Cpgn-Int-PackageDeploy-4.0.0"), 
   array("dai-smsi-relay","SMSI Relay","dai-smsi-relay-PackageDeploy-4.0.0")
   );
  
echo "Component: ".$components[0][0]."   Recent Changes: ".$components[0][1].". PackageDeploy Job: ".$components[0][2]."<br>";
echo "Component: ".$components[1][0]."   Recent Changes: ".$components[1][1].". PackageDeploy Job: ".$components[1][2]."<br>";
echo "Component: ".$components[2][0]."   Recent Changes: ".$components[2][1].". PackageDeploy Job: ".$components[2][2]."<br>";
echo "Component: ".$components[3][0]." <br>";
echo "Component: ".$components[4][0]." <br>";
echo "Component: ".$components[5][0]." <br>";
echo "Component: ".$components[6][0]." <br>";
echo "Component: ".$components[7][0]." <br>";
echo "Component: ".$components[8][0]." <br>";
echo "Component: ".$components[9][0]." <br>";
echo "Component: ".$components[10][0]." <br>";
echo "Component: ".$components[11][0]." <br>";
echo "Component: ".$components[12][0]." <br>";
echo "Component: ".$components[13][0]." <br>";
echo "Component: ".$components[14][0]." <br>";
echo "Component: ".$components[15][0]." <br>";
echo "Component: ".$components[16][0]." <br>";
echo "Component: ".$components[17][0]." <br>";
echo "Component: ".$components[18][0]." <br>";
echo "Component: ".$components[19][0]." <br>";
echo "Component: ".$components[20][0]." <br>";
echo "Component: ".$components[21][0]." <br>";
echo "Component: ".$components[22][0]." <br>";
echo "Component: ".$components[23][0]." <br>";


$envs = array
   (
    array("devint"), 
    array("scrum1"),
    array("scrum2"), 
    array("scrum3"), 
    array("performance"), 
    array("lab2lab"), 
    array("production")
   );

?>
</body>
</html>


