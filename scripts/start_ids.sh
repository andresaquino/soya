#!/bin/sh
# ****************************************************
#  starter for iDENSRV
# 
#  usage: 
#         start_ids.sh <server_alias> <Motorola iSDK Path>
#
#  description:
#         <server_alias>       mandatory argument
#         <Motorola iSDK Path> mandatory argument
#
#         The <server_alias> argument specify a unique Registry File to
#         read to get server unique configurations 
#
#         The <Motorola iSDK Path> argument specify the Path and the jar file
#         name for the Motorola iSDK
#
#  examples:
#         start_ids.sh iDENSRV01 /mpde/common.x/ipp/ipp-1.7.2/iPP.jar
#         start_ids.sh iDENSRV02 /mpde/common.x/ipp/ipp-1.7.2/iPP.jar
# **************************************************** 

if [ -z "$1" ] || [ -z "$2" ]
then
        echo "iDENSRV USAGE:"
        echo "               start_ids.sh <server_alias> <Motorola iSDK Path>"
        echo "               start_ids.sh iDENSRV01 /mpde/common.x/ipp/ipp-1.7.2/iPP.jar"
        exit 1
fi

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
SERVER_ALIAS=$1

MYPATH=.
MYPATH=$MYPATH:$BSCS_RESOURCE/$COMPNAME
MYPATH=$MYPATH:$BSCS_JAR/ids.jar
MYPATH=$MYPATH:$BSCS_JAR/func_util.jar
MYPATH=$MYPATH:$2

# 
# Start iDENSRV 
# Adapt the memory settings -Xms and -Xmx to your environment. 
# See the documenation of your JRE for more information.
#
# PN 325237 DOF 
exec $START_JAVA -Xms64M -Xmx128M -cp $MYPATH -Djava.io.tmpdir=$BSCS_LOG/$COMPNAME com.lhs.idensrv.IdenSrv $SERVER_ALIAS
