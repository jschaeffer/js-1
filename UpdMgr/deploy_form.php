<!DOCTYPE HTML>  
<html>
<head>
<style>
.error {color: #FF0000;}
</style>
</head>
<body>  

<?php
// define variables and set to empty values
$nameErr = $versionlErr = $rebuilddbErr = $targetErr = "";
$name = $version = $rebuilddb = $comment = $target = "";

if ($_SERVER["REQUEST_METHOD"] == "POST") {
  if (empty($_POST["name"])) {
    $nameErr = "Component Name is required";
  } else {
    $name = test_input($_POST["name"]);
    // check if name only contains letters and whitespace
    if (!preg_match("/^[a-zA-Z ]*$/",$name)) {
      $nameErr = "Only letters and white space allowed"; 
    }
  }
  
  if (empty($_POST["version"])) {
    $versionErr = "Version is required";
  } else {
    $version = test_input($_POST["version"]);
    // check if e-mail address is well-formed
    if (!filter_var($version, FILTER_VALIDATE_EMAIL)) {
      $versionErr = "Invalid version format"; 
    }
  }
    
  if (empty($_POST["target"])) {
    $target = "";
  } else {
    $target = test_input($_POST["target"]);
    // check if URL address syntax is valid (this regular expression also allows dashes in the URL)
    if (!preg_match("/\b(?:(?:https?|ftp):\/\/|www\.)[-a-z0-9+&@#\/%?=~_|!:,.;]*[-a-z0-9+&@#\/%=~_|]/i",$target)) {
      $targetErr = "Invalid Entry"; 
    }
  }

  if (empty($_POST["comment"])) {
    $comment = "";
  } else {
    $comment = test_input($_POST["comment"]);
  }

  if (empty($_POST["rebuilddb"])) {
    $rebuilddbErr = "Rebuild check is required";
  } else {
    $rebuilddb = test_input($_POST["rebuilddb"]);
  }
}

function test_input($data) {
  $data = trim($data);
  $data = stripslashes($data);
  $data = htmlspecialchars($data);
  return $data;
}
?>

<h2>Single Component Deploy</h2>
<p><span class="error">* required field.</span></p>
//<form method="post" action="<?php echo htmlspecialchars($_SERVER["PHP_SELF"]);?>">
<form method="post" action="deploy_out.php">  
  Component Name: <input type="text" name="name" value="<?php echo $name;?>">
  <span class="error">* <?php echo $nameErr;?></span>
  <br><br>
  Version: <input type="text" name="version" value="<?php echo $version;?>">
  <span class="error">* <?php echo $versionErr;?></span>
  <br><br>
  Scrum Target: <input type="text" name="target" value="<?php echo $target;?>">
  <span class="error"><?php echo $targetErr;?></span>
  <br><br>
  Comment: <textarea name="comment" rows="5" cols="40"><?php echo $comment;?></textarea>
  <br><br>
  Rebuild DB?:
  <input type="radio" name="rebuilddb" <?php if (isset($rebuilddb) && $rebuilddb=="Yes") echo "checked";?> value="Yes">Yes
  <input type="radio" name="rebuilddb" <?php if (isset($rebuilddb) && $rebuilddb=="No") echo "checked";?> value="No">No
  <span class="error">* <?php echo $rebuilddbErr;?></span>
  <br><br>
  <input type="submit" name="submit" value="Check">  
</form>

</body>
</html>
