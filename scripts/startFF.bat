@echo off

if not "%1" == "" goto :APPEND

@setlocal

rem 
rem Start script for the federated factory. 
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

set COMPNAME=fedfactory
set MYPATH=%MYPATH%;%BSCS_RESOURCE%\%COMPNAME%
set MYPATH=%MYPATH%;%BSCS_RESOURCE%
set MYPATH=%MYPATH%;%BSCS_JAR%\func_util.jar
set MYPATH=%MYPATH%;%BSCS_JAR%\func_sop_cmn.jar
set MYPATH=%MYPATH%;%BSCS_JAR%\func_sop_corba.jar
set MYPATH=%MYPATH%;%BSCS_JAR%\func_sop_lib.jar
set MYPATH=%MYPATH%;%BSCS_JAR%\fedfactory.jar
set MYPATH=%MYPATH%;%BSCS_JAR%\fedfactory_ext.jar

rem 
rem Use if JFF runs behind a firewall.
rem Uncomment, define a server port, open the port in the firewall. 
rem set JFF_PORT=<port number>
rem set ORBSERVERPORT="-Dcom.sun.CORBA.ORBServerPort=%JFF_PORT%"
rem


@echo on
%START_JAVA% -server -Xmx128M -cp %MYPATH% %ORBSERVERPORT% -DSVAPPLINDEX=%SVAPPLINDEX% -DSVAPPLHOST=%SVAPPLHOST% -DBSCS_RESOURCE=%BSCS_RESOURCE% -Djava.io.tmpdir=%BSCS_LOG%\%COMPNAME% -Djava.util.logging.config.file=%BSCS_RESOURCE%/fedfactory/logging.properties com.lhs.fedfactory.FedFactory %* 
@endlocal

goto :END

:APPEND
echo Append %1
set MYPATH=%MYPATH%;%1
:END
