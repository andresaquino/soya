#! /bin/sh
# ********************************************************************************************
# * Deployment script for CX Webclient
# * This script will deploy the application into the web container (e.g. tomcat)
# * Change the first lines below to suite to your needs
# *
# * WEBAPPS_DIR represents the deployment folder (e.g.$CATALINA_HOME/webapps)
# * BCSC_JAR represents the shipment directory and must be already set
# * JAVA_HOME should point to the JDK folder and must be already set
# ********************************************************************************************


WEBAPPS_DIR=$CATALINA_HOME/webapps

# ****************************************************
# * no changes below this line
# ****************************************************

if [ -z "$CATALINA_HOME" ]
then
  echo 'CATALINA_HOME missing'
  exit 1
fi

if [ -z "$1" ]
then
  echo 'Usage:' $0 '<deployment_mode>'
  echo 'Available deployment modes:'
  echo '  pos - for Customer Center Point of Sales'
  echo '  cu - for Customer Care'
  echo '  bp - for Business Partner Center BPX'
  echo '  prepaid - for Prepaid Customer Care (Prepaid CC)'
  echo '  b_bp - Business Partner Center BPX for iX Billing'
  echo '  r_bp - Business Partner Center BPX for iX Rating'
  echo '  r_prepaid - Prepaid Customer Care (Prepaid CC) for iX Rating'
  exit 1
fi


APP_NAME=custcare_$1
CONFIG_FILE=${APP_NAME}_configuration.zip


if [ ! -f $BSCS_JAR/$CONFIG_FILE ]
then
  echo Invalid deployment mode: $1
  exit 1
fi


echo Deploying $APP_NAME ...

DEPLOY_DIR=$WEBAPPS_DIR/$APP_NAME

mkdir -p $DEPLOY_DIR
cd $DEPLOY_DIR
$JAVA_HOME/bin/jar xfM $BSCS_JAR/custcare.zip
$JAVA_HOME/bin/jar xfM $BSCS_JAR/$CONFIG_FILE
rm -rf $DEPLOY_DIR/META-INF

echo Installing property files ...
if [ -f "$BSCS_RESOURCE/orb.properties" ]
then
  cp -f $BSCS_RESOURCE/orb.properties $DEPLOY_DIR/WEB-INF/classes
fi

echo Installing required libraries and 3PPs ...
LIB_DIR=$DEPLOY_DIR/WEB-INF/lib
cp -f $BSCS_JAR/func_frwmwk_cmn.jar $LIB_DIR
cp -f $BSCS_JAR/func_util.jar $LIB_DIR
cp -f $BSCS_JAR/soi.jar $LIB_DIR
cp -f $BSCS_JAR/func_frwmwk_clt.jar $LIB_DIR
cp -f $BSCS_3PP_JAR/fop.jar $LIB_DIR
cp -f $BSCS_3PP_JAR/batik.jar $LIB_DIR
cp -f $BSCS_3PP_JAR/avalon-framework-cvs-20020806.jar $LIB_DIR
cp -f $BSCS_3PP_JAR/commons-validator/commons-beanutils.jar $LIB_DIR
cp -f $BSCS_3PP_JAR/commons-validator/commons-collections.jar $LIB_DIR
cp -f $BSCS_3PP_JAR/commons-validator/commons-digester.jar $LIB_DIR
cp -f $BSCS_3PP_JAR/commons-validator/commons-logging.jar $LIB_DIR
cp -f $BSCS_3PP_JAR/commons-validator/commons-validator.jar $LIB_DIR
cp -f $BSCS_3PP_JAR/commons-validator/jakarta-oro.jar $LIB_DIR

echo Done
