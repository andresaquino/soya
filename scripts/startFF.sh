#!/bin/sh
# ****************************************************
# * starter for Federated Factory
# **

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

# Command line arguments
# -nomon     Start JFF without console
ORIGINAL_ARGS=$@

COMPNAME=fedfactory

MYPATH=$BSCS_RESOURCE/$COMPNAME
MYPATH=$MYPATH:$BSCS_RESOURCE
MYPATH=$MYPATH:$BSCS_JAR/func_util.jar
MYPATH=$MYPATH:$BSCS_JAR/func_sop_cmn.jar
MYPATH=$MYPATH:$BSCS_JAR/func_sop_corba.jar
MYPATH=$MYPATH:$BSCS_JAR/func_sop_lib.jar
MYPATH=$MYPATH:$BSCS_JAR/fedfactory.jar:$BSCS_JAR/fedfactory_ext.jar

# add platform dependent java options
ADD_OPT=
case $BSCS_OS_ID in
# on TRU64 we switch to the fast 64 bit mode
osf*) ADD_OPT=-fast64;;
aix*) ADD_OPT="-Dcom.ibm.CORBA.ORBWCharDefault=UTF16";;
# use the following switch on HP platforms to immediately reflect system time changes
hp*) ADD_OPT="-XX:+UseGetTimeOfDay -d64";;
# all other supported platforms (SUN9, HP/UX, Linux) are variants of the sun java
# JRE, therefore switch to the 64 bit mode, per default it is 32 bit.
*) ADD_OPT=-d64;;
esac

# Use only in case of a firewall between JFF and a client (CX/Tomcat).
# Uncomment, define a port number and open the port in the firewall.
# JFF_PORT=<port number>
# For the Sun JDK
# ORBSERVERPORT=" -Dcom.sun.CORBA.ORBServerPort="${JFF_PORT}
# For the IBM JDK
# ORBSERVERPORT=" -Dcom.ibm.CORBA.ListenerPort="${JFF_PORT}
ADD_OPT=${ADD_OPT}${ORBSERVERPORT}

#
# Start JFF
# Adapt the memory settings -Xms and -Xmx to your environment.
# See the documenation of your JRE for more information.
#
$START_JAVA -Xmx128M $ADD_OPT -cp $MYPATH -DSVAPPLINDEX=$SVAPPLINDEX -DSVAPPLHOST=$SVAPPLHOST -Djava.util.logging.config.file=$BSCS_RESOURCE/$COMPNAME/logging.properties -Djava.io.tmpdir=$BSCS_LOG/$COMPNAME com.lhs.fedfactory.FedFactory $ORIGINAL_ARGS
