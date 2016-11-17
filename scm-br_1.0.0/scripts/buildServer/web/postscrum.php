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
<th><a href="http://cvbuild.cv.infra:7001/view/Marley%20Env/job/Marley_SingleComponent_Deploy/build?delay=0sec">Marley</a><br><a href="deployLogs/Marley.html">Recent Deploys</a></th>
<th><a href="http://cvbuild.cv.infra:7001/view/Performance/job/performance_SingleComponent_Deploy/build?delay=0sec">Performance</a><br><a href="deployLogs/performance.html">Recent Deploys</a></th>
<th>Lab-to-Lab:<br>base</th>
<th>Lab-to-Lab:<br>freewheel</th>
<th>Lab-to-Lab:<br>kodiak</th>
<th>Production</th>
</tr>
<tr>
<td>ADS Core</td>
<td><?php include "Marley/ads-core.txt"; ?></td>
<td><?php include "performance/ads-core.txt"; ?></td>
<td><?php include "lab2lab/base/ads-core.txt"; ?></td>
<td><?php include "lab2lab/fw/ads-core.txt"; ?></td>
<td><?php include "lab2lab/kodiak/ads-core.txt"; ?></td>
<td><?php include "prod/ads-core.txt"; ?></td>
</tr>
<td>CAAS Core</td>
<td><?php include "Marley/caas-core.txt"; ?></td>
<td><?php include "performance/caas-core.txt"; ?></td>
<td><?php include "lab2lab/base/caas-core.txt"; ?></td>
<td><?php include "lab2lab/fw/caas-core.txt"; ?></td>
<td><?php include "lab2lab/kodiak/caas-core.txt"; ?></td>
<td><?php include "prod/caas-core.txt"; ?></td>
</tr>
<tr>
<td>ETL/Report DB</td>
<td><?php include "Marley/dai-etl-feeder.txt"; ?></td>
<td><?php include "performance/etldb.txt"; ?></td>
<td><?php include "lab2lab/base/etldb.txt"; ?></td>
<td><?php include "lab2lab/fw/etldb.txt"; ?></td>
<td><?php include "lab2lab/kodiak/etldb.txt"; ?></td>
<td><?php include "prod/etldb.txt"; ?></td>
</tr>
<tr>
<td>BAR DB</td>
<td><?php include "Marley/oss_bar.txt"; ?></td>
<?php include "performance/oss_bar.txt"; ?></td>
<td><?php include "lab2lab/base/oss_bar.txt"; ?></td>
<td><?php include "lab2lab/fw/oss_bar.txt"; ?></td>
<td><?php include "lab2lab/kodiak/oss_bar.txt"; ?></td>
<td><?php include "prod/oss_bar.txt"; ?></td>
</tr>
<tr>
<td>Microstrategy</td>
<td><?php include "Marley/MicroDev.txt"; ?></td>
<td><?php include "performance/MicroDev.txt"; ?></td>
<td><?php include "lab2lab/base/MicroDev.txt"; ?></td>
<td><?php include "lab2lab/fw/MicroDev.txt"; ?></td>
<td><?php include "lab2lab/kodiak/MicroDev.txt"; ?></td>
<td><?php include "prod/MicroDev.txt"; ?></td>
</tr>
<tr>
<td>Ops DT Domain</td>
<td><?php include "Marley/ops-dt-domain.txt"; ?></td>
<td><?php include "performance/ops-dt-domain.txt"; ?></td>
<td><?php include "lab2lab/base/ops-dt-domain.txt"; ?></td>
<td><?php include "lab2lab/fw/ops-dt-domain.txt"; ?></td>
<td><?php include "lab2lab/kodiak/ops-dt-domain.txt"; ?></td>
<td><?php include "prod/ops-dt-domain.txt"; ?></td>
</tr>
<tr>
<td>SMSI Publisher</td>
<td><?php include "Marley/smsi-publisher.txt"; ?></td>
<td><?php include "performance/smsi-publisher.txt"; ?></td>
<td><?php include "lab2lab/base/smsi-publisher.txt"; ?></td>
<td><?php include "lab2lab/fw/smsi-publisher.txt"; ?></td>
<td><?php include "lab2lab/kodiak/smsi-publisher.txt"; ?></td>
<td><?php include "prod/smsi-publisher.txt"; ?></td>
</tr>
<tr>
<td>ops-dce-metadata-agent</td>
<td><?php include "Marley/ops-dce-metadata-agent.txt"; ?></td>
<td><?php include "performance/ops-dce-metadata-agent.txt"; ?></td>
<td><?php include "lab2lab/base/ops-dce-metadata-agent.txt"; ?></td>
<td><?php include "lab2lab/fw/ops-dce-metadata-agent.txt"; ?></td>
<td><?php include "lab2lab/kodiak/ops-dce-metadata-agent.txt"; ?></td>
<td><?php include "prod/ops-dce-metadata-agent.txt"; ?></td>
</tr>
<tr>
<tr><td colspan=9 align=left><h2>Application</h2></td></tr>
<th>Name</th>
<th><a href="http://cvbuild.cv.infra:7001/view/Scrum%204%20Env/">Marley</a><br>IP: 10.13.18.118</th>
<th><a href="http://cvbuild.cv.infra:7001/view/">performance</a><br>App 10.13.19.138<br>DB 10.13.19.112</th>
<th>Lab-to-Lab:<br>base</th>
<th>Lab-to-Lab:<br>freewheel</th>
<th>Lab-to-Lab:<br>kodiak</th>
<th>Production</th>
</tr>
<tr>
<td>Campaign Manager</td>
<td><a href="http://10.13.18.118:9600/Dynamic-Ad-Insertion-cm"><?php include "Marley/Dynamic-Ad-Insertion-cm.txt"; ?></td>
<td><a href="http://10.13.19.129:9600/Dynamic-Ad-Insertion-cm"><?php include "performance/Dynamic-Ad-Insertion-cm.txt"; ?></td>
<td><?php include "lab2lab/base/Dynamic-Ad-Insertion-cm.txt"; ?></td>
<td><?php include "lab2lab/fw/Dynamic-Ad-Insertion-cm.txt"; ?></td>
<td><?php include "lab2lab/kodiak/Dynamic-Ad-Insertion-cm.txt"; ?></td>
<td><?php include "prod/Dynamic-Ad-Insertion-cm.txt"; ?></td>
</tr>
<tr>
<td>Decision Engine</td>
<td><a href="http://10.13.18.118:9610/ads"><?php include "Marley/Dynamic-Ad-Insertion-engine.txt"; ?>ads</a>
   <br><a href="http://10.13.18.118:9620/ads"><?php include "Marley/Dynamic-Ad-Insertion-engine.txt"; ?>psn</a></td>
