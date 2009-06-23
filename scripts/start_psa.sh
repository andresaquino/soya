#!/bin/sh
# ****************************************************
# * starter for PSA
# *
# *
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


COMPNAME=psa
#
# Customize following command line parameters !!
#
COMMAND_LINE_PARAMS="com/lhs/public/soi/fedfactory1 SOI_USER SOI_PASSWD CMI 1 -port 7512"

MYPATH=$BSCS_RESOURCE/$COMPNAME
MYPATH=$MYPATH:$BSCS_RESOURCE
MYPATH=$MYPATH:$BSCS_JAR/func_util.jar
MYPATH=$MYPATH:$BSCS_JAR/soi.jar
MYPATH=$MYPATH:$BSCS_JAR/func_frwmwk_cmn.jar
MYPATH=$MYPATH:$BSCS_JAR/psa.jar
##echo "MYPATH = "$MYPATH

# add platform dependent java options (copy&paste from start_cms.sh)
ADD_OPT=
case $BSCS_OS_ID in
# on TRU64 we switch to the fast 64 bit mode
osf*) ADD_OPT=-fast64;;
aix*) ADD_OPT="-Dcom.ibm.CORBA.ORBWCharDefault=UTF16";;
# all other supported platforms (SUN9, HP/UX, Linux) are variants of the sun java
# JRE, therefore switch to the 64 bit mode, per default it is 32 bit.
*) ADD_OPT=-d64;;
esac

# for an installation behind a firewall use the following line after setting $PSA_PORT
# ADD_OPT=$ADD_OPT\ -Dcom.sun.CORBA.OrbServerPort=$PSA_PORT

#
# Start PSA
# Adapt the memory settings -Xms and -Xmx to your environment.
# See the documenation of your JRE for more information.
#
echo "Starting psa ..."
$START_JAVA -Xms64M -Xmx128M $ADD_OPT -cp $MYPATH -Djava.io.tmpdir=$BSCS_LOG/$COMPNAME com.slb.inservices.Psa.PMIAdapter $COMMAND_LINE_PARAMS $@
