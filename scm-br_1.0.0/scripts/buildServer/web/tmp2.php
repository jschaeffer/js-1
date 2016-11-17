<?php
$dir    = '/opt/build/releaseTars/dai_reporting';
print "$dir";
$files1 = scandir($dir);
//$files2 = scandir($dir, 1);

print_r($files1);
//print_r($files2);
?> 


