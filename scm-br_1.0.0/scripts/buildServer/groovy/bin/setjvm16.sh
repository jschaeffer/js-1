#!/bin/bash

export PATH="/opt/tools/jdk1.6.0/lib:/opt/tools/jdk1.6.0/bin:${PATH}"
export JDK_HOME="/opt/tools/jdk1.6.0"
export JAVA_HOME="/opt/tools/jdk1.6.0"

echo "Path=${PATH}"
echo "JDK_HOME=${JDK_HOME}"
echo "JAVA_HOME=${JAVA_HOME}"

which java
