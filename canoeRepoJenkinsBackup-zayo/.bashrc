# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

export PS1="[\u@\h \W]\\$ "

# User specific aliases and functions
export JAVA_HOME=/usr/java/jdk1.8.0_25
export JRE_HOME=/usr/java/jdk1.8.0_25

##### Don't mess with the colors!
. ~/betcolor.sh
##### Thanks!  Jeff

alias wp="cd /opt/build/scm/scripts/buildServer/groovy/"
alias pp="cd /opt/build/scm/scripts/buildServer/properties/projects/"
alias bs="cd /opt/build/scripts"
