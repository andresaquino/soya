@echo off
@setlocal
rem ********************************************************************************************
rem * Deployment script for the PGX Webclient
rem * This script will deploy the application into the web container (e.g. tomcat)
rem * Change the first lines below to suite to your needs
rem *
rem * WEBAPPS_DIR represents the deployment folder (e.g.%CATALINA_HOME%\webapps)
rem * BCSC_JAR represents the shipment directory and must be already set
rem * JAVA_HOME should point to the JDK folder and must be already set
rem ********************************************************************************************


set WEBAPPS_DIR=%CATALINA_HOME%\webapps


rem ****************************************************
rem * no changes below this line
rem ****************************************************

set LINE=---------------------------------------------------

echo %LINE%
echo Start installing BSCS PGX Webclient
echo %LINE%

if "%CATALINA_HOME%" == "" goto noCatalinaHome
if "%JAVA_HOME%" == "" goto noJavaHome

set APP_NAME=pgx


echo Start unpacking PGX files ... 

mkdir %WEBAPPS_DIR%\%APP_NAME%

chdir /D %WEBAPPS_DIR%\%APP_NAME%
%JAVA_HOME%\bin\jar xfM %BSCS_JAR%\%APP_NAME%.zip

if "%1" == "rating" (
  %JAVA_HOME%\bin\jar xfM %BSCS_JAR%\%APP_NAME%_%1_configuration.zip
) else (
  %JAVA_HOME%\bin\jar xfM %BSCS_JAR%\%APP_NAME%_configuration.zip
)


echo Start copying the required libraries ...
set LIBDIR=%WEBAPPS_DIR%\%APP_NAME%\WEB-INF\lib
mkdir %LIBDIR%
xcopy %BSCS_JAR%\func_frwmwk_cmn.jar %LIBDIR% /Q /R /Y
xcopy %BSCS_JAR%\func_util.jar %LIBDIR% /Q /R /Y
xcopy %BSCS_JAR%\soi.jar %LIBDIR% /Q /R /Y
xcopy %BSCS_JAR%\func_frwmwk_clt.jar %LIBDIR% /Q /R /Y
rem xcopy %BSCS_ROOT%\3pp\jar\commons-validator\*.jar %LIBDIR% /Q /R /Y
xcopy %COMMONS_VALIDATOR_HOME%\*.jar %LIBDIR% /Q /R /Y
xcopy %BSCS_3PP_JAR%\commons-validator\commons-beanutils.jar %WEBAPPS_DIR%\%APP_NAME%\WEB-INF\lib /Q /R /Y
xcopy %BSCS_3PP_JAR%\commons-validator\commons-collections.jar %WEBAPPS_DIR%\%APP_NAME%\WEB-INF\lib /Q /R /Y
xcopy %BSCS_3PP_JAR%\commons-validator\commons-digester.jar %WEBAPPS_DIR%\%APP_NAME%\WEB-INF\lib /Q /R /Y
xcopy %BSCS_3PP_JAR%\commons-validator\commons-logging.jar %WEBAPPS_DIR%\%APP_NAME%\WEB-INF\lib /Q /R /Y
xcopy %BSCS_3PP_JAR%\commons-validator\commons-validator.jar %WEBAPPS_DIR%\%APP_NAME%\WEB-INF\lib /Q /R /Y
xcopy %BSCS_3PP_JAR%\commons-validator\jakarta-oro.jar %WEBAPPS_DIR%\%APP_NAME%\WEB-INF\lib /Q /R /Y
xcopy %BSCS_3PP_JAR%\toplink.jar %WEBAPPS_DIR%\%APP_NAME%\WEB-INF\lib /Q /R /Y
xcopy %BSCS_3PP_JAR%\ojdbc14.jar %WEBAPPS_DIR%\%APP_NAME%\WEB-INF\lib /Q /R /Y
xcopy %BSCS_3PP_JAR%\orai18n.jar %WEBAPPS_DIR%\%APP_NAME%\WEB-INF\lib /Q /R /Y

rmdir %WEBAPPS_DIR%\%APP_NAME%\Meta-inf /S/Q

echo Required libraries copied.

echo Installing property files from %BSCS_RESOURCE% ...
if exist %BSCS_RESOURCE%\orb.properties xcopy %BSCS_RESOURCE%\orb.properties %WEBAPPS_DIR%\%APP_NAME%\WEB-INF\classes /Q /R /Y
echo Required property files copied.

echo %LINE%
echo BSCS PGX Webclient installation done.
echo %LINE%
goto end

:noCatalinaHome
echo environment variable CATALINA_HOME is missing
goto end

:noJavaHome
echo environment variable JAVA_HOME is missing
goto end

:end

@endlocal
