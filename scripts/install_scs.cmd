@echo off

rem ---------------------------------------------------
rem  Installation script for the SCS Plugin.
rem ---------------------------------------------------
rem
rem Prerequisites:
rem
rem    - JCIL BSCS iX installation 
rem    - either as PlugIn in CMS or standalone
rem
rem ---------------------------------------------------


rem ---------------------------------------------------
rem  Variables to be set according to your environment
rem ---------------------------------------------------


rem ---------------------------------------------------
rem  End of section to be adapted to your environment
rem ---------------------------------------------------


rem ---------------------------------------------------
rem  Proceed with the installation
rem ---------------------------------------------------

echo -------------------------------
echo   SCS Plugin installation
echo -------------------------------
echo
echo
echo  CMS installation directory is: %SHIPMENT%
echo  SCS shipment directory is: %BSCS_SCS_PLUGIN%
echo  Both variable are default to %BSCS_ROOT% and may be overwritten

if "%SHIPMENT%" == "" (
	set SHIPMENT=%BSCS_ROOT%
)
if "%BSCS_SCS_PLUGIN%" == "" (
	set BSCS_SCS_PLUGIN=%BSCS_ROOT%
)
 
echo  Installing...

echo  Check/create the plugin descriptors directory
if not exist %SHIPMENT%\lib\jar\jcil_plugin mkdir %SHIPMENT%\lib\jar\jcil_plugin
if not exist %SHIPMENT%\resource\jcil\plugin mkdir %SHIPMENT%\resource\jcil\plugin

echo  Installing the plugin library
copy %BSCS_SCS_PLUGIN%\lib\jar\scs.jar %SHIPMENT%\lib\jar\jcil_plugin
rem --- currently classes from cms.jar are needed in order to run SOI CS ---
copy %BSCS_SCS_PLUGIN%\lib\jar\cms.jar %SHIPMENT%\lib\jar\jcil_plugin

echo  Installing the resource files
copy %BSCS_SCS_PLUGIN%\resource\scs\plugin\Registry_SOICS*.xml %SHIPMENT%\resource\jcil\plugin

copy %BSCS_SCS_PLUGIN%\resource\scs\*.xml %SHIPMENT%\resource\jcil
xcopy /e /s /y %BSCS_SCS_PLUGIN%\resource\scs\cdf %SHIPMENT%\resource\jcil\cdf
copy %BSCS_SCS_PLUGIN%\resource\scs\soi\* %SHIPMENT%\resource\jcil\soi

if exist %SHIPMENT%\resource\cms\plugin\Registry_CIL.xml (
	echo JCIL is also installed as plugin in CMS
	copy %BSCS_SCS_PLUGIN%\lib\jar\scs.jar %SHIPMENT%\lib\jar\cms_plugin
	copy %BSCS_SCS_PLUGIN%\resource\scs\plugin\Registry_SOICS*.xml %SHIPMENT%\resource\cms\plugin

	copy %BSCS_SCS_PLUGIN%\resource\scs\*.xml %SHIPMENT%\resource\cms
	xcopy /e /s /y %BSCS_SCS_PLUGIN%\resource\scs\cdf %SHIPMENT%\resource\cms\cdf
	copy %BSCS_SCS_PLUGIN%\resource\scs\soi\* %SHIPMENT%\resource\cms\soi
)

echo ---------------------------------
echo  SCS Plugin installation finished
echo ---------------------------------