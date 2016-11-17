# Edit this file to set custom options
# Tomcat accepts two parameters JAVA_OPTS and CATALINA_OPTS
# JAVA_OPTS are used during START/STOP/RUN
# CATALINA_OPTS are used during START/RUN

JAVA_HOME="/usr/java/latest"
AGENT_PATHS=""
JAVA_AGENTS=""
JAVA_LIBRARY_PATH=""
JVM_OPTS="-Xss192K -Djava.awt.headless=true -Xms512m -Xmx1024m -XX:MaxPermSize=256m -Dgemfire.disableShutdownHook=true"
export APPHOME_DIR=/opt/tcserver/instances/caas_admin
export DAI_CAASADMIN_CONFIG=$APPHOME_DIR/conf/caas-admin-config.properties
export CROWD_PROPERTIES=$APPHOME_DIR/conf/caas-admin-crowd.properties
export CROWD_EHCACHE=$APPHOME_DIR/conf/caas-admin-crowd-ehcache.xml
export DAI_CAASADMIN_LOG4J_CONFIG=$APPHOME_DIR/conf/caas_admin_log4j.groovy
JAVA_OPTS="$JVM_OPTS $AGENT_PATHS $JAVA_AGENTS $JAVA_LIBRARY_PATH -Dschema.validation.enabled=true -DDAI_CAASADMIN_CONFIG=$DAI_CAASADMIN_CONFIG -DDAI_CAASADMIN_LOG4J_CONFIG=$DAI_CAASADMIN_LOG4J_CONFIG -Dorg.apache.cxf.Logger=org.apache.cxf.common.logging.Log4jLogger"
