#!/bin/sh 
# vim: set ts=3 sw=3 sts=3 et si ai: 

# soya.sh -- put here a short description 
# ---------------------------------------------------------------------------- 
# (c) 2009 Nextel de México S.A. de C.V.
# Andrés Aquino Morales <andres.aquino@gmail.com>
# All rights reserved.
# 

# get application Name and Action
apAppName="soya"
apHome=${HOME}/soya
apDir=`dirname ${PWD}/${0}`
apName=`basename ${0%.*}`
scrPrcs=0

# move to application home directory
cd ${apHome}

# i need a config file...
[ ! -e ${apHome}/soya.conf ] && echo "hey!, i need a config file like soya.conf" && exit 1
[ ! -e ${apHome}/setup/${apName}.conf ] && echo "hey!, i need a config file like ${apHome}/setup/${apName}.conf" && exit 1

#
APPNAME=${apAppName}
APPPATH=${apHome}

# settings, setup & libraries
. ${apHome}/soya.conf
. ${apHome}/libutils.sh
. ${apHome}/setup/${apName}.conf

#
get_enviroment
apAction=`basename ${0#*.} | tr "[:upper:]" "[:lower:]"`
apHost=`hostname | tr "[:upper:]" "[:lower:]" | sed -e "s/m.*hp//g"`
apLog="${apHome}/log/${apName}"

# virtual terminal name
scrPrcs=`echo ${apName} | sed -e "s/[a-zA-Z\.]//g"`
[ "x${scrPrcs}" != "x" ] && scrPrcs="0${scrPrcs}"
scrName=`echo "$(echo "${apHost}____" | cut -c 1-4)" | tr "[:lower:]" "[:upper:]"`
scrName="${scrName}${apType}${scrPrcs}"

##
executeCmd () {
   local strCommand=${1}

   # si no hay otro proceso
   screen -ls | grep ${scrName} > /dev/null 2>&1
   [ "x$?" != "x0" ] && log_action "ERR" "${scrName} virtual terminal process doesn't exist!" && exit 1 

   # ejecutar el comando
   screen -x ${scrName} -p 0 -X stuff "$(printf '%b' "${strCommand}\015")"
   wait_for "Executing command ${strCommand} on ${scrName} " 2

   # reportar el estado de la ejecucion
   log_action "INFO" "${strCommand} on ${scrName} cooked, go home baby! "
 
}


# START
if [ ${apAction} = "start" ]
then
   # si no hay otro proceso
   screen -ls | grep ${scrName} > /dev/null 2>&1
   [ "x$?" = "x0" ] && log_action "ERR" "Another ${scrName} virtual terminal process exist!" && exit 1 
   
   # backup
   mkdir -p ${apHome}/log/${apDate}
   mv ${apLog}.log ${apHome}/log/${apDate}/${scrName}.log.`date '+%H%M'` > /dev/null 2>&1

   #
   . ${apHome}/setup/${apName}.conf
   screen -d -m -S ${scrName}
   screen -r ${scrName} -p 0 -X log off
   screen -r ${scrName} -p 0 -X logfile ${apLog}.log
   screen -r ${scrName} -p 0 -X logfile flush 10
   screen -r ${scrName} -p 0 -X log on
   wait_for "Starting ${scrName} virtual terminal " 6
   
   #
   screen -r ${scrName} -p 0 -X stuff "$(printf '%b' "${apCommand}\015")"
   wait_for "Starting process " 8
   log_action "INFO" "Process ${apType} running in background "
   exit 0

fi

# STOP
if [ ${apAction} = "stop" ]
then
   # si no hay otro proceso
   screen -ls | grep ${scrName} > /dev/null 2>&1
   if [ "x$?" != "x0" ] 
   then
      log_action "ERR" "OMFG...! Nothing to stop man. "
      exit 1
   else
      screen -r ${scrName} -p 0 -X log off
      screen -r ${scrName} -p 0 -X stuff "$(printf '%b' "exit\015")"
      wait_for "Stoping process " 12
      
      screen -x ${scrName} -p 0 -X quit > /dev/null 2>&1
      log_action "INFO" "Process ${scrName} finalized "
   fi
   exit 0

fi

# cualquier otro comando ...
# app.logsOn | app.logsOff | app.backUp | app.logsClear 
case ${apAction}  in
   logson)
      executeCmd "${apLogsOn}"
      exit 0
      ;;

   logsoff)
      executeCmd "${apLogsOff}"
      exit 0
      ;;

   syslogson)
      executeCmd "${apSyslogsOn}"
      exit 0
      ;;

   syslogsoff)
      executeCmd "${apSyslogsOff}"
      exit 0
      ;;

   dblogson)
      executeCmd "${apDBlogsOn}"
      exit 0
      ;;

   dblogsoff)
      executeCmd "${apDBlogsOff}"
      exit 0
      ;;

   backup)
      executeCmd "${apBackUp}"
      exit 0
      ;;

   logsclear)
      executeCmd "${apLogsClear}"
      exit 0
      ;;

   getlevel)
      executeCmd "${apLevel}"
      tail -n100 ${apLog}.log | grep "Level for this build" | tail -n1
      exit 0
      ;;

   version)
      #
      # generar num de release en base al changelog, para no modificar el md5 del script
      # sh ../playground/changelog.sh -> git log > CHANGELOG
      VERSIONAPP="1"
      UPVERSION=`echo ${VERSIONAPP} | sed -e "s/..$//g"`
      RLVERSION=`awk '/200/{t=substr($2,6,7);gsub("-",".",t);print t}' ${apHome}/CHANGELOG | head -n1`
      echo "${apAppName} v${UPVERSION}.${RLVERSION}"
      echo "(c) 2009 Nextel de Mexico S.A. de C.V."
      
      if [ "${TTYTYPE}" = "CONSOLE" ]
      then 
         echo "\nWritten by"
         echo "Andres Aquino <andres.aquino@gmail.com>"
      fi   
      exit 0
      ;;

esac

#
