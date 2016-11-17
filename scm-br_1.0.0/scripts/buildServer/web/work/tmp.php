<html>
<head>
<TITLE>SCM Server - Scrum Update Manager</TITLE>
<link rel="stylesheet" type="text/css" href="buildServer.css" />
<?php include "header.php"; ?>
</head>
<body>
<input type="submit" class="styled-button-9" value="Update" />
<?php 
 global $targ;
 global $comp;
 include "projectList.php"; 
 foreach ($envs as $targ) {
print "<hr>\n";
print "<table border=1>\n";
print "<colgroup span='10' style='background-color:#FFF2D7;'></colgroup>";
print "<tr><td colspan='12' align=left><h2>$targ</h2></td></tr>";
  foreach ($components as $comp) {
   $comp_dir="${targ}/${comp}";
     print "<tr>";
     print "  <td>$comp</td><td>";
     include "${comp_dir}.txt";
     print "</td></tr>";
  }
  print "</table>";
  print "<p>";
 }
?>
</body>
</html> 


caas-core.txt
