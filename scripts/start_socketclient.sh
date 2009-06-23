#!/bin/sh
# ****************************************************
#  starter for iDENSRV SocketClient
# 
#  usage: 
#         start_socketclient.sh <hostname> <port>
#
#  description:
#         <hostname>      mandatory argument
#
#         The <hostname> argument specify the hostname where iDENSRV is running
#
#         <port>          mandatory argument
#
#         The <port> argument specify the port where iDENSRV is running
#
#  examples:
#         start_socketclient.sh localhost 10001
#         start_socketclient.sh bern      10002
# **************************************************** 

if [ -z "$1" ] || [ -z "$2" ]
then
        echo "SocketClient USAGE:"
        echo "               start_socketclient.sh <hostname> <port>"
        exit 1
fi

if [ -z "$BSCS_JAR" ]
then
	echo "BSCS_JAR isn't set!"
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

COMPNAME=ids

#set default server alias
HOSTNAME=$1
PORT=$2

MYPATH=.
MYPATH=$MYPATH:$BSCS_JAR/ids.jar

# 
# Start iDENSRV SocketClient
# Adapt the memory settings -Xms and -Xmx to your environment. 
# See the documenation of your JRE for more information.
#
exec $START_JAVA -Xms64M -Xmx128M -cp $MYPATH -Djava.io.tmpdir=$BSCS_LOG/$COMPNAME com.lhs.idensrv.tester.SocketClient $HOSTNAME $PORT