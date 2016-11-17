JAVA_HOME="/usr/java/latest"
AGENT_PATHS=""
JAVA_AGENTS=""
JVM_OPTS="-Xss192K -Djava.awt.headless=true -Xms256m -Xmx512m -XX:MaxPermSize=256m -Dgemfire.disableShutdownHook=true"
JAVA_LIBRARY_PATH=""
export APPHOME_DIR=/opt/tcserver/instances/cm01
export DAI_CM_CONFIG=$APPHOME_DIR/conf/Dynamic-Ad-Insertion-cm-config.properties
export DAI_LOG4J_CONFIG=$APPHOME_DIR/conf/Dynamic-Ad-Insertion-cm-log4j.groovy
export CROWD_PROPERTIES=$APPHOME_DIR/conf/Dynamic-Ad-Insertion-cm-crowd.properties
export CROWD_EHCACHE=$APPHOME_DIR/conf/Dynamic-Ad-Insertion-cm-crowd-ehcache.xml
JAVA_OPTS="$JVM_OPTS $AGENT_PATHS $JAVA_AGENTS $JAVA_LIBRARY_PATH -Dschema.validation.enabled=true -DDAI_CM_CONFIG=$DAI_CM_CONFIG -DDAI_LOG4J_CONFIG=$DAI_LOG4J_CONFIG -Dorg.apache.cxf.Logger=org.apache.cxf.common.logging.Log4jLogger"
