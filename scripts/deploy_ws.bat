@echo on
@echo *****************************************************************************************
@echo                    DEPLOY WEB-SERVICES
@echo *****************************************************************************************
@echo off
@setlocal

rem ********************************************************************************************
rem * Deployment script for Web Services
rem * This script will deploy the application as jcil plug-in
rem *
rem * BCSC_JAR represents the shipment directory and must be already set
rem * JAVA_HOME should point to the JDK folder and must be already set
rem * CATALINA_HOME should point to the tomcat folder and must be already set
rem * 
rem example: deploy_ws.bat --> it deploys ws_v2.war into tomcat/webapps
rem example-2: deploy_ws.bat dl --> it deploys ws_v2_dl.war into tomcat/webapps
rem ********************************************************************************************

set WS_VERSION=2_NII_1
set WS_DEPLOYED_NAME=ws_v2_NII_1
set WS_DEPLOYMENT_MODE=
rem set WS_DEPLOYMENT_MODE=_dl

set WEBAPPS_DIR=%CATALINA_HOME%\webapps

set ANT_CMD=%ANT_HOME%\bin\ant

rem ****************************************************
rem * no changes below this line
rem ****************************************************

if "%CATALINA_HOME%" == "" goto noCatalinaHome
if "%JAVA_HOME%" == "" goto noJavaHome
if "%BSCS_JAR%" == "" goto noBSCS
if "%BSCS_RESOURCE%" == "" goto noBSCS

if "%1" == "/?" goto usage
if "%1" == "-h" goto usage
if "%1" == "help" goto usage

if "%1" == "" goto remote
if "%1" == "remote" goto remote
if "%1" == "dl" goto domain_layer
if not "%1" == "-version" goto usage

set WS_VERSION=%2%
goto version

:remote
	set WS_DEPLOYMENT_MODE=
	set DEPLOY_DIR=deploy_remote
	@echo on
	@echo deployment mode: remote (only webserver is deployed, it will connect cms and cil via corba)
	@echo off
	goto version

:domain_layer
	set WS_DEPLOYMENT_MODE=_dl
	set DEPLOY_DIR=deploy_domain_layer
	echo deployment mode: domain-layer (webserver is deployed together with cil and cms)
	goto version


:version
if "%2" == "-version" (
	set WS_VERSION=%3%
)

if not exist %BSCS_JAR%\ws_v%WS_VERSION%.zip (
	echo file: %BSCS_JAR%\ws_v%WS_VERSION%.zip does not exist
	goto error
)	


@echo on
@echo remark: tomcat shall not be running during the deployment.
echo Start unpacking web service files ... 

rmdir /s /q %WEBAPPS_DIR%\%WS_DEPLOYED_NAME%
mkdir %WEBAPPS_DIR%\%WS_DEPLOYED_NAME%
chdir /D %WEBAPPS_DIR%\%WS_DEPLOYED_NAME%
%JAVA_HOME%\bin\jar xfM %BSCS_JAR%\ws_v%WS_VERSION%.zip

echo Deploy BSCS components from current BSCS environment ...
chdir /D %WEBAPPS_DIR%\%WS_DEPLOYED_NAME%\%DEPLOY_DIR%
if "%ANT_HOME%" == "" goto noAnt
:continue_ant
%ANT_CMD%
rem ********************************************************************************************
rem  batch terminates at the end of the ant run
rem ********************************************************************************************

rem echo Installing property files from %BSCS_RESOURCE% ...
rem if exist %BSCS_RESOURCE%\orb.properties xcopy %BSCS_RESOURCE%\orb.properties %WEBAPPS_DIR%\%WS_DEPLOYED_NAME%\WEB-INF\classes /Q /R /Y
rem if "%WS_DEPLOYMENT_MODE%" == "_dl" xcopy %BSCS_RESOURCE%\database.properties %WEBAPPS_DIR%\%WS_DEPLOYED_NAME%\WEB-INF\classes /Q /R /Y
rem @echo tomcat server can be started now...
goto end

:noJavaHome
echo environment variable JAVA_HOME is missing
goto end

:noCatalinaHome
echo environment variable CATALINA_HOME is missing
goto end

:noBSCS
echo environment variable BSCS_JAR or BSCS_RESOURCE is missing
goto end

:noAnt
set ANT_HOME=%WEBAPPS_DIR%\%WS_DEPLOYED_NAME%\ant
set ANT_CMD="%JAVA_HOME%\bin\java" -classpath %ANT_HOME%\lib\ant-launcher.jar -Dant.home=%ANT_HOME% org.apache.tools.ant.launch.Launcher 
goto continue_ant

:error
:usage
@echo on
@echo usage
@echo  "deploy_ws.bat [deploymentmode] [-version <version>]"
@echo   avaiable deploymentmodes are (if not set the remote mode is taken)
@echo   dl - domain layer (web service is deployed together with cms, jcil servers)
@echo   remote - only web service component is installed it connects remote servers via corba

:end

@endlocal
