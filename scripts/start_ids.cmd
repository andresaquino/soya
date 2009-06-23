@echo off

if "%1" == "" goto :USAGE
if "%2" == "" goto :USAGE

@setlocal

rem 
rem Start script for the iDENSRV. 
rem
rem %~dp0 availiable in NT to find out from which directory 
rem the program is started. Our home directory MUST be one level higher.
rem 

set HOME_DIR=%~dp0
set HOME_DIR=%HOME_DIR%..

set START_JAVA="%JDK_HOME%\jre\bin\java"

if not "%JDK_HOME%" == "" goto gotJDK
@echo on
@echo Configuration problem:
@echo Environment variable JDK_HOME is not set. The java executable is searched in the normal path instead.
@echo off

set START_JAVA=java

:gotJDK

if not "%BSCS_RESOURCE%" == "" goto gotBSCSRESOURCE
@echo on
@echo Configuration problem:
@echo Environment variable BSCS_RESOURCE is not set. The home directory %HOME_DIR% is used instead.
@echo off
set BSCS_RESOURCE=%HOME_DIR%
:gotBSCSRESOURCE

if not "%BSCS_JAR%" == "" goto gotBSCSJAR
@echo on
@echo Configuration problem:
@echo Environment variable BSCS_JAR is not set. The home directory %HOME_DIR% is used instead.
@echo off
set BSCS_JAR=%HOME_DIR%
:gotBSCSJAR

if not "%BSCS_LOG%" == "" goto gotBSCSLOG
@echo on
@echo Configuration problem:
@echo Environment variable BSCS_LOG is not set. The home directory %HOME_DIR% is used instead.
@echo off
set BSCS_LOG=%HOME_DIR%
:gotBSCSLOG

set COMPNAME=ids
set SERVER_ALIAS=%1%
set MYPATH=.
set MYPATH=%MYPATH%;%BSCS_RESOURCE%\%COMPNAME%
set MYPATH=%MYPATH%;%BSCS_JAR%\ids.jar
set MYPATH=%MYPATH%;%BSCS_JAR%\func_util.jar
set MYPATH=%MYPATH%;%2%

rem 
rem Adapt the memory settings -Xms and -Xmx to your environment. 
rem See the documenation of your JRE for more information.
rem 

@echo on
%START_JAVA% -Xms64M -Xmx128M -cp %MYPATH% -Djava.io.tmpdir=%BSCS_LOG%\%COMPNAME% com.lhs.idensrv.IdenSrv %SERVER_ALIAS%
@endlocal
@echo off
goto END

:USAGE
@echo on
@echo iDENSRV USAGE:
@echo                start_ids.cmd [Server Alias] [Motorola iSDK Path]
@echo                Example: start_ids.cmd iDENSRV01 C:\Motorola\iSDK\iPP.jar

:END