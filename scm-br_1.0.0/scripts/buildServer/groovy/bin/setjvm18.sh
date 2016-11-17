#!/bin/bash

export PATH="/opt/tools/jdk1.8.0_20/lib:/opt/tools/jdk1.8.0_20/bin:${PATH}"
export JDK_HOME="/opt/tools/jdk1.8.0_20"
export JAVA_HOME="/opt/tools/jdk1.8.0_20"

echo ${PATH}
echo ${JDK_HOME}
echo ${JAVA_HOME}

which java
