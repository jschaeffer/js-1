<html>
<head>
    <title>Canoe SCM Server</title>
    <link rel="stylesheet" type="text/css" href="buildServer.css" />
</head>
<?php include 'header.php'; ?>
<body>
<h3>- Deployers select the column title link to go to the Jenkins Deploy Jobs tab specific to the Environment<br>
- Users can select the application links to go to the target environment application page<br></h3>
<hr>
<table align=left border=1>
  <colgroup style="background-color:#75A3A3;"></colgroup>
  <colgroup style="background-color:#FFD6AD;"></colgroup>
  <colgroup span="4" style="background-color:#FFF2D7;"></colgroup>
<tr><td colspan=6 align=left><h2>Application</h2></td></tr>
<tr>
<th>Name</th><th><a href="http://10.13.18.168:7001/view/DevInt%20Env/">DEVINT</a> <br>IP: 10.13.18.113</th>	<th><a href="http://10.13.18.168:7001/view/Scrum%201%20Env/">SCRUM 1</a><br>IP: 10.13.18.115</th><th><a href="http://10.13.18.168:7001/view/Scrum%202%20Env/">SCRUM 2</a><br>IP: 10.13.18.116</th>	<th><a href="http://10.13.18.168:7001/view/Scrum%203%20Env/">SCRUM 3</a><br>IP: 10.13.18.117</th><th><a href="http://10.13.18.168:7001/view/Scrum%204%20Env/">SCRUM 4</a><br>IP: 10.13.18.1xx</th></tr>
<tr>
<td>Campaign Manager</td>
<td><a href="http://10.13.18.113:9600/Dynamic-Ad-Insertion-cm-3.0.0"><?php include "devint/cm.txt"; ?></a><br>*<a href=http://10.13.18.168:7001/view/DAI/job/DAI-CampaignMgmt-NightlyBuild-3.0.0/changes>(Recent Changes)</a>
		</td><td><a href="http://10.13.18.115:9600/Dynamic-Ad-Insertion-cm-3.0.0"><?php include "scrum1/cm.txt"; ?></a></td>
					<td><a href="http://10.13.18.116:9600/Dynamic-Ad-Insertion-cm-3.0.0"><?php include "scrum2/cm.txt"; ?></a></td>
								<td><a href="http://10.13.18.117:9600/Dynamic-Ad-Insertion-cm-3.0.0"><?php include "scrum3/cm.txt"; ?></td>
                                                                <td><a href="http://10.13.18.1xx:9600/Dynamic-Ad-Insertion-cm-3.0.0"><?php include "scrum4/cm.txt"; ?></td></tr>
<tr>
<td>Decision Engine</td>
<td><a href="http://10.13.18.113:9610/ads-3.0.0-SNAPSHOT"><?php include "devint/de.txt"; ?>ads</a><br>
<a href="http://10.13.18.113:9620/ads-3.0.0-SNAPSHOT"><?php include "devint/de.txt"; ?>psn</a><br>*<a href=http://10.13.18.168:7001/view/DAI/job/DAI-DecisionEngine-NightlyBuild-3.0.0/changes>(Recent Changes)</a></td>
                <td><a href="http://10.13.18.115:9610/ads-3.0.0-SNAPSHOT"><?php include "scrum1/de.txt"; ?>ads</a><br>
		<a href="http://10.13.18.115:9620/ads-3.0.0-SNAPSHOT"><?php include "scrum1/de.txt"; ?>psn</a></td>
                                        <td><a href="http://10.13.18.116:9610/ads-3.0.0-SNAPSHOT"><?php include "scrum2/de.txt"; ?>ads</a><br>
					<a href="http://10.13.18.116:9620/ads-3.0.0-SNAPSHOT"><?php include "scrum2/de.txt"; ?>psn</a></td>
                                                                <td><a href="http://10.13.18.117:9610/ads-3.0.0-SNAPSHOT"><?php include "scrum3/de.txt"; ?>ads</a><br>
								<a href="http://10.13.18.117:9620/ads-3.0.0-SNAPSHOT"><?php include "scrum3/de.txt"; ?>psn</a>
</td>
                                                                <td><a href="http://10.13.18.1xx:9610/ads-3.0.0-SNAPSHOT"><?php include "scrum4/de.txt"; ?>ads</a><br>
                                                                <a href="http://10.13.18.1xx:9620/ads-3.0.0-SNAPSHOT"><?php include "scrum4/de.txt"; ?>psn</a>
