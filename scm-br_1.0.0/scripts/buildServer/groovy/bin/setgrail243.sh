#!/bin/bash

cd /opt/tools
rm grails
ln -s /opt/tools/grails-2.4.3 grails
GRAILS_HOME="/opt/tools/grails-2.4.3"
export GRAILS_HOME
export PATH=${GRAILS_HOME}/bin:${PATH}
