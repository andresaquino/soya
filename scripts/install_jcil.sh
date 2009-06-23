#!/bin/sh

# **********************************************************
# * Installation script for CMS IN Plugin
# **********************************************************

# **********************************************************
# * Adapt the variables below according to your environment
# **********************************************************

CMS_DIR=$BSCS_RESOURCE/cms
BILLSRV_DIR=$BSCS_RESOURCE/billsrv
JCIL_PLUGIN=$BSCS_RESOURCE/jcil



# **********************************************************
# * End of section to be adapted to your environment
# **********************************************************

ECHO=echo
CPFILE="cp -f"
MKDIR="mkdir -p"
CPDIR="cp -rf"
RMDIR="rm -rf"
CAT="cat"

$ECHO -------------------------------
$ECHO   CMS IN Plugin installation
$ECHO -------------------------------
$ECHO
$ECHO
$ECHO  CMS installation     directory is: $CMS_DIR
$ECHO  BILLSRV installation directory is: $BILLSRV_DIR
$ECHO  JCIL Plugin shipment directory is: $JCIL_PLUGIN
$ECHO 
$ECHO  Installing...

$ECHO  Check/create the plugin descriptors directory

if [ ! -d $BSCS_RESOURCE/cms/plugin ] ; then
  $MKDIR $BSCS_RESOURCE/cms/plugin
fi

$ECHO  Check/create the plugin library directory
if [ ! -d $BSCS_JAR/cms_plugin ] ; then
  $MKDIR $BSCS_JAR/cms_plugin
fi

$ECHO  Installing the plugin library
$CPFILE $BSCS_JAR/jcil.jar $BSCS_JAR/cms_plugin

$ECHO  Installing the resource files
$CPFILE $JCIL_PLUGIN/Registry_CIL.xml $CMS_DIR/plugin
$CPFILE $JCIL_PLUGIN/*Error*.xml $CMS_DIR
$CPDIR $JCIL_PLUGIN/cdf/* $CMS_DIR/cdf
$CPFILE $JCIL_PLUGIN/soi/*.xml $CMS_DIR/soi
if [ -d $JCIL_PLUGIN/plugin ] ; then
  if [ -f $JCIL_PLUGIN/plugin/* ] ; then
    $CPDIR $JCIL_PLUGIN/plugin/* $CMS_DIR/plugin
    $CPFILE $BSCS_JAR/jcil_plugin/*.jar $BSCS_JAR/cms_plugin/.
    if [ -f $BSCS_JAR/cms_plugin/cms.jar ] ; then
      rm $BSCS_JAR/cms_plugin/cms.jar
    fi
  fi
fi


$ECHO ---------------------------------
$ECHO  IN Plugin installation finished
$ECHO ---------------------------------




