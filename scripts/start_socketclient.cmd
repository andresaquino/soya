@echo off

if "%1" == "" goto :USAGE
if "%2" == "" goto :USAGE

@setlocal

rem 
rem Start script for the iDENSRV SocketClient. 
rem

set START_JAVA="%JDK_HOME%\jre\bin\java"

if not "%JDK_HOME%" == "" goto gotJDK
@echo on
@echo Configuration problem:
@echo Environment variable JDK_HOME is not set. The java executable is searched in the normal path instead.
@echo off

set START_JAVA=java

:gotJDK

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

set HOSTNAME=%1%
set PORT=%2%

set MYPATH=.
set MYPATH=%MYPATH%;%BSCS_JAR%\ids.jar

rem 
rem Adapt the memory settings -Xms and -Xmx to your environment. 
rem See the documenation of your JRE for more information.
rem 

@echo on
%START_JAVA% -Xms64M -Xmx128M -cp %MYPATH% -Djava.io.tmpdir=%BSCS_LOG%\%COMPNAME% com.lhs.idensrv.tester.SocketClient %HOSTNAME% %PORT%
@endlocal
@echo off
goto END

:USAGE
@echo on
@echo SocketClient USAGE:
@echo                start_socketclient.cmd [Hostname] [Port]

:END