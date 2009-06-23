@echo off
@setlocal

rem ********************************************************************************************
rem * Deployment script for Custcare Webclients
rem * This script will deploy the application into the web container (e.g. tomcat)
rem * Change the first lines below to suite to your needs
rem *
rem * WEBAPPS_DIR represents the deployment folder (e.g.%CATALINA_HOME%\webapps)
rem * BCSC_JAR represents the shipment directory and must be already set
rem * JAVA_HOME should point to the JDK folder and must be already set
rem * 
rem ********************************************************************************************


set WEBAPPS_DIR=%CATALINA_HOME%\webapps

rem ****************************************************
rem * no changes below this line
rem ****************************************************

set LINE=---------------------------------------------------

if "%1"=="" goto err 

if "%CATALINA_HOME%" == "" goto noCatalinaHome
if "%JAVA_HOME%" == "" goto noJavaHome
set PATH=%PATH%;%JAVA_HOME%\bin

set APP_NAME=custcare_%1


if not exist %BSCS_JAR%\%APP_NAME%_configuration.zip goto notavailable


echo Start unpacking custcare files ... 

mkdir %WEBAPPS_DIR%\%APP_NAME%
mkdir %WEBAPPS_DIR%\%APP_NAME%\WEB-INF\lib

chdir /D %WEBAPPS_DIR%\%APP_NAME%
"%JAVA_HOME%\bin\jar" xfM %BSCS_JAR%\custcare.zip


"%JAVA_HOME%\bin\jar" xfM %BSCS_JAR%\%APP_NAME%_configuration.zip


xcopy %BSCS_JAR%\func_frwmwk_cmn.jar %WEBAPPS_DIR%\%APP_NAME%\WEB-INF\lib /Q /R /Y
xcopy %BSCS_JAR%\func_util.jar %WEBAPPS_DIR%\%APP_NAME%\WEB-INF\lib /Q /R /Y
xcopy %BSCS_JAR%\soi.jar %WEBAPPS_DIR%\%APP_NAME%\WEB-INF\lib /Q /R /Y
xcopy %BSCS_JAR%\func_frwmwk_clt.jar %WEBAPPS_DIR%\%APP_NAME%\WEB-INF\lib /Q /R /Y
xcopy %BSCS_3PP_JAR%\fop.jar %WEBAPPS_DIR%\%APP_NAME%\WEB-INF\lib /Q /R /Y
xcopy %BSCS_3PP_JAR%\batik.jar %WEBAPPS_DIR%\%APP_NAME%\WEB-INF\lib /Q /R /Y
xcopy %BSCS_3PP_JAR%\avalon-framework-cvs-20020806.jar %WEBAPPS_DIR%\%APP_NAME%\WEB-INF\lib /Q /R /Y
xcopy %BSCS_3PP_JAR%\commons-validator\commons-beanutils.jar %WEBAPPS_DIR%\%APP_NAME%\WEB-INF\lib /Q /R /Y
xcopy %BSCS_3PP_JAR%\commons-validator\commons-collections.jar %WEBAPPS_DIR%\%APP_NAME%\WEB-INF\lib /Q /R /Y
xcopy %BSCS_3PP_JAR%\commons-validator\commons-digester.jar %WEBAPPS_DIR%\%APP_NAME%\WEB-INF\lib /Q /R /Y
xcopy %BSCS_3PP_JAR%\commons-validator\commons-logging.jar %WEBAPPS_DIR%\%APP_NAME%\WEB-INF\lib /Q /R /Y
xcopy %BSCS_3PP_JAR%\commons-validator\commons-validator.jar %WEBAPPS_DIR%\%APP_NAME%\WEB-INF\lib /Q /R /Y
xcopy %BSCS_3PP_JAR%\commons-validator\jakarta-oro.jar %WEBAPPS_DIR%\%APP_NAME%\WEB-INF\lib /Q /R /Y



rmdir /s /q %WEBAPPS_DIR%\%APP_NAME%\META-INF
echo Required libraries copied.

echo Installing property files from %BSCS_RESOURCE% ...
if exist %BSCS_RESOURCE%\orb.properties xcopy %BSCS_RESOURCE%\orb.properties %WEBAPPS_DIR%\%APP_NAME%\WEB-INF\classes /Q /R /Y
echo Required property files copied.

echo %LINE%
echo BSCS CX Webclient installation done.
echo %LINE%
goto end

:noJavaHome
echo environment variable JAVA_HOME is missing
goto end

:noCatalinaHome
echo environment variable CATALINA_HOME is missing
goto end

:err
echo usage : 
echo	deploy.bat {deploymentmode}
echo	avaiable deploymentmodes are
echo	cu - for Customer Care 
echo	bp - for Business Partner Center BPX
echo	prepaid - for Prepaid Customer Care (Prepaid CC)
echo	b_bp - Business Partner Center BPX for iX Billing
echo	r_bp - Business Partner Center BPX for iX Rating
echo	r_prepaid - Prepaid Customer Care (Prepaid CC) for iX Rating

goto end

:notavailable
echo The deploymentmode %1 is not available
goto end

:end

@endlocal





