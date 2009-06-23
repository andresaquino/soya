@echo off

if not "%1" == "" goto :APPEND

@setlocal



rem 
rem Start script for the CPS server. 
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

if not "%BSCS_3PP_JAR%" == "" goto gotBSCS3PPJAR
@echo on
@echo Configuration problem:
@echo Environment variable BSCS_3PP_JAR is not set. The home directory %HOME_DIR% is used instead.
@echo off
set BSCS_3PP_JAR=%HOME_DIR%
:gotBSCS3PPJAR

if not "%BSCS_LOG%" == "" goto gotBSCSLOG
@echo on
@echo Configuration problem:
@echo Environment variable BSCS_LOG is not set. The home directory %HOME_DIR% is used instead.
@echo off
set BSCS_LOG=%HOME_DIR%
:gotBSCSLOG


set COMPNAME=cps
set SERVER_NAME=CPS_IX 
if exist %BSCS_JAR%\cps_plugin for %%I in (%BSCS_JAR%\cps_plugin\*.jar) do call %0 %%I
set MYPATH=%MYPATH%;%BSCS_RESOURCE%\%COMPNAME%
set MYPATH=%MYPATH%;%BSCS_RESOURCE%
set MYPATH=%MYPATH%;%BSCS_JAR%\func_util.jar
set MYPATH=%MYPATH%;%BSCS_JAR%\soi.jar
set MYPATH=%MYPATH%;%BSCS_JAR%\func_frwmwk_cmn.jar
set MYPATH=%MYPATH%;%BSCS_3PP_JAR%\ojdbc14.jar
set MYPATH=%MYPATH%;%BSCS_3PP_JAR%\orai18n.jar
set MYPATH=%MYPATH%;%BSCS_3PP_JAR%\toplink.jar
set MYPATH=%MYPATH%;%BSCS_3PP_JAR%\jmxri.jar
set MYPATH=%MYPATH%;%BSCS_JAR%\func_frwmwk_srv.jar
set MYPATH=%MYPATH%;%BSCS_JAR%\security_plugin.jar
set MYPATH=%MYPATH%;%BSCS_JAR%\func_sop_cmn.jar
set MYPATH=%MYPATH%;%BSCS_JAR%\func_sop_corba.jar
set MYPATH=%MYPATH%;%BSCS_JAR%\func_sop_lib.jar
set MYPATH=%MYPATH%;%BSCS_JAR%\cms.jar
set MYPATH=%MYPATH%;%BSCS_JAR%\pms.jar
set MYPATH=%MYPATH%;%BSCS_JAR%\cps.jar

rem 
rem Adapt the memory settings -Xms and -Xmx to your environment. 
rem See the documenation of your JRE for more information.
rem 

@echo on
%START_JAVA% -server -Xms64M -Xmx128M -cp %MYPATH% -DSVAPPLINDEX=%SVAPPLINDEX% -DSVAPPLHOST=%SVAPPLHOST% -DBSCS_RESOURCE=%BSCS_RESOURCE% -Djava.io.tmpdir=%BSCS_LOG%\%COMPNAME% com.lhs.ccb.sfw.application.ExtendedServer -name %SERVER_NAME% 
@endlocal

goto :END

:APPEND
echo Append %1
set MYPATH=%MYPATH%;%1
:END