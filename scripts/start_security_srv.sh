#!/bin/sh
# ****************************************************
#  starter for Security Server
# 
#  usage: 
#         start_security_srv.sh [-nomon] [-name <server_name>]
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
#         If this argument is ommited then default server name used: CMS_900
#
#  examples:
#         start_security_srv.sh 
#         start_security_srv.sh -name my_server_name
#         start_security_srv.sh -nomon 
#         start_security_srv.sh -nomon -name my_server_name
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
   
COMPNAME=security

#set default server name
SERVER_NAME=SEC_900

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
  
MYPATH=$BSCS_RESOURCE/$COMPNAME
MYPATH=$MYPATH:$BSCS_RESOURCE
MYPATH=$MYPATH:$BSCS_JAR/func_util.jar
MYPATH=$MYPATH:$BSCS_JAR/soi.jar
MYPATH=$MYPATH:$BSCS_JAR/func_frwmwk_cmn.jar
MYPATH=$MYPATH:$BSCS_3PP_JAR/ojdbc14.jar
MYPATH=$MYPATH:$BSCS_3PP_JAR/orai18n.jar
MYPATH=$MYPATH:$BSCS_3PP_JAR/toplink.jar
MYPATH=$MYPATH:$BSCS_3PP_JAR/jmxri.jar
MYPATH=$MYPATH:$BSCS_JAR/func_frwmwk_srv.jar
MYPATH=$MYPATH:$BSCS_JAR/security_plugin.jar
MYPATH=$MYPATH:$BSCS_JAR/func_sop_cmn.jar
MYPATH=$MYPATH:$BSCS_JAR/func_sop_corba.jar
MYPATH=$MYPATH:$BSCS_JAR/func_sop_lib.jar

# add platform dependent java options
ADD_OPT=
case $BSCS_OS_ID in
# on TRU64 we switch to the fast 64 bit mode
osf*) ADD_OPT=-fast64;;
# on AIX switch the default wide character encoding
aix*) ADD_OPT="-Dcom.ibm.CORBA.ORBWCharDefault=UTF16";;
# all other supported platforms (SUN9, HP/UX, Linux) are variants of the sun java
# JRE, therefore switch to the 64 bit mode, per default it is 32 bit.
*) ADD_OPT=-d64;;
esac

# Use only in case of a firewall between CMS and a client (CX/Tomcat).
# Uncomment, define a port number and open the port in the firewall.
# SEC_PORT=<port number>
# For the Sun JDK
# ORBSERVERPORT=" -Dcom.sun.CORBA.ORBServerPort="${SEC_PORT}
# For the IBM JDK
# ORBSERVERPORT=" -Dcom.ibm.CORBA.ListenerPort="${SEC_PORT}
ADD_OPT=${ADD_OPT}${ORBSERVERPORT}

# 
# Start Security Server
# Adapt the memory settings -Xms and -Xmx to your environment. 
# See the documenation of your JRE for more information.
#
exec $START_JAVA -Xms32M -Xmx64M $ADD_OPT -cp $MYPATH -DBSCS_RESOURCE=$BSCS_RESOURCE -Djava.io.tmpdir=$BSCS_LOG/$COMPNAME -DSVAPPLINDEX=$SVAPPLINDEX -DSVAPPLHOST=$SVAPPLHOST com.lhs.ccb.sfw.application.ExtendedServer $ORIGINAL_COMMAND_LINE -name $SERVER_NAME
