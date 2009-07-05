#!/bin/sh 
# vim: set ts=3 sw=3 sts=3 et si ai: 

# soya.sh -- put here a short description 
# ---------------------------------------------------------------------------- 
# (c) 2009 Nextel de México S.A. de C.V.
# Andrés Aquino Morales <andres.aquino@gmail.com>
# All rights reserved.
# 

# get application Name and Action
apHome=/media/DELL/nextel.com.mx/soya.git
apDir=`dirname ${PWD}/${0}`
apAction=`basename ${0#*.} | tr "[:upper:]" "[:lower:]"`
apName=`basename ${0%.*}`

# move to application home directory
cd ${apHome}

# i need a config file...
[ ! -e soya.conf ] && echo "hey!, i need a config file like soya.conf" && exit 1
[ ! -e ${apName}.conf ] && echo "hey!, i need a config file like ${apName}.conf" && exit 1

# settings, setup & libraries
. soya.conf
. libutils.sh
. ${apName}.conf

#
get_enviroment

# virtual terminal name
scrPrcs=`echo $0 | sed -e "s/[a-zA-Z\.]//g"`
[ "x${scrPrcs}" != "x" ] && scrPrcs="0${scrPrcs}"
scrName=`echo "$(echo "${apHost}____" | cut -c 1-4)" | tr "[:lower:]" "[:upper:]"`
scrName="${scrName}${apType}${scrPrcs}"
 
# START
if [ ${apAction} = "start" ]
then
   # si no hay otro proceso
   screen -ls | grep ${scrName} > /dev/null 2>&1
   [ "x$?" = "x0" ] && log_action "ERR" "Another ${scrName} virtual terminal process exist!" && exit 1 
   
   # backup
   apLog="${apHome}/log/${apName}"
   mkdir -p ${apHome}/log/${apDate}
   mv ${apLog}.log ${apHome}/log/${apDate}/${scrName}.log.`date '+%H%M'` > /dev/null 2>&1

   #
   . ${apName}.conf
   screen -d -m -S ${scrName}
   screen -r ${scrName} -p 0 -X log off
   screen -r ${scrName} -p 0 -X logfile ${apLog}.log
   screen -r ${scrName} -p 0 -X logfile flush 10
   screen -r ${scrName} -p 0 -X log on
   wait_for "Starting ${scrName} virtual terminal " 6
   
   #
   screen -r ${scrName} -p 0 -X stuff "$(printf '%b' "${apCommand}\015")"
   wait_for "Starging process " 8
   report_status "OK" "Process ${apType} running in background "

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
      report_status "OK" "Process ${scrName} finalized "
   fi

fi

#
