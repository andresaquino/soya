@echo off
@setlocal

set COMPNAME=security

set MYPATH=%BSCS_RESOURCE%\%COMPNAME%
set MYPATH=%MYPATH%;%BSCS_RESOURCE%
set MYPATH=%MYPATH%;%BSCS_JAR%\func_util.jar
set MYPATH=%MYPATH%;%BSCS_JAR%\soi.jar
set MYPATH=%MYPATH%;%BSCS_JAR%\func_frwmwk_cmn.jar
set MYPATH=%MYPATH%;%BSCS_3PP_JAR%\ojdbc14.jar
set MYPATH=%MYPATH%;%BSCS_3PP_JAR%\orai18n.jar
set MYPATH=%MYPATH%;%BSCS_3PP_JAR%\toplink.jar
set MYPATH=%MYPATH%;%BSCS_3PP_JAR%\jmxri.jar
set MYPATH=%MYPATH%;%BSCS_JAR%\func_frwmwk_srv.jar
set MYPATH=%MYPATH%;%BSCS_JAR%\func_sop_cmn.jar
set MYPATH=%MYPATH%;%BSCS_JAR%\func_sop_corba.jar
set MYPATH=%MYPATH%;%BSCS_JAR%\func_sop_lib.jar
set MYPATH=%MYPATH%;%BSCS_JAR%\security_plugin.jar

rem 
rem Use if Security Server runs behind a firewall.
rem Uncomment, define a server port, open the port in the firewall. 
rem set SEC_PORT=<port number>
rem For the Sun JDK
rem set ORBSERVERPORT="-Dcom.sun.CORBA.ORBServerPort=%SEC_PORT%"
rem For the IBM JDK
rem set ORBSERVERPORT="-Dcom.ibm.CORBA.ListenerPort=%SEC_PORT%"
rem

@echo on
java -cp %MYPATH% %ORBSERVERPORT% -Djava.io.tmpdir=%BSCS_LOG%\%COMPNAME% -DSVAPPLINDEX=%SVAPPLINDEX% -DSVAPPLHOST=%SVAPPLHOST% com.lhs.ccb.sfw.application.ExtendedServer %*
@endlocal
