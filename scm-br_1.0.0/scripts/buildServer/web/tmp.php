<html>
<head>
<TITLE>SCM Server - Scrum Update Manager</TITLE>
<script type="text/javascript">

function toggle_visibility(tbid,lnkid)
{
  var obj = document.getElementsByTagName("table");
  for(i=0;i<obj.length;i++)
  {
   if(obj[i].id && obj[i].id != tbid)
   {
    document.getElementById(obj[i].id).style.display = "none";
    x = obj[i].id.substring(3);
    document.getElementById("lnk"+x).value = "[+] Expand";
    }
   }
  if(document.all){document.getElementById(tbid).style.display = document.getElementById(tbid).style.display == "block" ? "none" : "block";}
  else{document.getElementById(tbid).style.display = document.getElementById(tbid).style.display == "table" ? "none" : "table";}
  document.getElementById(lnkid).value = document.getElementById(lnkid).value == "[-] Collapse" ? "[+] Expand" : "[-] Collapse";
 }
</script>

<link rel="stylesheet" type="text/css" href="buildServer.css" />
<?php include 'header.php'; ?>

<style type="text/css">
.tbl {display:none;}
.lnk {border:none;background:none;width:85px;}
td {FONT-SIZE: 75%; MARGIN: 0px; COLOR: #000000;}
td {FONT-FAMILY: verdana,helvetica,arial,sans-serif}
a {TEXT-DECORATION: none;}
</style>
</head>
<body>
<table border="1" align="center" cellpadding="4" cellspacing="0">
 <tr><th>Canoe Ventures - Scrum Environment Update Manager<br>Data Current as of : <?php include 'devint/dtupd.txt'; ?></th></tr>
 <table width="1200px" border="0" align="center" cellpadding="4" cellspacing="0">
  <tr height="1">
   <td bgcolor="#727272" colspan="3"></td>
  </tr>
  <tr bgcolor="#EEEEEE" height="15">
   <td><strong>Scrum 1</strong></td>
   <?php include 'scrum2/diskspace.txt'; ?> - Disk Space Used</td>
   <td bgcolor="#EEEEEE" align="right"><input class="lnk" id="lnk1" type="button" value="[+] Expand" onclick="toggle_visibility('tbl1','lnk1');"></td>
  </tr>
  <tr>
   <td colspan="6">
    <table width="100%" border="0" cellpadding="3" cellspacing="0" id="tbl1" class="tbl">
     <tr bgcolor="#EEEEEE">
      <td width="25%"><b><u>Component</b></u></td>
      <td width="15%"><b><u>Current Version/<br>Pkg. Download</b></u></td>
      <td width="15%"><b><u>Update Avail?</b></u></td>
      <td width="10%"><b><u>New Changes</b></u></td>
      <td width="10%"><b><u>Env. State</b></u>
      <td width="10%"><b><u>Log Space</b></u></td>
     </tr>
     <tr>
      <td>Dynamic-Ad-Insertion-cm</td>
      <?php 
       $component="Dynamic-Ad-Insertion-cm";
       $cmdev=file_get_contents('devint/newcm.txt', true); 
       $cmloc=file_get_contents('scrum1/newcm.txt', true); 
      //  $cmdev=shell_exec("ssh tcserver@dvappdai01 grep Implementation-Version /opt/tcserver/instances/cm/webapps/Dynamic-Ad-Insertion-cm/META-INF/MANIFEST.MF | cut -d : -f 2 | tr -d ' '  |tr -d '\r'"); 
     //  $cmloc=shell_exec("ssh tcserver@dvappdai02 grep Implementation-Version /opt/tcserver/instances/cm/webapps/Dynamic-Ad-Insertion-cm/META-INF/MANIFEST.MF | cut -d : -f 2 | tr -d ' '  |tr -d '\r'"); 
      ?>
      <?php 
        if ($cmdev > $cmloc) {
             $updavail = "Yes<br>$cmdev";
             $recentchg = "<a href=\"http://10.13.18.168:7001/view/DAI-CM/job/DAI-CampaignMgmt-PackageDeploy-4.0.0/changes\">Changes</a>";
        }
        else {
             $updavail = "No";
             $recentchg ="";
        }
       ?>

      <?php 
//        if ($cmdev > $cmloc) {
//             $updavail = "Yes<br><a href=\"java -jar tmp/jenkins-cli.jar -s http://10.13.18.168:7001 build dai_scm-PackageDeploy-4.0.0\">Update to $cmdev?</a>";
//             $recentchg = "<a href=\"http://10.13.18.168:7001/view/DevInt%20Env/job/DAI-CampaignMgmt-PackageDeploy-3.0.0/changes\">Changes</a>";
//        }
//        else {
//             $updavail = "No";
//             $recentchg ="";
//        }
//       ?>

      <td><a href="http://10.13.18.168/releaseTars/Dynamic-Ad-Insertion-cm/Dynamic-Ad-Insertion-cm_<?php echo "$cmloc" ?>.tar"><?php echo $cmloc ?></a></td>
      <td><?php echo "$updavail"?></td>
      <td><?php echo "$recentchg"?></td>
      <?php include 'devint/envstate.txt'; ?></font></td>
      <?php include 'devint/logspc.txt'; ?></font></td>
     </tr>
     <tr height="1">
      <td colspan="6" bgcolor="#CCCCCC"></td>
     </tr>
     <tr>

      <td>Dynamic-Ad-Insertion-engine</td>
      <?php $adsdev=shell_exec("ssh tcserver@dvappdai01 grep Implementation-Version /opt/tcserver/instances/ads/webapps/ads-3.0.0-SNAPSHOT/META-INF/MANIFEST.MF | cut -d : -f 2 | tr -d ' '  |tr -d '\r'"); ?>
      <?php $adsloc=shell_exec("ssh tcserver@dvappdai02 grep Implementation-Version /opt/tcserver/instances/ads/webapps/ads-3.0.0-SNAPSHOT/META-INF/MANIFEST.MF | cut -d : -f 2 | tr -d ' '  |tr -d '\r'"); ?>
      <?php
/*
        if ($adsdev > $adsloc) {
             $updavail = "Yes<br>Update to $adsdev?";
             $recentchg = "<a href=\"http://10.13.18.168:7001/view/DAI-DecEng/job/DAI-DecisionEngine-PackageDeploy-3.0.0/changes\">Changes</a>";
        }
        else {
             $updavail = "No";
             $recentchg ="";
        }
*/
       ?>
      <td><a href="http://10.13.18.168/releaseTars/Dynamic-Ad-Insertion-engine/Dynamic-Ad-Insertion-engine_<?php echo "$adsloc" ?>.tar"><?php echo $adsloc ?></a></td>
      <td><?php echo "$updavail"?></td>
      <td><?php echo "$recentchg"?></td>
      <td><a href="http://10.13.18.115:9610/ads-3.0.0-SNAPSHOT">URL</a></td>
     </tr>
     <tr height="1">
      <td colspan="6" bgcolor="#CCCCCC"></td>
     </tr>
     <tr>
      <td>CIP Feedback</td>
      <?php $cipdev=shell_exec("ssh tcserver@dvappdai01 grep Implementation-Version /opt/tcserver/instances/cip/webapps/cip-server-3.0.0-SNAPSHOT/META-INF/MANIFEST.MF | cut -d : -f 2 | tr -d ' '  |tr -d '\r'"); ?>
      <?php $ciploc=shell_exec("ssh tcserver@dvappdai02 grep Implementation-Version /opt/tcserver/instances/cip/webapps/cip-server-3.0.0-SNAPSHOT/META-INF/MANIFEST.MF | cut -d : -f 2 | tr -d ' '  |tr -d '\r'"); ?>
      <?php
/*
        if ($cipdev > $ciploc) {
             $updavail = "Yes<br>Update to $cipdev?";
             $recentchg = "<a href=\"http://10.13.18.168:7001/view/DAI-CIP/job/dai-cip-feedback-PackageDeploy-3.0.0/changes\">Changes</a>";
        }
        else {
             $updavail = "No";
             $recentchg ="";
        }
*/
       ?>
      <td><a href="http://10.13.18.168/releaseTars/dai-cip-feedback/dai-cip-feedback_<?php echo "$ciploc" ?>.tar"><?php echo $ciploc ?></a></td>
      <td><?php echo "$updavail"?></td>
      <td><?php echo "$recentchg"?></td>
      <td><a href="http://10.13.18.115:9300/cip-server-3.0.0-SNAPSHOT/">URL</a></td>
     </tr>
     <tr height="1">
      <td colspan="6" bgcolor="#CCCCCC"></td>
     </tr>
     <tr>
      <td>DAI-SMSI</td>
      <?php $smsidev=shell_exec("ssh tcserver@dvappdai01 grep Implementation-Version /opt/tcserver/instances/smsi/webapps/safi-smsi-server/META-INF/MANIFEST.MF | cut -d : -f 2 | tr -d ' '  |tr -d '\r'"); ?>
      <?php $smsiloc=shell_exec("ssh tcserver@dvappdai02 grep Implementation-Version /opt/tcserver/instances/smsi/webapps/safi-smsi-server/META-INF/MANIFEST.MF | cut -d : -f 2 | tr -d ' '  |tr -d '\r'"); ?>
      <?php
/*
        if ($smsidev > $smsiloc) {
             $updavail = "Yes<br>Update to $smsidev?";
             $recentchg = "<a href=\"http://10.13.18.168:7001/view/DAI_SMSI/job/dai-smsi-PackageDeploy-3.0.0/changes\">Changes</a>";
        }
        else {
             $updavail = "No";
             $recentchg ="";
        }
*/
       ?>
      <td><a href="http://10.13.18.168/releaseTars/dai-smsi/dai-smsi_<?php echo "$smsiloc" ?>.tar"><?php echo $smsiloc ?></a></td>
      <td><?php echo "$updavail"?></td>
      <td><?php echo "$recentchg"?></td>
      <td><a href="http://10.13.18.115:9640/safi-smsi-server/">URL</a></td>
     </tr>
     <tr height="1">
      <td colspan="6" bgcolor="#CCCCCC"></td>
     </tr>
     <tr>
      <td>SMSI-Admin</td>
      <?php $sadmindev=shell_exec("ssh tcserver@dvappdai01 grep Implementation-Version /opt/tcserver/instances/smsi-admin/webapps/smsi-admin/META-INF/MANIFEST.MF | cut -d : -f 2 | tr -d ' '  |tr -d '\r'"); ?>
      <?php $sadminloc=shell_exec("ssh tcserver@dvappdai03 grep Implementation-Version /opt/tcserver/instances/smsi-admin/webapps/smsi-admin/META-INF/MANIFEST.MF | cut -d : -f 2 | tr -d ' '  |tr -d '\r'"); ?>
      <?php
/*
        if ($sadmindev < $sadminloc) {
             $updavail = "Yes<br><a href=`java -jar /opt/tools/tmp/jenkins-cli.jar -s http://10.13.18.168:7001 build dai_scm-PackageDeploy-4.0.0`>Update to $sadmindev?</a>\"";
             $recentchg = "<a href=\"http://10.13.18.168:7001/view/DevInt%20Env/job/smsi-admin-PackageDeploy-3.0.0/changes\">Changes</a>";
        }
        else {
             $updavail = "No echo $sadmindev $sadminloc";
             $recentchg ="";
        }
*/
       ?>
      <td><a href="http://10.13.18.168/releaseTars/smsi-admin/smsi-admin_<?php echo "$sadminloc" ?>.tar"><?php echo $sadminloc ?></a></td>
      <td><?php echo "$updavail"?></td>
      <td><?php echo "$recentchg"?></td>
      <td><a href="http://10.13.18.115:9440/smsi-admin/">Login</a></td>
     </tr>
     <tr height="1">
      <td bgcolor="#CCCCCC" colspan="6"></td>
     </tr>
     <tr height="1">
      <td bgcolor="#727272" colspan="6"></td>
     </tr>
     <tr height="8">
      <td colspan="6"></td>
     </tr>
    </table>
   </td>
  </tr>
 </table>
 <table width="1200px" border="0" align="center" cellpadding="4" cellspacing="0">
  <tr height="1">
   <td bgcolor="#727272" colspan="3"></td>
  </tr>
  <tr bgcolor="#EEEEEE" height="15">
   <td colspan="2"><strong>Scrum 2</strong></td>
   <td bgcolor="#EEEEEE" align="right"><input class="lnk" id="lnk2" type="button" value="[+] Expand" onclick="toggle_visibility('tbl2','lnk2');"></td>
  </tr>
  <tr>
   <td colspan="3">
    <table width="100%" border="0" cellpadding="4" cellspacing="0" id="tbl2" name="tbl2" class="tbl">
     <tr>
      <td colspan="3">Short summary which describes Project 2.</td>
     </tr>
     <tr bgcolor="#EEEEEE">
      <td width="70%">File Name</td>
      <td width="15%">Size</td>
      <td  width="15%"></td>
     </tr>
     <tr>
      <td>Document 1 of the project 2.doc</td>
      <td>209.5 KB</td>
      <td><a href="#">Download</a></td>
     </tr>
     <tr height="1">
      <td colspan="3" bgcolor="#CCCCCC"></td>
     </tr>
     <tr>
      <td>Document 2 of the project 2.doc</td>
      <td>86 KB</td>
      <td><a href="#">Download</a></td>
     </tr>
     <tr height="1">
      <td colspan="3" bgcolor="#CCCCCC" ></td>
     </tr>
     <tr height="1">
      <td bgcolor="#CCCCCC" colspan="3"></td>
     </tr>
     <tr height="1">
      <td bgcolor="#727272" colspan="3"></td>
     </tr>
     <tr height="8">
      <td colspan="3"></td>
     </tr>
    </table>
   </td>
  </tr>
 </table>
 <table width="1200px" border="0" align="center" cellpadding="4" cellspacing="0">
  <tr height="1">
   <td bgcolor="#727272" colspan="3"></td>
  </tr>
  <tr bgcolor="#EEEEEE" height="15">
   <td colspan="2"><strong>Scrum 3</strong></td>
   <td bgcolor="#EEEEEE" align="right"><input class="lnk" id="lnk3" type="button" value="[+] Expand" onclick="toggle_visibility('tbl3','lnk3');"></td>
  </tr>
  <tr>
   <td colspan="3">
    <table width="100%" border="0" cellpadding="4" cellspacing="0" id="tbl3" name="tbl3" class="tbl">
     <tr>
      <td colspan="3">Short summary which describes Project 3.</td>
     </tr>
     <tr bgcolor="#EEEEEE">
      <td width="70%">File Name</td>
      <td width="15%">Size</td>
      <td  width="15%"></td>
     </tr>
     <tr>
      <td>Document 1 of the project 3.doc</td>
      <td>209.5 KB</td>
      <td><a href="#">Download</a></td>
     </tr>
     <tr height="1">
      <td colspan="3" bgcolor="#CCCCCC"></td>
     </tr>
     <tr>
      <td>Document 2 of the project 3.doc</td>
      <td>86 KB</td>
      <td><a href="#">Download</a></td>
     </tr>
     <tr height="1">
      <td colspan="3" bgcolor="#CCCCCC" ></td>
     </tr>
     <tr height="1">
      <td bgcolor="#CCCCCC" colspan="3"></td>
     </tr>
     <tr height="1">
      <td bgcolor="#727272" colspan="3"></td>
     </tr>
     <tr height="8">
      <td colspan="3"></td>
     </tr>
    </table>
   </td>
  </tr>
 </table>
</table>
</body>
</html> 
