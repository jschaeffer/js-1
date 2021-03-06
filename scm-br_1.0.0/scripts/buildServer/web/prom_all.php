<html>
<head>
    <title>Canoe SCM Server</title>
    <link rel="stylesheet" type="text/css" href="RelServer.css" />
</head>
<?php include 'relheader.php'; ?>
<body>
<hr>
<table align=left border=1>
  <colgroup style="background-color:#EACDC1;"></colgroup>
  <colgroup span="3" style="background-color:#FFFAEA;"></colgroup>
  <colgroup style="background-color:#FBFBE8;"></colgroup>
  <colgroup style="background-color:#FCFCE9;"></colgroup>
  <colgroup style="background-color:F9F5EC;"></colgroup>

<tr><td colspan=12 align=left><h2>Database</h2></td></tr>
<tr>
<th>Name</th>
<th>SCRUM 1</a><br>Perry:CM/OSS<br><a href="deployLogs/scrum1.html">Recent Deploys</a></th>
<th>SCRUM 2</a><br>Reporting<br><a href="deployLogs/scrum2.html">Recent Deploys</a></th> 
<th>SCRUM 3</a><br>Transformers<br><a href="deployLogs/scrum3.html">Recent Deploys</a></th>
<th>Performance</th>
<th>Lab-to-Lab</th>
<th>Production</th>
</tr>
<tr>
<td>ADS Core<br><a href=http://10.13.18.168:7001/view/ADS-Core/job/ads-core-PackageDeploy-4.0.0/changes>(Recent Changes)</a></td>
<td><?php include "scrum1/ads-coredb.txt"; ?></td>
<td><?php include "scrum2/ads-coredb.txt"; ?></td>
<td><?php include "scrum3/ads-coredb.txt"; ?></td>
<td><?php include "performance/ads-coredb.txt"; ?></td>
<td><?php include "lab2lab/ads-coredb.txt"; ?></td>
<td><?php include "production/ads-coredb.txt"; ?></td>
</tr>
<td>CAAS Core<br><a href=http://10.13.18.168:7001/view/CAAS-Core/job/caas-core-PackageDeploy-4.0.0/changes>(Recent Changes)</a></td>
<td><?php include "scrum1/caas-coredb.txt"; ?></td>
<td><?php include "scrum2/caas-coredb.txt"; ?></td>
<td><?php include "scrum3/caas-coredb.txt"; ?></td>
<td><?php include "performance/caas-coredb.txt"; ?></td>
<td><?php include "lab2lab/caas-coredb.txt"; ?></td>
<td><?php include "production/caas-coredb.txt"; ?></td>
</tr>
<tr>
<td>ETL/Report DB</td>
<?php include "devint/etldb.txt"; ?><br>*<a href=http://10.13.18.168:7001/view/DAI-ETL-FEEDER/job/dai-etl-feeder-PackageDeploy-4.0.0/changes>(Recent Changes)</a></td>
<?php include "scrum1/etldb.txt"; ?></td>
<?php include "scrum2/etldb.txt"; ?></td>
<?php include "scrum3/etldb.txt"; ?></td>
<td><?php include "scrum4/etldb.txt"; ?></td>
<?php include "MicroDev/etldb.txt"; ?></td>
</tr>
<tr>
<td>Microstrategy</td>
<td><?php include "devint/mstr.txt"; ?><br>*<a href=http://10.13.18.168:7001/view/MicroDev_DB/job/MicroDev_PackageDeploy-4.0.0/changes>(Recent Changes)</a></td>
<td><a href="http://10.13.18.59:9700/MicroStrategy/servlet/mstrWeb?evt=3010&src=mstrWeb.3010&Port=9905&Project=scrum1_test&Server=10.13.18.59&loginReq=true&mstrWeb=*0&fromPh=1&welcome=*-1.*-1.0.0.0&ssb=*-1.*-1.0.0...1.39..1.2.1.1....1.2.1-3.768.769.774.770.773.14081.14080.8.772.775_&results=0.*0.*0.8.0.0.*0.268453447.*-1.1.*0"><?php include "scrum1/mstr.txt"; ?></td>
<td><a href="http://10.13.18.59:9700/MicroStrategy/servlet/mstrWeb?evt=3010&src=mstrWeb.3010&Port=9905&Project=scrum2_test&Server=10.13.18.59&loginReq=true&mstrWeb=-10*.13*.18*.59.scrum1*_test.9905_&fromPh=1&welcome=*-1.*-1.0.0.0&ssb=*-1.*-1.0.0...1.39..1.2.1.1....1.2.1-3.768.769.774.770.773.14081.14080.8.772.775_&results=0.*0.*0.8.0.0.*0.268453447.*-1.1.*0"><?php include "scrum2/mstr.txt"; ?></td>
<td><a href="http://10.13.18.59:9700/MicroStrategy/servlet/mstrWeb?evt=3010&src=mstrWeb.3010&Port=9905&Project=scrum3_test&Server=10.13.18.59&loginReq=true&mstrWeb=*0&fromPh=1&welcome=*-1.*-1.0.0.0&ssb=*-1.*-1.0.0...1.39..1.2.1.1....1.2.1-3.768.769.774.770.773.14081.14080.8.772.775_&results=0.*0.*0.8.0.0.*0.268453447.*-1.1.*0"><?php include "scrum3/mstr.txt"; ?></td>
<td><?php include "scrum4/mstr.txt"; ?></td>
<td><?php include "MicroDev/mstr.txt"; ?></td>
</tr>
<tr>
<td>Ops DT Domain</td>
<td><?php include "devint/opsdtdb.txt"; ?>
<br>*<a href=http://10.13.18.168:7001/view/Ops-ServAssur/job/ops-dt-domain-PackageDeploy-1.0.0/changes>(Recent Changes)</a></td>
<td><?php include "scrum1/opsdtdb.txt"; ?></td>
<td><?php include "scrum2/opsdtdb.txt"; ?></td>
<td><?php include "scrum3/opsdtdb.txt"; ?></td>
<td><?php include "scrum4/opsdtdb.txt"; ?></td>
<td><?php include "MicroDev/opsdtdb.txt"; ?></td>
</tr>
<tr>
<td>ops-dce-metadata-agent</td>
<td><?php include "devint/dce-mdatadb.txt"; ?>
<br>*<a href=http://10.13.18.168:7001/view/Ops-ServAssur/job/ops-dce-metadata-agent-PackageDeploy-1.0.0/changes>(Recent Changes)</a></td>
<td><?php include "scrum1/dce-mdatadb.txt"; ?></td>
<td><?php include "scrum2/dce-mdatadb.txt"; ?></td>
<td><?php include "scrum3/dce-mdatadb.txt"; ?></td>
<td><?php include "scrum4/dce-mdatadb.txt"; ?></td>
<td><?php include "MicroDev/dce-mdatadb.txt"; ?></td>
</tr>
<tr>
<tr><td colspan=9 align=left><h2>Application</h2></td></tr>
<th>Name</th>
<th><a href="http://10.13.18.168:7001/view/DevInt%20Env/">DEVINT</a> <br>IP: 10.13.18.113</th>
<th><a href="http://10.13.18.168:7001/view/Scrum%201%20Env/">SCRUM 1</a><br>IP: 10.13.18.115</th>
<th><a href="http://10.13.18.168:7001/view/Scrum%202%20Env/">SCRUM 2</a><br>IP: 10.13.18.116</th>
<th><a href="http://10.13.18.168:7001/view/Scrum%203%20Env/">SCRUM 3</a><br>IP: 10.13.18.117</th>
<th><a href="http://10.13.18.168:7001/view/Scrum%204%20Env/">SCRUM 4</a><br>IP: 10.13.18.1xx</th>
<th><a href="http://10.13.18.168:7001/view/">Performance</a><br>App 10.13.19.138<br>DB 10.13.19.112</th>
<th><a href="http://10.13.18.168:7001/view/">Lab-to-Lab</a></th>
<th>Production</th>
</tr>
<tr>
<td>Campaign Manager</td>
<td><a href="http://10.13.18.113:9600/Dynamic-Ad-Insertion-cm"><?php include "devint/cm.txt"; ?></a><br>*<a href=http://10.13.18.168:7001/view/DevInt%20Env/job/DAI-CampaignMgmt-PackageDeploy-4.0.0/changes>(Recent Changes)</a></td>
<td><a href="http://10.13.18.115:9600/Dynamic-Ad-Insertion-cm"><?php include "scrum1/cm.txt"; ?></a></td>
<td><a href="http://10.13.18.116:9600/Dynamic-Ad-Insertion-cm"><?php include "scrum2/cm.txt"; ?></a></td>
<td><a href="http://10.13.18.117:9600/Dynamic-Ad-Insertion-cm"><?php include "scrum3/cm.txt"; ?></td>
<td><a href="http://10.13.18.1xx:9600/Dynamic-Ad-Insertion-cm"><?php include "scrum4/cm.txt"; ?></td>
<td><a href="http://10.13.18.1xx:9600/Dynamic-Ad-Insertion-cm"><?php include "ltl/cm.txt"; ?></td>
<td><a href="http://10.13.18.1xx:9600/Dynamic-Ad-Insertion-cm"><?php include "perf/cm.txt"; ?></td>
<td><a href="http://10.13.18.1xx:9600/Dynamic-Ad-Insertion-cm"><?php include "prod/cm.txt"; ?></td>
</tr>
<tr>
<td>Decision Engine</td>
<td><a href="http://10.13.18.113:9610/ads"><?php include "devint/de.txt"; ?>ads</a><br>
<a href="http://10.13.18.113:9620/ads"><?php include "devint/de.txt"; ?>psn</a><br>*<a href=http://10.13.18.168:7001/view/DevInt%20Env/job/DAI-DecisionEngine-PackageDeploy-4.0.0/changes>(Recent Changes)</a></td>
<td><a href="http://10.13.18.115:9610/ads"><?php include "scrum1/de.txt"; ?>ads</a><br><a href="http://10.13.18.115:9620/ads"><?php include "scrum1/de.txt"; ?>psn</a></td>
<td><a href="http://10.13.18.116:9610/ads"><?php include "scrum2/de.txt"; ?>ads</a><br><a href="http://10.13.18.116:9620/ads"><?php include "scrum2/de.txt"; ?>psn</a></td>
<td><a href="http://10.13.18.117:9610/ads"><?php include "scrum3/de.txt"; ?>ads</a><br><a href="http://10.13.18.117:9620/ads"><?php include "scrum3/de.txt"; ?>psn</a></td>
<td><a href="http://10.13.18.11x:9610/ads"><?php include "scrum4/de.txt"; ?>ads</a><br><a href="http://10.13.18.11x:9620/ads"><?php include "scrum4/de.txt"; ?>psn</a></td>
<td><a href="http://10.13.18.1xx:9610/ads"><?php include "ltl/de.txt"; ?>ads</a><br><a href="http://10.13.18.1xx:9620/ads"><?php include "ltl/de.txt"; ?>psn</a></td>
<td><a href="http://10.13.18.1xx:9610/ads"><?php include "perf/de.txt"; ?>ads</a><br><a href="http://10.13.18.1xx:9620/ads"><?php include "perf/de.txt"; ?>psn</a></td>
<td><a href="http://10.13.18.1xx:9610/ads"><?php include "prod/de.txt"; ?>ads</a><br><a href="http://10.13.18.1xx:9620/ads"><?php include "prod/de.txt"; ?>psn</a></td>
</tr>
<tr>
<td>Lincoln LogSplitter</td>
<td><?php include "devint/log.txt"; ?><br>*<a href=http://10.13.18.168:7001/view/DevInt%20Env/job/dai-lincoln-PackageDeploy-1.0.0/changes>(Recent Changes)</a></td>
<td><?php include "scrum1/log.txt"; ?></td>
<td><?php include "scrum2/log.txt"; ?></td>
<td><?php include "scrum3/log.txt"; ?></td>
<td><?php include "scrum4/log.txt"; ?></td>
<td><?php include "ltl/log.txt"; ?></td>
<td><?php include "perf/log.txt"; ?></td>
<td><?php include "prod/log.txt"; ?></td>
</tr>
<tr>
<td>CIP Feedback</td>
<td><a href="http://10.13.18.113:9300/cip-server/"><?php include "devint/cip-feedback.txt"; ?></a><br>*<a href=http://10.13.18.168:7001/view/DevInt%20Env/job/dai-cip-feedback-PackageDeploy-4.0.0/changes>(Recent Changes)</a></td>
<td><a href="http://10.13.18.115:9300/cip-server/"><?php include "scrum1/cip-feedback.txt"; ?></a></td>
<td><a href="http://10.13.18.116:9300/cip-server/"><?php include "scrum2/cip-feedback.txt"; ?></a></td>
<td><a href="http://10.13.18.117:9300/cip-server/"><?php include "scrum3/cip-feedback.txt"; ?></a></td>
<td><a href="http://10.13.18.11x:9300/cip-server/"><?php include "scrum4/cip-feedback.txt"; ?></a></td>
<td><a href="http://10.13.18.1xx:9300/cip-server/"><?php include "ltl/cip-feedback.txt"; ?></a></td>
<td><a href="http://10.13.18.1xx:9300/cip-server/"><?php include "perf/cip-feedback.txt"; ?></a></td>
<td><a href="http://10.13.18.1xx:9300/cip-server/"><?php include "prod/cip-feedback.txt"; ?></a></td>
</tr>
<tr>
<td>CIP Sender</td>
<td><?php include "devint/cip.txt"; ?><br>*<a href=http://10.13.18.168:7001/view/DAI-CIP/job/dai-cip-PackageDeploy-4.0.0/changes>(Recent Changes)</a></td>
<td><?php include "scrum1/cip.txt"; ?></td>
<td><?php include "scrum2/cip.txt"; ?></td>
<td><?php include "scrum3/cip.txt"; ?></td>
<td><?php include "scrum4/cip.txt"; ?></td>
<td><?php include "ltl/cip.txt"; ?></td>
<td><?php include "perf/cip.txt"; ?></td>
<td><?php include "prod/cip.txt"; ?></td>
</tr>
<tr>
<td>CAAS Admin</td>
<td><a href="http://10.13.18.113:9475/caas-admin/"><?php include "devint/ca.txt"; ?></a><br>*<a href=http://10.13.18.168:7001/view/CAAS%20Jobs/job/caas-admin-PackageDeploy-4.0.0/changes>(Recent Changes)</a></td>
<td><a href="http://10.13.18.115:9475/caas-admin/"><?php include "scrum1/ca.txt"; ?></a></td>
<td><a href="http://10.13.18.116:9475/caas-admin/"><?php include "scrum2/ca.txt"; ?></a></td>
<td><a href="http://10.13.18.117:9475/caas-admin/"><?php include "scrum3/ca.txt"; ?></a></td>
<td><a href="http://10.13.18.11x:9475/caas-admin/"><?php include "scrum4/ca.txt"; ?></a></td>
<td><a href="http://10.13.18.1xx:9475/caas-admin/"><?php include "ltl/ca.txt"; ?></a></td>
<td><a href="http://10.13.18.1xx:9475/caas-admin/"><?php include "perf/ca.txt"; ?></a></td>
<td><a href="http://10.13.18.1xx:9475/caas-admin/"><?php include "prod/ca.txt"; ?></a></td>
</tr>
<tr>
<td>DAI SMSI</td>
<td><a href=http://10.13.18.113:9640/safi-smsi-server/><?php include "devint/smsi.txt"; ?></a><br>*<a href=http://10.13.18.168:7001/view/DevInt%20Env/job/dai-smsi-PackageDeploy-4.0.0/changes>(Recent Changes)</a></td> 
<td><a href=http://10.13.18.115:9640/safi-smsi-server/><?php include "scrum1/smsi.txt"; ?></a></td>
<td><a href=http://10.13.18.116:9640/safi-smsi-server/><?php include "scrum2/smsi.txt"; ?></td>
<td><a href=http://10.13.18.117:9640/safi-smsi-server/><?php include "scrum3/smsi.txt"; ?></td>
<td><a href=http://10.13.18.11x:9640/safi-smsi-server/><?php include "scrum4/smsi.txt"; ?></td>
<td><a href=http://10.13.18.1xx:9640/safi-smsi-server/><?php include "ltl/smsi.txt"; ?></td>
<td><a href=http://10.13.18.1xx:9640/safi-smsi-server/><?php include "perf/smsi.txt"; ?></td>
<td><a href=http://10.13.18.1xx:9640/safi-smsi-server/><?php include "prod/smsi.txt"; ?></td>
</tr>
<tr>
<td>SMSI Admin</td>
<td><a href=http://10.13.18.113:9440/smsi-admin><?php include "devint/smsi-admin.txt"; ?></a><br>*<a href=http://10.13.18.168:7001/view/DevInt%20Env/job/smsi-admin-PackageDeploy-4.0.0/changes>(Recent Changes)</a></td>
<td><a href=http://10.13.18.115:9440/smsi-admin><?php include "scrum1/smsi-admin.txt"; ?></a></td>
<td><a href=http://10.13.18.116:9440/smsi-admin><?php include "scrum2/smsi-admin.txt"; ?></td>
<td><a href=http://10.13.18.117:9440/smsi-admin><?php include "scrum3/smsi-admin.txt"; ?></td>
<td><a href=http://10.13.18.11x:9440/smsi-admin><?php include "scrum4/smsi-admin.txt"; ?></td>
<td><a href=http://10.13.18.1xx:9440/smsi-admin><?php include "ltl/smsi-admin.txt"; ?></td>
<td><a href=http://10.13.18.1xx:9440/smsi-admin><?php include "perf/smsi-admin.txt"; ?></td>
<td><a href=http://10.13.18.1xx:9440/smsi-admin><?php include "prod/smsi-admin.txt"; ?></td>
</tr>
<tr>
<td>DAI SMSI Relay</td>
<td><a href=http://10.13.18.113:9440/>dai-smsi-relay<?php include "devint/smsi-relay.txt"; ?></a><br>*<a href=http://10.13.18.168:7001/view/DAI_SMSI/job/dai-smsi-relay-PackageDeploy-4.0.0/changes>(Recent Changes)</a></td>
<td><a href=http://10.13.18.115:9440/dai-smsi-relay><?php include "scrum1/smsi-relay.txt"; ?></a></td>
<td><a href=http://10.13.18.116:9440/dai-smsi-relay><?php include "scrum2/smsi-relay.txt"; ?></td>
<td><a href=http://10.13.18.117:9440/dai-smsi-relay><?php include "scrum3/smsi-relay.txt"; ?></td>
<td><a href=http://10.13.18.11x:9440/dai-smsi-relay><?php include "scrum4/smsi-relay.txt"; ?></td>
<td><a href=http://10.13.18.1xx:9440/dai-smsi-relay><?php include "ltl/smsi-relay.txt"; ?></td>
<td><a href=http://10.13.18.1xx:9440/dai-smsi-relay><?php include "perf/smsi-relay.txt"; ?></td>
<td><a href=http://10.13.18.1xx:9440/dai-smsi-relay><?php include "prod/smsi-relay.txt"; ?></td>
</tr>
<tr>
<td>DAI Billing</td>
<td><a href=http://10.13.18.113:9545/dai-billing><?php include "devint/bill.txt"; ?></a><br>*<a href=http://10.13.18.168:7001/view/DevInt%20Env/job/dai-billing-PackageDeploy-4.0.0/changes>(Recent Changes)</a></td>
<td><a href=http://10.13.18.115:9545/dai-billing><?php include "scrum1/bill.txt"; ?></a></td>
<td><a href=http://10.13.18.116:9545/dai-billing><?php include "scrum2/bill.txt"; ?></td>
<td><a href=http://10.13.18.117:9545/dai-billing><?php include "scrum3/bill.txt"; ?></td>
<td><a href=http://10.13.18.11x:9545/dai-billing><?php include "scrum4/bill.txt"; ?></td>
<td><a href=http://10.13.18.1xx:9545/dai-billing><?php include "ltl/bill.txt"; ?></td>
<td><a href=http://10.13.18.1xx:9545/dai-billing><?php include "perf/bill.txt"; ?></td>
<td><a href=http://10.13.18.1xx:9545/dai-billing><?php include "prod/bill.txt"; ?></td>
</tr>
<tr>
<td>Int-Test-Support</td>
<td><a href=http://10.13.18.113:9535/int-test-support><?php include "devint/mock_svr.txt"; ?></a><br>*<a href=http://10.13.18.168:7001/view/DevInt%20Env/job/int-test-support-PackageDeploy-1.0.0/changes>(Recent Changes)</a></td>
<td><a href=http://10.13.18.115:9535/int-test-support><?php include "scrum1/mock_svr.txt"; ?></a></td>
<td><a href=http://10.13.18.116:9535/int-test-support><?php include "scrum2/mock_svr.txt"; ?></a></td>
<td><a href=http://10.13.18.117:9535/int-test-support><?php include "scrum3/mock_svr.txt"; ?></a></td>
<td><a href=http://10.13.18.11x:9535/int-test-support><?php include "scrum4/mock_svr.txt"; ?></a></td>
<td><a href=http://10.13.18.1xx:9535/int-test-support><?php include "ltl/mock_svr.txt"; ?></a></td>
<td><a href=http://10.13.18.1xx:9535/int-test-support><?php include "perf/mock_svr.txt"; ?></a></td>
<td><a href=http://10.13.18.1xx:9535/int-test-support><?php include "prod/mock_svr.txt"; ?></a></td>
</tr>
<tr>
<td>Programmer-Campaign-interface</td>
<td><a href=http://10.13.18.113:9591/pci><?php include "devint/pci.txt"; ?></a><br>*<a hr-f=http://10.13.18.168:7001/view/DevInt%20Env/job/Pgmr-Cpgn-Int-PackageDeploy-4.0.0/changes>(Recent Changes)</a></td>
<td><a href=http://10.13.18.115:9591/pci><?php include "scrum1/pci.txt"; ?></a></td>
<td><a href=http://10.13.18.116:9591/pci><?php include "scrum2/pci.txt"; ?></a></td>
<td><a href=http://10.13.18.117:9591/pci><?php include "scrum3/pci.txt"; ?></a></td>
<td><a href=http://10.13.18.11x:9591/pci><?php include "scrum4/pci.txt"; ?></a></td>
<td><a href=http://10.13.18.1xx:9591/pci><?php include "ltl/pci.txt"; ?></a></td>
<td><a href=http://10.13.18.1xx:9591/pci><?php include "perf/pci.txt"; ?></a></td>
<td><a href=http://10.13.18.1xx:9591/pci><?php include "prod/pci.txt"; ?></a></td>
</tr>
<tr>
<td>Canoe-ux</td>
<td><a href="http://10.13.18.113:9500/canoe-ux-1.6.0/"><?php include "devint/ux.txt"; ?></a><br>*<a href=http://10.13.18.168:7001/view/DevInt%20Env/job/canoe-ux-NightlyBuild-1.6.0/changes>(Recent Changes)</a></td>
<td>NA</td><td>NA</td><td>NA</td>
</tr>
<tr>
<td>OSS BAR</td>
<?php include "devint/bar.txt"; ?><br>*<a href=http://10.13.18.168:7001/view/DevInt%20Env/job/oss_bar-PackageDeploy-3.0.0/changes>(Recent Changes)</a></td>
<?php include "scrum1/bar.txt"; ?></td>
<?php include "scrum2/bar.txt"; ?></td>
<?php include "scrum3/bar.txt"; ?></td>
<?php include "scrum4/bar.txt"; ?></td>
<?php include "ltl/bar.txt"; ?></td>
<?php include "perf/bar.txt"; ?></td>
<?php include "prod/bar.txt"; ?></td>
</tr>
<tr>
<td>Ops DT</td>
<td><a href="http://10.13.18.113:9510/ops-dt/login/auth"><?php include "devint/opsdt.txt"; ?></a>
<br>*<a href=http://10.13.18.168:7001/view/Ops-ServAssur/job/ops-dt-PackageDeploy-1.0.0/changes>(Recent Changes)</a></td>
<td><a href="http://10.13.18.115:9510/ops-dt/login/auth"><?php include "scrum1/opsdt.txt"; ?></a></td>
<td><a href="http://10.13.18.116:9510/ops-dt/login/auth"><?php include "scrum2/opsdt.txt"; ?></a></td>
<td><a href="http://10.13.18.117:9510/ops-dt/login/auth"><?php include "scrum3/opsdt.txt"; ?></a></td>
<td><a href="http://10.13.18.11x:9510/ops-dt/login/auth"><?php include "scrum4/opsdt.txt"; ?></a></td>
<td><a href="http://10.13.18.11x:9510/ops-dt/login/auth"><?php include "ltl/opsdt.txt"; ?></a></td>
<td><a href="http://10.13.18.11x:9510/ops-dt/login/auth"><?php include "perf/opsdt.txt"; ?></a></td>
<td><a href="http://10.13.18.11x:9510/ops-dt/login/auth"><?php include "prod/opsdt.txt"; ?></a></td>
</tr>
<tr>
<td>Ops DCE SCTE CFA Rptg Agent 001</td>
<td><a href="http://10.13.18.113:9530/ops-dce-scte-cfa-reporting-agent/"><?php include "devint/dce-agent-001.txt"; ?></a>
<br>*<a href=http://10.13.18.168:7001/view/Ops-ServAssur/job/ops-dce-scte-cfa-reporting-agent-PackageDeploy-1.0.0/changes>(Recent Changes)</a></td>
<td><a href="http://10.13.18.115:9530/ops-dce-scte-cfa-reporting-agent/"><?php include "scrum1/dce-agent-001.txt"; ?></a></td>
<td><a href="http://10.13.18.116:9530/ops-dce-scte-cfa-reporting-agent/"><?php include "scrum2/dce-agent-001.txt"; ?></a></td>
<td><a href="http://10.13.18.117:9530/ops-dce-scte-cfa-reporting-agent/"><?php include "scrum3/dce-agent-001.txt"; ?></a></td>
<td><a href="http://10.13.18.11x:9530/ops-dce-scte-cfa-reporting-agent/"><?php include "scrum4/dce-agent-001.txt"; ?></a></td>
<td><a href="http://10.13.18.11x:9530/ops-dce-scte-cfa-reporting-agent/"><?php include "ltl/dce-agent-001.txt"; ?></a></td>
<td><a href="http://10.13.18.11x:9530/ops-dce-scte-cfa-reporting-agent/"><?php include "perf/dce-agent-001.txt"; ?></a></td>
<td><a href="http://10.13.18.11x:9530/ops-dce-scte-cfa-reporting-agent/"><?php include "prod/dce-agent-001.txt"; ?></a></td>
</tr>
<td>Ops DCE SAFI Rptg Agent 002</td>
<td><a href="http://10.13.18.113:9550/ops-dce-safi-reporting-agent/"><?php include "devint/dce-agent-002.txt"; ?></a>
<br>*<a href=http://10.13.18.168:7001/view/Ops-ServAssur/job/ops-dce-safi-reporting-agent-compile-1.0.0/changes>(Recent Changes)</a></td>
<td><a href="http://10.13.18.115:9550/ops-dce-safi-reporting-agent/"><?php include "scrum1/dce-agent-002.txt"; ?></a></td>
<td><a href="http://10.13.18.116:9550/ops-dce-safi-reporting-agent/"><?php include "scrum2/dce-agent-002.txt"; ?></a></td>
<td><a href="http://10.13.18.117:9550/ops-dce-safi-reporting-agent/"><?php include "scrum3/dce-agent-002.txt"; ?></a></td>
<td><a href="http://10.13.18.11x:9550/ops-dce-safi-reporting-agent/"><?php include "scrum4/dce-agent-002.txt"; ?></a></td>
<td><a href="http://10.13.18.11x:9550/ops-dce-safi-reporting-agent/"><?php include "ltl/dce-agent-002.txt"; ?></a></td>
<td><a href="http://10.13.18.11x:9550/ops-dce-safi-reporting-agent/"><?php include "perf/dce-agent-002.txt"; ?></a></td>
<td><a href="http://10.13.18.11x:9550/ops-dce-safi-reporting-agent/"><?php include "prod/dce-agent-002.txt"; ?></a></td>
</tr>
<tr>
<td>SMSI Publisher</td>
<td><a href="http://10.13.18.113:9520/smsi-publisher/smsipub/"><?php include "devint/smsipub.txt"; ?></a>
<br>*<a href=http://10.13.18.168:7001/view/DAI_SMSI/job/smsi-publisher-PackageDeploy-4.0.0/changes>(Recent Changes)</a></td>
<td><a href="http://10.13.18.115:9520/smsi-publisher/smsipub"><?php include "scrum1/smsipub.txt"; ?></a></td>
<td><a href="http://10.13.18.116:9520/smsi-publisher/smsipub"><?php include "scrum2/smsipub.txt"; ?></a></td>
<td><a href="http://10.13.18.117:9520/smsi-publisher/smsipub"><?php include "scrum3/smsipub.txt"; ?></a></td>
<td><a href="http://10.13.18.11x:9520/smsi-publisher/smsipub"><?php include "scrum4/smsipub.txt"; ?></a></td>
<td><a href="http://10.13.18.11x:9520/smsi-publisher/smsipub"><?php include "ltl/smsipub.txt"; ?></a></td>
<td><a href="http://10.13.18.11x:9520/smsi-publisher/smsipub"><?php include "perf/smsipub.txt"; ?></a></td>
<td><a href="http://10.13.18.11x:9520/smsi-publisher/smsipub"><?php include "prod/smsipub.txt"; ?></a></td>
</tr>
<tr>
<td>Ad Map Mgr</td>
<td><a href="http://10.13.18.113:9525/dai_amm/login/auth/"><?php echo "dai_amm-" . shell_exec("ssh tcserver@dvappdai01 grep Implementation-Version /opt/tcserver/instances/dai_amm/webapps/dai_amm/META-INF/MANIFEST.MF | cut -d : -f 2 | tr -d ' '  | tr -d '\r'"); ?></a></td>
<td><a href="http://10.13.18.115:9525/dai_amm/login/auth"><?php include "scrum1/amm.txt"; ?></a></td>
<td><?php include "scrum2/amm.txt"; ?></td>
<td><?php include "scrum3/amm.txt"; ?></td>
<td><?php include "scrum4/amm.txt"; ?></td>
<td><?php include "ltl/amm.txt"; ?></td>
<td><?php include "perf/amm.txt"; ?></td>
<td><?php include "prod/amm.txt"; ?></td>
</tr>
<tr>
<td>ops-dce-metadata-agent</td>
<td><a href="http://10.13.18.113:9580/ops-dce-metadata-agent/execution"><?php include "devint/dce-mdata.txt"; ?></a>
<br>*<a href=http://10.13.18.168:7001/view/Ops-ServAssur/job/ops-dce-metadata-agent-PackageDeploy-1.0.0/changes>(Recent Changes)</a></td>
<td><a href="http://10.13.18.115:9580/ops-dce-metadata-agent/execution"><?php include "scrum1/dce-mdata.txt"; ?></a></td>
<td><a href="http://10.13.18.116:9580/ops-dce-metadata-agent/execution"><?php include "scrum2/dce-mdata.txt"; ?></a></td>
<td><a href="http://10.13.18.117:9580/ops-dce-metadata-agent/execution"><?php include "scrum3/dce-mdata.txt"; ?></a></td>
<td><a href="http://10.13.18.11x:9580/ops-dce-metadata-agent/execution"><?php include "scrum4/dce-mdata.txt"; ?></a></td>
<td><a href="http://10.13.18.11x:9580/ops-dce-metadata-agent/execution"><?php include "ltl/dce-mdata.txt"; ?></a></td>
<td><a href="http://10.13.18.11x:9580/ops-dce-metadata-agent/execution"><?php include "perf/dce-mdata.txt"; ?></a></td>
<td><a href="http://10.13.18.11x:9580/ops-dce-metadata-agent/execution"><?php include "prod/dce-mdata.txt"; ?></a></td>
</tr>
<tr>
<td>Crypt</td>
<td><?php include "devint/cry.txt"; ?></td>
<td><?php include "scrum1/cry.txt"; ?></td>
<td><?php include "scrum2/cry.txt"; ?></td>
<td><?php include "scrum3/cry.txt"; ?></td>
<td><?php include "scrum4/cry.txt"; ?></td>
<td><?php include "ltl/cry.txt"; ?></td>
<td><?php include "perf/cry.txt"; ?></td>
<td><?php include "prod/cry.txt"; ?></td>
</tr>
</table>
</body>
</html>
