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
    <tr>
        <td valign="bottom">
            <table>
                <tr>
                    <td>Available SCM tasks</td>
                </tr>
                <tr>
                    <tr>
                        <td><a href="createLod.php"><h1>Create a new official Line of Development (branch)<br></a>
                           </h1><h2><ul><li><i>LODs are created from the HEAD of an existing LOD and include branch, tag and jenkins build jobs</h2></ul></i></td>
                    </tr>
                    <tr><td>&nbsp</td></tr>
            </table>
        </td>
    </tr>

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
</body>
</html>
