<?php
// ####################################################################################################
//
//                            DO NOT EDIT BELOW HERE
//
// ####################################################################################################


/**
 * This function returns an html dropdown of all the official "br_" lods defined on a specified Project
 */
function getLodDropDown($PROJECT, $FORM_ITEM_NAME, $MULTIPLE_SELECT) {
    $SCM_SCRIPTS_DIR = "/opt/build/scm/scripts/buildServer/groovy";
	//echo $SCM_SCRIPTS_DIR;
    $SOURCE_INFO = "source /opt/cvbuild/.bash_profile 2>&1";
    // get an array for each branch
    $lods = array();
//    $getLodCmd = $SOURCE_INFO . ' 2>&1 && cd ' .$SCM_SCRIPTS_DIR . ' 2>&1 && bin/eval.sh groovy scm.groovy -c GetLodsForProject --log_level=' . $LOG_LEVEL . ' --project=' . $PROJECT . ' --path_to_project=' . $PATH_TO_PROJECT; 
//    $getLodCmd = 'bash -c "'. $SOURCE_INFO . ' 2>&1 && cd ' .$SCM_SCRIPTS_DIR . ' 2>&1 && bin/eval.sh groovy scm.groovy -c GetLodsForProject --log_level=INFO --project=' . $PROJECT . ' --path_to_project=/opt/checkouts"'; 
    $getLodCmd = 'bash -c "'. $SOURCE_INFO . ' 2>&1 && cd ' .$SCM_SCRIPTS_DIR . ' 2>&1 && bin/eval.sh groovy scm.groovy -c GetTagsForProject --log_level=INFO --project=' . $PROJECT . ' --path_to_project=/opt/checkouts"';
    exec($getLodCmd . ' | egrep -e "^r_*"', $lods);
//    exec($getLodCmd . ' | egrep -e "^br_*"', $lods);
    usort($lods, 'lodWLevelCompare');
    $lods = array_reverse($lods);

    if($MULTIPLE_SELECT == 'true') {
        $output = '<select name="' . $FORM_ITEM_NAME . '" ' . 'multiple="multiple" size="5">';
    }
    else {
        $output = '<select name="' . $FORM_ITEM_NAME . '">';
    }
    foreach ($lods as $lod) {
        $lod = str_replace('/','',$lod);
        $output = $output . '<option value="' . $lod . '">' . $lod . '</option>';
    }
    $output = $output. '</select>';
    return $output;
}

function 
?>
