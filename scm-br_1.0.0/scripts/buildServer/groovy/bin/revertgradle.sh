#!/bin/bash

cd /opt/tools
rm gradle
ln -s /opt/tools/gradle-1.0-milestone-6 gradle
GRADLE_HOME="/opt/tools/gradle-1.0-milestone-6"
export GRADLE_HOME
export PATH=${GRADLE_HOME}/bin:${PATH}
