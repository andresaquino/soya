@echo off

rem
rem Command-line parameters of the SOITool:
rem -mode 
rem   could be <trace> or <gui>
rem 
rem -name
rem   This is the server name in the NamingService
rem   Server with this name will be searched under com/slb/sema/ccb/public
rem   This is the same value as specified in the -name argument of the server
rem 
rem -user
rem -password
rem   User name and password
rem 
rem -infile 
rem   This parameter is required only in <trace> mode
rem   Specify a file conform to trace.dtd
rem   All commands from this file will be send to the server for processing.
rem   Results will be written in the file named <infile>.out.xml if no other
rem   output file specified with -outfile
rem 
rem -outfile
rem   Optional parameter in <trace> mode to specify a name of the output XML file
rem 

@setlocal

set START_JAVA="%JDK_HOME%\jre\bin\java"

if not "%JDK_HOME%" == "" goto gotJDK
@echo on
@echo Configuration problem:
@echo Environment variable JDK_HOME is not set. The java executable is searched in the normal path instead.
@echo off

set START_JAVA=java

:gotJDK

set COMPNAME=soitool

set MYPATH=%BSCS_RESOURCE%\%COMPNAME%
set MYPATH=%MYPATH%;%BSCS_RESOURCE%
set MYPATH=%MYPATH%;%BSCS_JAR%\func_util.jar
set MYPATH=%MYPATH%;%BSCS_JAR%\soi.jar
set MYPATH=%MYPATH%;%BSCS_JAR%\func_frwmwk_cmn.jar
set MYPATH=%MYPATH%;%BSCS_JAR%\soitool.jar

@echo on
%START_JAVA% -cp %MYPATH% -Djava.io.tmpdir=%BSCS_LOG%\%COMPNAME% com.lhs.ccb.common.clients.SoiTool %*
@endlocal

