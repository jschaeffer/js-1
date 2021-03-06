# Edit this file to set custom options
# Tomcat accepts two parameters JAVA_OPTS and CATALINA_OPTS
# JAVA_OPTS are used during START/STOP/RUN
# CATALINA_OPTS are used during START/RUN

JAVA_HOME="/usr/java/latest"
AGENT_PATHS=""
JAVA_AGENTS=""
JAVA_LIBRARY_PATH=""
#JVM_OPTS="-Xmx512M -Xss192K"

JVM_OPTS="-Xss192K -Djava.awt.headless=true -Xms4G -Xmx4G -XX:MaxPermSize=256m -Dgemfire.disableShutdownHook=true -XX:+UseParNewGC -XX:+CMSParallelRemarkEnabled -XX:+UseConcMarkSweepGC"

export APPHOME_DIR=/opt/tcserver/instances/psn0201
export CONFIG_DIR=$APPHOME_DIR/ads-config
export LOG4J_XML=$APPHOME_DIR/conf/log4j.xml

JAVA_OPTS="$JVM_OPTS $AGENT_PATHS $JAVA_AGENTS $JAVA_LIBRARY_PATH -Dconfig.dir=$CONFIG_DIR -Dlog4j.location=$LOG4J_XML -Dorg.apache.cxf.Logger=org.apache.cxf.common.logging.Log4jLogger -XX:+HeapDumpOnOutOfMemoryError -XX:HeapDumpPath=/opt/tcserver/dump -Dschema.validation.enabled=true"

