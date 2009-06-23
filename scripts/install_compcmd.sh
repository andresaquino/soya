#! /bin/sh
# ********************************************************************************************
# * Deployment script for the CompositeCommands (jcil plugin)
# * This script will deploy the application into the jcil\plugin folder
# * Change the first lines below to suite to your needs
# *
# * BCSC_JAR represents the shipment directory and must be already set
# * JAVA_HOME should point to the JDK folder and must be already set
# ********************************************************************************************

# ****************************************************
# * no changes below this line
# ****************************************************

DEPLOY_DIR=$BSCS_JAR/jcil_plugin
RES_DIR=$BSCS_RESOURCE/jcil/plugin

mkdir -p $DEPLOY_DIR
mkdir -p $RES_DIR

cp -f $BSCS_JAR/compositecmd.jar $DEPLOY_DIR/.
cp -f $BSCS_RESOURCE/compcmd/*.xml $RES_DIR/.

if [ -f $BSCS_RESOURCE/cms/plugin/Registry_CIL.xml ] ; then
	cp -f $BSCS_JAR/compositecmd.jar $BSCS_JAR/cms_plugin/.
	cp -f $BSCS_RESOURCE/compcmd/*.xml $BSCS_RESOURCE/cms/plugin/.
fi
echo Done
