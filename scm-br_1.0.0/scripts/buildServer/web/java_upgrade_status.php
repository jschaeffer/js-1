<html>
<head>
<TITLE>SCM Server - Java Upgrade Tracker</TITLE>

<?php include "updmgr_header.php"; ?>
</head>
<style type="text/css">
.tbl {display:none;}
.lnk {border:none;background:none;width:85px;}
td {FONT-SIZE: 75%; MARGIN: 0px; COLOR: #000000;}
td {FONT-FAMILY: verdana,helvetica,arial,sans-serif}
a {TEXT-DECORATION: none;}
</style>

<link rel="stylesheet" type="text/css" href="newbuildServer.css" />
<body>
<?php 

 global $targ;
 global $dashtarg;
 global $inclnk;
 include "asarray_projectList.php";
 global $back_col;
 $back_col="#CCEBF5";

print "<h3>All current components across deployed systems</h3>";
  $dashtarg=strtoupper($targ);
print "<table width=1100px border=0 align=center cellpadding=4 cellspacing=0>\n";

print "<td bgcolor=${back_col} align=left></td><td bgcolor=${back_col} align=left><strong>$tab$tab$tab$tab$tab$tab$tab$tab Version Info across all DevInt/Scrum systems</strong></td><td bgcolor=${back_col} align=left></td>\n";
print "</tr>\n";

print "<table width=1100px border=1 align=center valign=top cellpadding=3 cellspacing=0>\n";
print "<tr bgcolor=#CCCCCC>\n";

print "<td width=25% bgcolor=#75A3A3><b><u>Component</b></u></td>\n";
 foreach ($grid_envs as $targ) {
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
   foreach ($grid_envs as $targ) {
     $comp_dir="${targ}/".$components[$x][0]."";
     print "<td class=dash bgcolor=#FFF2D7>";

     if (file_exists("${comp_dir}.JDK.txt")) {
       include "${comp_dir}.JDK.txt";
      } else {
       echo "";
     }
     print "</td>";
   }
  print "</tr>";
  }
  print "<p>";

print "</table>";

?>
</body>
</html> 
