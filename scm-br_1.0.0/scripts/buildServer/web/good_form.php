<?php
    $targ = "devint";
    if (isset($_POST['refresh_button']))
    {
         shell_exec("java -jar /opt/tools/tmp/jenkins-cli.jar -s http://cvbuild.cv.infra:7001 build tmp_chkdates");
    }
?>
<html>
<body>
    <form method="POST">
    <p>
        <button name="refresh_button" value="test">Run Test</button>
    </p>
    </form>
</body>


//<?php
   //$mycmd = 'bash -c "source ~/.bash_profile 2>&1 && ls /tmp"
//    print "this is it";
 //   print "<form name=input method=post action=shell_exec(\"ls /tmp\")>";
  //  print "<input type=\"submit\" value=\"Refresh Data\"/>";
   // print "</form>";

//<form name="input" action=`shell_exec("ls /tmp")` method="get">
//Username: <input type="text" name="user">
//<input type="submit" value="Refresh Data">
//</form> 


//<?php
//print "<form action=shell_exec("java -jar /opt/tools/tmp/jenkins-cli.jar -s http://cvbuild.cv.infra:7001 build dai_scm-PackageDeploy-4.0.0") method=\"post\">";
//print "<input type="submit" value="Branch Type"/>";
//print "</form>";
//?>

//</div>
</html>
