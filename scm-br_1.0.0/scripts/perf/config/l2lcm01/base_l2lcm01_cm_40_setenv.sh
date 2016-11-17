# Edit this file to set custom options
# Tomcat accepts two parameters JAVA_OPTS and CATALINA_OPTS
# JAVA_OPTS are used during START/STOP/RUN
# CATALINA_OPTS are used during START/RUN

JAVA_HOME="/usr/java/latest"
AGENT_PATHS=""
JAVA_AGENTS=""
JAVA_LIBRARY_PATH=""
JVM_OPTS="-Xss192K -Djava.awt.headless=true -Xms512m -Xmx1024m -XX:MaxPermSize=256m -Dgemfire.disableShutdownHook=true"
export APPHOME_DIR=/opt/tcserver/instances/cm_40
export DAI_CM_CONFIG=$APPHOME_DIR/conf/Dynamic-Ad-Insertion-cm-config.properties
export CROWD_PROPERTIES=$APPHOME_DIR/conf/Dynamic-Ad-Insertion-cm-crowd.properties
export CROWD_EHCACHE=$APPHOME_DIR/conf/Dynamic-Ad-Insertion-cm-crowd-ehcache.xml
export DAI_LOG4J_CONFIG=$APPHOME_DIR/conf/cm_log4j.groovy
JAVA_OPTS="$JVM_OPTS $AGENT_PATHS $JAVA_AGENTS $JAVA_LIBRARY_PATH -Dschema.validation.enabled=true -DDAI_CM_CONFIG=$DAI_CM_CONFIG -DDAI_LOG4J_CONFIG=$DAI_LOG4J_CONFIG -DCROWD_PROPERTIES=$CROWD_PROPERTIES -DCROWD_EHCACHE=$CROWD_EHCACHE -Dorg.apache.cxf.Logger=org.apache.cxf.common.logging.Log4jLogger"

