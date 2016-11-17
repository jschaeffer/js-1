<html>
<head>
<TITLE>SCM Server - Update Manager</TITLE>

<script type="text/javascript">
// To Set an automatic refresh
// setTimeout("location.reload(true);",45000);

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
<?php include "updmgr_header.php"; ?>

</head>
<body>
To view a specific environment dashboard select '[+] Expand'

<?php 

 global $targ;
 global $dashtarg;
 global $inclnk;
 global $sysstate;
 include "asarray_projectList.php";
 global $back_col;
 $back_col="#CCEBF5";

print "<h3>Display Grid Dashboard</h3>";
  $inclnk++;
  $dashtarg=strtoupper($targ);
print "<table width=1200px border=0 align=center cellpadding=4 cellspacing=0>
	<tr>
	<td bgcolor=${back_col} align=left><input class=\"lnk\" id=\"lnk$inclnk\" type=\"button\" value=\"[+] Open Grid\" onclick=\"toggle_visibility('tbl$inclnk','lnk$inclnk');\"></td>
	<td bgcolor=${back_col} align=left><strong>$tab$tab$tab$tab$tab$tab$tab$tab Version Info across all DevInt/Scrum systems</strong></td>
	<td bgcolor=${back_col} align=right><font size=2></font></td>
	</tr>\n";

print "<table width=1200px border=1 align=center valign=top cellpadding=3 cellspacing=0 id=\"tbl$inclnk\" name=\"tbl$inclnk\" class=\"tbl\"><tr bgcolor=#CCCCCC>\n";

print "<td width=25% bgcolor=#75A3A3><b><u>Component</b></u></td>\n";
 foreach ($grid_envs as $targ) {
    $dashtarg=strtoupper($targ);
    print "<td width=10% align=center bgcolor=#FFF2D7><b><u>$dashtarg</b></u></td>\n";
 }
print "</tr>\n";
global $cmloc;
global $cmdev;
global $devver;
global $locver;
global $env_arrlength;

  for ($x=0; $x<$arrlength; $x++) {
     echo "<tr><td bgcolor=#75A3A3>".$components[$x][1]."</td>";
   foreach ($grid_envs as $targ) {
     $comp_dir="${targ}/".$components[$x][0]."";
     print "<td class=dash bgcolor=#FFF2D7>";

     if (file_exists("${comp_dir}.txt")) {
       include "${comp_dir}.txt";
      } else {
       echo "No Data";
     }

#     include "${comp_dir}.txt";
     print "</td>";
   }
  }
  print "<p>";

print "</table>";


