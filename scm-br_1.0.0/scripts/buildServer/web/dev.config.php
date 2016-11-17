<?php
// Using sudo to restart apache does not setup the environmental variables correct.
// Set correct env variables here

#@apache_setenv('no-gzip', 1);
#@ini_set('zlib.output_compression', 0);
#@ini_set('implicit_flush', 1);
#for ($i = 0; $i < ob_get_level(); $i++) { ob_end_flush(); }
#ob_implicit_flush(1);

putenv("HOME=/home/cvbuild");
putenv("USER=cvbuild");

$BASE_URI="/scm";

// This is just a generic date time definition that gets loaded with each page  hit
$DATE_TIME_STAMP=date('o-m-d_H-i-s');

// This is the location of the scm web php pages
$WEB_DIR='/var/www/html/web';

$SOURCE_INFO='source ~/.bash_profile';

// This is the location of your scripts directory 
$SCM_SCRIPTS_DIR='/opt/build/scm/scripts/buildServer/groovy';

// This is the location of the build logs
$BUILDLOGS='/opt/build/scm/scripts/buildServer/log';

// Packaged assets directory.  Location of all compiled wars, db scripts and config files that can be deployed
$ASSETS='/opt/build/releaseTars';

$LOG_LEVEL="INFO";

$LODS_URI="lods";

$LOCAL_DIR="/opt/build/tempDirs";

?>
