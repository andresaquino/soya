#!/bin/sh

# **********************************************************
# * Installation script for SCS Plugin
# **********************************************************

# **********************************************************
# * Adapt the variables below according to your environment
# **********************************************************

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
$ECHO   SCS Plugin installation
$ECHO -------------------------------
$ECHO
$ECHO
$ECHO CMS installation   directory is: $SHIPMENT
$ECHO SCS Plugin shipment directory is: $BSCS_SCS_PLUGIN
$ECHO both variable are defaulted to $BSCS_ROOT and may be overwritten
if [ -z "$SHIPMENT" ]
then
	SHIPMENT=$BSCS_ROOT
fi
if [ -z "$BSCS_SCS_PLUGIN" ]
then
	BSCS_SCS_PLUGIN=$BSCS_ROOT
fi

$ECHO 
$ECHO  Installing...

$ECHO  Check/create the plugin descriptors directory

if [ ! -d $SHIPMENT/resource/jcil/plugin ] ; then
  $MKDIR $SHIPMENT/resource/jcil/plugin
fi

if [ ! -d $SHIPMENT/lib/jar/jcil_plugin ] ; then
  $MKDIR $SHIPMENT/lib/jar/jcil_plugin
fi

$ECHO  Installing the plugin library
$CPFILE $BSCS_SCS_PLUGIN/lib/jar/scs.jar $SHIPMENT/lib/jar/jcil_plugin
# --- currently classes from cms.jar are needed in order to run SOI CS ---
$CPFILE $BSCS_SCS_PLUGIN/lib/jar/cms.jar $SHIPMENT/lib/jar/jcil_plugin

$ECHO  Installing the resource files
$CPFILE $BSCS_SCS_PLUGIN/resource/scs/plugin/Registry_SOICS*.xml $SHIPMENT/resource/jcil/plugin

$CPFILE $BSCS_SCS_PLUGIN/resource/scs/*.xml $SHIPMENT/resource/jcil
$CPDIR $BSCS_SCS_PLUGIN/resource/scs/cdf/* $SHIPMENT/resource/jcil/cdf
$CPFILE $BSCS_SCS_PLUGIN/resource/scs/soi/* $SHIPMENT/resource/jcil/soi

if [ -f $SHIPMENT/resource/cms/plugin/Registry_CIL.xml ] ; then
	$ECHO  JCIL is also installed as plugin in CMS
	$CPFILE $BSCS_SCS_PLUGIN/lib/jar/scs.jar $SHIPMENT/lib/jar/cms_plugin
	$CPFILE $BSCS_SCS_PLUGIN/resource/scs/plugin/Registry_SOICS*.xml $SHIPMENT/resource/cms/plugin
	$CPFILE $BSCS_SCS_PLUGIN/resource/scs/*.xml $SHIPMENT/resource/cms
	$CPDIR $BSCS_SCS_PLUGIN/resource/scs/cdf/* $SHIPMENT/resource/cms/cdf
	$CPFILE $BSCS_SCS_PLUGIN/resource/scs/soi/* $SHIPMENT/resource/cms/soi
fi

$ECHO ---------------------------------
$ECHO  SCS Plugin installation finished
$ECHO ---------------------------------


