<html>
<head>
    <title>Canoe SCM Server</title>
    <link rel="stylesheet" type="text/css" href="buildServer.css" />
</head>
<?php include 'envconf_header.php'; ?>
<body>
<h3>- Deployers select the column title link to go to the Jenkins Deploy Jobs tab specific to the Environment<br>
- Users can select the application links to go to the target environment application page<br>
- PackageDeploy Jenkins jobs will display package name<br>
- <a href="postscrum.php">Post Scrum Enviroments</a></h3>
<hr>
<table align=left border=1>
  <colgroup style="background-color:#75A3A3;"></colgroup>
  <colgroup style="background-color:#FFD6AD;"></colgroup>
  <colgroup span="10" style="background-color:#FFF2D7;"></colgroup>
<tr><td colspan=12 align=left><h2>Database</h2></td></tr>
<tr>
<th>Name</th>
<th><a href="http://cvbuild.cv.infra:7001/view/DevInt%20Env/">DEVINT</a><br><a href="deployLogs/devint.html">Recent Deploys</a><br>IP: 10.13.18.111</th>
<th><a href="http://cvbuild.cv.infra:7001/view/Scrum%201%20Env/">SCRUM 1</a><br>Perry:CM/OSS<br><a href="deployLogs/scrum1.html">Recent Deploys</a><br>IP: 10.13.18.119</th>
<th><a href="http://cvbuild.cv.infra:7001/view/Scrum%202%20Env/">SCRUM 2</a><br>Reporting<br><a href="deployLogs/scrum2.html">Recent Deploys</a><br>IP: 10.13.18.120</th> 
<th><a href="http://cvbuild.cv.infra:7001/view/Scrum%203%20Env/">SCRUM 3</a><br>Transformers<br><a href="deployLogs/scrum3.html">Recent Deploys</a><br>IP: 10.13.18.121</th>
<th><a href="http://cvbuild.cv.infra:7001/view/Scrum%204%20Env/">SCRUM 4</a><br><br><a href="deployLogs/scrum4.html">Recent Deploys</a><br>IP: 10.13.18.122</th>
</tr>
<tr>
<td>ADS Core</td>
<td><?php include "devint/ads-core.txt"; ?><br>*<a href=http://cvbuild.cv.infra:7001/view/ADS-Core/job/ads-core-PackageDeploy-4.0.0/changes>(Recent Changes)</a></td>
<td><?php include "scrum1/ads-core.txt"; ?></td>
<td><?php include "scrum2/ads-core.txt"; ?></td>
<td><?php include "scrum3/ads-core.txt"; ?></td>
<td><?php include "scrum4/ads-core.txt"; ?></td>
</tr>
<td>CAAS Core</td>
<td><?php include "devint/caas-core.txt"; ?><br>*<a href=http://cvbuild.cv.infra:7001/view/CAAS-Core/job/caas-core-PackageDeploy-4.0.0/changes>(Recent Changes)</a></td>
<td><?php include "scrum1/caas-core.txt"; ?></td>
<td><?php include "scrum2/caas-core.txt"; ?></td>
<td><?php include "scrum3/caas-core.txt"; ?></td>
<td><?php include "scrum4/caas-core.txt"; ?></td>
</tr>
<tr>
<td>ETL/Report DB</td>
<td><?php include "devint/dai-etl-feeder.txt"; ?><br>*<a href=http://cvbuild.cv.infra:7001/view/DAI-ETL-FEEDER/job/dai-etl-feeder-PackageDeploy-4.0.0/changes>(Recent Changes)</a></td>
<td><?php include "scrum1/dai-etl-feeder.txt"; ?></td>
<td><?php include "scrum2/dai-etl-feeder.txt"; ?></td>
<td><?php include "scrum3/dai-etl-feeder.txt"; ?></td>
<td><?php include "scrum4/dai-etl-feeder.txt"; ?></td>
</tr>
<tr>
<td>BAR DB</td>
<td><?php include "devint/oss_bar.txt"; ?><br>*<a href=http://cvbuild.cv.infra:7001/view/DevInt%20Env/job/oss_bar-PackageDeploy-3.0.0/changes>(Recent Changes)</a></td>
<td><?php include "scrum1/oss_bar.txt"; ?></td>
<td><?php include "scrum2/oss_bar.txt"; ?></td>
<td><?php include "scrum3/oss_bar.txt"; ?></td>
<td><?php include "scrum4/oss_bar.txt"; ?></td>
</tr>
<tr>
<td>Microstrategy</td>
<td><?php include "devint/MicroDev.txt"; ?><br>*<a href=http://cvbuild.cv.infra:7001/view/MicroDev_DB/job/MicroDev_PackageDeploy-4.0.0/changes>(Recent Changes)</a></td>
<td><a href="http://10.13.18.59:9700/MicroStrategy/servlet/mstrWeb?evt=3010&src=mstrWeb.3010&Port=9905&Project=scrum1_test&Server=10.13.18.59&loginReq=true&mstrWeb=*0&fromPh=1&welcome=*-1.*-1.0.0.0&ssb=*-1.*-1.0.0...1.39..1.2.1.1....1.2.1-3.768.769.774.770.773.14081.14080.8.772.775_&results=0.*0.*0.8.0.0.*0.268453447.*-1.1.*0"><?php include "scrum1/MicroDev.txt"; ?></td>
<td><a href="http://10.13.18.59:9700/MicroStrategy/servlet/mstrWeb?evt=3010&src=mstrWeb.3010&Port=9905&Project=scrum2_test&Server=10.13.18.59&loginReq=true&mstrWeb=-10*.13*.18*.59.scrum1*_test.9905_&fromPh=1&welcome=*-1.*-1.0.0.0&ssb=*-1.*-1.0.0...1.39..1.2.1.1....1.2.1-3.768.769.774.770.773.14081.14080.8.772.775_&results=0.*0.*0.8.0.0.*0.268453447.*-1.1.*0"><?php include "scrum2/MicroDev.txt"; ?></td>
<td><a href="http://10.13.18.59:9700/MicroStrategy/servlet/mstrWeb?evt=3010&src=mstrWeb.3010&Port=9905&Project=scrum3_test&Server=10.13.18.59&loginReq=true&mstrWeb=*0&fromPh=1&welcome=*-1.*-1.0.0.0&ssb=*-1.*-1.0.0...1.39..1.2.1.1....1.2.1-3.768.769.774.770.773.14081.14080.8.772.775_&results=0.*0.*0.8.0.0.*0.268453447.*-1.1.*0"><?php include "scrum3/MicroDev.txt"; ?></td>
<td><a href="http://10.13.18.59:9700/MicroStrategy/servlet/mstrWeb?evt=3010&src=mstrWeb.3010&Port=9905&Project=scrum4_test&Server=10.13.18.59&loginReq=true&mstrWeb=*0&fromPh=1&welcome=*-1.*-1.0.0.0&ssb=*-1.*-1.
0.0...1.39..1.2.1.1....1.2.1-3.768.769.774.770.773.14081.14080.8.772.775_&results=0.*0.*0.8.0.0.*0.268453447.*-1.1.*0"><?php include "scrum4/MicroDev.txt"; ?></td>
</tr>
<tr>
<td>Ops DT Domain</td>
<td><?php include "devint/ops-dt-domain.txt"; ?>
<br>*<a href=http://cvbuild.cv.infra:7001/view/Ops-ServAssur/job/ops-dt-domain-PackageDeploy-1.0.0/changes>(Recent Changes)</a></td>
<td><?php include "scrum1/ops-dt-domain.txt"; ?></td>
<td><?php include "scrum2/ops-dt-domain.txt"; ?></td>
<td><?php include "scrum3/ops-dt-domain.txt"; ?></td>
<td><?php include "scrum3/ops-dt-domain.txt"; ?></td>
</tr>
<tr>
<td>SMSI Publisher</td>
<td><?php include "devint/smsi-publisher.txt"; ?>
<br>*<a href=http://cvbuild.cv.infra:7001/view/DAI_SMSI/job/smsi-publisher-PackageDeploy-4.0.0/changes>(Recent Changes)</a></td>
<td><?php include "scrum1/smsi-publisher.txt"; ?></td>
<td><?php include "scrum2/smsi-publisher.txt"; ?></td>
<td><?php include "scrum3/smsi-publisher.txt"; ?></td>
<td><?php include "scrum4/smsi-publisher.txt"; ?></td>
</tr>
<tr>
<td>ops-dce-metadata-agent</td>
<td><?php include "devint/ops-dce-metadata-agent.txt"; ?>
<br>*<a href=http://cvbuild.cv.infra:7001/view/Ops-ServAssur/job/ops-dce-metadata-agent-PackageDeploy-1.0.0/changes>(Recent Changes)</a></td>
<td><?php include "scrum1/ops-dce-metadata-agent.txt"; ?></td>
<td><?php include "scrum2/ops-dce-metadata-agent.txt"; ?></td>
<td><?php include "scrum3/ops-dce-metadata-agent.txt"; ?></td>
<td><?php include "scrum4/ops-dce-metadata-agent.txt"; ?></td>
</tr>
<tr>
<tr><td colspan=9 align=left><h2>Application</h2></td></tr>
<th>Name</th>
<th><a href="http://cvbuild.cv.infra:7001/view/DevInt%20Env/">DEVINT</a> <br>IP: 10.13.18.113</th>
<th><a href="http://cvbuild.cv.infra:7001/view/Scrum%201%20Env/">SCRUM 1</a><br>IP: 10.13.18.115</th>
<th><a href="http://cvbuild.cv.infra:7001/view/Scrum%202%20Env/">SCRUM 2</a><br>IP: 10.13.18.116</th>
<th><a href="http://cvbuild.cv.infra:7001/view/Scrum%203%20Env/">SCRUM 3</a><br>IP: 10.13.18.117</th>
<th><a href="http://cvbuild.cv.infra:7001/view/Scrum%204%20Env/">SCRUM 4</a><br>IP: 10.13.18.122</th>
</tr>
<tr>
<td>Campaign Manager</td>
<td><a href="http://10.13.18.113:9600/Dynamic-Ad-Insertion-cm/login/auth"><?php include "devint/Dynamic-Ad-Insertion-cm.txt"; ?></a><br>*<a href=http://cvbuild.cv.infra:7001/view/DevInt%20Env/job/DAI-CampaignMgmt-PackageDeploy-4.0.0/changes>(Recent Changes)</a></td>
<td><a href="http://10.13.18.115:9600/Dynamic-Ad-Insertion-cm"><?php include "scrum1/Dynamic-Ad-Insertion-cm.txt"; ?></a></td>
<td><a href="http://10.13.18.116:9600/Dynamic-Ad-Insertion-cm"><?php include "scrum2/Dynamic-Ad-Insertion-cm.txt"; ?></a></td>
<td><a href="http://10.13.18.117:9600/Dynamic-Ad-Insertion-cm"><?php include "scrum3/Dynamic-Ad-Insertion-cm.txt"; ?></td>
<td><a href="http://10.13.18.122:9600/Dynamic-Ad-Insertion-cm"><?php include "scrum4/Dynamic-Ad-Insertion-cm.txt"; ?></td>
</tr>
<tr>
<td>Decision Engine</td>
<td><a href="http://10.13.18.113:9610/ads"><?php include "devint/Dynamic-Ad-Insertion-engine.txt"; ?>ads</a><br>
<a href="http://10.13.18.113:9620/ads"><?php include "devint/Dynamic-Ad-Insertion-engine.txt"; ?>ads</a><br>
<td><a href="http://10.13.18.115:9610/ads"><?php include "scrum1/Dynamic-Ad-Insertion-engine.txt"; ?>ads</a><br><a href="http://10.13.18.115:9620/ads"><?php include "scrum1/Dynamic-Ad-Insertion-engine.txt"; ?>psn</a></td>
<td><a href="http://10.13.18.116:9610/ads"><?php include "scrum2/Dynamic-Ad-Insertion-engine.txt"; ?>ads</a><br><a href="http://10.13.18.116:9620/ads"><?php include "scrum2/Dynamic-Ad-Insertion-engine.txt"; ?>psn</a></td>
<td><a href="http://10.13.18.117:9610/ads"><?php include "scrum3/Dynamic-Ad-Insertion-engine.txt"; ?>ads</a><br><a href="http://10.13.18.117:9620/ads"><?php include "scrum3/Dynamic-Ad-Insertion-engine.txt"; ?>psn</a></td>
<td><a href="http://10.13.18.122:9610/ads"><?php include "scrum4/Dynamic-Ad-Insertion-engine.txt"; ?>ads</a><br><a href="http://10.13.18.122:9620/ads"><?php include "scrum4/Dynamic-Ad-Insertion-engine.txt"; ?>psn</a></td>
</tr>
<tr>
<td>ACP (Asset CIP Pub)</td>
<td><?php include "devint/acp.txt"; ?><br>*<a href=http://cvbuild.cv.infra:7001/view/DevInt%20Env/job/acp-PackageDeploy-4.0.0/changes>(Recent Changes)</a></td>
<td><?php include "scrum1/acp.txt"; ?></td>
<td><?php include "scrum2/acp.txt"; ?></td>
<td><?php include "scrum3/acp.txt"; ?></td>
<td><?php include "scrum4/acp.txt"; ?></td>
</tr>
<tr>
<td>Lincoln LogSplitter</td>
<td><?php include "devint/dai-lincoln.txt"; ?><br>*<a href=http://cvbuild.cv.infra:7001/view/DevInt%20Env/job/dai-lincoln-PackageDeploy-4.0.0/changes>(Recent Changes)</a></td>
<td><?php include "scrum1/dai-lincoln.txt"; ?></td>
<td><?php include "scrum2/dai-lincoln.txt"; ?></td>
<td><?php include "scrum3/dai-lincoln.txt"; ?></td>
<td><?php include "scrum4/dai-lincoln.txt"; ?></td>
</tr>
<tr>
<td>CIP Feedback</td>
<td><a href="http://10.13.18.113:9300/cip-server/"><?php include "devint/dai-cip-feedback.txt"; ?></a><br>*<a href=http://cvbuild.cv.infra:7001/view/DevInt%20Env/job/dai-cip-feedback-PackageDeploy-4.0.0/changes>(Recent Changes)</a></td>
<td><a href="http://10.13.18.115:9300/cip-server/"><?php include "scrum1/dai-cip-feedback.txt"; ?></a></td>
<td><a href="http://10.13.18.116:9300/cip-server/"><?php include "scrum2/dai-cip-feedback.txt"; ?></a></td>
<td><a href="http://10.13.18.117:9300/cip-server/"><?php include "scrum3/dai-cip-feedback.txt"; ?></a></td>
<td><a href="http://10.13.18.122:9300/cip-server/"><?php include "scrum4/dai-cip-feedback.txt"; ?></a></td>
</tr>
<tr>
<td>CIP Sender</td>
<td><?php include "devint/dai-cip.txt"; ?><br>*<a href=http://cvbuild.cv.infra:7001/view/DAI-CIP/job/dai-cip-PackageDeploy-4.0.0/changes>(Recent Changes)</a></td>
<td><?php include "scrum1/dai-cip.txt"; ?></td>
<td><?php include "scrum2/dai-cip.txt"; ?></td>
<td><?php include "scrum3/dai-cip.txt"; ?></td>
<td><?php include "scrum4/dai-cip.txt"; ?></td>
</tr>
<tr>
<td>CAAS Admin</td>
<td><a href="http://10.13.18.113:9475/caas-admin/"><?php include "devint/caas-admin.txt"; ?></a><br>*<a href=http://cvbuild.cv.infra:7001/view/CAAS%20Jobs/job/caas-admin-PackageDeploy-4.0.0/changes>(Recent Changes)</a></td>
<td><a href="http://10.13.18.115:9475/caas-admin/"><?php include "scrum1/caas-admin.txt"; ?></a></td>
<td><a href="http://10.13.18.116:9475/caas-admin/"><?php include "scrum2/caas-admin.txt"; ?></a></td>
<td><a href="http://10.13.18.117:9475/caas-admin/"><?php include "scrum3/caas-admin.txt"; ?></a></td>
<td><a href="http://10.13.18.122:9475/caas-admin/"><?php include "scrum4/caas-admin.txt"; ?></a></td>
</tr>
<tr>
<td>DAI SMSI</td>
<td><a href=http://10.13.18.113:9640/safi-smsi-server/><?php include "devint/dai-smsi.txt"; ?></a><br>*<a href=http://cvbuild.cv.infra:7001/view/DevInt%20Env/job/dai-smsi-PackageDeploy-4.0.0/changes>(Recent Changes)</a></td> 
<td><a href=http://10.13.18.115:9640/safi-smsi-server/><?php include "scrum1/dai-smsi.txt"; ?></a></td>
<td><a href=http://10.13.18.116:9640/safi-smsi-server/><?php include "scrum2/dai-smsi.txt"; ?></td>
<td><a href=http://10.13.18.117:9640/safi-smsi-server/><?php include "scrum3/dai-smsi.txt"; ?></td>
<td><a href=http://10.13.18.122:9640/safi-smsi-server/><?php include "scrum4/dai-smsi.txt"; ?></td>
</tr>
<tr>
<td>SMSI Admin</td>
<td><a href=http://10.13.18.113:9440/smsi-admin><?php include "devint/smsi-admin.txt"; ?></a><br>*<a href=http://cvbuild.cv.infra:7001/view/DevInt%20Env/job/smsi-admin-PackageDeploy-4.0.0/changes>(Recent Changes)</a></td>
<td><a href=http://10.13.18.115:9440/smsi-admin><?php include "scrum1/smsi-admin.txt"; ?></a></td>
<td><a href=http://10.13.18.116:9440/smsi-admin><?php include "scrum2/smsi-admin.txt"; ?></td>
<td><a href=http://10.13.18.117:9440/smsi-admin><?php include "scrum3/smsi-admin.txt"; ?></td>
<td><a href=http://10.13.18.122:9440/smsi-admin><?php include "scrum4/smsi-admin.txt"; ?></td>
</tr>
<tr>
<td>DAI SMSI Relay</td>
<td><a href=http://10.13.18.113:9511/dai-smsi-relay><?php include "devint/dai-smsi-relay.txt"; ?></a><br>*<a href=http://cvbuild.cv.infra:7001/view/DAI_SMSI/job/dai-smsi-relay-PackageDeploy-4.0.0/changes>(Recent Changes)</a></td>
<td><a href=http://10.13.18.115:9511/dai-smsi-relay><?php include "scrum1/dai-smsi-relay.txt"; ?></a></td>
<td><a href=http://10.13.18.116:9511/dai-smsi-relay><?php include "scrum2_dai-smsi-relay.txt"; ?></td>
<td><a href=http://10.13.18.117:9511/dai-smsi-relay><?php include "scrum3/dai-smsi-relay.txt"; ?></td>
<td><a href=http://10.13.18.122:9511/dai-smsi-relay><?php include "scrum4/dai-smsi-relay.txt"; ?></td>
</tr>
<tr>
<td>DAI Billing</td>
<td><a href=http://10.13.18.113:9545/dai-billing><?php include "devint/dai-billing.txt"; ?></a><br>*<a href=http://cvbuild.cv.infra:7001/view/DevInt%20Env/job/dai-billing-PackageDeploy-4.0.0/changes>(Recent Changes)</a></td>
<td><a href=http://10.13.18.115:9545/dai-billing><?php include "scrum1/dai-billing.txt"; ?></a></td>
<td><a href=http://10.13.18.116:9545/dai-billing><?php include "scrum2/dai-billing.txt"; ?></td>
<td><a href=http://10.13.18.117:9545/dai-billing><?php include "scrum3/dai-billing.txt"; ?></td>
<td><a href=http://10.13.18.122:9545/dai-billing><?php include "scrum4/dai-billing.txt"; ?></td>
</tr>
<tr>
<td>Int-Test-Support</td>
<td><a href=http://10.13.18.113:9535/int-test-support><?php include "devint/int-test-support.txt"; ?></a><br>*<a href=http://cvbuild.cv.infra:7001/view/DevInt%20Env/job/int-test-support-PackageDeploy-1.0.0/changes>(Recent Changes)</a></td>
<td><a href=http://10.13.18.115:9535/int-test-support><?php include "scrum1/int-test-support.txt"; ?></a></td>
<td><a href=http://10.13.18.116:9535/int-test-support><?php include "scrum2/int-test-support.txt"; ?></a></td>
<td><a href=http://10.13.18.117:9535/int-test-support><?php include "scrum3/int-test-support.txt"; ?></a></td>
<td><a href=http://10.13.18.122:9535/int-test-support><?php include "scrum4/int-test-support.txt"; ?></a></td>
</tr>
<tr>
<td>Programmer-Campaign-interface</td>
<td><a href=http://10.13.18.113:9591/pci><?php include "devint/Pgmr-Cpgn-Int.txt"; ?></a><br>*<a hr-f=http://cvbuild.cv.infra:7001/view/DevInt%20Env/job/Pgmr-Cpgn-Int-PackageDeploy-4.0.0/changes>(Recent Changes)</a></td>
<td><a href=http://10.13.18.115:9591/pci><?php include "scrum1/Pgmr-Cpgn-Int.txt"; ?></a></td>
<td><a href=http://10.13.18.116:9591/pci><?php include "scrum2/Pgmr-Cpgn-Int.txt"; ?></a></td>
<td><a href=http://10.13.18.117:9591/pci><?php include "scrum3/Pgmr-Cpgn-Int.txt"; ?></a></td>
<td><a href=http://10.13.18.122:9591/pci><?php include "scrum4/Pgmr-Cpgn-Int.txt"; ?></a></td>
</tr>
<tr>
<td>Canoe-ux</td>
<td><a href="http://10.13.18.113:9500/canoe-ux-1.6.0/"><?php include "devint/ux.txt"; ?></a><br>*<a href=http://cvbuild.cv.infra:7001/view/DevInt%20Env/job/canoe-ux-NightlyBuild-1.6.0/changes>(Recent Changes)</a></td>
<td>NA</td><td>NA</td><td>NA</td><td>NA</td>
</tr>
<tr>
<td>Ops DT</td>
<td><a href="http://10.13.18.113:9510/ops-dt/login/auth"><?php include "devint/ops-dt.txt"; ?></a>
<br>*<a href=http://cvbuild.cv.infra:7001/view/Ops-ServAssur/job/ops-dt-PackageDeploy-1.0.0/changes>(Recent Changes)</a></td>
<td><a href="http://10.13.18.115:9510/ops-dt/login/auth"><?php include "scrum1/ops-dt.txt"; ?></a></td>
<td><a href="http://10.13.18.116:9510/ops-dt/login/auth"><?php include "scrum2/ops-dt.txt"; ?></a></td>
<td><a href="http://10.13.18.117:9510/ops-dt/login/auth"><?php include "scrum3/ops-dt.txt"; ?></a></td>
<td><a href="http://10.13.18.122:9510/ops-dt/login/auth"><?php include "scrum4/ops-dt.txt"; ?></a></td>
</tr>
<tr>
<td>Ops DCE SCTE CFA Rptg Agent 001</td>
<td><a href="http://10.13.18.113:9530/ops-dce-scte-cfa-reporting-agent/"><?php include "devint/ops-dce-scte-cfa-reporting-agent.txt"; ?></a>
<br>*<a href=http://cvbuild.cv.infra:7001/view/Ops-ServAssur/job/ops-dce-scte-cfa-reporting-agent-PackageDeploy-1.0.0/changes>(Recent Changes)</a></td>
<td><a href="http://10.13.18.115:9530/ops-dce-scte-cfa-reporting-agent/"><?php include "scrum1/ops-dce-scte-cfa-reporting-agent.txt"; ?></a></td>
<td><a href="http://10.13.18.116:9530/ops-dce-scte-cfa-reporting-agent/"><?php include "scrum2/ops-dce-scte-cfa-reporting-agent.txt"; ?></a></td>
<td><a href="http://10.13.18.117:9530/ops-dce-scte-cfa-reporting-agent/"><?php include "scrum3/ops-dce-scte-cfa-reporting-agent.txt"; ?></a></td>
<td><a href="http://10.13.18.122:9530/ops-dce-scte-cfa-reporting-agent/"><?php include "scrum4/ops-dce-scte-cfa-reporting-agent.txt"; ?></a></td>
</tr>
<td>Ops DCE SAFI Rptg Agent 002</td>
<td><a href="http://10.13.18.113:9550/ops-dce-safi-reporting-agent/"><?php include "devint/ops-dce-safi-reporting-agent.txt"; ?></a>
<br>*<a href=http://cvbuild.cv.infra:7001/view/Ops-ServAssur/job/ops-dce-safi-reporting-agent-PackageDeploy-1.0.0/changes>(Recent Changes)</a></td>
<td><a href="http://10.13.18.115:9550/ops-dce-safi-reporting-agent/"><?php include "scrum1/ops-dce-safi-reporting-agent.txt"; ?></a></td>
<td><a href="http://10.13.18.116:9550/ops-dce-safi-reporting-agent/"><?php include "scrum2/ops-dce-safi-reporting-agent.txt"; ?></a></td>
<td><a href="http://10.13.18.117:9550/ops-dce-safi-reporting-agent/"><?php include "scrum3/ops-dce-safi-reporting-agent.txt"; ?></a></td>
<td><a href="http://10.13.18.122:9550/ops-dce-safi-reporting-agent/"><?php include "scrum4/ops-dce-safi-reporting-agent.txt"; ?></a></td>
</tr>
<tr>
<td>SMSI Publisher</td>
<td><a href="http://10.13.18.113:9520/smsi-publisher/smsipub/"><?php include "devint/smsi-publisher.txt"; ?></a>
<br>*<a href=http://cvbuild.cv.infra:7001/view/DAI_SMSI/job/smsi-publisher-PackageDeploy-4.0.0/changes>(Recent Changes)</a></td>
<td><a href="http://10.13.18.115:9520/smsi-publisher/smsipub"><?php include "scrum1/smsi-publisher.txt"; ?></a></td>
<td><a href="http://10.13.18.116:9520/smsi-publisher/smsipub"><?php include "scrum2/smsi-publisher.txt"; ?></a></td>
<td><a href="http://10.13.18.117:9520/smsi-publisher/smsipub"><?php include "scrum3/smsi-publisher.txt"; ?></a></td>
<td><a href="http://10.13.18.122:9520/smsi-publisher/smsipub"><?php include "scrum4/smsi-publisher.txt"; ?></a></td>
</tr>
<tr>
<td>Ad Map Mgr</td>
<td><a href="http://10.13.18.113:9525/dai_amm/login/auth/"><?php include "devint/dai_amm.txt"; ?></a>
<br>*<a href=http://cvbuild.cv.infra:7001/job/dai_amm-PackageDeploy-4.0.0/changes>(Recent Changes)</a></td>
<td><a href="http://10.13.18.115:9525/dai_amm/login/auth"><?php include "scrum1/dai_amm.txt"; ?></a></td>
<td><?php include "scrum2/dai_amm.txt"; ?></td>
<td><?php include "scrum3/dai_amm.txt"; ?></td>
<td><a href="http://10.13.18.122:9525/dai_amm/login/auth"><?php include "scrum4/dai_amm.txt"; ?></a></td>
</tr>
<tr>
<td>Ad Map Mgr Publisher</td>
<td><a href="http://10.13.18.113:9505/dai_amm_publisher/login/auth/"><?php include "devint/dai_amm_publisher.txt"; ?></a>
<br>*<a href=http://cvbuild.cv.infra:7001/job/dai_amm_publsiher-PackageDeploy-4.0.0/changes>(Recent Changes)</a></td>
<td><a href="http://10.13.18.115:9505/dai_amm_publisher/login/auth"><?php include "scrum1/dai_amm_publisher.txt"; ?></a></td>
<td><a href="http://10.13.18.116:9505/dai_amm_publisher/login/auth"><?php include "scrum2/dai_amm_publisher.txt"; ?></a></td>
<td><a href="http://10.13.18.117:9505/dai_amm_publisher/login/auth"><?php include "scrum3/dai_amm_publisher.txt"; ?></a></td>
<td><a href="http://10.13.18.122:9505/dai_amm_publisher/login/auth"><?php include "scrum4/dai_amm_publisher.txt"; ?></a></td>
</tr>
<tr>
<td>ops-dce-metadata-agent</td>
<td><a href="http://10.13.18.113:9580/ops-dce-metadata-agent/execution"><?php include "devint/ops-dce-metadata-agent.txt"; ?></a>
<br>*<a href=http://cvbuild.cv.infra:7001/view/Ops-ServAssur/job/ops-dce-metadata-agent-PackageDeploy-1.0.0/changes>(Recent Changes)</a></td>
<td><a href="http://10.13.18.115:9580/ops-dce-metadata-agent/execution"><?php include "scrum1/ops-dce-metadata-agent.txt"; ?></a></td>
<td><a href="http://10.13.18.116:9580/ops-dce-metadata-agent/execution"><?php include "scrum2/ops-dce-metadata-agent.txt"; ?></a></td>
<td><a href="http://10.13.18.117:9580/ops-dce-metadata-agent/execution"><?php include "scrum3/ops-dce-metadata-agent.txt"; ?></a></td>
<td><a href="http://10.13.18.122:9580/ops-dce-metadata-agent/execution"><?php include "scrum4/ops-dce-metadata-agent.txt"; ?></a></td>
</tr>
<tr>
<td>Crypt</td>
<td><?php include "devint/crypt.txt"; ?></td>
<td><?php include "scrum1/crypt.txt"; ?></td>
<td><?php include "scrum2/crypt.txt"; ?></td>
<td><?php include "scrum3/crypt.txt"; ?></td>
<td><?php include "scrum4/crypt.txt"; ?></td>
</tr>
</table>
</body>
</html>
