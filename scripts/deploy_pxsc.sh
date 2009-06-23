#!/bin/sh
# *******************************************************************************
# * Deployment script for PX Smart Client Webclient.
# * This script will deploy the application into the web container (e.g. tomcat)
# * Change the first lines below to suite to your needs
# *
# * WEBAPPS_DIR is folder containing all web apps (e.g.$CATALINA_HOME/webapps)
# * DEPLOY_NAME represents the deployment name under WEBAPPS_DIR
# *
# * BCSC environment must be already set
# * JAVA_HOME should point to the Java in folder and must be already set.
# *******************************************************************************

# ********************************************************
# * Adapt the following lines to your directory structure 
# ********************************************************

WEBAPPS_DIR=${CATALINA_HOME}/webapps
DEPLOY_NAME=PXSC

# ********************************************************
# * No changes below this line
# ********************************************************

DEPLOY_PREFIX=
DEPLOY_DIR=${WEBAPPS_DIR}/${DEPLOY_PREFIX}${DEPLOY_NAME}

LINE=--------------------------------------------------------------------------

SHIP_JARS="func_frwmwk_cmn.jar func_util.jar soi.jar func_frwmwk_clt.jar func_frwmwk_clt_dl.jar func_frwmwk_srv.jar"
SHIP_3PP="toplink.jar ojdbc14.jar commons-validator/commons-beanutils.jar commons-validator/commons-collections.jar commons-validator/commons-digester.jar commons-validator/commons-logging.jar commons-validator/commons-validator.jar commons-validator/jakarta-oro.jar"
SHIP_RES="orb.properties database.properties"

echo $LINE
echo Start PXSC Webclient deployment to ${DEPLOY_DIR}
echo $LINE

if [ -z "$BSCS_JAR" ] ; then
  echo BSCS_JAR not set. Run environment.sh first. Bye.
  exit 1
fi

if [ -z "$BSCS_ROOT" ] ; then
  echo BSCS_ROOT not set. Run environment.sh first. Bye.
  exit 1
fi

if [ ! -d "$WEBAPPS_DIR" ] ; then
  echo WEBAPPS_DIR ${WEBAPPS_DIR} does not exist. Bye.
  exit 1
fi

echo
echo Create deployment directory ${DEPLOY_DIR}
mkdir -p ${DEPLOY_DIR}


echo
echo Start unpacking PXSC files into ${DEPLOY_DIR}
cd ${DEPLOY_DIR}
$JAVA_HOME/bin/jar xfM ${BSCS_JAR}/smartpx.zip
rm -rf ${DEPLOY_DIR}/META-INF
echo Unpacking PXSC files done

echo
echo Installing required libraries from ${BSCS_JAR}
mkdir -p ${DEPLOY_DIR}/WEB-INF/lib

for shipjar in ${SHIP_JARS}
do
  echo Copy ${shipjar}
  cp -f ${BSCS_JAR}/${shipjar} ${DEPLOY_DIR}/WEB-INF/lib
done

for ship3pp in ${SHIP_3PP}
do
  echo Copy ${ship3pp}
  cp -f ${BSCS_ROOT}/3pp/jar/${ship3pp} ${DEPLOY_DIR}/WEB-INF/lib
done
echo Required libraries copied.

echo
echo Installing required resources from ${BSCS_RESOURCE}
for shipres in ${SHIP_RES}
do
  if [ -f "$BSCS_RESOURCE/$shipres" ] ; then
    echo Copy ${shipres}
    cp -f ${BSCS_RESOURCE}/${shipres} ${DEPLOY_DIR}/WEB-INF/classes
  else
    echo Resource file $BSCS_RESOURCE/$shipres does not exist. Keeping the default one.
  fi
done
echo Required resources copied.

echo
echo $LINE
echo PXSC Webclient installation done.
echo $LINE