</td>
</tr><tr>
<td>ETL Feeder</td>
<td><?php include "devint/etl.txt"; ?><br>*<a href=http://10.13.18.168:7001/view/DevInt%20Env/job/dai-etl-feeder-NightlyBuild-1.0.0/changes>(Recent Changes)</a>
                </td><td><?php include "scrum1/etl.txt"; ?></td>
                                        <td><?php include "scrum2/etl.txt"; ?></td>
                                                                <td><?php include "scrum3/etl.txt"; ?></td>
								<td><?php include "scrum4/etl.txt"; ?></td>
</tr><tr>
<td>Lincoln LogSplitter</td>
<td><?php include "devint/log.txt"; ?><br>*<a href=http://10.13.18.168:7001/view/DevInt%20Env/job/dai-lincoln-NightlyBuild-1.0.0/changes>(Recent Changes)</a>
                </td><td><?php include "scrum1/log.txt"; ?></td>
                                        <td><?php include "scrum2/log.txt"; ?></td>
                                                                <td><?php include "scrum3/log.txt"; ?></td>
								<td><?php include "scrum4/log.txt"; ?></td>
</tr><tr>
<td>Reporting</td>
<td><a href="http://10.13.18.113:9750/dai_reporting/"><?php include "devint/rpt.txt"; ?></a><br>*<a href=http://10.13.18.168:7001/view/DevInt%20Env/job/dai_reporting-NightlyBuild-1.0.0/changes>(Recent Changes)</a>
                </td><td><a href="http://10.13.18.115:9750/dai_reporting/"><?php include "scrum1/rpt.txt"; ?></a></td>
                                        <td><a href="http://10.13.18.116:9750/dai_reporting/"><?php include "scrum2/rpt.txt"; ?></a></td>
                                                                <td><a href="http://10.13.18.117:9750/dai_reporting/"><?php include "scrum3/rpt.txt"; ?></a></td>
                                                                <td><a href="http://10.13.18.1xx:9750/dai_reporting/"><?php include "scrum4/rpt.txt"; ?></a></td>
</tr><tr>
<td>CIP Feedback</td>
<td><a href="http://10.13.18.113:9300/cip-server-3.0.0-SNAPSHOT/"><?php include "devint/cip-feedback.txt"; ?></a><br>*<a href=http://10.13.18.168:7001/view/DevInt%20Env/job/dai-cip-feedback-NightlyBuild-3.0.0/changes>(Recent Changes)</a>
                </td><td><a href="http://10.13.18.115:9300/cip-server-3.0.0-SNAPSHOT/"><?php include "scrum1/cip-feedback.txt"; ?></a></td>
                                        <td><a href="http://10.13.18.116:9300/cip-server-3.0.0-SNAPSHOT/"><?php include "scrum2/cip-feedback.txt"; ?></a>
</td>
                                                                <td><a href="http://10.13.18.117:9300/cip-server-3.0.0-SNAPSHOT/"><?php include "scrum3/cip-feedback.txt"; ?></a></td>
                                                                <td><a href="http://10.13.18.1xx:9300/cip-server-3.0.0-SNAPSHOT/"><? php include "scrum4/cip-feedback.txt"; ?></a></td>

</tr><tr>
<td>CIP Sender</td>
<td><?php include "devint/cip.txt"; ?><br>*<a href=http://10.13.18.168:7001/view/DevInt%20Env/job/dai-cip-NightlyBuild-2.0.0/changes>(Recent Changes)</a>
                </td><td><?php include "scrum1/cip.txt"; ?></td>
                                        <td><?php include "scrum2/cip.txt"; ?></td>
                                                                <td><?php include "scrum3/cip.txt"; ?></td>
                                                                <td><?php include "scrum4/cip.txt"; ?></td>
</tr><tr>
<td>DAI SMSI</td>
<td><?php include "devint/smsi.txt"; ?><br>*<a href=http://10.13.18.168:7001/view/DevInt%20Env/job/dai-smsi-NightlyBuild-3.0.0/changes>(Recent Changes)</a>
                </td><td><?php include "scrum1/smsi.txt"; ?></td>
                                        <td><?php include "scrum2/smsi.txt"; ?></td>
                                                                <td><?php include "scrum3/smsi.txt"; ?></td>
                                                                <td><?php include "scrum4/smsi.txt"; ?></td>
