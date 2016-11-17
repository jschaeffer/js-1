# Edit this file to set custom options
# Tomcat accepts two parameters JAVA_OPTS and CATALINA_OPTS
# JAVA_OPTS are used during START/STOP/RUN
# CATALINA_OPTS are used during START/RUN

JAVA_HOME="/usr/java/latest"
AGENT_PATHS=""
JAVA_AGENTS=""
JAVA_LIBRARY_PATH=""
export APPHOME_DIR=/opt/tcserver/instances/CIS_FW
export CONFIG_DIR=$APPHOME_DIR/cis-config
export LOG4J_XML=$APPHOME_DIR/conf/log4j_cis.xml
JVM_OPTS="-Xmx512M -Xss192K"
JAVA_OPTS="$JVM_OPTS $AGENT_PATHS $JAVA_AGENTS $JAVA_LIBRARY_PATH  -Dconfig.dir=$CONFIG_DIR -Dcrypt.key.path=/opt/tcserver/crypt/L2L.key -Dlog4j.location=$LOG4J_XML -Dorg.apache.cxf.Logger=org.apache.cxf.common.logging.Log4jLogger"
#JAVA_OPTS="$JVM_OPTS $AGENT_PATHS $JAVA_AGENTS $JAVA_LIBRARY_PATH"
