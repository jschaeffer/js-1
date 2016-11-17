<html>
<head>
    <title>Canoe SCM Server</title>
    <link rel="stylesheet" type="text/css" href="buildServer.css" />
</head>
<?php include 'header.php'; ?>
<body>
<h3>- Deployers select the column title link to go to the Jenkins Deploy Jobs tab specific to the Environment<br>
- Users can select the application links to go to the target environment application page<br>
- PackageDeploy Jenkins jobs will display package name</h3>
<hr>
<table align=left border=1>
  <colgroup style="background-color:#75A3A3;"></colgroup>
  <colgroup style="background-color:#FFD6AD;"></colgroup>
  <colgroup span="4" style="background-color:#FFF2D7;"></colgroup>
<tr><td colspan=6 align=left><h2>Database</h2></td></tr>
<tr>
<th>Name</th>
<th><a href="http://10.13.18.168:7001/view/DevInt%20Env/">DEVINT</a><br>IP: 10.13.18.111</th> 
<th><a href="http://10.13.18.168:7001/view/Scrum%201%20Env/">SCRUM 1</a><br>IP: 10.13.18.119</th>
<th><a href="http://10.13.18.168:7001/view/Scrum%202%20Env/">SCRUM 2</a><br>IP: 10.13.18.120</th> 
<th><a href="http://10.13.18.168:7001/view/Scrum%203%20Env/">SCRUM 3</a><br>IP: 10.13.18.121</th>
<th><a href="http://10.13.18.168:7001/view/MicroDev_DB/">MicroDev</a><br>IP: 10.13.18.55</th>
</tr>
<tr>
<td>Core DB</td>
<td><?php include "devint/core.txt"; ?><br>*<a href=http://10.13.18.168:7001/view/DevInt%20Env/job/DAI-Core-NightlyBuild-3.0.0/changes>(Recent Changes)</a></td>
<td><?php include "scrum1/core.txt"; ?></td>
<td><?php include "scrum2/core.txt"; ?></td>
<td><?php include "scrum3/core.txt"; ?></td>
<td><?php include "MicroDev/core.txt"; ?></td>
</tr>
<tr>
<td>ETL/Report DB</td>
<td><?php include "devint/etldb.txt"; ?><br>*<a href=http://10.13.18.168:7001/view/DevInt%20Env/job/dai-etl-feeder-NightlyBuild-3.0.0/changes>(Recent Changes)</a>
</td><td><?php include "scrum1/etldb.txt"; ?></td>
<td><?php include "scrum2/etldb.txt"; ?></td>
<td><?php include "scrum3/etldb.txt"; ?></td>
<td><?php include "MicroDev/etl.txt"; ?></td>
</tr>
<tr>
<td>BAR DB</td>
<td><?php include "devint/bar.txt"; ?><br>*<a href=http://10.13.18.168:7001/view/DevInt%20Env/job/oss_bar-PackageDeploy-3.0.0/changes>(Recent Changes)</a>
</td><td><?php include "scrum1/bardb.txt"; ?></td>
<td><?php include "scrum2/bar.txt"; ?></td>
<td><?php include "scrum3/bar.txt"; ?></td>
<td><?php include "MicroDev/bar.txt"; ?></td>
</tr>
<tr>
<td>DAI Billing</td>
<td><?php include "devint/bill.txt"; ?><br>*<a href=http://10.13.18.168:7001/view/DevInt%20Env/job/dai-billing-PackageDeploy-3.0.0/changes>(Recent Changes)</a></td>
<td><?php include "scrum1/bill.txt"; ?></td>
<td><?php include "scrum2/bill.txt"; ?></td>
<td><?php include "scrum3/bill.txt"; ?></td>
<td><?php include "MicroDev/bill.txt"; ?></td>
</tr>
<tr>
<td>Ops DT</td>
<td><?php include "devint/opsdt.txt"; ?>
<br>*<a href=http://10.13.18.168:7001/view/Ops-ServAssur/job/ops-dt-PackageDeploy-1.0.0/changes>(Recent Changes)</a></td>
<td><?php include "scrum1/opsdt.txt"; ?></td>
<td><?php include "scrum2/opsdt.txt"; ?></td>
<td><?php include "scrum3/opsdt.txt"; ?></td>
</tr>
<tr>
<td>SMSI Publisher</td>
<td><?php include "devint/smsipub.txt"; ?>
<br>*<a href=http://10.13.18.168:7001/view/DAI_SMSI/job/smsi-publisher-PackageDeploy-3.0.0/changes>(Recent Changes)</a></td>
<td><?php include "scrum1/smsipub.txt"; ?></td>
<td><?php include "scrum2/smsipub.txt"; ?></td>
<td><?php include "scrum3/smsipub.txt"; ?></td>
</tr>
<tr>
<tr><td colspan=6 align=left><h2>Application</h2></td></tr>
<th>Name</th>
<th><a href="http://10.13.18.168:7001/view/DevInt%20Env/">DEVINT</a> <br>IP: 10.13.18.113</th>	
<th><a href="http://10.13.18.168:7001/view/Scrum%201%20Env/">SCRUM 1</a><br>IP: 10.13.18.115</th>
<th><a href="http://10.13.18.168:7001/view/Scrum%202%20Env/">SCRUM 2</a><br>IP: 10.13.18.116</th>	
<th><a href="http://10.13.18.168:7001/view/Scrum%203%20Env/">SCRUM 3</a><br>IP: 10.13.18.117</th>
<th><a href="http://10.13.18.168:7001/view/Scrum%204%20Env/">SCRUM 4</a><br>IP: 10.13.18.1xx</th>
</tr>
<tr>
<td>Campaign Manager</td>
<td><a href="http://10.13.18.113:9600/Dynamic-Ad-Insertion-cm"><?php include "devint/cm.txt"; ?></a><br>*<a href=http://10.13.18.168:7001/view/DevInt%20Env/job/DAI-CampaignMgmt-PackageDeploy-3.0.0/changes>(Recent Changes)</a></td>
<td><a href="http://10.13.18.115:9600/Dynamic-Ad-Insertion-cm"><?php include "scrum1/cm.txt"; ?></a></td>
<td><a href="http://10.13.18.116:9600/Dynamic-Ad-Insertion-cm"><?php include "scrum2/cm.txt"; ?></a></td>
<td><a href="http://10.13.18.117:9600/Dynamic-Ad-Insertion-cm"><?php include "scrum3/cm.txt"; ?></td>
<td><a href="http://10.13.18.1xx:9600/Dynamic-Ad-Insertion-cm"><?php include "scrum4/cm.txt"; ?></td>
</tr>
<tr>
<td>Decision Engine</td>
<td><a href="http://10.13.18.113:9610/ads"><?php include "devint/de.txt"; ?>ads</a><br>
<a href="http://10.13.18.113:9620/ads"><?php include "devint/de.txt"; ?>psn</a><br>
*<a href=http://10.13.18.168:7001/view/DevInt%20Env/job/DAI-DecisionEngine-NightlyBuild-3.0.0/changes>(Recent Changes)</a></td>
<td><a href="http://10.13.18.115:9610/ads"><?php include "scrum1/de.txt"; ?>ads</a><br>
<a href="http://10.13.18.115:9620/ads"><?php include "scrum1/de.txt"; ?>psn</a></td>
<td><a href="http://10.13.18.116:9610/ads"><?php include "scrum2/de.txt"; ?>ads</a><br>
<a href="http://10.13.18.116:9620/ads"><?php include "scrum2/de.txt"; ?>psn</a></td>
<td><a href="http://10.13.18.117:9610/ads"><?php include "scrum3/de.txt"; ?>ads</a><br>
<a href="http://10.13.18.117:9620/ads"><?php include "scrum3/de.txt"; ?>psn</a></td>
</tr>
<tr>
<td>ETL Feeder</td>
<td><?php include "devint/etl.txt"; ?><br>*<a href=http://10.13.18.168:7001/view/DevInt%20Env/job/dai-etl-feeder-NightlyBuild-3.0.0/changes>(Recent Changes)</a>
</td><td><?php include "scrum1/etl.txt"; ?></td>
<td><?php include "scrum2/etl.txt"; ?></td>
<td><?php include "scrum3/etl.txt"; ?></td></tr>
<tr>
<td>Lincoln LogSplitter</td>
<td><?php include "devint/log.txt"; ?><br>*<a href=http://10.13.18.168:7001/view/DevInt%20Env/job/dai-lincoln-NightlyBuild-1.0.0/changes>(Recent Changes)</a></td>
<td><?php include "scrum1/log.txt"; ?></td>
<td><?php include "scrum2/log.txt"; ?></td>
<td><?php include "scrum3/log.txt"; ?></td>
</tr>
<tr>
<td>CAAS Admin</td>
<td><a href="http://10.13.18.113:9475/caas-admin/"><?php include "devint/ca.txt"; ?></a><br>*<a href=http://10.13.18.168:7001/view/CAAS%20Jobs/job/caas-admin-PackageDeploy-4.0.0/changes>(Recent Changes)</a></td>
<td><a href="http://10.13.18.115:9475/caas-admin/"><?php include "scrum1/ca.txt"; ?></a></td>
<td><a href="http://10.13.18.116:9475/caas-admin/"><?php include "scrum2/ca.txt"; ?></a></td>
<td><a href="http://10.13.18.117:9475/caas-admin/"><?php include "scrum3/ca.txt"; ?></a></td>
</tr>
<tr>
<td>CIP Feedback</td>
<td><a href="http://10.13.18.113:9300/cip-server-3.0.0-SNAPSHOT/"><?php include "devint/cip-feedback.txt"; ?></a><br>*<a href=http://10.13.18.168:7001/view/DevInt%20Env/job/dai-cip-feedback-NightlyBuild-3.0.0/changes>(Recent Changes)</a></td>
<td><a href="http://10.13.18.115:9300/cip-server-3.0.0-SNAPSHOT/"><?php include "scrum1/cip-feedback.txt"; ?></a></td>
<td><a href="http://10.13.18.116:9300/cip-server-3.0.0-SNAPSHOT/"><?php include "scrum2/cip-feedback.txt"; ?></a></td>
<td><a href="http://10.13.18.117:9300/cip-server-3.0.0-SNAPSHOT/"><?php include "scrum3/cip-feedback.txt"; ?></a></td>
</tr>
<tr>
<td>CIP Sender</td>
<td><?php include "devint/cip.txt"; ?><br>*<a href=http://10.13.18.168:7001/view/DevInt%20Env/job/dai-cip-NightlyBuild-2.0.0/changes>(Recent Changes)</a></td>
<td><?php include "scrum1/cip.txt"; ?></td>
<td><?php include "scrum2/cip.txt"; ?></td>
<td><?php include "scrum3/cip.txt"; ?></td>
</tr>
<tr>
<td>DAI SMSI</td>
<td><a href=http://10.13.18.113:9640/safi-smsi-server/><?php include "devint/smsi.txt"; ?></a><br>*<a href=http://10.13.18.168:7001/view/DevInt%20Env/job/dai-smsi-NightlyBuild-3.0.0/changes>(Recent Changes)</a></td>
<td><a href=http://10.13.18.115:9640/safi-smsi-server/><?php include "scrum1/smsi.txt"; ?></a></td>
<td><a href=http://10.13.18.116:9640/safi-smsi-server/><?php include "scrum2/smsi.txt"; ?></td>
<td><a href=http://10.13.18.117:9640/safi-smsi-server/><?php include "scrum3/smsi.txt"; ?></td>
</tr>
<tr>
<td>SMSI Admin</td>
<td><a href=http://10.13.18.113:9440/smsi-admin><?php include "devint/smsi-admin.txt"; ?></a><br>*<a href=http://10.13.18.168:7001/view/DevInt%20Env/job/smsi-admin-PackageDeploy-3.0.0/changes>(Recent Changes)</a></td>
<td><a href=http://10.13.18.115:9440/smsi-admin><?php include "scrum1/smsi-admin.txt"; ?></a></td>
<td><a href=http://10.13.18.116:9440/smsi-admin><?php include "scrum2/smsi-admin.txt"; ?></td>
<td><a href=http://10.13.18.117:9440/smsi-admin><?php include "scrum3/smsi-admin.txt"; ?></td>
</tr>
<tr>
<td>DAI Billing</td>
<td><a href=http://10.13.18.113:9545/dai-billing><?php include "devint/bill.txt"; ?></a><br>*<a href=http://10.13.18.168:7001/view/DevInt%20Env/job/dai-billing-PackageDeploy-3.0.0/changes>(Recent Changes)</a></td>
<td><a href=http://10.13.18.115:9545/dai-billing><?php include "scrum1/bill.txt"; ?></a></td>
<td><a href=http://10.13.18.116:9545/dai-billing><?php include "scrum2/bill.txt"; ?></td>
<td><a href=http://10.13.18.117:9545/dai-billing><?php include "scrum3/bill.txt"; ?></td>
</tr>
<tr>
<td>Canoe-ux</td>
<td><a href="http://10.13.18.113:9500/canoe-ux-1.6.0/"><?php include "devint/ux.txt"; ?></a><br>*<a href=http://10.13.18.168:7001/view/DevInt%20Env/job/canoe-ux-NightlyBuild-1.6.0/changes>(Recent Changes)</a></td>
<td>NA</td><td>NA</td><td>NA</td>
</tr>
<tr>
<td>OSS BAR</td>
<td><a href="http://10.13.18.113:9700/oss_bar/login/auth"><?php include "devint/bar.txt"; ?></a><br>*<a href=http://10.13.18.168:7001/view/DevInt%20Env/job/oss_bar-PackageDeploy-1.2.0/changes>(Recent Changes)</a></td>
$myvar = 3.0.0_xxx
<td><a href="http://10.13.18.115:9700/oss_bar/login/auth"><?php include "scrum1/bar.txt"; ?></a></td>
<td><a href="http://10.13.18.116:9700/oss_bar/login/auth"><?php include "scrum2/bar.txt"; ?></a></td>
<td><a href="http://10.13.18.117:9700/oss_bar/login/auth"><?php echo "$myvar"; ?></a></td>
</tr>
<tr>
<td>Ops DT</td>
<td><a href="http://10.13.18.113:9510/ops-dt/login/auth"><?php echo"ops-dt-" . shell_exec("ssh tcserver@dvappdai01 grep Implementation-Version /opt/tcserver/instances/ops-dt/webapps/ops-dt/META-INF/MANIFEST.MF | cut -d : -f 2 | tr -d ' '  |tr -d '\r'"); ?></a>
<br>*<a href=http://10.13.18.168:7001/view/Ops-ServAssur/job/ops-dt-PackageDeploy-1.0.0/changes>(Recent Changes)</a></td>
<td><a href="http://10.13.18.115:9510/ops-dt/login/auth"><?php echo"ops-dt-" . shell_exec("ssh tcserver@dvappdai02 grep Implementation-Version /opt/tcserver/instances/ops-dt/webapps/ops-dt/META-INF/MANIFEST.MF | cut -d : -f 2 | tr -d ' '  |tr -d '\r'"); ?></a></td>
<td><a href="http://10.13.18.116:9510/ops-dt/login/auth"><?php echo"ops-dt-" . shell_exec("ssh tcserver@dvappdai03 grep Implementation-Version /opt/tcserver/instances/ops-dt/webapps/ops-dt/META-INF/MANIFEST.MF | cut -d : -f 2 | tr -d ' '  |tr -d '\r'"); ?></a></td>
<td><a href="http://10.13.18.117:9510/ops-dt/login/auth"><?php echo"ops-dt-" . shell_exec("ssh tcserver@dvappdai04 grep Implementation-Version /opt/tcserver/instances/ops-dt/webapps/ops-dt/META-INF/MANIFEST.MF | cut -d : -f 2 | tr -d ' '  |tr -d '\r'"); ?></a></td>
</tr>
<tr>
<td>SMSI Publisher</td>
<td><a href="http://10.13.18.113:9520/smsi-publisher/smsipub/"><?php echo"smsi-publisher-" . shell_exec("ssh tcserver@dvappdai01 grep Implementation-Version /opt/tcserver/instances/smsipub/webapps/smsi-publisher/META-INF/MANIFEST.MF | cut -d : -f 2 | tr -d ' '  | tr -d '\r'"); ?></a>
<br>*<a href=http://10.13.18.168:7001/view/DAI_SMSI/job/smsi-publisher-PackageDeploy-3.0.0/changes>(Recent Changes)</a></td>
<td><a href="http://10.13.18.115:9520/smsi-publisher/smsipub"><?php echo"smsi-publisher-" . shell_exec("ssh tcserver@dvappdai02 grep Implementation-Version /opt/tcserver/instances/smsipub/webapps/smsi-publisher/META-INF/MANIFEST.MF | cut -d : -f 2 | tr -d ' '  |tr -d '\r'"); ?></a></td>
<td><a href="http://10.13.18.116:9520/smsi-publisher/smsipub"><?php echo"smsi-publisher-" . shell_exec("ssh tcserver@dvappdai03 grep Implementation-Version /opt/tcserver/instances/smsipub/webapps/smsi-publisher/META-INF/MANIFEST.MF | cut -d : -f 2 | tr -d ' '  |tr -d '\r'"); ?></a></td>
<td><a href="http://10.13.18.117:9520/smsi-publisher/smsipub"><?php echo"smsi-publisher-" . shell_exec("ssh tcserver@dvappdai04 grep Implementation-Version /opt/tcserver/instances/smsipub/webapps/smsi-publisher/META-INF/MANIFEST.MF | cut -d : -f 2 | tr -d ' '  |tr -d '\r'"); ?></a></td>
</tr>
<tr>
<td>Ad Map Mgr</td>
<td><?php echo "na-" . shell_exec("ssh tcserver@dvappdai01 grep Implementation-Version /opt/tcserver/instances/cip/webapps/cip-server*/META-INF/MANIFEST.MF | cut -d : -f 2 | tr -d ' '  | tr -d '\r'"); ?><?php include "devint/amm.txt"; ?></td>
<td><?php include "scrum1/amm.txt"; ?></td>
<td><?php include "scrum2/amm.txt"; ?></td>
<td><?php include "scrum3/amm.txt"; ?></td>
</tr>
<tr>
<td>Crypt</td>
<td><?php include "devint/cry.txt"; ?></td>
<td><?php include "scrum1/cry.txt"; ?></td>
<td><?php include "scrum2/cry.txt"; ?></td>
<td><?php include "scrum3/cry.txt"; ?></td>
</tr>
</table>
</body>
</html>
