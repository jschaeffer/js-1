<html>
<head>
  <title>Scrum health/activity monitor</title>
  <link rel="stylesheet" type="text/css" href="buildServer.css" />
</head>
<?php include 'header.php'; ?>
<body>

<h3>- Shows realtime data for the current status of the scrum systems and links tos top and restart them <br>
<hr>

<table align=left border=1>
  <colgroup style="background-color:#666699;"></colgroup>
  <colgroup span="19" style="background-color:#B5B591;"></colgroup>
<tr><td colspan=7 align=left><h2>Scrum Systems</h2></td></tr>

<tr colgroup span="19" style="background-color:#666699;"></colgroup>
<td>Scrum system</td>
<td>Tcserver activity</td>
<td>diskspace (%)</td>
<td>Latest Deploy</td>
</tr>

<tr>
<td>Scrum1</td>
<td><?php include "scrum1/sc1_active.txt"; ?></td>
<td><?php include "scrum1/sc1_disk.txt"; ?></td>
<td><?php include "scrum1/sc1_deploy.txt"; ?></td>
</tr>

<tr>
<td>Scrum2</td>
<td><?php include "scrum2/sc2_active.txt"; ?></td>
<td><?php include "scrum2/sc2_disk.txt"; ?></td>
<td><?php include "scrum2/sc2_deploy.txt"; ?></td>
</tr>

<tr>
<td>Scrum3</td>
<td><?php include "scrum3/sc3_active.txt"; ?></td>
<td><?php include "scrum3/sc3_disk.txt"; ?></td>
<td><?php include "scrum3/sc3_deploy.txt"; ?></td>
</tr>

<tr>
<td colspan=22 align=left><h2>Instances Running Status</h2></td></tr>
<tr colgroup span="19" style="background-color:#666699;"></colgroup>
<td> Scrum system </td>
<td>Campaing Manager</td>
<td>Decision Engine</td>
<td>Lincoln LogSplitter</td>
<td>CIP Feedback</td>
<td>CIP Sender</td>
<td>CAAS Admin</td>
<td>DAI SMSI</td>
<td>SMSI Admin</td>
<td>DAI Billing</td>
<td>Int-Test-Support</td>
<td>Programmer-Campaign-interface</td>
<td>Canoe-ux</td>
<td>OSS BAR</td>
<td>Ops DT</td>
<td>Ops DCE SCTE CFA Rptg Agent 001</td>
<td>Ops DCE SAFI Rptg Agent 002</td>
<td>SMSI Publisher</td>
<td>Ad Map Mgr</td>
<td>ops-dce-metadata-agent</td>
<td>dai-smsi-relay</td>
</tr>

<tr>
<td>Scrum1</td>
<td><?php include "scrum1/cm_stat.txt"; ?></td>
<td><?php include "scrum1/dec_eng_stat.txt"; ?></td>
<td><?php include "scrum1/lin_log_stat.txt"; ?></td>
<td><?php include "scrum1/cip_feed_stat.txt"; ?></td>
<td><?php include "scrum1/cip_send_stat.txt"; ?></td>
<td><?php include "scrum1/caas_admin_stat.txt"; ?></td>
<td><?php include "scrum1/dai_smsi_stat.txt"; ?></td>
<td><?php include "scrum1/smsi_admin_stat.txt"; ?></td>
<td><?php include "scrum1/billing_stat.txt"; ?></td>
<td><?php include "scrum1/int_test_stat.txt"; ?></td>
<td><?php include "scrum1/prog_cmp_stat.txt"; ?></td>
<td><?php include "scrum1/ux_stat.txt"; ?></td>
<td><?php include "scrum1/bar_stat.txt"; ?></td>
<td><?php include "scrum1/ops_dt_stat.txt"; ?></td>
<td><?php include "scrum1/dce_001_stat.txt"; ?></td>
<td><?php include "scrum1/dce_002_stat.txt"; ?></td>
<td><?php include "scrum1/smsi_admin_stat.txt"; ?></td>
<td><?php include "scrum1/amm_stat.txt"; ?></td>
<td><?php include "scrum1/dce_mdata_stat.txt"; ?></td>
</tr>

<tr>
<td>Scrum2</td>
<td><?php include "scrum2/cm_stat.txt"; ?></td>
<td><?php include "scrum2/dec_eng_stat.txt"; ?></td>
<td><?php include "scrum2/lin_log_stat.txt"; ?></td>
<td><?php include "scrum2/cip_feed_stat.txt"; ?></td>
<td><?php include "scrum2/cip_send_stat.txt"; ?></td>
<td><?php include "scrum2/caas_admin_stat.txt"; ?></td>
<td><?php include "scrum2/dai_smsi_stat.txt"; ?></td>
<td><?php include "scrum2/smsi_admin_stat.txt"; ?></td>
<td><?php include "scrum2/billing_stat.txt"; ?></td>
<td><?php include "scrum2/int_test_stat.txt"; ?></td>
<td><?php include "scrum2/prog_cmp_stat.txt"; ?></td>
<td><?php include "scrum2/ux_stat.txt"; ?></td>
<td><?php include "scrum2/bar_stat.txt"; ?></td>
<td><?php include "scrum2/ops_dt_stat.txt"; ?></td>
<td><?php include "scrum2/dce_001_stat.txt"; ?></td>
<td><?php include "scrum2/dce_002_stat.txt"; ?></td>
<td><?php include "scrum2/smsi_admin_stat.txt"; ?></td>
<td><?php include "scrum2/amm_stat.txt"; ?></td>
<td><?php include "scrum2/dce_mdata_stat.txt"; ?></td>
</tr>

<tr>
<td>Scrum3</td>
<td><?php include "scrum3/cm_stat.txt"; ?></td>
<td><?php include "scrum3/dec_eng_stat.txt"; ?></td>
<td><?php include "scrum3/lin_log_stat.txt"; ?></td>
<td><?php include "scrum3/cip_feed_stat.txt"; ?></td>
<td><?php include "scrum3/cip_send_stat.txt"; ?></td>
<td><?php include "scrum3/caas_admin_stat.txt"; ?></td>
<td><?php include "scrum3/dai_smsi_stat.txt"; ?></td>
<td><?php include "scrum3/smsi_admin_stat.txt"; ?></td>
<td><?php include "scrum3/billing_stat.txt"; ?></td>
<td><?php include "scrum3/int_test_stat.txt"; ?></td>
<td><?php include "scrum3/prog_cmp_stat.txt"; ?></td>
<td><?php include "scrum3/ux_stat.txt"; ?></td>
<td><?php include "scrum3/bar_stat.txt"; ?></td>
<td><?php include "scrum3/ops_dt_stat.txt"; ?></td>
<td><?php include "scrum3/dce_001_stat.txt"; ?></td>
<td><?php include "scrum3/dce_002_stat.txt"; ?></td>
<td><?php include "scrum3/smsi_admin_stat.txt"; ?></td>
<td><?php include "scrum3/amm_stat.txt"; ?></td>
<td><?php include "scrum3/dce_mdata_stat.txt"; ?></td>
</tr>
