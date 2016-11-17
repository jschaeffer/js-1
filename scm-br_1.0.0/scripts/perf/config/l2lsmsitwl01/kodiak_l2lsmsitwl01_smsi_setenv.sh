# Edit this file to set custom options
# Tomcat accepts two parameters JAVA_OPTS and CATALINA_OPTS
# JAVA_OPTS are used during START/STOP/RUN
# CATALINA_OPTS are used during START/RUN

JAVA_HOME="/usr/java/latest"
AGENT_PATHS=""
JAVA_AGENTS=""
JAVA_LIBRARY_PATH=""
export APPHOME_DIR=/opt/tcserver/instances/smsi
export CONFIG_DIR=$APPHOME_DIR/conf
export LOG4J_XML=$APPHOME_DIR/conf/smsi-log4j.xml
JVM_OPTS="-Xmx1G -Xss1G"
JAVA_OPTS="$JVM_OPTS $AGENT_PATHS $JAVA_AGENTS $JAVA_LIBRARY_PATH -Dconfig.dir=$CONFIG_DIR -Dlog4j.location=$LOG4J_XML -Dcrypt.key.path=/opt/tcserver/crypt/L2L.key -Dorg.apache.cxf.Logger=org.apache.cxf.common.logging.Log4jLogger -Dschema-validation-enabled=true" 
