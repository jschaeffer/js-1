<html>
<head>
<TITLE>SCM Server - Canoe Release Viewer</TITLE>
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
<style type="text/css">
.tbl {display:none;}
.lnk {border:none;background:none;width:85px;}
td {FONT-SIZE: 75%; MARGIN: 0px; COLOR: #000000;}
td {FONT-FAMILY: verdana,helvetica,arial,sans-serif}
a {TEXT-DECORATION: none;}
</style>

<link rel="stylesheet" type="text/css" href="newbuildServer.css" />
<?php include "relmgr_header.php"; ?>
</head>
<body>
To view a specific environment dashboard select '[+] Expand'

<?php 

 global $targ;
 global $dashtarg;
 global $inclnk;
# include "projectList.php"; 
 include "asarray_projectList.php";

print "<h3>DevInt and Scrum Testing Dashboards</h3>";
 foreach ($envs as $targ) {
  $targdisk=file_get_contents("${targ}/diskspace.txt", true);
  $inclnk++;
  $lastup=file_get_contents("$targ/dtupd.txt", true);
  $dashtarg=strtoupper($targ);
print "<table width=1200px border=0 align=center cellpadding=4 cellspacing=0>\n";
print "<td bgcolor=#CEFFFD align=left><input class=\"lnk\" id=\"lnk$inclnk\" type=\"button\" value=\"[+] Expand\" onclick=\"toggle_visibility('tbl$inclnk','lnk$inclnk');\"><strong>${dashtarg}</strong> $tab$tab$tab$tab$tab$tab Data Current as of : $lastup $tab$tab$tab </td><td bgcolor=#CEFFFD align=right>Disk Space Left- $targdisk</td>\n";
print "</tr>\n";

print "<table width=1200px border=1 align=center valign=top cellpadding=3 cellspacing=0 id=\"tbl$inclnk\" name=\"tbl$inclnk\" class=\"tbl\">\n";
print "<tr><td bgcolor=#CEFFFD colspan=6 align=left><a href=\"http://cvbuild.cv.infra:7001/job/SelectSCMEnv-Refresh/buildWithParameters?token=TOKEN_NAME&SelEnv=${targ}\"><input type=submit class=styled-button-4 value=\"Refresh Update Mgr. data\" /></a>$tab
$tab<a href=\"../deployLogs/${targ}.html\"><input type=submit class=styled-button-4 value=\"Recent ${targ} Deployments\" /></a>
$tab
<a href=\"http://cvbuild.cv.infra:7001/job/${targ}_SingleComponent_Deploy/build?delay=0sec\"><input type=submit class=styled-button-4 value=\"Deploy a Component\" /></a>
$tab
<a href=\"http://cvbuild.cv.infra:7001/job/${targ}_Multicomponent_Deploy/build?delay=0sec\"><input type=submit class=styled-button-4 value=\"Deploy Multiple Components at DevInt Version\" /></a>
$tab
<a href=\"http://cvbuild.cv.infra:7001/job/${targ}_RestartTcserver/build?delay=0sec\"><input type=submit class=styled-button-4 value=\"Restart a tcserver instance\" /></a>
</td></tr>\n";
print "<tr bgcolor=#CCCCCC>\n";

print "<td width=22%><b><u>Component</b></u></td>\n";
print "<td width=17%><b><u>Current ${dashtarg} Version</b></u></td>\n";
print "<td width=20%><b><u>Newer Version Available?</b></u></td>\n";
print "<td width=14% align=center><b><u>New Changes</b></u></td>\n";
print "<td width=10% align=center><b><u>tcServer State</b></u>\n";
print "<td width=10%><b><u>App. Log Usage</b></u></td>\n";
print "</tr>\n";
global $cmloc;
global $cmdev;
global $devver;
global $locver;

  for ($x=0; $x<$arrlength; $x++) {
     $comp_dir="${targ}/".$components[$x][0]."";
     print "<tr>";
     echo "<td>".$components[$x][1]."</td><td>";
     include "${comp_dir}.txt";
     $cmdev=file_get_contents("devint/".$components[$x][0].".txt", true);
     $cmloc=file_get_contents("${comp_dir}.txt", true);
     $devver=str_replace("_",".","$cmdev");
     $locver=str_replace("_",".","$cmloc");
        if ($devver > $locver) {
             $updavail = "<a href=\"http://cvbuild.cv.infra:7001/job/${targ}_SingleComponent_Deploy/build?delay=0sec\"><input type=submit class=styled-button-4 value=\"Yes Update\" /></a> -to $cmdev";
        }
        else {
             $updavail="<font color=lightgrey>No, at latest version";
        }
     $recentchg = "<h2><a href=\"http://cvbuild.cv.infra:7001/job/".$components[$x][2]."/changes\">See Changes</a></h3>";
     print "</td><td>";
     echo "$updavail";
     print "</td><td>";
     echo "$recentchg";
     print "</td>";
     include "$targ/".$components[$x][3].".envstate.txt";
     print "</td>";
     include "$targ/".$components[$x][3].".logs";
     print "</td></tr>";
  }
  print "<p>";
 }
  print "</table>";

print "<h3>Post Scrum Testing Dashboard</h3>";
foreach ($post_envs as $targ) {
  $targdisk=file_get_contents("${targ}/diskspace.txt", true);
  $inclnk++;
  $lastup=file_get_contents("$targ/dtupd.txt", true);
  $dashtarg=strtoupper($targ);
print "<table width=1200px border=0 align=center cellpadding=4 cellspacing=0>\n";
print "<td bgcolor=#B5FFFC align=left><input class=\"lnk\" id=\"lnk$inclnk\" type=\"button\" value=\"[+] Expand\" onclick=\"toggle_visibility('tbl$inclnk','lnk$inclnk');\"><strong>${dashtarg}</strong> $tab$tab$tab$tab$tab$tab Data Current as of : $lastup $tab$tab$tab </td><td bgcolor=#B5FFFC align=right>Disk Space Left- $targdisk</td>\n";
print "</tr>\n";

print "<table width=1200px border=1 align=center valign=top cellpadding=3 cellspacing=0 id=\"tbl$inclnk\" name=\"tbl$inclnk\" class=\"tbl\">\n";
print "<tr><td bgcolor=#B5FFFC colspan=6 align=left>Operations --> $tab$tab<a href=\"http://cvbuild.cv.infra:7001/job/SelectSCMEnv-Refresh/build?delay=0sec\"><input type=submit class=styled-button-4 value=\"Refresh data\" /></a>$tab$tab<a href=\"../deployLogs/${targ}.html\"><input type=submit class=styled-button-4 value=\"Recent ${targ} Deployments\" /></a>$tab$tab<a href=\"http://cvbuild.cv.infra:7001/job/${targ}_SingleComponent_Deploy/build?delay=0sec\"><input type=submit class=styled-button-4 value=\"Update a Component\" /></a>$tab$tab<a href=\"http://cvbuild.cv.infra:7001/job/${targ}_RestartTcserver/build?delay=0sec\"><input type=submit class=styled-button-4 value=\"Restart a tcserver instance\" /></a>
</td></tr>\n";

print "<tr bgcolor=#CCCCCC>\n";

print "<td width=25%><b><u>Component</b></u></td>\n";
print "<td width=15%><b><u>Current ${targ} Version</b></u></td>\n";
print "<td width=20%><b><u>Date Installed</b></u></td>\n";
print "<td width=15% align=center><b><u>Version Description</b></u></td>\n";
print "<td width=10% align=center><b><u>tcServer State</b></u>\n";
print "<td width=10%><b><u>App. Log Usage</b></u></td>\n";
print "</tr>\n";
global $cmloc;
global $cmdev;

  for ($x=0; $x<$arrlength; $x++) {
     $comp_dir="${targ}/".$components[$x][0]."";
     print "<tr>";
     echo "<td>".$components[$x][1]."</td><td>";
     include "${comp_dir}.txt";
     $cmdev=file_get_contents("devint/".$components[$x][0].".txt", true);
     $instdate=file_get_contents("Marley/".$components[$x][0]."instdate.txt", true);
     $recentchg = "<h2><a href=\"http://cvbuild.cv.infra:7001/job/".$components[$x][2]."/changes\">See Version Info</a></h3>";
     $updavail="<font color=grey>$instdate";
     print "</td><td>";
     echo "$updavail";
     print "</td><td>";
     echo "$recentchg";

     print "</td>";
     include "$targ/".$components[$x][3].".envstate.txt";
     print "</td>";
     include "$targ/".$components[$x][3].".logs";
     print "</td></tr>";
  }
  print "</table>";
  print "<p>";
 }
  print "</table>";

print "<h3>Performance Testing Dashboard</h3>";
foreach ($perf_envs as $targ) {
  $targdisk=file_get_contents("${targ}/diskspace.txt", true);
  $inclnk++;
  $lastup=file_get_contents("$targ/dtupd.txt", true);
  $dashtarg=strtoupper($targ);
print "<table width=1200px border=0 align=center cellpadding=4 cellspacing=0>\n";
print "<td bgcolor=#B5FFFC align=left><input class=\"lnk\" id=\"lnk$inclnk\" type=\"button\" value=\"[+] Expand\" onclick=\"toggle_visibility('tbl$inclnk','lnk$inclnk');\"><strong>${dashtarg}</strong> $tab$tab$tab$tab$tab$tab Data Current as of : $lastup $tab$tab$tab </td><td bgcolor=#B5FFFC align=right></td>\n";
print "</tr>\n";

print "<table width=1200px border=1 align=center valign=top cellpadding=3 cellspacing=0 id=\"tbl$inclnk\" name=\"tbl$inclnk\" class=\"tbl\">\n";
print "<tr><td bgcolor=#B5FFFC colspan=10 align=left>Operations --> $tab$tab<a href=\"http://cvbuild.cv.infra:7001/view/SCM/job/performance-EnvRefresh/build?delay=0sec\"><input type=submit class=styled-button-4 value=\"Refresh data\" /></a>$tab$tab<a href=\"../deployLogs/${targ}.html\"><input type=submit class=styled-button-4 value=\"Recent ${targ} Deployments\" /></a>$tab$tab<a href=\"http://cvbuild.cv.infra:7001/job/${targ}_SingleComponent_Deploy/build?delay=0sec\"><input type=submit class=styled-button-4 value=\"Update a Component\" /></a>$tab$tab<a href=\"http://cvbuild.cv.infra:7001/job/${targ}_RestartTcserver/build?delay=0sec\"><input type=submit class=styled-button-4 value=\"Restart a tcserver instance\" /></a>
</td></tr>\n";

print "<tr bgcolor=#CCCCCC>\n";

print "<td width=25%><b><u>Component</b></u></td>\n";
print "<td width=15%><b><u>Current ${dashtarg} Version</b></u></td>\n";
print "<td width=20%><b><u>Date Installed<br>Newer Available?</b></u></td>\n";
print "<td width=15% align=center><b><u>Version Description</b></u></td>\n";
print "<td width=10% colspan=5><b><u>tcServer State</b></u>\n";
print "<td width=10% colspan=5><b><u>App. Log Usage</b></u></td>\n";
print "</tr>\n";
global $cmloc;
global $cmdev;

  for ($x=0; $x<$perf_arrlength; $x++) {
     $comp_dir="${targ}/".$perf_components[$x][0]."";
     print "<tr>";
     echo "<td>".$perf_components[$x][1]."</td><td>";
     include "${comp_dir}.txt";
     $cmdev=file_get_contents("devint/".$perf_components[$x][0].".txt", true);
     $cmloc=file_get_contents("${comp_dir}.txt", true);
     $devver=str_replace("_",".","$cmdev");
     $locver=str_replace("_",".","$cmloc");
        if ($devver > $locver) {
             $upbuton = "Devint at: $cmdev";
        }
        else {
             $upbuton="<font color=lightgrey>No, at latest version";
        }

     $instdate=file_get_contents("performance/".$perf_components[$x][0].".instdate.txt", true);
     $recentchg = "<h2><a href=\"http://cvbuild.cv.infra:7001/job/".$perf_components[$x][2]."/changes\">See Version Info</a></h3>";
     $updavail="$instdate<br>$upbuton";
     print "</td><td>";
     echo "$updavail";
     print "</td><td>";
     echo "$recentchg";

     print "</td>";
     global $perf_comps;
     $perf_comps=$perf_components[$x][3];
//     echo "${perf_comps}";
     for ($y=0; $y<$perf_comps; $y++) {
//      echo "<td>$y";
//      include "$targ/ads${y}.envstate.txt";
//      include "$targ/ads5.envstate.txt";
        include "$targ/".$perf_components[$x][0].$y."_envstate.txt";
     }
     print "</td>";
     include "$targ/".$perf_components[$x][3].".logs";
     print "</td></tr>";
  }
  print "</table>";
  print "<p>";
 }
  print "</table>";



print "<h3>Formal Integration Testing (Lab-to-Lab) Dashboards</h3>";
foreach ($lab_envs as $targ) {
  $inclnk++;
  $lastup=file_get_contents("lab2lab/dtupd.txt", true);
  $dashtarg=strtoupper($targ);
print "<table width=1200px border=0 align=center cellpadding=4 cellspacing=0>\n";
print "<td bgcolor=#B5FFFC align=left><input class=\"lnk\" id=\"lnk$inclnk\" type=\"button\" value=\"[+] Expand\" onclick=\"toggle_visibility('tbl$inclnk','lnk$inclnk');\"><strong>${dashtarg}</strong> $tab$tab$tab$tab$tab$tab Data Current as of : $lastup $tab$tab$tab </td><td bgcolor=#B5FFFC align=right></td>\n";
print "</tr>\n";

print "<table width=1200px border=1 align=center valign=top cellpadding=3 cellspacing=0 id=\"tbl$inclnk\" name=\"tbl$inclnk\" class=\"tbl\">\n";
print "<tr><td bgcolor=#CEFFFD colspan=10 align=left>Operations --> $tab$tab<a href=\"http://cvbuild.cv.infra:7001/job/lab-to-labEnv-Refresh\"><input type=submit class=styled-button-4 value=\"Refresh Update Mgr. data\" /></a>$tab";
print "<a href=\"../deployLogs/lab2lab.html\"><input type=submit class=styled-button-4 value=\"Recent Lab-to-Lab Deployments\" /></a>$tab$tab<a href=\"http://cvbuild.cv.infra:7001/job/lab2lab_SingleComponent_Deploy/build?delay=0sec\"><input type=submit class=styled-button-4 value=\"Update a Component\" /></a>$tab$tab<a href=\"http://cvbuild.cv.infra:7001/job/lab2lab_RestartTcserver/build?delay=0sec\"><input type=submit class=styled-button-4 value=\"Restart a tcserver instance\" /></a>
</td></tr>\n";

print "<tr bgcolor=#CCCCCC>\n";

print "<td width=25%><b><u>Component</b></u></td>\n";
print "<td width=15%><b><u>Current ${dashtarg} Version</u><br>& Date Installed</b></td>\n";
print "<td width=15%><b><u>Newer Available?</b></u></td>\n";
print "<td width=15% align=center><b><u>Version Description</b></u></td>\n";
print "<td width=20% colspan=5><b><u>tcServer State</b></u>\n";
print "<td width=10% colspan=5><b><u>App. Log Usage</b></u></td>\n";
print "</tr>\n";
global $cmloc;
global $cmdev;

  for ($x=0; $x<$l2l_arrlength; $x++) {
     $comp_dir="lab2lab/${targ}/".$lab2lab_components[$x][0]."";
     print "<tr>";
     echo "<td>".$lab2lab_components[$x][1]."</td><td>";
     include "${comp_dir}.txt";
     $instdate=file_get_contents("lab2lab/${targ}/".$lab2lab_components[$x][0].".instdate.txt", true);
     $updavail="<br>$instdate";
     echo "$updavail";
     print "</td><td>";
     $cmdev=file_get_contents("devint/".$lab2lab_components[$x][0].".txt", true);
     $cmloc=file_get_contents("${comp_dir}.txt", true);
     $devver=str_replace("_",".","$cmdev");
     $locver=str_replace("_",".","$cmloc");
        if ($devver > $locver) {
             $upbuton = "Devint at: $cmdev";
        }
        else {
             $upbuton="<font color=lightgrey>No, at latest version";
        }
     echo "$upbuton";
     $rel_dir="releases/".$lab2lab_components[$x][0]."_$cmloc";
     $recentchg = "<h2><a href=\"${rel_dir}.html\">See Version Info</a></h3>";
     print "</td><td>";
     echo "$recentchg";

     print "</td>";
     global $lab2lab_comps;
     $lab2lab_comps=5;
#     $perf_comps=$perf_components[$x][3];
     for ($y=0; $y<$lab2lab_comps; $y++) {
        include "lab2lab/$targ/".$lab2lab_components[$x][0].$y."_envstate.txt";
     }
     print "</td>";
     include "lab2lab/$targ/".$lab2lab_components[$x][3].".logs";
     print "</td></tr>";
  }
  print "</table>";
  print "<p>";
 }
  print "</table>";

print "<h3>Production Dashboards</h3>";
foreach ($prod_envs as $targ) {
  $inclnk++;
  $lastup=file_get_contents("prod/dtupd.txt", true);
  $dashtarg=strtoupper($targ);
print "<table width=1200px border=0 align=center cellpadding=4 cellspacing=0>\n";
print "<td bgcolor=#B5FFFC align=left><input class=\"lnk\" id=\"lnk$inclnk\" type=\"button\" value=\"[+] Expand\" onclick=\"toggle_visibility('tbl$inclnk','lnk$inclnk');\"><strong>${dashtarg}</strong> $tab$tab$tab$tab$tab$tab Data Current as of : $lastup $tab$tab$tab </td><td bgcolor=#B5FFFC align=right></td>\n";
print "</tr>\n";

print "<table width=1200px border=1 align=center valign=top cellpadding=3 cellspacing=0 id=\"tbl$inclnk\" name=\"tbl$inclnk\" class=\"tbl\">\n";
print "<tr><td bgcolor=#CEFFFD colspan=10 align=left>Operations --> $tab$tab<a href=\"http://cvbuild.cv.infra:7001/job/xxxEnv-Refresh\"><input type=submit class=styled-button-4 value=\"(Will be) Refresh Update Mgr. data\" /></a>$tab";
print "<a href=\"../deployLogs/prod.html\"><input type=submit class=styled-button-4 value=\"(Will be) Recent Production Deployments\" /></a>$tab$tab<a href=\"http://cvbuild.cv.infra:7001/job/xxx_SingleComponent_Deploy/build?delay=0sec\"><input type=submit class=styled-button-4 value=\"(Will be) Update a Component\" /></a></td></tr>\n";

print "<tr bgcolor=#CCCCCC>\n";

print "<td width=25%><b><u>Component</b></u></td>\n";
print "<td width=25%><b><u>Current ${dashtarg} Version</u></td>\n";
print "<td width=25%><b><u>Date Installed</b></u></td>\n";
print "<td width=25% align=center><b><u>Version Description</b></u></td>\n";
print "</tr>\n";
global $cmloc;
global $cmdev;

  for ($x=0; $x<$l2l_arrlength; $x++) {
     $comp_dir="prod/${targ}/".$lab2lab_components[$x][0]."";
     print "<tr>";
     echo "<td>".$lab2lab_components[$x][1]."</td><td>";
     include "${comp_dir}.txt";
     $instdate=file_get_contents("prod/${targ}/".$lab2lab_components[$x][0].".instdate.txt", true);
     $showinst="<td>$instdate";
     echo "$showinst";
     print "</td><td>";
     $rel_dir="releases/".$lab2lab_components[$x][0]."_$cmloc";
     $recentchg = "<h2><a href=\"${rel_dir}.html\">See Version Info</a></h3>";
     echo "$recentchg";
     print "</td></tr>";
  }
  print "</table>";
  print "<p>";
 }
  print "</table>";
#    echo $_SERVER['PHP_AUTH_USER'];
    include 'footer.php';
?>
</body>
</html> 
