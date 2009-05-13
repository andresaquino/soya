#!/bin/sh 
# vim: set ts=3 sw=3 sts=3 et si ai: 
# 
# service.sh -- meta service management application 
# --------------------------------------------------------------------
# (c) 2009 NEXTEL DE MEXICO

# get application Name and Action
apDir=`dirname ${0}`
apName=`basename ${0%.*}`
apAction=`basename ${0#*.}`
apConf=${apDir}/${apName}.conf

# verify application
[ ! -h ${0} ] && echo "hey!, use ln -sf service application-name.{start|stop}" && exit 1

# verify app config
[ ! -r ${apConf} ] && echo "Can't find ${apConf} !" && exit 1

# by default, don't start any application
apProcesses=0

# read app config
. ${apConf}

#echo "Action: ${apAction} of Application: ${apName}"
#echo "Executing: ${apCommand}"

# si se indico el numero de procesos a levantar
[ ${1} ] && apProcesses=${1}

# si es mayor a 0, inicia al menos 1 proceso
if [ ${apProcesses} -gt 0 2>/dev/null ]
then
   # backup
   apBackup=`date '+%Y%m%d'`
   mkdir -p ~/log/${apBackup}
   
   #
   echo "Starting ${apProcesses} processes"
   pCount=1
   while [ ${pCount} -le ${apProcesses} ]
   do
      #
      # Application 
      scName=`echo ${apName}${pCount} | tr "[:lower:]" "[:upper:]"`
      echo "ID ${scName} initialized"
      if [ -e ~/log/${scName}-output.log ]
      then
         mv ~/log/${scName}-output.log ~/log/${apBackup}/${scName}.log.`date '+%H%M'`
      fi

      # tunning
      command=`echo ${apCommand} | sed -e "s/NAME/${scName}/g"`
      command=`echo ${command} | sed -e "s/COUNT/${pCount}/g"`
      
      screen -dmS ${scName}
      screen -r ${scName} -p 0 -X log off
      screen -r ${scName} -p 0 -X logfile ~/log/${scName}-output.log
      screen -r ${scName} -p 0 -X log on
      screen -r ${scName} -p 0 -X logfile flush 10
      screen -r ${scName} -p 0 -X stuff "$(printf '%b' "echo ${command}\015")"
      sleep 5

      pCount=$((${pCount}+1))
   done
else
   echo "Please, use ${apName}.start #ProcessesToStart"
fi

