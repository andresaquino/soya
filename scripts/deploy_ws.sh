#! /bin/sh
# ********************************************************************************************
# Deployment script for Web Services
# This script will deploy the application as jcil plug-in
# 
# BCSC_JAR represents the shipment directory and must be already set
# JAVA_HOME should point to the JDK folder and must be already set
# CATALINA_HOME should point to the tomcat folder and must be already set
#  
# example: deploy_ws.sh --> it deploys ws_v2 into tomcat/webapps
# example-2: domain layer deployment needs changes in the script see below...
# ********************************************************************************************

WS_VERSION=2_NII_1
WS_DEPLOYED_NAME=ws_v2_NII_1
WS_DEPLOYMENT_MODE=
DEPLOY_DIR=deploy_remote

# in case of domain layer mode please remove remark from the begening of the next 2 lines
# WS_DEPLOYMENT_MODE=_dl
# DEPLOY_DIR=deploy_domain_layer

WEBAPPS_DIR=$CATALINA_HOME/webapps

ANT_HOME=$WEBAPPS_DIR/$WS_DEPLOYED_NAME/ant
ANT_CMD="$JAVA_HOME/bin/java -classpath $ANT_HOME/lib/ant-launcher.jar -Dant.home=$ANT_HOME org.apache.tools.ant.launch.Launcher "

# ****************************************************
# * no changes below this line
# ****************************************************

rm -rf $WEBAPPS_DIR/$WS_DEPLOYED_NAME
mkdir $WEBAPPS_DIR/$WS_DEPLOYED_NAME
cd $WEBAPPS_DIR/$WS_DEPLOYED_NAME
#$JAVA_HOME/bin/jar xfM $BSCS_JAR/ws_v$WS_VERSION$WS_DEPLOYMENT_MODE.war
$JAVA_HOME/bin/jar xfM $BSCS_JAR/ws_v$WS_VERSION.zip
cd $WEBAPPS_DIR/$WS_DEPLOYED_NAME/$DEPLOY_DIR
$ANT_CMD 

cd $BSCS_SCRIPTS