</tr><tr>
<td>Canoe-ux</td>
<td><a href="http://10.13.18.113:9500/canoe-ux-1.6.0/"><?php include "devint/ux.txt"; ?></a><br>*<a href=http://10.13.18.168:7001/view/Canoe-Ux/job/canoe-ux-compile-1.6.0/changes>(Recent Changes)</a>
                </td><td>NA</td><td>NA</td><td>NA</td><td>NA</td>
</tr><tr>
<td>OSS BAR</td>
<td><a href="http://10.13.18.113:9700/oss_bar/login/auth"><?php include "devint/bar.txt"; ?></a><br>*<a href=http://10.13.18.168:7001/view/OSS/job/oss_bar-NightlyBuild-1.1.0/changes>(Recent Changes)</a>
                </td><td><?php include "scrum1/bar.txt"; ?></td>
                                        <td><?php include "scrum2/bar.txt"; ?></td>
                                                                <td><a href="http://10.13.18.117:9700/oss_bar/login/auth"><?php include "scrum3/bar.txt"; ?></a></td>
                                                                <td><a href="http://10.13.18.1:9700/oss_bar/login/auth"><?php include "scrum4/bar.txt"; ?></a></td>

</tr><tr>
<td>Ad Map Mgr</td>
<td><?php include "devint/amm.txt"; ?>
                </td><td><?php include "scrum1/amm.txt"; ?></td>
                                        <td><?php include "scrum2/amm.txt"; ?></td>
                                                                <td><?php include "scrum3/amm.txt"; ?></td>
                                                                <td><?php include "scrum4/amm.txt"; ?></td>
</tr><tr>
<td>Crypt</td>
<td><?php include "devint/cry.txt"; ?>
                </td><td><?php include "scrum1/cry.txt"; ?></td>
                                        <td><?php include "scrum2/cry.txt"; ?></td>
                                                                <td><?php include "scrum3/cry.txt"; ?></td>
                                                                <td><?php include "scrum4/cry.txt"; ?></td>
</tr> <tr>
<td colspan=6 align=left><h2>Database</h2></td>
</tr>
<tr>
<th>Name</th><th>DEVINT <br>IP: 10.13.18.111</th> <th>SCRUM 1<br>IP: 10.13.18.119</th><th>SCRUM 2<br>IP: 10.13.18.120</th> <th>SCRUM 3<br>IP: 10.13.18.121</th><th>SCRUM 4<br>IP: 10.13.18.1xx</th>
</tr><tr>
<td>Core DB</td>
<td><?php include "devint/core.txt"; ?><br>*<a href=http://10.13.18.168:7001/view/DAI/job/DAI-Core-NightlyBuild-3.0.0/changes>(Recent Changes)</a>
                </td><td><?php include "scrum1/core.txt"; ?></td>
                                        <td><?php include "scrum2/core.txt"; ?></td>
                                                                <td><?php include "scrum3/core.txt"; ?></td>
                                                                <td><?php include "scrum3/core.txt"; ?></td>
</tr><tr>
<td>DAI SMSI</td>
<td><?php include "devint/smsidb.txt"; ?>
                </td><td><?php include "scrum1/smsidb.txt"; ?></td>
                                        <td><?php include "scrum2/smsidb.txt"; ?></td>
                                                                <td><?php include "scrum3/smsidb.txt"; ?></td></tr>
<tr>
<td>ETL/Report DB</td>
<td><?php include "devint/etldb.txt"; ?>
                </td><td><?php include "scrum1/etldb.txt"; ?></td>
                                        <td><?php include "scrum2/etldb.txt"; ?></td>
                                                                <td><?php include "scrum3/etldb.txt"; ?></td></tr>
<tr>
<td>BAR DB</td>
<td><?php include "devint/bardb.txt"; ?>
                </td><td><?php include "scrum1/bardb.txt"; ?></td>
                                        <td><?php include "scrum2/bardb.txt"; ?></td>
                                                                <td><?php include "scrum3/bardb.txt"; ?></td></tr>
<tr>
<td>Ad Map Mgr DB</td>
<td><?php include "devint/ammdb.txt"; ?>
                </td><td><?php include "scrum1/ammdb.txt"; ?></td>
                                        <td><?php include "scrum2/ammdb.txt"; ?></td>
                                                                <td><?php include "scrum3/ammdb.txt"; ?></td></tr>
</table>
</body>
</html>
