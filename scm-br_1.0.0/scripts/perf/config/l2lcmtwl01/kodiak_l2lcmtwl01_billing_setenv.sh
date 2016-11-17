# Edit this file to set custom options
# Tomcat accepts two parameters JAVA_OPTS and CATALINA_OPTS
# JAVA_OPTS are used during START/STOP/RUN
# CATALINA_OPTS are used during START/RUN

JAVA_HOME="/usr/java/latest"
AGENT_PATHS=""
JAVA_AGENTS=""
JAVA_LIBRARY_PATH=""
JVM_OPTS="-Xss192K -Djava.awt.headless=true -Xms256m -Xmx512m -XX:MaxPermSize=256m -Dgemfire.disableShutdownHook=true"
export APPHOME_DIR=/opt/tcserver/instances/billing
export DAI_BILLING_CONFIG=$APPHOME_DIR/conf/dai-billing-config.properties
export DAI_BILLING_LOG4J_CONFIG=$APPHOME_DIR/conf/dai-billing-log4j.groovy
export CROWD_PROPERTIES=$APPHOME_DIR/conf/dai-billing-crowd.properties
export CROWD_EHCACHE=$APPHOME_DIR/conf/dai-billing-crowd-ehcache.xml
JAVA_OPTS="$JVM_OPTS $AGENT_PATHS $JAVA_AGENTS $JAVA_LIBRARY_PATH -Dschema.validation.enabled=true -DDAI_BILLING_CONFIG=$DAI_BILLING_CONFIG -DDAI_BILLING_LOG4J_CONFIG=$DAI_BILLING_LOG4J_CONFIG -Dorg.apache.cxf.Logger=org.apache.cxf.common.logging.Log4jLogger"
