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
<?php include "updmgr_header.php"; ?>
</head>
<body>
To view a specific environment dashboard select '[+] Expand'

<?php 

 global $targ;
 global $dashtarg;
 global $inclnk;
 include "asarray_projectList.php";
 global $back_col;
 $back_col="#CCEBF5";
// $back_col="#DFECEC";

print "<h3>Display Old-style Grid Dashboard</h3>";
  $inclnk++;
  $dashtarg=strtoupper($targ);
print "<table width=1100px border=0 align=center cellpadding=4 cellspacing=0>\n";
print "<td bgcolor=${back_col} align=left><input class=\"lnk\" id=\"lnk$inclnk\" type=\"button\" value=\"[+] Open Grid\" onclick=\"toggle_visibility('tbl$inclnk','lnk$inclnk');\"></td><td bgcolor=${back_col} align=left><strong>$tab$tab$tab$tab$tab$tab$tab$tab Version Info across all DevInt/Scrum systems</strong></td><td bgcolor=${back_col} align=left></td>\n";
print "</tr>\n";

print "<table width=1100px border=1 align=center valign=top cellpadding=3 cellspacing=0 id=\"tbl$inclnk\" name=\"tbl$inclnk\" class=\"tbl\">\n";
print "<tr bgcolor=#CCCCCC>\n";

print "<td width=25% bgcolor=#75A3A3><b><u>Component</b></u></td>\n";
 foreach ($rcr_envs as $targ) {
    $dashtarg=strtoupper($targ);
    print "<td width=10% bgcolor=#FFF2D7><b><u>$dashtarg</b></u></td>\n";
 }
print "</tr>\n";
global $cmloc;
global $cmdev;
global $devver;
global $locver;
global $env_arrlength;

  for ($x=0; $x<$arrlength; $x++) {
     echo "<tr><td bgcolor=#75A3A3>".$components[$x][1]."</td>";
   foreach ($rcr_envs as $targ) {
     $comp_dir="${targ}/".$components[$x][0]."";
     print "<td class=dash bgcolor=#FFF2D7>";

     if (file_exists("${comp_dir}.txt")) {
       include "${comp_dir}.txt";
      } else {
       echo "";
     }

#     include "${comp_dir}.txt";
     print "</td>";
   }
  }
  print "<p>";

print "</table>";

#    echo $_SERVER['PHP_AUTH_USER'];
    include 'footer.php';
?>
</body>
</html> 
