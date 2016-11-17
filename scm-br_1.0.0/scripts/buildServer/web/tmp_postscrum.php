<html>
<head>
    <title>Canoe SCM Server</title>
    <link rel="stylesheet" type="text/css" href="buildServer.css" />
</head>
<?php include 'header.php'; ?>
<body>
<h3>- Deployers select the column title link to go to the Jenkins Deploy Jobs tab specific to the Environment<br>
- Users can select the application links to go to the target environment application page<br>
- PackageDeploy Jenkins jobs will display package name<br>
- <a href="disp_all.php">Scrum Enviroments</a></h3>
<hr>
<table align=left border=1>
  <colgroup style="background-color:#75A3A3;"></colgroup>
  <colgroup span="10" style="background-color:#FFF2D7;"></colgroup>
<tr><td colspan=12 align=left><h2>Database</h2></td></tr>
<tr>
<th>Name</th>
<th><a href="http://10.13.18.168:7001/view/Scrum%204%20Env/">Marley</a><br><a href="deployLogs/Marley.html">Recent Deploys</a></th>
<th><a href="http://10.13.18.168:7001/view/Scrum%204%20Env/">Performance</a><br></th>
</tr>
<tr>
<td>ADS Core</td>
<td><?php include "Marley/ads-coredb.txt"; ?></td>
<td><?php include "Performance/ads-coredb.txt"; ?></td>
</tr>
<td>CAAS Core</td>
<td><?php include "Marley/caas-coredb.txt"; ?></td>
<td><?php include "Performance/caas-coredb.txt"; ?></td>
</tr>
<tr>
<td>Core DB</td>
<td><?php include "Marley/coredb.txt"; ?></td>
<td><?php include "Performance/coredb.txt"; ?></td>
</tr>
<tr>
<td>ETL/Report DB</td>
<td><?php include "Marley/etldb.txt"; ?></td>
<?php include "Performance/etldb.txt"; ?></td>
</tr>
<tr>
<td>BAR DB</td>
<td><?php include "Marley/bardb.txt"; ?></td>
<?php include "Performance/bardb.txt"; ?></td>
</tr>
<tr>
<td>Microstrategy</td>
<td><?php include "Marley/mstr.txt"; ?></td>
<td><?php include "Performance/mstr.txt"; ?></td>
</tr>
<tr>
<td>Ops DT Domain</td>
<td><?php include "Marley/opsdtdb.txt"; ?></td>
<td><?php include "Performance/opsdtdb.txt"; ?></td>
</tr>
<tr>
<td>SMSI Publisher</td>
<td><?php include "Marley/smsipub.txt"; ?></td>
<td><?php include "Performance/smsipub.txt"; ?></td>
</tr>
<tr>
<td>ops-dce-metadata-agent</td>
<td><?php include "Marley/dce-mdatadb.txt"; ?></td>
<td><?php include "Performance/dce-mdatadb.txt"; ?></td>
</tr>
<tr>
<tr><td colspan=9 align=left><h2>Application</h2></td></tr>
<th>Name</th>
<th><a href="http://10.13.18.168:7001/view/Scrum%204%20Env/">Marley</a><br>IP: 10.13.18.118</th>
<th><a href="http://10.13.18.168:7001/view/">Performance</a><br>App 10.13.19.138<br>DB 10.13.19.112</th>
<th><a href="http://10.13.18.168:7001/view/">Lab-to-Lab</a></th>
<th>Production</th>
</tr>
<tr>
<td>Campaign Manager</td>
<td><a href="http://10.13.18.118:9600/Dynamic-Ad-Insertion-cm"><?php include "Marley/cm.txt"; ?></td>
<td><a href="http://10.13.18.1xx:9600/Dynamic-Ad-Insertion-cm"><?php include "Performance/cm.txt"; ?></td>
<td><a href="http://10.13.18.1xx:9600/Dynamic-Ad-Insertion-cm"><?php include "ltl/cm.txt"; ?></td>
<td><a href="http://10.13.18.1xx:9600/Dynamic-Ad-Insertion-cm"><?php include "prod/cm.txt"; ?></td>
</tr>
<tr>
<td>Decision Engine</td>
<td><a href="http://10.13.18.118:9610/ads"><?php include "Marley/de.txt"; ?>ads</a><br><a href="http://10.13.18.118:9620/ads"><?php include "Marley/de.txt"; ?>psn</a></td>
<td><a href="http://10.13.18.1xx:9610/ads"><?php include "Performance/ads1.txt"; ?>ads</a><br><a href="http://10.13.18.1xx:9620/ads"><?php include "Performance/psn1.txt"; ?>psn</a></td>
<td><a href="http://10.13.18.1xx:9610/ads"><?php include "ltl/de.txt"; ?>ads</a><br><a href="http://10.13.18.1xx:9620/ads"><?php include "ltl/de.txt"; ?>psn</a></td>
<td><a href="http://10.13.18.1xx:9610/ads"><?php include "prod/de.txt"; ?>ads</a><br><a href="http://10.13.18.1xx:9620/ads"><?php include "prod/de.txt"; ?>psn</a></td>
</tr>
<tr>
<td>Lincoln LogSplitter</td>
<td><?php include "Marley/log.txt"; ?></td>
<td><?php include "Performance/log.txt"; ?></td>
<td><?php include "ltl/log.txt"; ?></td>
<td><?php include "prod/log.txt"; ?></td>
</tr>
<tr>
<td>CIP Feedback</td>
<td><a href="http://10.13.18.118:9300/cip-server/"><?php include "Marley/cip-feedback.txt"; ?></a></td>
<td><a href="http://10.13.18.1xx:9300/cip-server/"><?php include "Performance/cip-feedback1.txt"; ?></a></td>
<td><a href="http://10.13.18.1xx:9300/cip-server/"><?php include "ltl/cip-feedback.txt"; ?></a></td>
<td><a href="http://10.13.18.1xx:9300/cip-server/"><?php include "prod/cip-feedback.txt"; ?></a></td>
</tr>
<tr>
<td>CIP Sender</td>
<td><?php include "Marley/cip.txt"; ?></td>
<td><?php include "Performance/cip1.txt"; ?></td>
<td><?php include "ltl/cip.txt"; ?></td>
<td><?php include "prod/cip.txt"; ?></td>
</tr>
<tr>
<td>CAAS Admin</td>
<td><a href="http://10.13.18.118:9475/caas-admin/"><?php include "Marley/ca.txt"; ?></a></td>
<td><a href="http://10.13.18.1xx:9475/caas-admin/"><?php include "Performance/ca.txt"; ?></a></td>
<td><a href="http://10.13.18.1xx:9475/caas-admin/"><?php include "ltl/ca.txt"; ?></a></td>
<td><a href="http://10.13.18.1xx:9475/caas-admin/"><?php include "prod/ca.txt"; ?></a></td>
</tr>
<tr>
<td>DAI SMSI</td>
<td><a href=http://10.13.18.118:9640/safi-smsi-server/><?php include "Marley/smsi.txt"; ?></td>
<td><a href=http://10.13.18.1xx:9640/safi-smsi-server/><?php include "Performance/smsi1.txt"; ?></td>
<td><a href=http://10.13.18.1xx:9640/safi-smsi-server/><?php include "ltl/smsi.txt"; ?></td>
<td><a href=http://10.13.18.1xx:9640/safi-smsi-server/><?php include "prod/smsi.txt"; ?></td>
</tr>
<tr>
<td>SMSI Admin</td>
<td><a href=http://10.13.18.118:9440/smsi-admin><?php include "Marley/smsi-admin.txt"; ?></td>
<td><a href=http://10.13.18.1xx:9440/smsi-admin><?php include "Performance/smsi-admin.txt"; ?></td>
<td><a href=http://10.13.18.1xx:9440/smsi-admin><?php include "ltl/smsi-admin.txt"; ?></td>
<td><a href=http://10.13.18.1xx:9440/smsi-admin><?php include "prod/smsi-admin.txt"; ?></td>
</tr>
<tr>
<td>DAI SMSI Relay</td>
<td><a href=http://10.13.18.118:9440/dai-smsi-relay><?php include "Marley/smsi-relay.txt"; ?></td>
<td><a href=http://10.13.18.1xx:9440/dai-smsi-relay><?php include "Performance/smsi-relay.txt"; ?></td>
<td><a href=http://10.13.18.1xx:9440/dai-smsi-relay><?php include "ltl/smsi-relay.txt"; ?></td>
<td><a href=http://10.13.18.1xx:9440/dai-smsi-relay><?php include "prod/smsi-relay.txt"; ?></td>
</tr>
<tr>
<td>DAI Billing</td>
<td><a href=http://10.13.18.118:9545/dai-billing><?php include "Marley/bill.txt"; ?></td>
<td><a href=http://10.13.18.1xx:9545/dai-billing><?php include "Performance/bill.txt"; ?></td>
<td><a href=http://10.13.18.1xx:9545/dai-billing><?php include "ltl/bill.txt"; ?></td>
<td><a href=http://10.13.18.1xx:9545/dai-billing><?php include "prod/bill.txt"; ?></td>
</tr>
<tr>
<td>Int-Test-Support</td>
<td><a href=http://10.13.18.118:9535/int-test-support><?php include "Marley/mock_svr.txt"; ?></a></td>
<td><a href=http://10.13.18.1xx:9535/int-test-support><?php include "Performance/mock_svr.txt"; ?></a></td>
<td><a href=http://10.13.18.1xx:9535/int-test-support><?php include "ltl/mock_svr.txt"; ?></a></td>
<td><a href=http://10.13.18.1xx:9535/int-test-support><?php include "prod/mock_svr.txt"; ?></a></td>
</tr>
<tr>
<td>Programmer-Campaign-interface</td>
<td><a href=http://10.13.18.118:9591/pci><?php include "Marley/pci.txt"; ?></a></td>
<td><a href=http://10.13.18.1xx:9591/pci><?php include "Performance/pci.txt"; ?></a></td>
<td><a href=http://10.13.18.1xx:9591/pci><?php include "ltl/pci.txt"; ?></a></td>
<td><a href=http://10.13.18.1xx:9591/pci><?php include "prod/pci.txt"; ?></a></td>
</tr>
<tr>
<td>Canoe-ux</td>
<td>NA</td><td>NA</td><td>NA</td>
</tr>
<tr>
<td>OSS BAR</td>
<?php include "Marley/bar.txt"; ?></td>
<?php include "Performance/bar.txt"; ?></td>
<?php include "ltl/bar.txt"; ?></td>
<?php include "prod/bar.txt"; ?></td>
</tr>
<tr>
<td>Ops DT</td>
<td><a href="http://10.13.18.118:9510/ops-dt/login/auth"><?php include "Marley/opsdt.txt"; ?></a></td>
<td><a href="http://10.13.18.11x:9510/ops-dt/login/auth"><?php include "Performance/opsdt.txt"; ?></a></td>
<td><a href="http://10.13.18.11x:9510/ops-dt/login/auth"><?php include "ltl/opsdt.txt"; ?></a></td>
<td><a href="http://10.13.18.11x:9510/ops-dt/login/auth"><?php include "prod/opsdt.txt"; ?></a></td>
</tr>
<tr>
<td>Ops DCE SCTE CFA Rptg Agent 001</td>
<td><a href="http://10.13.18.118:9530/ops-dce-scte-cfa-reporting-agent/"><?php include "Marley/dce-agent-001.txt"; ?></a></td>
<td><a href="http://10.13.18.11x:9530/ops-dce-scte-cfa-reporting-agent/"><?php include "Performance/dce-agent-001.txt"; ?></a></td>
<td><a href="http://10.13.18.11x:9530/ops-dce-scte-cfa-reporting-agent/"><?php include "ltl/dce-agent-001.txt"; ?></a></td>
<td><a href="http://10.13.18.11x:9530/ops-dce-scte-cfa-reporting-agent/"><?php include "prod/dce-agent-001.txt"; ?></a></td>
</tr>
<td>Ops DCE SAFI Rptg Agent 002</td>
<td><a href="http://10.13.18.118:9550/ops-dce-safi-reporting-agent/"><?php include "Marley/dce-agent-002.txt"; ?></a></td>
<td><a href="http://10.13.18.11x:9550/ops-dce-safi-reporting-agent/"><?php include "Performance/dce-agent-002.txt"; ?></a></td>
<td><a href="http://10.13.18.11x:9550/ops-dce-safi-reporting-agent/"><?php include "ltl/dce-agent-002.txt"; ?></a></td>
<td><a href="http://10.13.18.11x:9550/ops-dce-safi-reporting-agent/"><?php include "prod/dce-agent-002.txt"; ?></a></td>
</tr>
<tr>
<td>SMSI Publisher</td>
<td><a href="http://10.13.18.118:9520/smsi-publisher/smsipub"><?php include "Marley/smsipub.txt"; ?></a></td>
<td><a href="http://10.13.18.11x:9520/smsi-publisher/smsipub"><?php include "Performance/smsipub1.txt"; ?></a></td>
<td><a href="http://10.13.18.11x:9520/smsi-publisher/smsipub"><?php include "ltl/smsipub.txt"; ?></a></td>
<td><a href="http://10.13.18.11x:9520/smsi-publisher/smsipub"><?php include "prod/smsipub.txt"; ?></a></td>
</tr>
<tr>
<td>Ad Map Mgr</td>
<td><?php include "Marley/amm.txt"; ?></td>
<td><?php include "Performance/amm.txt"; ?></td>
<td><?php include "ltl/amm.txt"; ?></td>
<td><?php include "prod/amm.txt"; ?></td>
</tr>
<tr>
<td>ops-dce-metadata-agent</td>
<td><a href="http://10.13.18.118:9580/ops-dce-metadata-agent/execution"><?php include "MarleyMarley/dce-mdata.txt"; ?></a></td>
<td><a href="http://10.13.18.11x:9580/ops-dce-metadata-agent/execution"><?php include "Performance/dce-mdata.txt"; ?></a></td>
<td><a href="http://10.13.18.11x:9580/ops-dce-metadata-agent/execution"><?php include "ltl/dce-mdata.txt"; ?></a></td>
<td><a href="http://10.13.18.11x:9580/ops-dce-metadata-agent/execution"><?php include "prod/dce-mdata.txt"; ?></a></td>
</tr>
<tr>
<td>Crypt</td>
<td><?php include "Marley/cry.txt"; ?></td>
<td><?php include "Performance/cry.txt"; ?></td>
<td><?php include "ltl/cry.txt"; ?></td>
<td><?php include "prod/cry.txt"; ?></td>
</tr>
</table>
</body>
</html>
