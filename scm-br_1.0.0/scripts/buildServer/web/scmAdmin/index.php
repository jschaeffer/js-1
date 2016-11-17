<?php
    include 'config.php';
?>

<html>
<head>
    <title>Canoe SCM Server</title>
    <link rel="stylesheet" type="text/css" href="../buildServer.css" />
</head>
<body>
<?php include 'header.php'; ?>
<ul>
 <li><h1>Development</h1>
  <ol>
   <li><a href="http://cvbuild.cv.infra/scmAdmin/createLod.php"><h2>Create new LOD (line of development) including Git branch, Git tag and jenkins build jobs</a></h2>
   <li><a href="http://cvbuild.cv.infra/scmAdmin/deleteLod.php"><h2>Delete an LOD (line of development) including Git branch, Git tag and jenkins build jobs</a></h2>
  </ol><p><br/><br/><br/>
 <li><h1>SCM</h1>
  <ol>
   <li><h2>View Environment Configurations page<a href="http://cvbuild.cv.infra/disp_all.php">&nbsp&nbsp(Scrum Systems)</a><a href="http://cvbuild.cv.infra/postscrum.php">&nbsp&nbsp(Post-Scrum Systems)</a></h2>
   <li><a href="http://cvbuild.cv.infra/main.php"><h2>Run Update Manager</a></h2>
   <li><a href="http://cvbuild.cv.infra/viewRel.php"><h2>View Release Version Information</a></h2>
  </ol>
</ul>
<div align="center">
    <hr size="1"/>
    <h3>Select An Option From Above</h3>
    <br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/>
</div>
<?
#    echo $_SERVER['PHP_AUTH_USER'];
    include '../footer.php';
?>
</body>
</html>
