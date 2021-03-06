<script>
	var validateForm=function() {
                var lodNameRE = /^br_[0-9]+.[0-9]+/;
//		var lodNameRE = /^br_[0-9]+.[0-9]+.[0-9]+/;
		var lodNameSrc = document.forms["createLod"]["lod"].value;
		var lodNameNew = document.forms["createLod"]["newLod"].value;
		var errorMsg = "";
		var error = "false";
		var lod_num = "";
		if (!lodNameNew.match(lodNameRE)) {
			errorMsg = "LOD name does not adhere to the naming standard. The name must be of the form \"br_number.number.number\".";	
			error = "true";
		}
		lod_num = lodWLevelCompare(lodNameSrc.toString(), lodNameNew.toString());
		if(lod_num >= 0) {
			errorMsg = errorMsg + " The LOD you entered needs to increment related to the LOD your branching from. Make sure the new LOD is incrementally higher than the source LOD.";
			error = "true";
		}
			
		if (error == "true") {
			document.forms["createLod"].elements["newLod"].focus();
			alert(errorMsg);
			return false;
		}
		else {
			return true;
		}
	}
	
	function lodWLevelCompare(x, y) {
		var x_array = x.split("_");	
		var y_array = y.split("_");
		var x_noLev = x_array[1];
		var y_noLev = y_array[1];
		return lodCompare(x_noLev, y_noLev);
	}

	function lodCompare(x, y) {
		var x_array = x.split(".");
		var y_array = y.split(".");
		var major_compare = x_array[0] - y_array[0];
		var minor_compare = x_array[1] - y_array[1];
		var patch_compare = x_array[2] - y_array[2];
		if(major_compare != 0) {
			return major_compare;
		} 
		else {
			if(minor_compare != 0) {
				return minor_compare;
			} 
			else {
				return patch_compare;
	 		}
		}
	}
	
</script>

<?php

$multipleSelect='false';

if ( !isset($_POST['project']) ) {
    echo '<div align="center">';
    echo '<form method="post" name="selectProject">';
    echo '<table class="details">';
    echo '<tr>';
    echo '<th colspan="2">Select Project to Create LOD</th>';
    echo '</tr>';
    echo '<tr>';
    echo '<td>Project Name</td>';
    echo '<td>' . getProjectDropDown('project') . '</td>';
    echo '</tr>';
    echo '</table>';
    echo '<input type="submit" value="Select Project"/>';
    echo '</form>';
	echo 'If your project is not selectable, you need to do two things. First, you need to create an lod that <br>';
	echo 'conforms to the standard br_number.number.number naming convention. Second, you need to send an email <br>';
	echo 'to jeff.schaeffer@canoe-ventures.com to have a jenkins build setup for you. The project dropdown values are refreshed <br>';
	echo 'every 5 minutes.<br>';
    echo '</div>';

}
elseif ( !isset($_POST['lod']) ) {

    echo '<div align="center">';
    echo '<form method="post" onsubmit="return validateForm()" name="createLod">';
    echo '<table class="details">';
    echo '<tr>';
    echo '<th colspan="2">Create LOD for Project ' . $_POST['project'] . '</th>';
    echo '</tr>';
    echo '<tr>';
    echo '<td>Source LOD to Branch From</td>';
    echo '<td>' . getLodDropDown($_POST['project'], 'lod', $multipleSelect) . '</td>';
    echo '</tr>';
    echo '<tr>';
    echo '<td>LOD Name to Create</td>';
	echo '<td><input type="text" name="newLod" size="12"></td>';
    echo '</tr>';
    echo '</table>';
    echo '<input type="submit" value="Create LOD"/>';
    echo '<input type="hidden" name="project" value="' . $_POST['project'] . '"/>';
    echo '</form>';
    echo '</div>';
}

    if ( (strlen($_POST['project']) > 0 ) && ( strlen($_POST['lod']) > 0 ) && ( strlen($_POST['newLod']) > 0 ) ) {
       
        $SRC_LOD = $_POST['lod'];
	$NEW_LOD = $_POST['newLod'];
	$PROJECT_NAME = $_POST['project'];

	//$createLodCmd = 'bash -c "source ~/.bash_profile 2>&1 && cd ' .$SCM_SCRIPTS_DIR . ' 2>&1 && bin/eval.sh groovy scm.groovy -c CreateLodCie --log_level=INFO --lod_src=' . $SRC_LOD . ' --lod_new=' . $NEW_LOD . ' --project=' . $PROJECT_NAME . ' --path_to_project=/opt/checkouts"'; 
	$createLodCmd = $SOURCE_INFO . ' 2>&1 && cd ' .$SCM_SCRIPTS_DIR . ' 2>&1 && bin/eval.sh groovy scm.groovy -c CreateLodCie --log_level=INFO --lod_src=' . $SRC_LOD . ' --lod_new=' . $NEW_LOD . ' --project=' . $PROJECT_NAME . ' --path_to_project=/opt/checkouts'; 

	echo "<hr size=\"1\">";
	echo "<div align=\"center\"><h3>Create LOD Script Output</h3></div>";

	// execute the command to release
	echo $createLodCmd . '<br/>';
	system($createLodCmd . ' | awk \'{print $0"<br/>"}\' ');

    }
?>
