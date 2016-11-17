#!/bin/bash

cd /opt/tools
rm grails
ln -s /opt/tools/grails-2.3.7 grails
GRAILS_HOME="/opt/tools/grails-2.3.7"
export GRAILS_HOME
export PATH=${GRAILS_HOME}/bin:${PATH}