print "<h3>DevInt and Scrum Testing Dashboards</h3>";
 for ($e=0; $e<$envlength; $e++) {
  $targ=$envs[$e][0];
  $targdisk=file_get_contents("${targ}/diskspace.txt", true);
  $inclnk++;
  $lastup=file_get_contents("$targ/dtupd.txt", true);
  $dashtarg=strtoupper($targ);
  global $sysstate;
  $sysstate=strtoupper(file_get_contents("$targ/sysstate.txt", true));

   $pos=strpos($sysstate, DOWN);
   if ($pos === false) {
    $resetState="$tab$tab<a href=\"http://cvbuild.cv.infra:7001/job/ScrumPreserveState/build?delay=0sec\"><input type=submit class=styled-button-2 value=\"Stop and preserve state\"/></a>";
        }
   else {
    $resetState="$tab$tab<a href=\"http://cvbuild.cv.infra:7001/job/ScrumResurrectState/build?delay=0sec\"><input type=submit class=styled-button-2 value=\"Resurrect to preserved state\"/></a>";
        }

print "<table width=1200px border=0 align=center cellpadding=4 cellspacing=0>\n";

print "<td bgcolor=${back_col} align=left><input class=\"lnk\" id=\"lnk$inclnk\" type=\"button\" value=\"[+] Expand\" onclick=\"toggle_visibility('tbl$inclnk','lnk$inclnk');\"></td><td bgcolor=${back_col} align=left width=10%><strong>${dashtarg}</strong> is ${sysstate}</td><td bgcolor=${back_col} align=left>$tab$tab$tab$tab$tab$tab Data Current as of : $lastup $tab$tab$tab </td><td bgcolor=${back_col} align=right>$tab$tab$tab$tab$tab$tab Disk Space Left- $targdisk</td>\n";

print "</tr>\n";

print "<table width=1200px border=1 align=center valign=top cellpadding=3 cellspacing=0 id=\"tbl$inclnk\" name=\"tbl$inclnk\" class=\"tbl\">\n";

print "<tr><td bgcolor=${back_col} colspan=7 align=left><a href=\"http://cvbuild.cv.infra:7001/job/SelectSCMEnv-Refresh/buildWithParameters?token=TOKEN_NAME&SelEnv=${targ}\"><input type=submit class=styled-button-2 value=\"Refresh Update Mgr. data\" /></a>$tab<a href=\"../deployLogs/${targ}.html\"><input type=submit class=styled-button-2 value=\"Recent ${targ} Deployments\" /></a>$tab";
print "<a href=\"http://cvbuild.cv.infra:7001/job/${targ}_SingleComponent_Deploy/build?delay=0sec\"><input type=submit class=styled-button-2 value=\"Deploy a Component\" /></a>$tab";
print "<a href=\"http://cvbuild.cv.infra:7001/job/${targ}_Multicomponent_Deploy/build?delay=0sec\"><input type=submit class=styled-button-2 value=\"Deploy Multiple Components at DevInt Version\" /></a>$tab";
print "<a href=\"http://cvbuild.cv.infra:7001/job/Auto_RestartTcserver/build?delay=0sec\"><input type=submit class=styled-button-2 value=\"Restart appserver\" /></a>
$resetState
</td></tr>\n";
print "<tr bgcolor=${back_col}>\n";

print "<td width=15%><b><u>Component</b></u></td>\n";
print "<td width=15%><b><u>Current ${dashtarg} Version</b></u></td>\n";
print "<td width=15%><b><u>Newer Version Available?</b></u></td>\n";
print "<td width=7% align=center><b><u>New Changes</b></u></td>\n";
print "<td width=7% align=center><b><u>tcServer State</b></u>\n";
print "<td width=7% align=center><b><u>App Action</b></u>\n";
print "<td width=7%><b><u>App. Log Usage</b></u></td>\n";
print "</tr>\n";
global $cmloc;
global $cmdev;
global $devver;
global $locver;
global $logorrest;
global $logurl;
global $myposup;
global $myposdn;
global $webinf;
global $resurl;
  for ($x=0; $x<$arrlength; $x++) {
     $comp_dir="${targ}/".$components[$x][0]."";
     print "<tr>";
     echo "<td class=dash>".$components[$x][1]."</td><td class=dash>";
     if (file_exists("${comp_dir}.txt")) {
       include "${comp_dir}.txt";
     } else {
       echo "Not Inst.";
     }
     $cmdev=file_get_contents("devint/".$components[$x][0].".txt", true);
     $cmloc=file_get_contents("${comp_dir}.txt", true);
     $devver1=str_replace(".","","$cmdev");
     $locver1=str_replace(".","","$cmloc");
     $devver=str_replace("_",".","$devver1");
     $locver=str_replace("_",".","$locver1");
        if ($devver == $locver) {
             $updavail="<font color=lightgrey>No, at latest version";
        }
        else {
             $updavail = "<a href=\"http://cvbuild.cv.infra:7001/job/${targ}_SingleComponent_Deploy/build?delay=0sec\"><input type=submit class=styled-button-3 value=\"Yes Update\" /></a> -to $cmdev";
        }
     $recentchg = "<h2><a href=\"http://cvbuild.cv.infra:7001/job/".$components[$x][2]."/changes\">See Changes</a></h3>";
     print "</td><td class=dash>";
     echo "$updavail";
     print "</td><td class=dash>";
     echo "$recentchg";
     print "</td><td class=dash align=center>";

//     $envstate="devint/componentno1.envstate.txt";
     $envstate="$targ/".$components[$x][0].".envstate.txt";
     include "$envstate";
     print "</td><td class=dash align=center>";
     $logorrest=`grep big ${envstate}`;
     $myposup=strpos($logorrest,"biggreen");
     $myposdn=strpos($logorrest,"bigred");

     if ($myposup == true) {
         $webinf=$components[$x][4];
       if ($webinf == "NA") {
           $logurl="";
       } else {
           $logurl="<a href=".$envs[$e][1].":".$components[$x][4]."><input type=submit class=styled-button-3 value=".$components[$x][5]."></a>";
       }
       print "$logurl"; 
     } elseif ($myposdn == true) {
       if ($webinf == "NA") {
           $resurl="";
       } else {
           $resurl="<a href=http://cvbuild.cv.infra:7001/job/Auto_RestartTcserver/buildWithParameters?token=TOKEN_NAME&DeployTarg=${targ}&Instance=".$components[$x][0]."><input type=submit class=styled-button-3 value=\"Restart\" /></a>";
//           $resurl="<a href=http://cvbuild.cv.infra:7001/job/${targ}_RestartTcserver/buildWithParameters?token=TOKEN_NAME&Instance=".$components[$x][0]."/><input type=submit class=styled-button-3 value=\"Restart\" /></a>";
       }
       print "$resurl";
     } else {
     }

     print "</td><td class=dash align=center>";
     include "$targ/".$components[$x][3].".logs";
     print "</td></tr>";
  }
  print "<p>";
 }
  print "</table>";

