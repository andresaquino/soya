#!/bin/sh
# ****************************************************
#  starter for JCIL
# 
#  usage: 
#         start_jcil.sh [-nomon] [-name <server_name>]
#
#  description:
#         -nomon              optional argument
#         -name <server_name> optional argument
#
#         The -nomon argument disables the Server Monitor. This is useful 
#         when server runs in background.
#         if -nomon argument is ommited then server starts an interactive
#         Server Monitor which accepts commands from standard input.
#
#         The -name <server_name> argument allows to specify a unique 
#         server name in the CORBA naming service
#         If this argument is ommited then default server name used: JCIL_900
#
#  examples:
#         start_jcil.sh 
#         start_jcil.sh -name my_server_name
#         start_jcil.sh -nomon 
#         start_jcil.sh -nomon -name my_server_name
# **************************************************** 

if [ -z "$BSCS_RESOURCE" ]
then
	echo "BSCS_RESOURCE isn't set!"
	exit 1
fi

if [ -z "$BSCS_JAR" ]
then
	echo "BSCS_JAR isn't set!"
	exit 1
fi

if [ -z "$BSCS_3PP_JAR" ]
then
	echo "BSCS_3PP_JAR isn't set!"
	exit 1
fi

if [ -z "$BSCS_LOG" ]
then
  echo "BSCS_LOG isn't set!"
	exit 1
fi

START_JAVA=$JDK_HOME/jre/bin/java
if [ -z "$JDK_HOME" ]
then
	echo "JDK_HOME isn't set! The java executable from the current path setting is taken instead."
	START_JAVA=java
fi

COMPNAME=jcil

#set default server name
SERVER_NAME=JCIL_900

#save original command line
ORIGINAL_COMMAND_LINE=$@
  
#parse command line, extract optional server name
while [ $# -gt 0 ]
do
    case "$1" in
      -name)  SERVER_NAME="$2"; shift;;
    esac
    shift
done
  
MYPATH=$MYPATH:$BSCS_RESOURCE/$COMPNAME
MYPATH=$MYPATH:$BSCS_RESOURCE
MYPATH=$MYPATH:$BSCS_JAR/func_util.jar
MYPATH=$MYPATH:$BSCS_JAR/soi.jar
MYPATH=$MYPATH:$BSCS_JAR/func_frwmwk_cmn.jar
MYPATH=$MYPATH:$BSCS_3PP_JAR/ojdbc14.jar
MYPATH=$MYPATH:$BSCS_3PP_JAR/orai18n.jar
MYPATH=$MYPATH:$BSCS_3PP_JAR/toplink.jar
MYPATH=$MYPATH:$BSCS_3PP_JAR/jmxri.jar
MYPATH=$MYPATH:$BSCS_3PP_JAR/quartz-1.5.1.jar
MYPATH=$MYPATH:$BSCS_3PP_JAR/commons-logging.jar
MYPATH=$MYPATH:$BSCS_3PP_JAR/commons-logging-api.jar
MYPATH=$MYPATH:$BSCS_JAR/func_frwmwk_srv.jar
MYPATH=$MYPATH:$BSCS_JAR/security_plugin.jar
MYPATH=$MYPATH:$BSCS_JAR/func_sop_cmn.jar
MYPATH=$MYPATH:$BSCS_JAR/func_sop_corba.jar
MYPATH=$MYPATH:$BSCS_JAR/func_sop_lib.jar
MYPATH=$MYPATH:$BSCS_JAR/jcil.jar

# add all plugins that are found for jcil
if [ -d "$BSCS_JAR/jcil_plugin" ] ; then
  for jarfile in `ls $BSCS_JAR/jcil_plugin/*.jar` ; do  MYPATH=$MYPATH:$jarfile ; done
fi

# add platform dependent java options
ADD_OPT=
case $BSCS_OS_ID in
# The property com.sun.CORBA.transport.ORBTCPReadTimeouts can be reset to adjust the transport read tcp 
# timeout property, which is a colon separated property with the following syntax:
# <initial time to wait: max read giop header time to wait: max read message time to wait: backoff factor>
# If you often get CORBA exceptions for the reason that the timeout is reached (especially in the case that 
# Sun JDK 1.5.0 is used), please uncomment the following line, and change the value accordly.
# sun*) ADD_OPT="-Dcom.sun.CORBA.transport.ORBTCPReadTimeouts=1:60000:300:1";;
# on TRU64 we switch to the fast 64 bit mode
osf*) ADD_OPT=-fast64;; 
aix*) ADD_OPT="-Dcom.ibm.CORBA.ORBWCharDefault=UTF16";;
# use the following switch on HP platforms to immediately reflect system time changes
hp*) ADD_OPT="-XX:+UseGetTimeOfDay -d64";;
# all other supported platforms (SUN9, HP/UX, Linux) are variants of the sun java
# JRE, therefore switch to the 64 bit mode, per default it is 32 bit.
*) ADD_OPT=-d64;;
esac


# Use only in case of a firewall between JCIL and a client (CX/Tomcat).
# Uncomment, define a port number and open the port in the firewall.
# JCIL_PORT=<port number>
# For the Sun JDK
# ORBSERVERPORT=" -Dcom.sun.CORBA.ORBServerPort="${JCIL_PORT}
# For the IBM JDK
# ORBSERVERPORT=" -Dcom.ibm.CORBA.ListenerPort="${JCIL_PORT}
ADD_OPT=${ADD_OPT}${ORBSERVERPORT}

#
# Start JCIL 
# Adapt the memory settings -Xms and -Xmx to your environment. 
# See the documenation of your JRE for more information.
#
exec $START_JAVA -Xms64M -Xmx128M $ADD_OPT -cp $MYPATH -DSVAPPLINDEX=$SVAPPLINDEX -DSVAPPLHOST=$SVAPPLHOST -DBSCS_RESOURCE=$BSCS_RESOURCE -Djava.io.tmpdir=$BSCS_LOG/$COMPNAME com.lhs.ccb.sfw.application.ExtendedServer $ORIGINAL_COMMAND_LINE -name $SERVER_NAME
  
