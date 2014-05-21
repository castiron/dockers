#!/bin/bash -p

export CATALINE_TMPDIR=/tmp/tomcat7-tomcat7-tmp
export CATALINA_BASE=/var/lib/tomcat7
/usr/share/tomcat7/bin/catalina.sh run

