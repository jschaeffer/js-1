<html>
<head>
<TITLE>SCM Server - Canoe Update Manager</TITLE>
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
<?php include "header.php"; ?>
</head>
<body>
<table border="1" align="center" cellpadding="4" cellspacing="0">
<tr><th>Canoe Ventures - Canoe Update Manager<br>Data Current as of : <?php include 'devint/dtupd.txt'; ?></th></tr>
<?php 

 global $targ;
 global $inclnk;
# include "projectList.php"; 
 include "asarray_projectList.php";
 foreach ($envs as $targ) {
  $targdisk=file_get_contents("${targ}/diskspace.txt", true);
  $inclnk++;
print "<table width=1200px border=0 align=center cellpadding=4 cellspacing=0>\n";
print "<td bgcolor=#EEEEEE align=left><input class=\"lnk\" id=\"lnk$inclnk\" type=\"button\" value=\"[+] Expand\" onclick=\"toggle_visibility('tbl$inclnk','lnk$inclnk');\"><strong>$targ</strong></td><td bgcolor=#EEEEEE align=right>Disk Space Left- $targdisk</td>\n";
print "</tr>\n";

print "<table width=1200px border=0 align=center valign=top cellpadding=3 cellspacing=0 id=\"tbl$inclnk\" name=\"tbl$inclnk\" class=\"tbl\">\n";
print "<tr bgcolor=#CCCCCC>\n";

print "<td width=25%><b><u>Component</b></u></td>\n";
print "<td width=15%><b><u>Current Version/<br>Pkg. Download</b></u></td>\n";
print "<td width=20%><b><u>Update Avail?</b></u></td>\n";
print "<td width=15% align=center><b><u>New Changes</b></u></td>\n";
print "<td width=10% align=center><b><u>Env. State</b></u>\n";
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
     $cmloc=file_get_contents("${comp_dir}.txt", true);
        if ($cmdev > $cmloc) {
             $updavail = "<h2><a href=\"http://10.13.18.168:7001/job/${targ}_SingleComponent_Deploy/build?delay=0sec\">Yes - $cmdev</a></h2>";
             $recentchg = "<h2><a href=\"http://10.13.18.168:7001/job/".$components[$x][2]."/changes\">See Changes</a></h3>";
        }
        else {
             $updavail = "";
             $recentchg ="";
        }
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

?>
</body>
</html> 
