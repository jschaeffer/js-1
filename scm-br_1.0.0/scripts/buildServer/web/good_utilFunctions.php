<?php
// ####################################################################################################
//
//                            DO NOT EDIT BELOW HERE
//
// ####################################################################################################

function promotionLevelCompare($x, $y){
    $array = array('dev', 'qa', 'stage', 'prod');
    $x_pos = -1;
    $y_pos = -1;

    $count = count($array);
    for ($i = 0; $i < $count; $i++) {
        if ( strcmp($array[$i], $x) == 0 ){
            $x_pos = $i;
        }
    }

    $count = count($array);
    for ($i = 0; $i < $count; $i++) {
        if ( strcmp($array[$i], $y) == 0 ){
            $y_pos = $i;
        }
    }

    #echo $x_pos . "<br>";
    #echo $y_pos . "<br>";

    return $x_pos - $y_pos;
}

function lodWLevelCompare($x, $y){
    $x_noLev = substr($x, strpos($x,'_')+1);
    $y_noLev = substr($y, strpos($y,'_')+1);
    return lodCompare($x_noLev, $y_noLev);
}

function lodCompare($x, $y){
    list($x_major, $x_minor, $x_patch) = explode(".", $x);
    list($y_major, $y_minor, $y_patch) = explode(".", $y);

    $major_compare = intval($x_major) - intval($y_major);
//    echo "major_compare = " . $major_compare;
    $minor_compare = intval($x_minor) - intval($y_minor);
//    echo "minor_compare = " . $minor_compare;
    $patch_compare = intval($x_patch) - intval($y_patch);
//    echo "patch_compare = " . $patch_compare;

    if ( $major_compare != 0 ) {
        return $major_compare;
    } else {
        if ( $minor_compare != 0 ) {
            return $minor_compare;
        } else {
            return $patch_compare;
        }
    }
}

function snapshotCompare($x, $y){
    list($x_lod, $x_build_number) = explode("_", $x);
    list($y_promotion_level, $y_lod, $y_build_number) = explode("_", $y);
    #echo $x_lod;
    #echo $x_build_number;
    #echo $y_promotion_level;
    #echo $y_lod;
    #echo $y_build_number;
    $lod_compare = lodCompare($x_lod, $y_lod);
    $number_compare = intval($x_build_number) - intval($y_build_number);
    if ( $lod_compare != 0 ) {
        return $lod_compare;
    } else {
        return $number_compare;
    }
}

function curlRequest($url) {
	
	$userpass = 'cvbuild-cnv/token:772f934fda55bbd825e5be3cc95f3bd4';
	$curl_handle=curl_init();
	curl_setopt($curl_handle,CURLOPT_URL, $url);
	curl_setopt($curl_handle,CURLOPT_SSL_VERIFYPEER, 'FALSE');
	curl_setopt($curl_handle,CURLOPT_USERPWD, $userpass);
	curl_setopt($curl_handle,CURLOPT_RETURNTRANSFER,1);
	$buffer = curl_exec($curl_handle);
	curl_close($curl_handle);
	return $buffer;	
}

function getProjectDropDown($FORM_ITEM_NAME) {

	$outFile = "/var/www/html/projectList.txt";
	$output = '<select name="' . $FORM_ITEM_NAME . '">';
	$repos = array();
	$fileHandle = fopen($outFile, 'r') or die("cannot open file " . $outFile);
	
	while(!feof($fileHandle)) {
		$line = fgets($fileHandle);
		//echo $line . '<br>';
		$projectName = strtok($line, "=");
		$projectStatus = strtok("=");		
		if((strcmp($projectStatus, "enabled")) == 1) {
			$output = $output . '<option value="' . $projectName . '">' . $projectName . '</option>';		
		}
		else {
			$output = $output . '<option value="' . $projectName . '" disabled>' . $projectName . '</option>';		
		}
		//$repos[$projectName] = $projectStatus;			
	}
	fclose($fileHandle);
	//sort($repos);
/*
	foreach ($repos as $repo => $status) {
		echo 'Repo: ' . $repo . ' Status: ' . $status . '<br/>';
		if($status = 'enabled') {
			$output = $output . '<option value="' . $repo . '">' . $repo . '</option>';		
		}
		else {
			$output = $output . '<option value="' . $repo . '" disabled>' . $repo . '</option>';		
		}
	}
*/
	//$output = $output . '<option value="js-1">js-1</option>';		
	$output = $output. '</select>';
	return $output;
}

/**
 * This function returns an html dropdown of all the active projects
 */
function getProjectList() {

	$outFileNew = "/var/www/html/projectList.new";
	$outFileOrig = "/var/www/html/projectList.txt";
	$repos = array();
	$lodRE = '/br_[0-9]+.[0-9]+.[0-9]+/';
	$github_repos_url = 'https://github.com/api/v2/json/repos/show/CanoeVentures';    
	$curlResponse = curlRequest($github_repos_url);

	if (empty($curlResponse)) {
		print "Sorry - no data was returned.<p>";
	}
	else {
		$jsonResult = json_decode($curlResponse);		
		foreach($jsonResult->repositories as $r) {
			$repos[] = $r->name;	
		}
	}
	sort($repos);
	$valid_branch = " ";
        $valid_tag = " ";
	$fileHandle = fopen($outFileNew, 'w') or die("cannot open file " . $outFileNew);
	foreach ($repos as $repo) {
		$curlResponse = curlRequest($github_repos_url . '/' . $repo . '/branches');		
		$jsonResult = json_decode($curlResponse);
		sleep(2);
		
		foreach($jsonResult->branches as $key => $val) {
			if (preg_match($lodRE, $key)) {
				$valid_branch = "true";
				break;
			}
			else {
				$valid_branch = "false";
			}
		}
		if ($valid_branch == "true") {
			fwrite($fileHandle, $repo . "=enabled\n");
			$valid_branch = "false";
		}
		else {
			fwrite($fileHandle, $repo . "=disabled\n");
		}		
	}
	fclose($fileHandle);
	// may need to put in a semaphore here
	copy($outFileNew, $outFileOrig);
}



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
    $getLodCmd = 'bash -c "'. $SOURCE_INFO . ' 2>&1 && cd ' .$SCM_SCRIPTS_DIR . ' 2>&1 && bin/eval.sh groovy scm.groovy -c GetLodsForProject --log_level=DEBUG --project=' . $PROJECT . ' --path_to_project=/opt/checkouts"'; 
    exec($getLodCmd . ' | egrep -e "^br_*"', $lods);
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
?>
