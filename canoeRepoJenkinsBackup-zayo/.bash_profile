# .bash_profile

# Get the aliases and functions
if [ -f ~/.bashrc ]; then
	. ~/.bashrc
fi

# User specific environment and startup programs

CLASSPATH=${CLASSPATH}:/opt/build/scm/scripts/buildServer/groovy/lib/log4j_1.2.15.jar:/opt/build/scm/scripts/buildServer/groovy/lib/commons-logging-1.1.1.jar:/opt/build/scm/scripts/buildServer/groovy/lib:/opt/tools/atlassian-cli/lib
export CLASSPATH

M3_HOME="/opt/cvbuild"
export M3_HOME

MVN_CACHE="/opt/cvbuild/.m2"
export MVN_CACHE

IVY_CACHE="/opt/cvbuild/.ivy2/cache"
export IVY_CACHE

JENKINS_HOME="/opt/cie/jenkins"
export JENKINS_HOME

JENKINS_URL="http://cvbuild.cv.infra/:7001/"
export JENKINS_URL

GRAILS_HOME="/opt/tools/grails"
export GRAILS_HOME

GRADLE_HOME="/opt/tools/gradle"
export GRADLE_HOME

GRADLE_OPTS="-Dorg.gradle.daemon=false"

GROOVY_HOME="/opt/tools/groovy"
export GROOVY_HOME

GIT_HOME="/opt/git/bin"
export GIT_HOME

GIT_EXEC_PATH="/opt/git/2.0.4/libexec/git-core"
export GIT_EXEC_PATH

JAVA_HOME="/opt/tools/jdk1.8.0_25"
export JAVA_HOME

JDK_HOME="/opt/tools/jdk1.8.0_25"
export JDK_HOME

SCALA_HOME="/opt/tools/scala"
export SCALA_HOME

MAVEN_HOME="/opt/tools/apache-maven-3.2.3"
export MAVEN_HOME

ANT_HOME="/opt/tools/apache-ant-1.7.1"
export ANT_HOME

SOAPUI_HOME="/opt/tools/soapui"
export SOAPUI_HOME

SCM_CONFIG="/opt/cvbuild/config/scmConfig.groovy"
export SCM_CONFIG

DAI_CIPHOME="/opt/cvbuild/config/dai-cip"
export DAI_CIPHOME

DAI_CIP_CONFIG="/opt/cvbuild/config/dai-cip-feedback"
export DAI_CIP_CONFIG

SMSICONFIG="/opt/cvbuild/config/smsi-publisher"
export SMSICONFIG

DAI_SCM_SOURCE="/opt/cvbuild/config/dai_scm_source"
export DAI_SCM_SOURCE

DAI_SCM_TARGET="/opt/cvbuild/config/dai_scm_target"
export DAI_SCM_TARGET

CORE_CONFIG="/opt/cvbuild/config/dai-core"
export CORE_CONFIG

CROWD_PROPERTIES="/opt/cvbuild/config/dai_cm/Dynamic-Ad-Insertion-cm-crowd.properties"
export CROWD_PROPERTIES

CROWD_EHCACHE="/opt/cvbuild/config/dai_cm/Dynamic-Ad-Insertion-cm-crowd-ehcache.xml"
export CROWD_EHCACHE

DAI_CM_HOME="/opt/cvbuild/config/dai_cm"
export DAI_CM_HOME

DAI_CM_CONFIG="/opt/cvbuild/config/dai_cm/Dynamic-Ad-Insertion-cm-config.properties"
export DAI_CM_CONFIG

DAI_LOG4J_CONFIG="/opt/cvbuild/config/dai_cm/Dynamic-Ad-Insertion-cm-log4j.groovy.xml"
export DAI_LOG4J_CONFIG

CM_CROWD_PROPERTIES="/opt/cvbuild/config/dai_cm/Dynamic-Ad-Insertion-cm-crowd.properties"
export CM_CROWD_PROPERTIES

CM_CROWD_EHCACHE=/opt/cvbuild/config/dai_cm/"Dynamic-Ad-Insertion-cm-crowd-ehcache.xml"
export CM_CROWD_EHCACHE

DAI_DCECONFIG="/opt/cvbuild/config/dai-dce"
export DAI_DCECONFIG

ORACLE_HOME="/usr/lib/oracle/11.2/client64"
export ORACLE_HOME

LD_LIBRARY_PATH="${ORACLE_HOME}/lib:${LD_LIBRARY_PATH}"
export LD_LIBRARY_PATH

TNS_ADMIN="/opt/cvbuild/tnsadmin"
export TNS_ADMIN

PHANTOMJS_HOME="/opt/tools/phantomjs-1.9.7-linux-x86_64"
export PHANTOMJS_HOME

PATH=${JAVA_HOME}/bin:$PATH:$HOME/bin:${GIT_HOME}:${GRAILS_HOME}/bin:${GRADLE_HOME}/bin:${GROOVY_HOME}/bin:$ANT_HOME/bin:${MAVEN_HOME}/bin:${ORACLE_HOME}/bin:${SCALA_HOME}/bin:${SOAPUI_HOME}/bin:${PHANTOMJS_HOME}/bin

export PATH

dvappdai01=cv-devint.cv.scrum
dvappdai02=cv-scrum01.cv.scrum
dvappdai03=cv-scrum02.cv.scrum
dvappdai04=cv-scrum03.cv.scrum
dvappdai05=cv-scrum04.cv.scrum

alias vi=/bin/vi




