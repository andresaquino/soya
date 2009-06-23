@echo off
@setlocal

rem ********************************************************************************************
rem * Deployment script for Composite Commands
rem * This script will deploy the application as jcil plug-in
rem * JCIL can be a plug-in of CMS.
rem *
rem * BCSC_JAR represents the shipment directory and must be already set
rem * JAVA_HOME should point to the JDK folder and must be already set
rem * 
rem ********************************************************************************************


rem ****************************************************
rem * no changes below this line
rem ****************************************************

echo install composite commands as jcil plug-in
xcopy %BSCS_RESOURCE%\compcmd\Registry_CompCmd.xml %BSCS_RESOURCE%\jcil\plugin\ /Q /R /Y
xcopy %BSCS_RESOURCE%\compcmd\FUNC_FRMWK_COMPCMD_ErrorDictionary.xml %BSCS_RESOURCE%\jcil\plugin\ /Q /R /Y
xcopy %BSCS_JAR%\compositecmd.jar %BSCS_JAR%\jcil_plugin\ /Q /R /Y

if exist %BSCS_RESOURCE%\cms\plugin\Registry_CIL.xml (
	echo install composite commands as cms plug-in [jcil is a cms plug-in]
	xcopy %BSCS_RESOURCE%\compcmd\Registry_CompCmd.xml %BSCS_RESOURCE%\cms\plugin\ /Q /R /Y
	xcopy %BSCS_RESOURCE%\compcmd\FUNC_FRMWK_COMPCMD_ErrorDictionary.xml %BSCS_RESOURCE%\cms\plugin\ /Q /R /Y
	xcopy %BSCS_JAR%\compositecmd.jar %BSCS_JAR%\cms_plugin\ /Q /R /Y
)

@endlocal





