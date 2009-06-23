@echo off

if not "%1" == "" goto :APPEND

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



rem Change server name to your needs
set SERVER_NAME=JCIL_900 
set COMPNAME=jcil

if exist %BSCS_JAR%\jcil_plugin for %%I in (%BSCS_JAR%\jcil_plugin\*.jar) do call %0 %%I
set MYPATH=%MYPATH%;%BSCS_RESOURCE%\%COMPNAME%
set MYPATH=%MYPATH%;%BSCS_RESOURCE%
set MYPATH=%MYPATH%;%BSCS_JAR%\func_util.jar
set MYPATH=%MYPATH%;%BSCS_JAR%\soi.jar
set MYPATH=%MYPATH%;%BSCS_JAR%\func_frwmwk_cmn.jar
set MYPATH=%MYPATH%;%BSCS_3PP_JAR%\ojdbc14.jar
set MYPATH=%MYPATH%;%BSCS_3PP_JAR%\orai18n.jar
set MYPATH=%MYPATH%;%BSCS_3PP_JAR%\toplink.jar
set MYPATH=%MYPATH%;%BSCS_3PP_JAR%\jmxri.jar
set MYPATH=%MYPATH%;%BSCS_3PP_JAR%\quartz-1.5.1.jar
set MYPATH=%MYPATH%;%BSCS_3PP_JAR%\commons-logging.jar
set MYPATH=%MYPATH%;%BSCS_3PP_JAR%\commons-logging-api.jar
set MYPATH=%MYPATH%;%BSCS_JAR%\func_frwmwk_srv.jar
set MYPATH=%MYPATH%;%BSCS_JAR%\func_sop_cmn.jar
set MYPATH=%MYPATH%;%BSCS_JAR%\func_sop_corba.jar
set MYPATH=%MYPATH%;%BSCS_JAR%\func_sop_lib.jar
set MYPATH=%MYPATH%;%BSCS_JAR%\jcil.jar
set MYPATH=%MYPATH%;%BSCS_JAR%\security_plugin.jar


rem The property com.sun.CORBA.transport.ORBTCPReadTimeouts can be reset to adjust the transport read tcp 
rem timeout property, which is a colon separated property with the following syntax:
rem <initial time to wait: max read giop header time to wait: max read message time to wait: backoff factor>
rem If you often get CORBA exceptions for the reason that the timeout is reached (especially in the case that 
rem Sun JDK 1.5.0 is used), please add the following VM argument as one of the arguments of %START_JAVA%
rem "-Dcom.sun.CORBA.transport.ORBTCPReadTimeouts=1:60000:300:1"


rem 
rem Use if JCIL runs behind a firewall.
rem Uncomment, define a server port, open the port in the firewall. 
rem set JCIL_PORT=<port number>
rem For the Sun JDK
rem set ORBSERVERPORT="-Dcom.sun.CORBA.ORBServerPort=%JCIL_PORT%"
rem For the IBM JDK
rem set ORBSERVERPORT="-Dcom.ibm.CORBA.ListenerPort=%JCIL_PORT%"
rem

rem 
rem Adapt the memory settings -Xms and -Xmx to your environment. 
rem See the documenation of your JRE for more information.
rem 

@echo on

%START_JAVA% -server -Xms64M -Xmx128M -cp %MYPATH% %ORBSERVERPORT% -DSVAPPLINDEX=%SVAPPLINDEX% -DSVAPPLHOST=%SVAPPLHOST% -DBSCS_RESOURCE=%BSCS_RESOURCE% -Djava.io.tmpdir=%BSCS_LOG%\%COMPNAME% -DSVAPPLINST=%SVAPPLINST% com.lhs.ccb.sfw.application.ExtendedServer -name %SERVER_NAME%
@endlocal

:APPEND
echo Append %1
set MYPATH=%MYPATH%;%1
:END