print "<h3>Performance Testing Dashboards</h3>";
foreach ($perf_envs as $targ) {
  $targdisk=file_get_contents("${targ}/diskspace.txt", true);
  $inclnk++;
  $lastup=file_get_contents("$targ/dtupd.txt", true);
  $dashtarg=strtoupper($targ);
print "<table width=1200px border=0 align=center cellpadding=4 cellspacing=0>\n";
print "<td bgcolor=${back_col} align=left><input class=\"lnk\" id=\"lnk$inclnk\" type=\"button\" value=\"[+] Expand\" onclick=\"toggle_visibility('tbl$inclnk','lnk$inclnk');\"></td><td bgcolor=${back_col} align=left><strong>&nbsp ${dashtarg}</strong></td><td bgcolor=${back_col} align=left>$tab$tab$tab Data Current as of : $lastup $tab$tab$tab </td><td bgcolor=${back_col} align=right>$tab$tab$tab$tab$tab$tab$tab$tab$tab$tab</td>\n";
print "</tr>\n";
print "<table width=1200px border=1 align=center valign=top cellpadding=3 cellspacing=0 id=\"tbl$inclnk\" name=\"tbl$inclnk\" class=\"tbl\">\n";
print "<tr><td bgcolor=${back_col} colspan=7 align=left>Operations --> $tab$tab<a href=\"http://cvbuild.cv.infra:7001/job/perf-EnvRefresh/build?token=TOKEN_NAME\"><input type=submit class=styled-button-2 value=\"Refresh data\" /></a>$tab$tab<a href=\"../deployLogs/perf.html\"><input type=submit class=styled-button-2 value=\"Recent ${targ} Deployments\" /></a>$tab$tab<a href=\"http://cvbuild.cv.infra:7001/job/perf_SingleComponent_Deploy/build?delay=0sec\"><input type=submit class=styled-button-2 value=\"Update a Component\" /></a>$tab$tab<a href=\"http://cvbuild.cv.infra:7001/job/${targ}_RestartTcserver/build?delay=0sec\"><input type=submit class=styled-button-2 value=\"Restart appserver\" /></a>
</td></tr>\n";
print "<tr bgcolor=${back_col}>\n";
print "<td width=25%><b><u>Component</b></u></td>\n";
print "<td width=15%><b><u>Current ${dashtarg} Version & Date Installed</u></b></td>\n";
print "<td width=15%><b><u>Newer Available?</b></u></td>\n";
print "<td width=15% align=center><b><u>Version Description</b></u></td>\n";
print "<td width=20% align=center><b><u>Host/Instance</b></u></td>\n";
print "<td width=4% align=center><b><u>tcServer State</b></u>\n";
print "<td width=4% align=center><b><u>Log Usage</b></u></td>\n";
print "</tr>\n";
global $cmloc;
global $cmdev;
  for ($x=0; $x<$perf_arrlength; $x++) {
     $comp_dir="${targ}/".$perf_components[$x][0]."";
     print "<tr>";
     echo "<td class=dash>".$perf_components[$x][1]."</td><td class=dash>";
     if (file_exists("${comp_dir}.txt")) {
       include "${comp_dir}.txt";
     } else {
       echo "Not Inst.";
     }
     $instdate=file_get_contents("${targ}/".$perf_components[$x][0].".instdate.txt", true);
     $updavail="<br>$instdate";
     echo "$updavail";
     print "</td><td class=dash>";
     $cmdev=file_get_contents("devint/".$perf_components[$x][0].".txt", true);
     $cmloc=file_get_contents("${comp_dir}.txt", true);
     $devver1=str_replace(".","","$cmdev");
     $locver1=str_replace(".","","$cmloc");
     $devver=str_replace("_",".","$devver1");
     $locver=str_replace("_",".","$locver1");
        if ($devver == $locver) {
             $upbuton="<font color=lightgrey>No, at latest version";
        }
        else {
             $upbuton = "Devint at: $cmdev";
        }
     echo "$upbuton";
     $recentchg = "<h2><a href=\"http://cvbuild.cv.infra:7001/job/".$perf_components[$x][2]."/changes\">See Version Info</a></h3>";
     print "</td><td class=dash>";
     echo "$recentchg";
     print "</td>";
     global $perf_comps;
     $perf_comps=$perf_components[$x][3];
        print "<td class=dash align=center>";
     for ($y=0; $y<$perf_comps; $y++) {
        include "$targ/".$perf_components[$x][0].$y."_app.txt";
        print "<br>";
     }
        print "</td>";
        print "<td class=dash align=center>";
     for ($y=0; $y<$perf_comps; $y++) {
        include "$targ/".$perf_components[$x][0].$y."_envstate.txt";
        print "<br>";
     }
        print "</td>";
        print "<td class=dash align=center>";
     for ($y=0; $y<$perf_comps; $y++) {
        include "$targ/".$perf_components[$x][0].$y.".logs";
        print "<br>";
     }
     print "</tr>";
  }
  print "</table>";
  print "<p>";
 }

  print "</table>";



