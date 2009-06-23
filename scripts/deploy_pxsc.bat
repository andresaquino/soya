@echo off
@setlocal
rem *******************************************************************************
rem * Deployment script for PX Smart Client Webclient.
rem * This script will deploy the application into the web container (e.g. tomcat)
rem * Change the first lines below to suite to your needs
rem *
rem * WEBAPPS_DIR is folder containing all web apps (e.g.%CATALINA_HOME%\webapps)
rem * DEPLOY_NAME represents the deployment name under WEBAPPS_DIR
rem *
rem * BCSC environment must be already set
rem * JAVA_HOME should point to the Java in folder and must be already set.
rem *******************************************************************************

set WEBAPPS_DIR=%CATALINA_HOME%\webapps
set DEPLOY_NAME=PXSC

rem ****************************************************
rem * no changes below this line
rem ****************************************************

set DEPLOY_PREFIX=
set DEPLOY_DIR=%WEBAPPS_DIR%\%DEPLOY_PREFIX%%DEPLOY_NAME%

set LINE=---------------------------------------------------

if exist %BSCS_ROOT% goto checkwebapps
echo BSCS environment not set. Bye.
goto end

:checkwebapps
if exist %WEBAPPS_DIR% goto install
echo Webapps directory does not exist. Bye.
goto end

:install
echo %LINE%
echo Start installing PXSC Webclient...
echo %LINE%

echo Create deployment directory %DEPLOY_DIR%
mkdir %DEPLOY_DIR%

echo Start unpacking PXSC files into %DEPLOY_DIR%
chdir /D %DEPLOY_DIR%
"%JAVA_HOME%\bin\jar.exe" xfM %BSCS_JAR%\smartpx.zip
rmdir %DEPLOY_DIR%\META-INF /S/Q
echo Unpacking PXSC files done.

echo Installing the required libraries ...
if not exist %DEPLOY_DIR%\WEB-INF\lib mkdir %DEPLOY_DIR%\WEB-INF\lib
xcopy %BSCS_JAR%\func_frwmwk_cmn.jar %DEPLOY_DIR%\WEB-INF\lib /Q /R /Y
xcopy %BSCS_JAR%\func_util.jar %DEPLOY_DIR%\WEB-INF\lib /Q /R /Y
xcopy %BSCS_JAR%\soi.jar %DEPLOY_DIR%\WEB-INF\lib /Q /R /Y
xcopy %BSCS_JAR%\func_frwmwk_clt.jar %DEPLOY_DIR%\WEB-INF\lib /Q /R /Y
xcopy %BSCS_JAR%\func_frwmwk_srv.jar %DEPLOY_DIR%\WEB-INF\lib /Q /R /Y
xcopy %BSCS_JAR%\func_frwmwk_clt_dl.jar %DEPLOY_DIR%\WEB-INF\lib /Q /R /Y
xcopy %BSCS_ROOT%\3pp\jar\toplink.jar %DEPLOY_DIR%\WEB-INF\lib /Q /R /Y
xcopy %BSCS_ROOT%\3pp\jar\ojdbc14.jar %DEPLOY_DIR%\WEB-INF\lib /Q /R /Y
xcopy %BSCS_ROOT%\3pp\jar\commons-validator\commons-beanutils.jar %DEPLOY_DIR%\WEB-INF\lib /Q /R /Y
xcopy %BSCS_ROOT%\3pp\jar\commons-validator\commons-collections.jar %DEPLOY_DIR%\WEB-INF\lib /Q /R /Y
xcopy %BSCS_ROOT%\3pp\jar\commons-validator\commons-digester.jar %DEPLOY_DIR%\WEB-INF\lib /Q /R /Y
xcopy %BSCS_ROOT%\3pp\jar\commons-validator\commons-logging.jar %DEPLOY_DIR%\WEB-INF\lib /Q /R /Y
xcopy %BSCS_ROOT%\3pp\jar\commons-validator\commons-validator.jar %DEPLOY_DIR%\WEB-INF\lib /Q /R /Y
xcopy %BSCS_ROOT%\3pp\jar\commons-validator\jakarta-oro.jar %DEPLOY_DIR%\WEB-INF\lib /Q /R /Y
echo Required libraries copied.
echo

echo Installing property files from %BSCS_RESOURCE%
if exist %BSCS_RESOURCE%\orb.properties xcopy %BSCS_RESOURCE%\orb.properties %DEPLOY_DIR%\WEB-INF\classes /Q /R /Y
if exist %BSCS_RESOURCE%\database.properties xcopy %BSCS_RESOURCE%\database.properties %DEPLOY_DIR%\WEB-INF\classes /Q /R /Y
echo Property files copied.
echo

echo %LINE%
echo PXSC Webclient installation done.
echo %LINE%

:end
@endlocal
