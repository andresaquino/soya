#!/bin/sh
# vim: set ts=2 sw=2 sts=2 si ai: 

# soya.sh - SOI Platform Applications Container
# =-=
# (c) 2008, 2009 Nextel de Mexico
# Andres Aquino Morales <andres.aquino@gmail.com>
# 

# get application Name and Action
apAppName="soya"
apHome=${HOME}/soya
apDir=`dirname ${PWD}/${0}`
apName=`basename ${0%.*}`
apDebug="on"
scrPrcs=0

# move to application home directory
cd ${apHome}

# i need a config file...
[ ! -e ${apHome}/soya.conf ] && echo "hey!, i need a config file like soya.conf" && exit 1
[ ! -e ${apHome}/setup/${apName}.conf ] && echo "hey!, i need a config file like ${apHome}/setup/${apName}.conf" && exit 1

# settings, setup & libraries
. ${apHome}/soya.conf
. ${apHome}/libutils.sh
. ${apHome}/setup/${apName}.conf

#
get_enviroment
cd ${apHome}/setup/
apAction=`basename ${0#*.} | tr "[:upper:]" "[:lower:]"`
apHost=`hostname | tr "[:upper:]" "[:lower:]" | sed -e "s/m.*hp//g"`
apLog=${apLog}/${apName}

# virtual terminal name
scrPrcs=`echo ${apName} | sed -e "s/[a-zA-Z\.]/0/g;s/.*\([0-9][0-9]\)$/\1/g"`
scrName=`echo "$(echo "${apHost}____" | cut -c 1-4)" | tr "[:lower:]" "[:upper:]"`
scrName="${scrName}${apType}${scrPrcs}"

get_enviroment 
pidfile=/tmp/${0%.*}.pid

##
executeCmd () {
	local strCommand=${1}

	# eliminar referencias nulas del screen
	screen -wipe > /dev/null 2&>1

	# si no hay otro proceso
	screen -ls | grep ${scrName} > /dev/null 2>&1
	[ "x$?" != "x0" ] && log_action "ERR" "${scrName} virtual terminal process doesn't exist!" && exit 1 

	# ejecutar el comando
	screen -x ${scrName} -p 0 -X stuff "$(printf '%b' "${strCommand}\015")"
	wait_for "Executing command ${strCommand} on ${scrName} " 2

	# reportar el estado de la ejecucion
	log_action "INFO" "${strCommand} on ${scrName} cooked, go home baby! "
 
}

##
get_tree_of_applications () {
	local nameProcess=${1}

	rm -f $pidfile
	get_process_id "$nameProcess"

	[ ! -e $pidfile ] && log_action "ERR" "${scrName} process doesn't exist!" && exit 1 

	p=`cat $pidfile | sort -n | head -n1`
	echo $p > /tmp/${scrName}.proc
	while true
	do
		case "${systemSO}" in
			"HP-UX")
				proc=`cat /tmp/pslist | awk -v pp=$p '{if ($5 ~ pp){print $4}}' 2> /dev/null | sed -e "s/ *//g"`
				;;
			"Linux")
				proc=`cat /tmp/pslist | awk -v pp=$p '{if ($4 ~ pp){print $3}}' 2> /dev/null | sed -e "s/ *//g"`
				;;
		esac
		
		[ "x$proc" = "x" ] && break
		
		p=$proc
		echo $proc >> /tmp/${nameProcess}.proc
	done
  sort -n /tmp/${nameProcess}.proc > /tmp/${nameProcess}.list

}


# START
if [ ${apAction} = "start" ]
then

	# eliminar referencias nulas del screen
	screen -wipe > /dev/null 2>&1

	screen -ls | grep ${scrName} > /dev/null 2>&1
	[ "x$?" = "x0" ] && log_action "ERR" "Another ${scrName} virtual terminal process exist!" && exit 1 
	
	# backup
	mkdir -p ${apHome}/log/${apDate}
	mv ${apLog}.log ${apHome}/log/${apDate}/${scrName}.log.`date '+%H%M'` > /dev/null 2>&1

	#
	. ${apName}.conf
	screen -d -m -S ${scrName}
	screen -r ${scrName} -p 0 -X log off
	screen -r ${scrName} -p 0 -X logfile ${apLog}.log
	screen -r ${scrName} -p 0 -X logfile flush 10
	screen -r ${scrName} -p 0 -X log ${apDebug}
	wait_for "Starting ${scrName} virtual terminal " 6
	
	#
	screen -r ${scrName} -p 0 -X stuff "$(printf '%b' "${apCommand} || exit\015")"
	wait_for "Starting process " 8
	log_action "INFO" "Process ${apType} running in background "

	# get the tree applications
	get_tree_of_applications ${scrName}

	exit 0

fi

# CHECK
if [ ${apAction} = "check" ]
then

	# determinar procesos a terminar
	get_tree_of_applications ${scrName}

	#
	echo "Execution's tree"
	pos=
	for PID in $(cat /tmp/${scrName}.list)
	do
		 case "${systemSO}" in
			"HP-UX")
				pname=`cat /tmp/pslist | awk -v pp=$PID '{if ($4 ~ pp){print $0}}' | sed -e "s/.*[0-9]:[0-9][0-9]//g" 2> /dev/null` 
				;;
			"Linux")
				pname=`cat /tmp/pslist | awk -v pp=$PID '{if ($3 ~ pp){print $0}}' | sed -e "s/.*[0-9]:[0-9][0-9]//g" 2> /dev/null`
				;;
		esac
		echo "${pos} '- (${PID})${pname}"
		[ "x${pos}" = "x" ] && pos=" "
	done

fi

 
# STOP
if [ ${apAction} = "stop" ]
then

	# determinar procesos a terminar
	get_tree_of_applications ${scrName}

	# si no hay otro proceso
	screen -ls | grep ${scrName} > /dev/null 2>&1
	if [ "x$?" != "x0" ] 
	then
		log_action "ERR" "OMFG...! Nothing to stop man. "
		exit 1
	else
		screen -r ${scrName} -p 0 -X log off
		screen -r ${scrName} -p 0 -X stuff "$(printf '%b' "exit\015")"
		wait_for "Stopping process " 14
		
    awk '{print "kill -9 "$1}' /tmp/${scrName}.list | sh > /dev/null 2>&1
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
		VERSIONAPP="2"
		UPVERSION=`echo ${VERSIONAPP} | sed -e "s/..$//g"`
		RLVERSION=`awk '/2010/{t=substr($1,6,7);gsub("-"," Rev.",t);print t}' ${apHome}/CHANGELOG | head -n1`
		echo "${apAppName} v${UPVERSION}.${RLVERSION}"
		echo "(c) 2008, 2009 Nextel de Mexico, S.A. de C.V.\n"

		if [ "${TTYTYPE}" = "CONSOLE" ]
		then 
			echo "\nWritten by"
			echo "Andres Aquino <andres.aquino@gmail.com>"
		fi	
		exit 0
		;;

esac

#
