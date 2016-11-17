<html>
<head>
    <title>Canoe SCM Server</title>
    <link rel="stylesheet" type="text/css" href="RelServer.css" />
</head>
<body>
<? include 'header.php'; ?>
<h2>
<ul>
 <li>Development
  <ul>
   <li><a href="http://cvbuild.cv.infra/scmAdmin/createLod.php">Create new official LOD (line of development) including branch, tag and jenkins build jobs</a>
  </ul>
<hr>
 <li>SCM
  <ul>
   <li><a href="http://cvbuild.cv.infra/main.php">Update Manager</a>
   <li><a href="http://cvbuild.cv.infra/viewRel.php">View Release Version Information</a>
  </ul>
</ul>
<div align="center">
    <hr size="1"/>
    <br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/>
    <h3>Select An Option From Above</h3>
    <br/><br/><br/><br/><br/><br/><br/><br/><br/><br/><br/>
</div>
<?
#    echo $_SERVER['PHP_AUTH_USER'];
    include 'footer.php';
?>
<h2>

</body>
</html>
