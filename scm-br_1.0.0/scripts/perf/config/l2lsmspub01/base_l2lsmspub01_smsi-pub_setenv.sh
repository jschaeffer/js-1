JAVA_HOME="/usr/java/latest"
AGENT_PATHS=""
JAVA_AGENTS=""
JAVA_LIBRARY_PATH="-Djava.library.path=$CATALINA_BASE/insight/sigar-lib"
JVM_OPTS="-Xss192K -Djava.awt.headless=true -Xms256m -Xmx512m -XX:MaxPermSize=256m -Dgemfire.disableShutdownHook=true" 
export APPHOME_DIR=/opt/tcserver/instances/smsi-pub
export SMSICONFIG=$APPHOME_DIR/conf/smsi-publisher.properties
export LOG4J_CONFIG=$APPHOME_DIR/conf/smsi-publisher-log4j.properties
JAVA_OPTS="$JVM_OPTS $AGENT_PATHS $JAVA_AGENTS $JAVA_LIBRARY_PATH -Dschema.validation.enabled=true -Dconfig.file=$SMSICONFIG -Dlog4j.configuration=$LOG4J_CONFIG -Dorg.apache.cxf.Logger=org.apache.cxf.common.logging.Log4jLogger"
