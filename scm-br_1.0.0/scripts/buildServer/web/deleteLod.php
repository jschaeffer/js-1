<!--
<script>
	var validateForm=function() {
</script>
-->

<?php

$multipleSelect='true';

if ( !isset($_POST['project']) ) {
    echo '<div align="center">';
    echo '<form method="post" name="selectProject">';
    echo '<table class="details">';
    echo '<tr>';
    echo '<th colspan="2">Select Project to Remove LOD</th>';
    echo '</tr>';
    echo '<tr>';
    echo '<td>Project Name</td>';
    echo '<td>' . getProjectDropDown('project') . '</td>';
    echo '</tr>';
    echo '</table>';
    echo '<input type="submit" value="Select Project"/>';
    echo '</form>';
    echo 'If your project is not selectable, it means you do not have any Jenkins jobs set up for it. Just delete your lod (branch) manually.';
    echo '</div>';

}
elseif ( !isset($_POST['lod[]']) ) {

    echo '<div align="center">';
    echo '<form method="post" name="deleteLod">';
    echo '<table class="details">';
    echo '<tr>';
    echo '<th colspan="2">Delete LOD from Project ' . $_POST['project'] . '</th>';
    echo '</tr>';
    echo '<tr>';
    echo '<td>LOD to Delete</td>';
    echo '<td>' . getLodDropDown($_POST['project'], 'lod[]', $multipleSelect ) . '</td>';
    echo '</tr>';
    echo '</table>';
    echo '<input type="submit" value="Delete LOD"/>';
    echo '<input type="hidden" name="project" value="' . $_POST['project'] . '"/>';
    echo '</form>';
    echo '</div>';
}

    if ( (strlen($_POST['project']) > 0 ) && ( count($_POST['lod']) > 0 ) ) {
       
        $LOD_ARRAY = $_POST['lod'];
	$PROJECT_NAME = $_POST['project'];
	//$LOD_COUNT = count($LOD_ARRAY);
 	//echo 'num_LODs = ' . $LOD_COUNT;

	echo "<hr size=\"1\">";
	echo "<div align=\"center\"><h3>Delete LOD Script Output</h3></div>";

	foreach( $LOD_ARRAY as $LOD ) {
	    $deleteLodCmd = $SOURCE_INFO . ' 2>&1 && cd ' .$SCM_SCRIPTS_DIR . ' 2>&1 && bin/eval.sh groovy scm.groovy -c DeleteLodCie --log_level=INFO --lod=' . $LOD . ' --project=' . $PROJECT_NAME . ' --path_to_project=/opt/checkouts'; 

	    // execute the command to release
	    echo $deleteLodCmd . '<br/>';
	    system($deleteLodCmd . ' | awk \'{print $0"<br/>"}\' ');
	}

    }
?>
