@echo off
@setlocal

rem
rem Home directory of the BSCS installation
rem All paths to \lib \resource and other directories are specified
rem relative to this home directory
rem
rem %~dp0 availiable in NT to find out from which directory
rem the program is started. Our home directory MUST be one level higher.
rem

set HOME_DIR=%~dp0
set HOME_DIR=%HOME_DIR%..

set START_JAVA=%JDK_HOME%\jre\bin\java

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


set COMPNAME=psa

rem Customize following command line parameters !!
set COMMAND_LINE_PARAMS=com/lhs/public/soi/fedfactory1 SOI_USER SOI_PASSWD CMI 1 -port 7512

set MYPATH=%BSCS_RESOURCE%
set MYPATH=%MYPATH%;%BSCS_RESOURCE%\%COMPNAME%
set MYPATH=%MYPATH%;%BSCS_JAR%\func_util.jar
set MYPATH=%MYPATH%;%BSCS_JAR%\psa.jar
set MYPATH=%MYPATH%;%BSCS_JAR%\soi.jar
set MYPATH=%MYPATH%;%BSCS_JAR%\func_frwmwk_cmn.jar


rem
rem Adapt the memory settings -Xms and -Xmx to your environment.
rem See the documenation of your JRE for more information.
rem

@echo on
rem start /MIN %JDK_HOME%\bin\orbd -ORBInitialPort 2010 -port 2010

%START_JAVA% -Xms64M -Xmx128M -cp %MYPATH% -Djava.io.tmpdir=%BSCS_LOG%\%COMPNAME% com.slb.inservices.Psa.PMIAdapter %COMMAND_LINE_PARAMS%
@endlocal
