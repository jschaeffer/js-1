# Edit this file to set custom options
# Tomcat accepts two parameters JAVA_OPTS and CATALINA_OPTS
# JAVA_OPTS are used during START/STOP/RUN
# CATALINA_OPTS are used during START/RUN

JAVA_HOME="/usr/java/latest"
AGENT_PATHS=""
JAVA_AGENTS=""
JAVA_LIBRARY_PATH=""
JVM_OPTS="-Xss256K -Djava.awt.headless=true -Xms1G -Xmx1G -XX:MaxPermSize=256m -Dgemfire.disableShutdownHook=true"
export APPHOME_DIR=/opt/tcserver/instances/smsi-admin
export SMSI_ADMIN_CONFIG=$APPHOME_DIR/conf/smsi-admin-config.properties
export CROWD_PROPERTIES=$APPHOME_DIR/conf/smsi-admin-crowd.properties
export CROWD_EHCACHE=$APPHOME_DIR/conf/smsi-admin-crowd-ehcache.xml
export SMSI_ADMIN_LOG4J_CONFIG=$APPHOME_DIR/conf/smsi-admin-log4j.groovy
JAVA_OPTS="$JVM_OPTS $AGENT_PATHS $JAVA_AGENTS $JAVA_LIBRARY_PATH -DSMSI_ADMIN_CONFIG=$SMSI_ADMIN_CONFIG -DSMSI_ADMIN_LOG4J_CONFIG=$SMSI_ADMIN_LOG4J_CONFIG -DCROWD_PROPERTIES=$CROWD_PROPERTIES -DCROWD_EHCACHE=$CROWD_EHCACHE -Dorg.apache.cxf.Logger=org.apache.cxf.common.logging.Log4jLogger"
