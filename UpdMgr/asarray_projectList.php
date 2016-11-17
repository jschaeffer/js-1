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
   array("componentno1","$tab;Component No1","componentno1-PackageDeploy-5.15.0","1","","URL"),
   array("componentno2","$tab;Component No2","componentno2-PackageDeploy-5.0.0","NA",""),
   array("componentno3","$tab;Component No3","componentno3-PackageDeploy-5.0.0","NA","")
   );

// The Post Scrum Components array consists of
//  Col1 - Real Component Name
//  Col2 - Common name with capitalization
//  Col3 - PackageDeploy location for changes link
//  Col4 - Number of Application instances per component
//  Col4 - TCServer Instance names on Scrum systems
//  Col5 - Endpoint/Login link
$perf_components = array
   (
   array("componentno1","$tab;Component No1","componentno1-PackageDeploy-5.11.0","","",""),
   array("componentno2","$tab;Component No2","componentno2-PackageDeploy-5.0.0","","",""),
   array("componentno3","$tab;Component No3","componentno3-PackageDeploy-4.0.0","","","")
   );

$lab2lab_components = array
   (
   array("componentno1","$tab;Component No1","componentno1-PackageDeploy-5.4.0","",""),
   array("componentno2","$tab;Component No2","componentno2-PackageDeploy-5.0.0","",""),
   array("componentno3","$tab;Component No3","componentno3-PackageDeploy-4.0.0","","")
   );

$production_components = array
   (
   array("componentno1","$tab;Component No1","DAI-CampaignMgmt-PackageDeploy-4.0.0","1","9600/componentno1/login/auth"),
   array("componentno2","$tab;Component No2","componentno2-PackageDeploy-4.0.0","",""),
   array("componentno3","$tab;Component No3","componentno3-PackageDeploy-4.0.0","","")
   );

global $arrlength;
$arrlength = count($components);
global $performance_arrlength;
$performance_arrlength = count($perf_components);
global $perf_arrlength;
$perf_arrlength = count($perf_components);
global $l2l_arrlength;
$l2l_arrlength = count($lab2lab_components);
global $prod_arrlength;
$production_arrlength = count($production_components);

//  The Envs array consists of
//  Col1 - The directory name of the system.  Used to point the SCM Web for information.
//  Col2 - The url link to the base system
$envs = array
   (
    array("scrum1","http://scrum01.scrum"),
    array("scrum2","http://scrum02.scrum"),
    array("scrum3","http://scrum03.scrum"), 
    array("scrum4","http://scrum04.scrum"),
    array("devint","http://devint.scrum"),
);

//$envs = array(scrum1, scrum2, scrum3, scrum4, devint);
$grid_envs = array(devint, scrum1, scrum2, scrum3, scrum4, performance, lab1, lab2, production);
$perf_envs = array(performance);
$lab_envs = array(lab1, lab2);
$prod_envs = array(production);
global $envlength;
$envlength = count($envs);

?>
