#! /bin/sh
#
#u
#u
#u      startOCS.sh - starts the OCS server with the passed arguments.
#u
#u      The environment variable SVAPPLINDEX should be set before calling this script
#u
#u	Synopsis: 
#u			startOCS.sh [port]
#u
#u       The [port] argument can be ommitted if 
#u       env. var SOISRV_PORT contains the port
#u
#u	Example:
#u			startOCS.sh 14567 
#u			startOCS.sh
#u
#u
echo "Welcome to OCS"
 
NAMESPACE_ROOT="com/lhs/private/soi"

APPLINDEX=0
# Evaluate optional application index for the SOP feature from environment.
if [ -n "$SVAPPLINDEX" ];
then 
    CMD_OPT="-SVAPPLINDEX $SVAPPLINDEX"
    APPLINDEX=$SVAPPLINDEX
fi


# Evaluate local hostname (used for machines with multiple network interfaces).
HOST="$SVAPPLHOST"
if [ -n "$HOST" ];
then
    # SOP feature.
    CMD_OPT="$CMD_OPT -SVAPPLHOST $HOST"
else
    HOST=`hostname`
    if [ ! -n "$HOST" ];
    then
	HOST="$HOSTNAME"
	if [ ! -n "$HOST" ];
        then
	    echo "\\n\\n  Could not evaluate hostname for ORBEndpoint."
	    grep "^#u" $0 | sed -e "s/^#u//"
	    exit 1
	fi
    fi
fi

CMD_OPT="$CMD_OPT -ORBEndPoint iiop://$HOST"

if [ $# -gt 1 ] ; then
        grep "^#u" $0 | sed -e "s/^#u//"
        exit 1
fi

if [ -n "$BSCS_RESOURCE" ]
    then 
        RESOURCE_ROOT="$BSCS_RESOURCE"
else    
        RESOURCE_ROOT="$MPDE_ROOT/resource"
fi

## env var there?
if [ -n "$SOISRV_PORT" ]
    then
    PORT="$SOISRV_PORT"
fi

## how many params? --> assign values
if [ $# -eq 1 ] ; then
	PORT=${1}
fi

## port specified?
if [ ! -n "${PORT}" ];
then
    grep "^#u" $0 | sed -e "s/^#u//"
    exit 1
fi

IIOP="$HOST:$PORT"
SOINaming="ocs/$HOST/$APPLINDEX"

CMD_OPT="$CMD_OPT -ORBInitRef NameService=corbaloc:iiop:${IIOP}/NameService"
CMD_OPT="$CMD_OPT -ORBSvcConf $BSCS_RESOURCE/svc.conf"
CMD_OPT="$CMD_OPT -Component ocs"
CMD_OPT="$CMD_OPT -SOINaming ${SOINaming}"
CMD_OPT="$CMD_OPT -UseSecurity true"

echo "\\nStart OCS"
echo "with     Application Index '${SVAPPLINDEX}'"
echo "on       host '${HOST}'" 
echo "against  NamingService '${IIOP}'\n"

echo ocs $CMD_OPT
exec ocs $CMD_OPT

