<?php
if($_POST['formSubmit'] == "Submit")
{
	$errorMessage = "";
	
	if(empty($_POST['formName']))
	{
		$errorMessage .= "<li>You forgot to enter a name!</li>";
	}
	
	$varDeploy = $_POST['formDeploy'];
	$varName = $_POST['formName'];

	if(empty($errorMessage)) 
	{
		$fs = fopen("formDeploy.csv","a");
                foreach ($comps as $components) {
                    print "Selected ${components}<br />\n";
		    fwrite($fs,$components . ", " . $varDeploy . ", " . $varComp ."\n");
                }
		fclose($fs);
		
		header("Location: endit.html");
		exit;
	}
}
?>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd"> 
<html>
<head>
	<title>Deploy Promotion</title>
</head>

<body>
	<?php
		if(!empty($errorMessage)) 
		{
			echo("<p>There was an error with your entry:</p>\n");
			echo("<ul>" . $errorMessage . "</ul>\n");
		} 
	?>
	<form action="endit.php" method="post">
		<p>
			What component would you like to promote?<br>
			<input type="text" name="formDeploy" maxlength="50" value="<?=$varDeploy;?>" />
		</p>
		<p>
			What is your name?<br>
			<input type="text" name="formName" maxlength="50" value="<?=$varName;?>" />
		</p>				
     <p>
        Please choose the component you wish to promote 
    </p>

   <?php
    $lines = file('projectList.wrk');

$comps = array();
$inc="0";
foreach ($lines as $line_num => $line) {
   $inc= $inc+1;
   $comps[$inc] = ${line};
   print "<input type=\"checkbox\" name=\"${comps}\" value=\"$comps[$inc]}\">${line}<br>";
}
?>
		<input type="submit" name="formSubmit" value="Submit" />
	</form>
</body>
</html>
