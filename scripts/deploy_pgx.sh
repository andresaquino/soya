#! /bin/sh
# ********************************************************************************************
# * Deployment script for the PGX Webclient
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

APP_NAME=pgx
CONFIG_FILE=${APP_NAME}_configuration.zip

if [ ! -z "$1" ]
then
 CONFIG_FILE=${APP_NAME}_$1_configuration.zip
fi

if [ ! -f $BSCS_JAR/$CONFIG_FILE ]
then
  echo Invalid configuration: $1
  exit 1
fi


echo Deploying $APP_NAME ...

DEPLOY_DIR=$WEBAPPS_DIR/$APP_NAME

mkdir -p $DEPLOY_DIR
cd $DEPLOY_DIR
$JAVA_HOME/bin/jar xfM $BSCS_JAR/$APP_NAME.zip
$JAVA_HOME/bin/jar xfM $BSCS_JAR/$CONFIG_FILE
rm -rf $DEPLOY_DIR/META-INF

echo Installing property files ...
if [ -f "$BSCS_RESOURCE/orb.properties" ]
then
  cp -f $BSCS_RESOURCE/orb.properties $DEPLOY_DIR/WEB-INF/classes
fi

echo Installing required libraries and 3PPs ...
LIBDIR=$DEPLOY_DIR/WEB-INF/lib
cp -f $BSCS_JAR/func_frwmwk_cmn.jar $LIBDIR
cp -f $BSCS_JAR/func_util.jar $LIBDIR
cp -f $BSCS_JAR/soi.jar $LIBDIR
cp -f $BSCS_JAR/func_frwmwk_clt.jar $LIBDIR
cp -f $BSCS_3PP_JAR/commons-validator/commons-beanutils.jar $LIBDIR
cp -f $BSCS_3PP_JAR/commons-validator/commons-collections.jar $LIBDIR
cp -f $BSCS_3PP_JAR/commons-validator/commons-digester.jar $LIBDIR
cp -f $BSCS_3PP_JAR/commons-validator/commons-logging.jar $LIBDIR
cp -f $BSCS_3PP_JAR/commons-validator/commons-validator.jar $LIBDIR
cp -f $BSCS_3PP_JAR/commons-validator/jakarta-oro.jar $LIBDIR
cp -f $BSCS_3PP_JAR/toplink.jar $LIBDIR
cp -f $BSCS_3PP_JAR/ojdbc14.jar $LIBDIR
cp -f $BSCS_3PP_JAR/orai18n.jar $LIBDIR

echo Done
