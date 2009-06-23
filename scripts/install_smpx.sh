#!/bin/sh

# **********************************************************
# * Installation script for SMPX Plugin
# **********************************************************

# **********************************************************
# * Adapt the variables below according to your environment
# **********************************************************

CMS_RES_DIR=$BSCS_RESOURCE/cms
SMPX_RES_DIR=$BSCS_RESOURCE/smpx
CIL_RES_DIR=$BSCS_RESOURCE/jcil

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
$ECHO   SMPX Plugin installation
$ECHO -------------------------------
$ECHO
$ECHO
$ECHO  CMS         resource directory is: $CMS_RES_DIR
$ECHO  SMPX Plugin resource directory is: $SMPX_RES_DIR
$ECHO 
$ECHO  Installing...

$ECHO  Check/create the plugin descriptors directory

if [ ! -d $CMS_RES_DIR/plugin ] ; then
  $MKDIR $CMS_RES_DIR/plugin
fi

if [ ! -d $SMPX_RES_DIR/plugin ] ; then
  $MKDIR $SMPX_RES_DIR/plugin
fi

if [ ! -d $CIL_RES_DIR/plugin ] ; then
  $MKDIR $CIL_RES_DIR/plugin
fi

$ECHO  Check/create the plugin library directory
if [ ! -d $BSCS_JAR/cms_plugin ] ; then
  $MKDIR $BSCS_JAR/cms_plugin
fi

$ECHO  Installing the plugin library
$CPFILE $BSCS_JAR/smpx.jar $BSCS_JAR/cms_plugin

$ECHO  Installing the resource files

$CPFILE $SMPX_RES_DIR/SMPX_Registry.xml $CMS_RES_DIR/plugin
$CPFILE $SMPX_RES_DIR/SMPX_Integration.xml $CMS_RES_DIR/plugin

$CPFILE $SMPX_RES_DIR/SMPX_ErrorDictionary.xml $CMS_RES_DIR

$CPDIR $SMPX_RES_DIR/cdf/* $CMS_RES_DIR/cdf
$CPFILE $SMPX_RES_DIR/soi/*.xml $CMS_RES_DIR/soi

$ECHO  Adding CIL SOI extensions
if [ -f $CMS_RES_DIR/plugin/Registry_CIL.xml ] ; then
	$CPFILE $SMPX_RES_DIR/plugin/Registry_CIL*.xml $CMS_RES_DIR/plugin
fi
$CPFILE $SMPX_RES_DIR/plugin/Registry_CIL*.xml $CIL_RES_DIR/plugin

$ECHO ---------------------------------
$ECHO  SMPX Plugin installation finished
$ECHO ---------------------------------


