@echo off

rem ---------------------------------------------------
rem  Installation script for the CMS SMPX Plugin.
rem ---------------------------------------------------
rem
rem Prerequisites:
rem
rem    - CMS installation
rem
rem ---------------------------------------------------


rem ---------------------------------------------------
rem  Variables to be set according to your environment
rem ---------------------------------------------------

SET CMS_RES_DIR=%BSCS_RESOURCE%\cms
SET SMPX_RES_DIR=%BSCS_RESOURCE%\smpx
SET CIL_RES_DIR=%BSCS_RESOURCE%\jcil

rem ---------------------------------------------------
rem  End of section to be adapted to your environment
rem ---------------------------------------------------


rem ---------------------------------------------------
rem  Proceed with the installation
rem ---------------------------------------------------



echo --------------------------------
echo   CMS SMPX Plugin installation
echo --------------------------------
echo
echo
echo  CMS  resources directory is: %CMS_RES_DIR%
echo  SMPX resources directory is: %SMPX_RES_DIR%
echo  CIL  resources directory is: %CIL_RES_DIR%
echo
echo  Installing...

echo  Check/create the plugin descriptors directory
if not exist %CMS_RES_DIR%\plugin mkdir %CMS_RES_DIR%\plugin
if not exist %SMPX_RES_DIR%\plugin mkdir %SMPX_RES_DIR%\plugin
if not exist %CIL_RES_DIR%\plugin mkdir %CIL_RES_DIR%\plugin

echo  Check/create the plugin library directory
if not exist %BSCS_JAR%\cms_plugin mkdir %BSCS_JAR%\cms_plugin

echo  Installing the plugin library
copy %BSCS_JAR%\smpx.jar %BSCS_JAR%\cms_plugin

echo  Installing the registry files
copy %SMPX_RES_DIR%\SMPX_Registry.xml %CMS_RES_DIR%\plugin
copy %SMPX_RES_DIR%\SMPX_Integration.xml %CMS_RES_DIR%\plugin
echo  Installing the error dictionary
copy %SMPX_RES_DIR%\SMPX_ErrorDictionary.xml %CMS_RES_DIR%
echo  Installing the command definition files
xcopy /e /s %SMPX_RES_DIR%\cdf %CMS_RES_DIR%\cdf
echo  Installing the SOI extensions
copy %SMPX_RES_DIR%\soi\* %CMS_RES_DIR%\soi
echo Add CIL SOI extensions
if exist %CMS_RES_DIR%\plugin\Registry_CIL.xml (
	copy %SMPX_RES_DIR%\plugin\Registry_CIL*.xml %CMS_RES_DIR%\plugin
)
copy %SMPX_RES_DIR%\plugin\Registry_CIL*.xml %CIL_RES_DIR%\plugin

echo ---------------------------------
echo  SMPX Plugin installation finished
echo ---------------------------------