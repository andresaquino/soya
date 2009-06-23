@echo off

rem ---------------------------------------------------
rem  Installation script for the CMS JCIL Plugin.
rem ---------------------------------------------------
rem
rem Prerequisites:
rem
rem    - CMS BSCS 9.0 installation
rem
rem ---------------------------------------------------


rem ---------------------------------------------------
rem  Variables to be set according to your environment
rem ---------------------------------------------------

SET BILLSRV_DIR=%BSCS_RESOURCE%\billsrv
SET CMS_DIR=%BSCS_RESOURCE%\cms
SET JCIL_PLUGIN=%BSCS_RESOURCE%\jcil

rem ---------------------------------------------------
rem  End of section to be adapted to your environment
rem ---------------------------------------------------


rem ---------------------------------------------------
rem  Proceed with the installation
rem ---------------------------------------------------

echo -------------------------------
echo   CMS JCIL Plugin installation
echo -------------------------------
echo
echo
echo  CMS installation     	directory is: %CMS_DIR%
echo  BILLSERV installation directory is: %BILLSRV_DIR%
echo  JCIL Plugin shipment  directory is: %JCIL_PLUGIN%
echo 
echo  Installing...

echo  Check/create the plugin descriptors directory
if not exist %CMS_DIR%\plugin mkdir %CMS_DIR%\plugin

echo  Check/create the plugin library directory
if not exist %BSCS_JAR%\cms_plugin mkdir %BSCS_JAR%\cms_plugin

echo  Installing the plugin library
copy %BSCS_JAR%\jcil.jar %BSCS_JAR%\cms_plugin

echo  Installing the resource files
copy %JCIL_PLUGIN%\Registry_CIL.xml %CMS_DIR%\plugin
copy %JCIL_PLUGIN%\*Error*.xml %CMS_DIR%
xcopy /e /s %JCIL_PLUGIN%\cdf %CMS_DIR%\cdf
if exist %JCIL_PLUGIN%\plugin xcopy /e /s %JCIL_PLUGIN%\plugin %CMS_DIR%\plugin

copy %JCIL_PLUGIN%\soi\* %CMS_DIR%\soi

if exist %BSCS_JAR%\jcil_plugin (
if exist %BSCS_JAR%\jcil_plugin\*.jar (
xcopy %BSCS_JAR%\jcil_plugin\*.jar %BSCS_JAR%\cms_plugin\ /Q /R /Y
rem -- clean up after all jcil plugins have been copied to cms plugin
if exist %BSCS_JAR%\cms_plugin\cms.jar del %BSCS_JAR%\cms_plugin\cms.jar
)
)

echo ---------------------------------
echo  JCIL Plugin installation finished
echo ---------------------------------