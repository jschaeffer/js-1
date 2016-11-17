These php pages were created to enable push-button automation to common tasks such as creating new LODs (Lines of Developement, or branches), deploying releases to target environments, etc.

In order to configure the environment properly, make sure to create a sym-link called config.php to point to the proper config.php file (dev.config.php, or prod.config.php)

The apache server should be configured to run as the user that has ownership of the scm scripts (usually cvbuild)