<td><a href="http://10.13.19.138:9600/ads-3.0.0-SNAPSHOT"><?php include "performance/Dynamic-Ad-Insertion-engine1.txt"; ?>ads</a>
   <br><a href="http://10.13.19.132:9600/ads-3.0.0-SNAPSHOT"><?php include "performance/Dynamic-Ad-Insertion-engine2.txt"; ?>psn</a></td>
<td><?php include "lab2lab/base/Dynamic-Ad-Insertion-engine1.txt"; ?>ads</a><br><?php include "lab2lab/base/Dynamic-Ad-Insertion-engine2.txt"; ?>psn</a></td>
<td><?php include "lab2lab/fw/Dynamic-Ad-Insertion-engine1.txt"; ?>ads</a><br><?php include "lab2lab/fw/Dynamic-Ad-Insertion-engine2.txt"; ?>psn</a></td>
<td><?php include "lab2lab/kodiak/Dynamic-Ad-Insertion-engine1.txt"; ?>ads</a><br><?php include "lab2lab/kodiak/Dynamic-Ad-Insertion-engine2.txt"; ?>psn</a></td>
<td><?php include "prod/Dynamic-Ad-Insertion-engine.txt"; ?>ads</a>
  <br><?php include "prod/Dynamic-Ad-Insertion-engine.txt"; ?>psn</a></td>
