#! /bin/sh

# ****************************************************
#  starter for SOI test tool
# 
#  usage: 
#         soitool.sh [-name <server_name>] [-mode [gui|trace]] [-user <user>] [-password <password>] -soi <SOI> -ver <SOI version>
#
#  examples:
#         soitool.sh -name com/lhs/public/soi/fedfactory1  -mode gui -user CX -password CX -soi CIL -ver 1
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

COMPNAME=soitool

MYPATH=$BSCS_RESOURCE/$COMPNAME
MYPATH=$MYPATH:$BSCS_RESOURCE
MYPATH=$MYPATH:$BSCS_JAR/func_util.jar
MYPATH=$MYPATH:$BSCS_JAR/soi.jar
MYPATH=$MYPATH:$BSCS_JAR/func_frwmwk_cmn.jar
MYPATH=$MYPATH:$BSCS_JAR/soitool.jar

## echo "MYPATH = "$MYPATH

exec $START_JAVA -cp $MYPATH -Djava.io.tmpdir=$BSCS_LOG/$COMPNAME com.lhs.ccb.common.clients.SoiTool $*