print "<h3>Formal Integration Testing (Lab-to-Lab) Dashboards</h3>";
foreach ($lab_envs as $targ) {
  $inclnk++;
  $lastup=file_get_contents("lab2lab/dtupd.txt", true);
  $sysstate=strtoupper(file_get_contents("lab2lab/$targ/sysstate.txt", true));
  if ($targ == kodiak) {
     $dashtarg="GOOGLE";
        }
   else {
     $dashtarg=strtoupper($targ);
        }

   $pos=strpos($sysstate, DOWN);
   if ($pos === false) {
    $resetState="$tab<a href=\"http://cvbuild.cv.infra:7001/job/L2LPreserveState/build?delay=0sec\"><input type=submit class=styled-button-2 value=\"Stop and preserve state\"/></a>";
        }
    else {
    $resetState="$tab<a href=\"http://cvbuild.cv.infra:7001/job/L2LResurrectState/build?delay=0sec\"><input type=submit class=styled-button-2 value=\"Resurrect to preserved state\"/></a>";
        }

print "<table width=1200px border=0 align=center cellpadding=4 cellspacing=0>\n";
print "<td bgcolor=${back_col} align=left><input class=\"lnk\" id=\"lnk$inclnk\" type=\"button\" value=\"[+] Expand\" onclick=\"toggle_visibility('tbl$inclnk','lnk$inclnk');\"></td><td bgcolor=${back_col} align=left width=10%><strong>${dashtarg}</strong> is ${sysstate}</td><td bgcolor=${back_col} align=left>$tab$tab$tab$tab$tab$tab Data Current as of : $lastup $tab$tab$tab </td><td bgcolor=${back_col} align=right>$tab$tab$tab$tab$tab$tab</td>\n";
print "</tr>\n";

print "<table width=1200px border=1 align=center valign=top cellpadding=3 cellspacing=0 id=\"tbl$inclnk\" name=\"tbl$inclnk\" class=\"tbl\">\n";
print "<tr><td bgcolor=${back_col} colspan=7 align=left>Operations --> $tab$tab<a href=\"http://cvbuild.cv.infra:7001/job/lab-to-labEnv-Refresh\"><input type=submit class=styled-button-2 value=\"Refresh Update Mgr. data\" /></a>$tab";
print "<a href=\"../deployLogs/L2L.html\"><input type=submit class=styled-button-2 value=\"Recent Lab-to-Lab Deployments\" /></a>$tab$tab<a href=\"http://cvbuild.cv.infra:7001/job/Zayo_L2L_SingleComponent_Deploy/build?delay=0sec\"><input type=submit class=styled-button-2 value=\"Update a Component\" /></a>$tab$tab<a href=\"http://cvbuild.cv.infra:7001/view/lab-2-lab/job/lab-2-lab_RestartTcserver/build?delay=0sec\"><input type=submit class=styled-button-2 value=\"Restart appserver\"/></a>
$resetState
</td></tr>\n";

print "<tr bgcolor=${back_col}>\n";

print "<td  width=25%><b><u>Component</b></u></td>\n";
print "<td width=15%><b><u>Current ${dashtarg} Version</u><br>& Date Installed</b></td>\n";
print "<td width=15%><b><u>Newer Available?</b></u></td>\n";
print "<td width=15% align=center><b><u>Version Description</b></u></td>\n";
print "<td width=20% align=center><b><u>Host/Instance</b></u></td>\n";
print "<td width=4% align=center><b><u>tcServer State</b></u>\n";
print "<td width=4% align=center><b><u>Log Usage</b></u></td>\n";
print "</tr>\n";
global $cmloc;
global $cmdev;

  for ($x=0; $x<$l2l_arrlength; $x++) {
     $comp_dir="lab2lab/${targ}/".$lab2lab_components[$x][0]."";
     print "<tr>";
     echo "<td class=dash>".$lab2lab_components[$x][1]."</td><td class=dash>";
     if (file_exists("${comp_dir}.txt")) {
       include "${comp_dir}.txt";
     } else {
       echo "Not Inst.";
     }
     $instdate=file_get_contents("lab2lab/${targ}/".$lab2lab_components[$x][0].".instdate.txt", true);
     $updavail="<br>$instdate";
     echo "$updavail";
     print "</td><td class=dash>";
     $cmdev=file_get_contents("devint/".$lab2lab_components[$x][0].".txt", true);
     $cmloc=file_get_contents("${comp_dir}.txt", true);
     $devver1=str_replace(".","","$cmdev");
     $locver1=str_replace(".","","$cmloc");
     $devver=str_replace("_",".","$devver1");
     $locver=str_replace("_",".","$locver1");
        if ($devver == $locver) {
            $upbuton="<font color=lightgrey>No, at latest version";
        }
        else {
             $upbuton = "Devint at: $cmdev";
        }
     echo "$upbuton";
     $rel_dir="releases/".$lab2lab_components[$x][0]."_$cmloc";
     $recentchg = "<h2><a href=\"${rel_dir}.html\">See Version Info</a></h3>";
     print "</td><td class=dash>";
     echo "$recentchg";

     print "</td>";
     global $lab2lab_comps;
     $lab2lab_comps=$lab2lab_components[$x][3];
        print "<td class=dash align=center>";
     for ($y=0; $y<$lab2lab_comps; $y++) {
        include "lab2lab/$targ/".$lab2lab_components[$x][0].$y."_app.txt";
        print "<br>";
     }
        print "</td>";
        print "<td class=dash align=center>";
     for ($y=0; $y<$lab2lab_comps; $y++) {
        include "lab2lab/$targ/".$lab2lab_components[$x][0].$y."_envstate.txt";
        print "<br>";
     }
        print "</td>";
        print "<td class=dash align=center>";
     for ($y=0; $y<$lab2lab_comps; $y++) {
        include "lab2lab/$targ/".$lab2lab_components[$x][0].$y.".logs";
        print "<br>";
     }
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
print "<td bgcolor=${back_col} align=left width=14%><input class=\"lnk\" id=\"lnk$inclnk\" type=\"button\" value=\"[+] Expand\" onclick=\"toggle_visibility('tbl$inclnk','lnk$inclnk');\"></td><td bgcolor=${back_col} align=left width=15%><strong>${dashtarg}</strong></td><td bgcolor=${back_col} align=left> Data Current as of : $lastup $tab$tab$tab </td><td bgcolor=${back_col} align=right></td>\n";
print "</tr>\n";

print "<table width=1200px border=1 align=center valign=top cellpadding=3 cellspacing=0 id=\"tbl$inclnk\" name=\"tbl$inclnk\" class=\"tbl\">\n";
print "<tr><td bgcolor=${back_col} colspan=10 align=left>Operations --> $tab$tab$tab$tab$tab$tab<a href=\"http://cvbuild.cv.infra:7001/job/NewProd-env_refresh/build?token=TOKEN_NAME\"><input type=submit class=styled-button-2 value=\"Refresh Update Mgr. data\" /></a>$tab";
print "$tab$tab$tab$tab$tab$tab<a href=\"../deployLogs/production.html\"><input type=submit class=styled-button-2 value=\"Recent Production Deployments\" /></a></td></tr>\n";

print "<tr bgcolor=${back_col}>\n";

print "<td width=25%><b><u>Component</b></u></td>\n";
print "<td width=25%><b><u>Current ${dashtarg} Version</u></td>\n";
print "<td width=25%><b><u>Date Installed</b></u></td>\n";
print "<td width=25% align=center><b><u>Version Description</b></u></td>\n";
print "</tr>\n";
global $cmloc;
global $cmdev;

  for ($x=0; $x<$production_arrlength; $x++) {
     $comp_dir="prod/${targ}/".$production_components[$x][0]."";
     $cmloc=file_get_contents("${comp_dir}.txt", true);
     print "<tr>";
     echo "<td class=dash>".$production_components[$x][1]."</td><td class=dash>";
     if (file_exists("${comp_dir}.txt")) {
       include "${comp_dir}.txt";
     } else {
       echo "Not Inst.";
     }
     $instdate=file_get_contents("prod/${targ}/".$production_components[$x][0].".instdate.txt", true);
     $showinst="<td class=dash>$instdate";
     echo "$showinst";
     print "</td><td class=dash>";
     $rel_dir="releases/".$production_components[$x][0]."_$cmloc";
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