</tr>
<tr>
<td>Lincoln LogSplitter</td>
<td><?php include "Marley/dai-lincoln.txt"; ?></td>
<td><?php include "performance/dai-lincoln.txt"; ?></td>
<td><?php include "lab2lab/base/dai-lincoln.txt"; ?></td>
<td><?php include "lab2lab/fw/dai-lincoln.txt"; ?></td>
<td><?php include "lab2lab/kodiak/dai-lincoln.txt"; ?></td>
<td><?php include "prod/dai-lincoln.txt"; ?></td>
</tr>
<tr>
<td>CIP Feedback</td>
<td><a href="http://10.13.18.118:9300/cip-server/"><?php include "Marley/dai-cip-feedback.txt"; ?></a></td>
<td><a href="http://10.13.19.134:9600/cip-feedback/"><?php include "performance/dai-cip-feedback.txt"; ?></a></td>
<td><?php include "lab2lab/base/dai-cip-feedback.txt"; ?></a></td>
<td><?php include "lab2lab/fw/dai-cip-feedback.txt"; ?></a></td>
<td><?php include "lab2lab/kodiak/dai-cip-feedback.txt"; ?></a></td>
<td><?php include "prod/dai-cip-feedback.txt"; ?></a></td>
</tr>
<tr>
<td>CIP Sender</td>
<td><?php include "Marley/dai-cip.txt"; ?></td>
<td><?php include "performance/dai-cip.txt"; ?></td>
<td><?php include "lab2lab/base/dai-cip.txt"; ?></td>
<td><?php include "lab2lab/fw/dai-cip.txt"; ?></td>
<td><?php include "lab2lab/kodiak/dai-cip.txt"; ?></td>
<td><?php include "prod/dai-cip.txt"; ?></td>
</tr>
<tr>
<td>CAAS Admin</td>
<td><a href="http://10.13.18.118:9475/caas-admin/"><?php include "Marley/caas-admin.txt"; ?></a></td>
<td><a href="http://10.13.18.1xx:9475/caas-admin/"><?php include "performance/caas-admin.txt"; ?></a></td>
<td><?php include "lab2lab/base/caas-admin.txt"; ?></a></td>
<td><?php include "lab2lab/fw/caas-admin.txt"; ?></a></td>
<td><?php include "lab2lab/kodiak/caas-admin.txt"; ?></a></td>
<td><?php include "prod/caas-admin.txt"; ?></a></td>
</tr>
<tr>
<td>DAI SMSI</td>
<td><a href=http://10.13.18.118:9640/safi-smsi-server/><?php include "Marley/dai-smsi.txt"; ?></td>
<td><a href=http://10.13.19.135:9600/smsi/><?php include "performance/dai-smsi.txt"; ?></td>
<td><?php include "lab2lab/base/dai-smsi.txt"; ?></td>
<td><?php include "lab2lab/fw/dai-smsi.txt"; ?></td>
<td><?php include "lab2lab/kodiak/dai-smsi.txt"; ?></td>
<td><?php include "prod/dai-smsi.txt"; ?></td>
</tr>
<tr>
<td>SMSI Admin</td>
<td><a href=http://10.13.18.118:9440/smsi-admin><?php include "Marley/smsi-admin.txt"; ?></td>
<td><a href=http://10.13.18.1xx:9440/smsi-admin><?php include "performance/smsi-admin.txt"; ?></td>
<td><?php include "lab2lab/base/smsi-admin.txt"; ?></td>
<td><?php include "lab2lab/fw/smsi-admin.txt"; ?></td>
<td><?php include "lab2lab/kodiak/smsi-admin.txt"; ?></td>
<td><?php include "prod/smsi-admin.txt"; ?></td>
</tr>
<tr>
<td>DAI SMSI Relay</td>
<td><a href=http://10.13.18.118:9440/dai-smsi-relay><?php include "Marley/dai-smsi-relay.txt"; ?></td>
<td><a href=http://10.13.18.1xx:9440/dai-smsi-relay><?php include "performance/dai-smsi-relay.txt"; ?></td>
<td><?php include "lab2lab/base/dai-smsi-relay.txt"; ?></td>
<td><?php include "lab2lab/fw/dai-smsi-relay.txt"; ?></td>
<td><?php include "lab2lab/kodiak/dai-smsi-relay.txt"; ?></td>
<td><?php include "prod/dai-smsi-relay.txt"; ?></td>
</tr>
<tr>
<td>DAI Billing</td>
<td><a href=http://10.13.18.118:9545/dai-billing><?php include "Marley/dai-billing.txt"; ?></td>
<td><a href=http://10.13.18.1xx:9545/dai-billing><?php include "performance/dai-billing.txt"; ?></td>
<td><?php include "lab2lab/base/dai-billing.txt"; ?></td>
<td><?php include "lab2lab/fw/dai-billing.txt"; ?></td>
<td><?php include "lab2lab/kodiak/dai-billing.txt"; ?></td>
<td><?php include "prod/dai-billing.txt"; ?></td>
</tr>
<tr>
<td>Int-Test-Support</td>
<td><a href=http://10.13.18.118:9535/int-test-support><?php include "Marley/int-test-support.txt"; ?></a></td>
<td><a href=http://10.13.18.1xx:9535/int-test-support><?php include "performance/int-test-support.txt"; ?></a></td>
<td><?php include "lab2lab/base/int-test-support.txt"; ?></a></td>
<td><?php include "lab2lab/fw/int-test-support.txt"; ?></a></td>
<td><?php include "lab2lab/kodiak/int-test-support.txt"; ?></a></td>
<td><?php include "prod/int-test-support.txt"; ?></a></td>
</tr>
<tr>
<td>Programmer-Campaign-interface</td>
<td><a href=http://10.13.18.118:9591/pci><?php include "Marley/Pgmr-Cpgn-Int.txt"; ?></a></td>
<td><a href=http://10.13.18.1xx:9591/pci><?php include "performance/Pgmr-Cpgn-Int.txt"; ?></a></td>
<td><?php include "lab2lab/base/Pgmr-Cpgn-Int.txt"; ?></a></td>
<td><?php include "lab2lab/fw/Pgmr-Cpgn-Int.txt"; ?></a></td>
<td><?php include "lab2lab/kodiak/Pgmr-Cpgn-Int.txt"; ?></a></td>
<td><?php include "prod/Pgmr-Cpgn-Int.txt"; ?></a></td>
</tr>
<tr>
<td>Ops DT</td>
<td><a href="http://10.13.18.118:9510/ops-dt/login/auth"><?php include "Marley/ops-dt.txt"; ?></a></td>
<td><a href="http://10.13.18.11x:9510/ops-dt/login/auth"><?php include "performance/ops-dt.txt"; ?></a></td>
<td><?php include "lab2lab/base/ops-dt.txt"; ?></a></td>
<td><?php include "lab2lab/fw/ops-dt.txt"; ?></a></td>
<td><?php include "lab2lab/kodiak/ops-dt.txt"; ?></a></td>
<td><?php include "prod/ops-dt.txt"; ?></a></td>
</tr>
<tr>
<td>Ops DCE SCTE CFA Rptg Agent 001</td>
<td><a href="http://10.13.18.118:9530/ops-dce-scte-cfa-reporting-agent/"><?php include "Marley/ops-dce-scte-cfa-reporting-agent.txt"; ?></a></td>
<td><a href="http://10.13.18.11x:9530/ops-dce-scte-cfa-reporting-agent/"><?php include "performance/ops-dce-scte-cfa-reporting-agent.txt"; ?></a></td>
<td><?php include "lab2lab/base/ops-dce-scte-cfa-reporting-agent.txt"; ?></a></td>
<td><?php include "lab2lab/fw/ops-dce-scte-cfa-reporting-agent.txt"; ?></a></td>
<td><?php include "lab2lab/kodiak/ops-dce-scte-cfa-reporting-agent.txt"; ?></a></td>
<td><?php include "prod/ops-dce-scte-cfa-reporting-agent.txt"; ?></a></td>
</tr>
<td>Ops DCE SAFI Rptg Agent 002</td>
<td><a href="http://10.13.18.118:9550/ops-dce-safi-reporting-agent/"><?php include "Marley/ops-dce-safi-reporting-agent.txt"; ?></a></td>
<td><a href="http://10.13.18.11x:9550/ops-dce-safi-reporting-agent/"><?php include "performance/ops-dce-safi-reporting-agent.txt"; ?></a></td>
<td><?php include "lab2lab/base/ops-dce-safi-reporting-agent.txt"; ?></a></td>
<td><?php include "lab2lab/fw/ops-dce-safi-reporting-agent.txt"; ?></a></td>
<td><?php include "lab2lab/kodiak/ops-dce-safi-reporting-agent.txt"; ?></a></td>
<td><?php include "prod/ops-dce-safi-reporting-agent.txt"; ?></a></td>
</tr>
<tr>
<td>SMSI Publisher</td>
<td><a href="http://10.13.18.118:9520/smsi-publisher/smsipub"><?php include "Marley/smsi-publisher.txt"; ?></a></td>
<td><a href="http://10.13.18.11x:9520/smsi-publisher/smsipub"><?php include "performance/smsi-publisher.txt"; ?></a></td>
<td><?php include "lab2lab/base/smsi-publisher.txt"; ?></a></td>
<td><?php include "lab2lab/fw/smsi-publisher.txt"; ?></a></td>
<td><?php include "lab2lab/kodiak/smsi-publisher.txt"; ?></a></td>
<td><?php include "prod/smsi-publisher.txt"; ?></a></td>
</tr>
<tr>
<td>Ad Map Mgr</td>
<td><?php include "Marley/dai_amm.txt"; ?></td>
<td><?php include "performance/dai_amm.txt"; ?></td>
<td><?php include "lab2lab/base/dai_amm.txt"; ?></td>
<td><?php include "lab2lab/fw/dai_amm.txt"; ?></td>
<td><?php include "lab2lab/kodiak/dai_amm.txt"; ?></td>
<td><?php include "prod/dai_amm.txt"; ?></td>
</tr>
<tr>
<td>ops-dce-metadata-agent</td>
<td><a href="http://10.13.18.118:9580/ops-dce-metadata-agent/execution"><?php include "Marley/ops-dce-metadata-agent.txt"; ?></a></td>
<td><a href="http://10.13.18.11x:9580/ops-dce-metadata-agent/execution"><?php include "performance/ops-dce-metadata-agent.txt"; ?></a></td>
<td><?php include "lab2lab/base/ops-dce-metadata-agent.txt"; ?></a></td>
<td><?php include "lab2lab/fw/ops-dce-metadata-agent.txt"; ?></a></td>
<td><?php include "lab2lab/kodiak/ops-dce-metadata-agent.txt"; ?></a></td>
<td><?php include "prod/ops-dce-metadata-agent.txt"; ?></a></td>
</tr>
<tr>
<td>Crypt</td>
<td><?php include "Marley/cry.txt"; ?></td>
<td><?php include "performance/cry.txt"; ?></td>
<td><?php include "lab2lab/base/cry.txt"; ?></td>
<td><?php include "lab2lab/fw/cry.txt"; ?></td>
<td><?php include "lab2lab/kodiak/cry.txt"; ?></td>
<td><?php include "prod/cry.txt"; ?></td>
</tr>
</table>
</body>
</html>
