# Edit this file to set custom options
# Tomcat accepts two parameters JAVA_OPTS and CATALINA_OPTS
# JAVA_OPTS are used during START/STOP/RUN
# CATALINA_OPTS are used during START/RUN

JAVA_HOME="/usr/java/latest"
AGENT_PATHS=""
JAVA_AGENTS=""
JAVA_LIBRARY_PATH=""
JVM_OPTS="-Xss192K -Djava.awt.headless=true -Xms512m -Xmx512m -XX:MaxPermSize=256m -Dgemfire.disableShutdownHook=true -Duser.timezone=America/New_York"
export APPHOME_DIR=/opt/tcserver/instances/FW_CIP_ING_02
export PCI_CONFIG=$APPHOME_DIR/conf/pci-env-application.properties
JAVA_OPTS="$JVM_OPTS $AGENT_PATHS $JAVA_AGENTS $JAVA_LIBRARY_PATH -Dschema.validation.enabled=true -Dlog4j.configuration=$APPHOME_DIR/conf/pci-log4j.properties -Dconfig.file=$PCI_CONFIG -Dorg.apache.cxf.Logger=org.apache.cxf.common.logging.Log4jLogger"
