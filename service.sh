#!/bin/sh 
# vim: set ts=2 sw=2 sts=2 et si ai: 

# service.sh -- put here a short description 
# ---------------------------------------------------------------------------- 
# (c) 2009 Nextel de México S.A. de C.V.
# Andrés Aquino Morales <andres.aquino@gmail.com>
# All rights reserved.
# 

# get application Name and Action
apHome=/home/andresaquino/fromUSB/nextel.com.mx/soi.git
apDir=`dirname ${PWD}/${0}`
apName=`basename ${0%.*}`
apAction=`basename ${0#*.} | tr "[:upper:]" "[:lower:]"`
apConf=${apDir}/${apName}.conf
apProcesses=0
apAuthorized=false

# move to application home directory
cd ${apHome}

# read app config
[ ! -e ${apConf} ] && echo "hey!, i need a config file like ${apConf}" && exit 1

# user application settings
. ${apConf}

# esta autorizada para iniciar
[ ${apAuthorized} = false ] && echo "I need apAuthorized set to true in ${apConf}..." && exit 1

# our library
. utils.lib.sh

# si se indico el numero de proceso a levantar
[ ${1} ] && apProcesses=${1}

# START
if [ ${apAction} = "start" ]
then
   # existe otra aplicacion?
   scName=`echo ${apName}${apProcesses} | tr "[:lower:]" "[:upper:]"`
   cnName=`screen -ls | grep ${scName} | wc -l`
   apLog="${apHome}/log/${scName}-output.log"
   
   # si no hay otro proceso
   if [ ${cnName} -eq 0 ]
   then
      if [ ${apProcesses} -ge 0 2>/dev/null ]
      then
         # backup
         apBackup=`date '+%Y%m%d'`
         mkdir -p ${apHome}/log/${apBackup}
         mv ${apLog} ${apHome}/log/${apBackup}/${scName}-output.log.`date '+%H%M'`
      fi
     
      # iniciando proceso no. X
      echo "Starting ${scName} process "
      
      # tunning
      command=`echo ${apCommand} | sed -e "s/PARAMS/${scName}/g"`
      command=`echo ${command} | sed -e "s/PARAM2/${apProcesses}/g"`
      
      #
      screen -d -m -S ${scName}
      screen -x ${scName} -p 0 -X log off
      screen -x ${scName} -p 0 -X logfile ${scLog}
      screen -x ${scName} -p 0 -X logfile flush 10
      screen -x ${scName} -p 0 -X log on
      screen -x ${scName} -p 0 -X stuff "$(printf '%b' ". ${command}\015")"
      
      # another idea...
      # ::create a new terminal
      # screen -r ${scName} -X screen
      # ::on the pCount terminal, execute the command required
      # screen -r ${scName} -p ${pCount} -X stuff "$(printf '%b' ". ${command}\015")"
   else
      echo "Another instance is already running..."
   fi
fi

# STOP
if [ ${apAction} = "stop" ]
then
      screen -x ${scName} -p 0 -X log off
      screen -x ${scName} -p 0 -X stuff "$(printf '%b' "exit\015")"
      sleep 10
      
      screen -x ${scName} -p 0 -X quit > /dev/null 2>&1
      sleep 2
      echo "${scName} finalized"

fi

#
