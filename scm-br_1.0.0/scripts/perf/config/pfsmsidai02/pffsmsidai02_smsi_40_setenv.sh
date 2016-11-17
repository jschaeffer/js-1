# Edit this file to set custom options
# Tomcat accepts two parameters JAVA_OPTS and CATALINA_OPTS
# JAVA_OPTS are used during START/STOP/RUN
# CATALINA_OPTS are used during START/RUN

JAVA_HOME="/usr/java/latest"
AGENT_PATHS=""
JAVA_AGENTS=""
JAVA_LIBRARY_PATH=""
export APPHOME_DIR=/opt/tcserver/instances/smsi_40
export CONFIG_DIR=$APPHOME_DIR/conf
export LOG4J_XML=$APPHOME_DIR/conf/smsi-log4j.xml
JVM_OPTS="-Xmx3G -Xss3G -XX:MaxPermSize=256m -Xss256K"
JAVA_OPTS="$JVM_OPTS $AGENT_PATHS $JAVA_AGENTS $JAVA_LIBRARY_PATH -Dschema-validation-enabled=true -Dconfig.dir=$CONFIG_DIR -Dlog4j.location=$LOG4J_XML -Dcrypt.key.path=/opt/tcserver/crypt/PERF.key -Dorg.apache.cxf.Logger=org.apache.cxf.common.logging.Log4jLogger" 
