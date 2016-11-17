<?php
$lines = file('projectList.wrk');
print "<form>";
// Loop through our array, show HTML source as HTML source; and line numbers too.
$comp = array();
$inc="0";
foreach ($lines as $line_num => $line) {
   $inc= $inc+1;
   print "<input type=\"checkbox\" name=\"${comp}\" value=\"${comp[$inc]}\">${line}<br>";
}
print "</form>"
   print "${comp[$inc]}<br />\n";
?>

