#!/bin/sh 
# vim: set ts=3 sw=3 sts=3 et si ai: 
# 
# service.sh -- meta service management application 
# --------------------------------------------------------------------
# (c) 2009 NEXTEL DE MEXICO

# get application Name and Action
apHome=/home/andresaquino/fromUSB/nextel.com.mx/soi.git
apDir=`dirname ${PWD}/${0}`
apName=`basename ${0%.*}`
apAction=`basename ${0#*.} | tr "[:upper:]" "[:lower:]"`
apConf=${apDir}/${apName}.conf
apProcesses=0                                               # by default, don't start any application
apAuthorized=false

# move to application home directory
cd ${apHome}

# verify application
[ ! -h ${0} ] && echo "hey!, use ln -sf service application-name.{start|stop}" && exit 1

# read app config
[ ! -e ${apConf} ] && echo "hey!, i need a config file like ${apConf}" && exit 1

. utils.lib.sh
. ${apConf}

# autorizada para levantar
[ ${apAuthorized} ] || (echo "uhmmm, this is a bad idea..." && exit 1)

# si se indico el numero de proceso a levantar
[ ${1} ] && apProcesses=${1}

# START
if [ ${apAction} = "start" ]
then
   # exite otra aplicacion?
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
      command=`echo ${apCommand} | sed -e "s/PARAM1/${scName}/g"`
      command=`echo ${command} | sed -e "s/PARAM2/${apProcesses}/g"`
      
      #
      screen -d -m -S ${scName}
      screen -r ${scName} -p 0 -X log off
      screen -r ${scName} -p 0 -X logfile ${scLog}
      screen -r ${scName} -p 0 -X logfile flush 10
      screen -r ${scName} -p 0 -X log on
      screen -r ${scName} -p 0 -X stuff "$(printf '%b' ". ${command}\015")"
      
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
   echo "STOP"
fi
 
