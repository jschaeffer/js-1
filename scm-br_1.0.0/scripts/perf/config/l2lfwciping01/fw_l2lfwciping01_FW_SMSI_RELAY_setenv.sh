# Edit this file to set custom options
# Tomcat accepts two parameters JAVA_OPTS and CATALINA_OPTS
# JAVA_OPTS are used during START/STOP/RUN
# CATALINA_OPTS are used during START/RUN

JAVA_HOME="/usr/java/latest"
AGENT_PATHS=""
JAVA_AGENTS=""
JVM_OPTS="-Xss192K -Djava.awt.headless=true -Xms512m -Xmx512m -XX:MaxPermSize=256m -Dgemfire.disableShutdownHook=true"
export APPHOME_DIR=/opt/tcserver/instances/FW_SMSI_RELAY
export CONFIG_DIR=$APPHOME_DIR/conf
export LOG4J_XML=$APPHOME_DIR/conf/log4j.xml

JAVA_OPTS="$JVM_OPTS $AGENT_PATHS $JAVA_AGENTS $JAVA_LIBRARY_PATH -Djavax.net.ssl.trustStore=/opt/tcserver/.l2lfwciping01.truststore -Dschema.validation.enabled=true -Dconfig.dir=$CONFIG_DIR -Dlog4j.location=$LOG4J_XML -Dorg.apache.cxf.Logger=org.apache.cxf.common.logging.Log4jLogger"
