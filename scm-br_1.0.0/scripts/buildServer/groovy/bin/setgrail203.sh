#!/bin/bash

cd /opt/tools
rm grails
ln -s /opt/tools/grails-2.0.4 grails
GRAILS_HOME="/opt/tools/grails-2.0.4"
export GRAILS_HOME
export PATH=${GRAILS_HOME}/bin:${PATH}
